ARG PHP_VER="7.4"

FROM php:${PHP_VER}-fpm-alpine3.12

RUN apk update; 

# PHP packages
RUN apk add --update \
    bash \
    libressl \
    ca-certificates \
    openssh \
    openssh-client \
    rsync \
    git \
    curl \
    wget \
    gzip \
    tar \
    patch \
    perl \
    pcre \
    imap \
    imagemagick \
    mariadb-client \
    build-base \
    autoconf \
    libtool \
    php7-dev \
    pcre-dev \
    imagemagick-dev \
    php7 \
    php7-fpm \
    php7-opcache \
    php7-session \
    php7-dom \
    php7-xml \
    php7-xmlreader \
    php7-ctype \
    php7-ftp \
    php7-gd \
    php7-json \
    php7-posix \
    php7-curl \
    php7-pdo \
    php7-pdo_mysql \
    php7-pdo_pgsql \
    php7-pdo_sqlite \
    php7-pgsql \
    php7-sockets \
    php7-zlib \
    php7-mcrypt \
    php7-mysqli \
    php7-sqlite3 \
    php7-bz2 \
    php7-phar \
    php7-openssl \
    php7-posix \
    php7-zip \
    php7-calendar \
    php7-iconv \
    php7-imap \
    php7-soap \
    php7-dev \
    php7-pear \
    php7-redis \
    php7-mbstring \
    php7-xdebug \
    php7-exif \
    php7-xsl \
    php7-ldap \
    php7-bcmath \
    php7-memcached \
    php7-oauth \
    php7-apcu \
    libpq \
    postgresql-dev \
    libpng \
    libpng-dev \
    libjpeg-turbo-dev \
    libwebp-dev \
    zlib-dev \
    libxpm-dev \
    libzip-dev \
    bzip2-dev \
    gd  

# Install extension
RUN docker-php-ext-install \
    mysqli \
    pdo \
    pgsql \
    pdo_mysql \
    pdo_pgsql \
    zip \
    opcache \
    gd

# Install composer.
COPY --from=composer:1 /usr/bin/composer /usr/bin/composer

# Install Drush, Drupal Console, Drupal Coder
RUN /usr/bin/composer global require drush/drush drupal/console drupal/coder \ 
    && ln -s /root/.composer/vendor/bin/drush /usr/bin/drush \
    && ln -s /root/.composer/vendor/bin/drupal /usr/bin/drupal \
    && ln -s /root/.composer/vendor/bin/phpcs /usr/bin/phpcs \
    && ln -s /root/.composer/vendor/bin/phpcbf /usr/bin/phpcbf \
    && ln -s /root/.composer/vendor/drupal/coder/coder_sniffer/Drupal /root/.composer/vendor/squizlabs/php_codesniffer/src/Standards/Drupal \
    && ln -s /root/.composer/vendor/drupal/coder/coder_sniffer/DrupalPractice /root/.composer/vendor/squizlabs/php_codesniffer/src/Standards/DrupalPractice \
    && rm -rf /root/.composer/cache/* 
  

# Use the default production configuration
RUN cp "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"

# Phpfpm port.
EXPOSE 9000

VOLUME ["/var/www/html"]