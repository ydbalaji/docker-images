FROM ubuntu:latest

LABEL maintainer="Balaji Y D"

RUN apt-get update
RUN apt-get -y upgrade

ENV DEBIAN_FRONTEND noninteractive

# Edit sources.list to add to install libapache2-mod-fastcgi
RUN echo "deb http://archive.ubuntu.com/ubuntu trusty multiverse \ndeb http://archive.ubuntu.com/ubuntu trusty-updates multiverse \ndeb http://security.ubuntu.com/ubuntu trusty-security multiverse" >> /etc/apt/sources.list

## Add apt repository.
RUN apt-get update ; \
    apt-get install -y \
    software-properties-common ; \
    LC_ALL=en_US.UTF-8 add-apt-repository ppa:ondrej/php

## Install apache, curl and lynx-cur are for debugging the container.
RUN apt-get update ; \
    apt-get install -y \
    apache2 \
    openssl \
    libapache2-mod-fcgid \
    libapache2-mod-fastcgi \
    vim \
    ssl-cert \
    ca-certificates \
    curl \
    git \
    wget \
    zip \
    cron \
    supervisor 

## Manually set up the apache environment variables
ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOG_DIR /var/log/apache2
ENV APACHE_LOCK_DIR /var/lock/apache2
ENV APACHE_PID_FILE /var/run/apache2.pid

## Enabling apache  variables
RUN a2enmod ssl \
    && a2enmod headers \
    && a2enmod rewrite \
    && a2dismod mpm_prefork \
    && a2dismod mpm_event \
    && a2enmod mpm_worker \
    && a2enmod actions \
    && a2enmod proxy_fcgi \
    && a2enmod fastcgi \
    && a2enmod http2 \
    && a2enmod proxy \
    && a2enmod proxy_http \
    && a2enmod alias \
    && a2enmod vhost_alias \
    && a2enmod remoteip \
    && a2ensite default-ssl \
    && c_rehash /etc/ssl/certs/ \
    && a2ensite default-ssl.conf

## Install Mysql server and client
RUN apt-get update ; \
    apt-get install -y \
    mysql-server \
    mysql-client

## Install php7.4
RUN apt-get update ; \
    apt-get install -y \
    php7.4 \
    php-fpm \
    libapache2-mod-php7.4

## Install php7.4 extension
RUN apt-get update ; \
    apt-get install -y \
	php7.4-fpm \
	php7.4-pgsql \
	php7.4-mysql \
	php7.4-sqlite \
	php7.4-sqlite3 \
	php7.4-opcache \
	php7.4-common \
	php7.4-mbstring \
	php7.4-soap \
	php7.4-cli \
	php7.4-intl \
	php7.4-json \
	php7.4-pdo \
	php7.4-xsl \
	php7.4-xml \
	php7.4-imap \
	php7.4-ldap \
	php7.4-curl \
	php7.4-gd  \
    php7.4-zip  \
	php7.4-dev \
	php-igbinary \
	php7.4-redis \
	php-memcached \
	php-mongodb \
	php7.4-imagick \
	php7.4-bcmath \
    php-zmq \
    php7.4-apcu \
    sqlite3 \
	libsqlite3-dev

## Copy Apache Config files
COPY 000-default.conf /etc/apache2/sites-available/000-default.conf 
RUN a2ensite 000-default.conf

## Copy Supervisor file in to conatianer
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

## Copy the Apache Config file for Php-fpm
# COPY php7.4-fpm.conf /etc/apache2/conf-available/php7.4-fpm.conf

## Copy the index.php to /var/www/html
COPY index.php /var/www/html/index.php

RUN sed -i 's/;daemonize = yes/daemonize = no/g' /etc/php/7.4/fpm/php-fpm.conf

RUN mkdir -p /var/log/php-fpm
RUN mkdir -p /var/run/php
RUN a2enconf php7.4-fpm

## Ports 80 and 443
EXPOSE 80
EXPOSE 443

# ADD app /var/www/html
VOLUME ["/var/www/html"]

# By default, simply start apache and PHP by supervisord.
# CMD service php7.4-fpm start &&  /usr/sbin/apache2ctl -D FOREGROUND
CMD ["/usr/bin/supervisord"]