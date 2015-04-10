#!/bin/bash

SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ]; do
  DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
  SOURCE="$(readlink "$SOURCE")"
  [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE" 
done
DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"

ARLEKIN_DATA_EXISTS=`docker inspect --format="{{ .Id }}" arlekin-data 2> /dev/null`

if [ -z "$ARLEKIN_DATA_EXISTS" ]
then
  docker run -d -v /home/r/.composer --name arlekin-data debian
fi

VEES=""

for FILE in $DIR/arlekin/*
do
  VEES=$VEES" -v $FILE:/home/r/`basename $FILE`"
done

docker \
  run \
  --rm \
  -it \
  $VEES \
  --volumes-from arlekin-data \
  --link mariadb:mysql \
  bmichalski/arlekin-dev-sandbox
