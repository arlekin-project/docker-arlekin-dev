#!/bin/bash

SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ]; do
  DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
  SOURCE="$(readlink "$SOURCE")"
  [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE"
done
DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"

VOLUMES_PATH=$DIR/arlekin

ARLEKIN_FOLDERS='arlekin-core
arlekin-dbal
arlekin-dbal-driver-pdo-mysql
arlekin-dbal-migration
arlekin-dbal-migration-driver-pdo-mysql
arlekin-dml
arlekin-dml-driver-pdo-mysql'

VOLUMES_COUNT=0

for FOLDER in $ARLEKIN_FOLDERS
do
  if [ -d $VOLUMES_PATH/$FOLDER ]; then
    VOLUMES_COUNT=$(($VOLUMES_COUNT + 1))
  fi
done

if [ $VOLUMES_COUNT = 0 ]
then
    echo 'Missing volumes, aborting.';
    exit 1
fi

VOLUMES=""

for FILE in $VOLUMES_PATH/*
do
  VOLUMES=$VOLUMES" -v $FILE:/home/r/`basename $FILE`"
done

ARLEKIN_MARIADB_EXISTS=`docker inspect --format="{{ .Id }}" arlekin-mariadb 2> /dev/null`
ARLEKIN_MARIADB_DATA_EXISTS=`docker inspect --format="{{ .Id }}" arlekin-mariadb-data 2> /dev/null`

if [ -z "$ARLEKIN_MARIADB_DATA_EXISTS" ]
then
  docker run -d -v /var/lib/mysql --name arlekin-mariadb-data ubuntu:14.04
fi

if ! [ -z "$ARLEKIN_MARIADB_EXISTS" ]
then
  docker kill arlekin-mariadb
  docker rm arlekin-mariadb
fi

docker run \
-p 3306:3306 \
--volumes-from arlekin-mariadb-data \
--name arlekin-mariadb \
-d bmichalski/docker-mariadb

ARLEKIN_DATA_EXISTS=`docker inspect --format="{{ .Id }}" arlekin-data 2> /dev/null`

if [ -z "$ARLEKIN_DATA_EXISTS" ]
then
  docker run -d -v /home/r/.composer --name arlekin-data debian
fi

docker \
  run \
  --rm \
  -it \
  $VOLUMES \
  --volumes-from arlekin-data \
  --link arlekin-mariadb:mysql \
  bmichalski/arlekin-dev-sandbox
