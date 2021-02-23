ARG PHP_VER="7.4"

FROM php:${PHP_VER}-fpm-alpine

LABEL maintainer="Balaji YD"

ENV LOCAL_UID=1000
ENV LOCAL_GID=1000

RUN apk update 

RUN apk add --update --no-cache \
    # php7 \
    # php7-common \
    # php7-sysvsem \
    # php7-sysvshm \
    # php7-tidy \
    # php7-tokenizer \
    # php7-xml \
    # php7-xmlreader \
    # php7-xmlrpc \
    # php7-xmlwriter \
    # php7-xsl \
    # php7-zip \
    # php7-phar \
    # php7-posix \
    # php7-pspell \
    # php7-session \
    # php7-shmop \
    # php7-simplexml \
    # php7-snmp \
    # php7-soap \
    # php7-sockets \
    # php7-sqlite3 \
    # php7-sysvmsg \
    # php7-mysqlnd \
    # php7-odbc \
    # php7-opcache \
    # php7-openssl \
    # php7-pcntl \
    # php7-pdo \
    # php7-pdo_dblib \
    # php7-pdo_mysql \
    # php7-pdo_odbc \
    # php7-pdo_pgsql \
    # php7-pdo_sqlite \
    # php7-pgsql \
    # php7-ftp \
    # php7-gd \
    # php7-gettext \
    # php7-gmp \
    # php7-iconv \
    # php7-imap \
    # php7-intl \
    # php7-json \
    # php7-ldap \
    # php7-mbstring \
    # php7-mysqli \
    # php7-bcmath \
    # php7-bz2 \
    # php7-calendar \
    # php7-ctype \
    # php7-curl \
    # php7-dba \
    # php7-dom \
    # php7-enchant \
    # php7-exif \
    # php7-fileinfo \
    # php7-pear \
    # php7-apache2 \
    # php7-cgi \
    # php7-dev \
    # php7-doc \
    # php7-embed \
    # php7-fpm \
    # php7-litespeed \
    # php7-phpdbg \
    # php7-amqp \
    # php7-mailparse \
    # php7-oauth \
    # php7-zmq \
    # php7-pecl-mcrypt \
    # php7-pecl-apcu \
    # php7-pecl-imagick \
    # php7-pecl-xdebug \
    # php7-pecl-yaml \
    # php7-sodium \
    # php7-pecl-memcached \
    # php7-pecl-redis \
    # php7-pecl-event \
    # php7-pecl-lzf \
    # php7-pecl-timezonedb \
    # php7-pecl-ast \
    bash \
    c-client=2007f-r11 \
    curl \
    fcgi \
    findutils \
    freetype \
    git \
    gmp \
    gzip \
    icu-libs \
    imagemagick\
    jpegoptim \
    less \
    libbz2 \
    libevent \
    libjpeg-turbo \
    libjpeg-turbo-utils \
    libldap \
    libltdl \
    libmemcached-libs \
    libmcrypt \
    libpng \
    libpng-dev \
    librdkafka \
    libuuid \
    libwebp \
    libxml2 \
    libxslt \
    libzip \
    make \
    mariadb-client \
    mariadb-connector-c \
    nano \
    openssh \
    openssh-client \
    patch \
    pngquant \
    postgresql-client \
    rabbitmq-c \
    rsync \
    su-exec \
    sudo \
    tar \
    tidyhtml-libs \ 
    autoconf \
    cmake \
    build-base \
    bzip2-dev \
    freetype-dev \
    gmp-dev \
    icu-dev \
    imagemagick-dev \
    imap-dev \
    jpeg-dev \
    krb5-dev \
    libevent-dev \
    libgcrypt-dev \
    libjpeg-turbo-dev \
    libmemcached-dev \
    libmcrypt-dev \
    libpng-dev \
    librdkafka-dev \
    libtool \
    libwebp-dev \
    libxslt-dev \
    libzip-dev \
    linux-headers \
    openldap-dev \
    openssl-dev \
    pcre-dev \
    postgresql-dev \
    rabbitmq-c-dev \
    tidyhtml-dev \
    unixodbc-dev \
    yaml-dev \
    # todo: move out tig and tmux to -dev version.
    tig \
    tmux \
    unzip \
    wget \
    zlib-dev \
    yaml; 


RUN  docker-php-ext-install \
        bcmath \
        gd \
        bz2 \
        calendar \
        exif \
        mysqli \
        opcache \
        pcntl \
        pdo_mysql \
        pdo_pgsql \
        pgsql \
        soap \
        sockets \
        xmlrpc \
        xsl \
        zip; 

RUN docker-php-ext-configure gd \
        --with-webp \
        --with-freetype=/usr/include/ \
        --with-jpeg=/usr/include/; 

RUN NUMPROC=$(grep -c ^processor /proc/cpuinfo 2>/dev/null || 1) \
    && docker-php-ext-install -j${NUMPROC} gd

# Usefull bash alias for docker exec.
RUN ln -s /bin/bash /bash && \
    ln -s /bin/sh /sh


RUN addgroup -S -g "${LOCAL_UID}" apache \
 && adduser -S -D -u "${LOCAL_UID}" -s /sbin/nologin -h /var/www -G apache apache \
 && chown -R apache:www-data /var/www/

# Install composer.
COPY --from=composer:1 /usr/bin/composer /usr/bin/composer

# Fix composer cache folder permission to run composer as apache user.
RUN chmod +x /usr/bin/composer \
    && chown -R apache:www-data /var/www 

USER root

RUN set -ex; \
    \
    # We keep drush 8 as default for PHP 7.x because it's used for Drupal 7 as well.
    #####
    su-exec apache composer global require drush/drush; \
    drush_launcher_url="https://github.com/drush-ops/drush-launcher/releases/download/0.9.0/drush.phar"; \
    wget -O drush.phar "${drush_launcher_url}"; \
    chmod +x drush.phar; \
    mv drush.phar /usr/local/bin/drush; \
    \
    # Drupal console
    console_url="https://github.com/hechoendrupal/drupal-console-launcher/releases/download/1.9.7/drupal.phar"; \
    curl "${console_url}" -L -o drupal.phar; \
    mv drupal.phar /usr/local/bin/drupal; \
    chmod +x /usr/local/bin/drupal; \
    \
    # Clean up
    su-exec wodby composer clear-cache; 
    #su-exec wodby drush cc drush


# Clean.
RUN apk del tzdata && \
    rm -rf /var/www/.composer/cache/* \
    && rm -rf /var/cache/apk/*

# Use the default production configuration
RUN cp "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"

# Phpfpm port.
EXPOSE 9000

VOLUME ["/var/www/html"]