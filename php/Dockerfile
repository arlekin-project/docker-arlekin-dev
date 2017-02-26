FROM ubuntu:16.04

RUN \
  apt-get update -y && \
  apt-get install -y software-properties-common

RUN \
  LC_ALL=C.UTF-8 add-apt-repository ppa:ondrej/php

RUN \
  apt-get update -y && \
  apt-get install -y \
    php7.1-cli \
    php7.1-dev \
    php7.1-curl \
    php7.1-zip \
    php7.1-xdebug \

    openssh-server \
    sudo \
    adduser \

    wget \
    git \
    curl \
    unzip \

    vim \

    inetutils-ping \

    php7.1-mysql \
    php7.1-mbstring

RUN \
  adduser --disabled-login --uid 1042 --gecos 'r' r && \
  usermod -a -G sudo r && \
  echo "r ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

RUN \
  curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin && \
  echo "php -c /etc/php/7.0/cli-composer/php.ini /usr/bin/composer.phar install" > /usr/bin/composer && \
  chmod +x /usr/bin/composer

CMD \
  service ssh start && \
  touch /var/log/php_cli_errors.log && \
  touch /var/log/php_cli_composer_errors.log && \
  tail -f /var/log/php_*.log
