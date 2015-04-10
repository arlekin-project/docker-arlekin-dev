FROM ubuntu:14.04

RUN \
  apt-get update && \
  apt-get install -y\
    vim \
    curl \
    git \
    php5-cli \
    php5-xsl \ 
    php5-mysql \
    mysql-client \
  && \
  adduser --disabled-password --gecos '' r && \
  usermod -aG sudo r && \
  echo "r ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers && \
  mkdir /home/r/bin && \
  #Fixing permissions
  chown -R r:r /home/r/bin && \
  su - r -c "curl -sS https://getcomposer.org/installer | php -- --install-dir=/home/r/bin" && \
  mv /home/r/bin/composer.phar /home/r/bin/composer

COPY conf/root/fix-permissions.sh /root/fix-permissions.sh

ENV HOME /root

WORKDIR /root

CMD \
  bash /root/fix-permissions.sh && \
  bash -c "su - r"
