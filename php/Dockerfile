ARG PHP_VER="7.4"

FROM php:${PHP_VER}-fpm-alpine

LABEL maintainer="Balaji YD"

ENV LOCAL_UID=1000
ENV LOCAL_GID=1000

RUN apk update; 

RUN apk add --update --no-cache \
    su-exec \
    git \
    bash \
    shadow \
    curl \
    wget \
    lynx \
    tzdata \
    rsync \
    openssh \
    openssl \
    ca-certificates \
    patch \
    mysql-client \
    postgresql-client \
    imagemagick \
    php7 \
    php7-zip \
    php7-gd \
    libzip-dev \
    bzip2-dev \
    libjpeg-turbo-dev \
    libpng-dev \
    freetype-dev \
    jpeg-dev \
    libwebp \
    libwebp-dev \
    libjpeg-turbo-dev

RUN  docker-php-ext-install \
        gd \
        zip; 

RUN docker-php-ext-configure gd \
        --with-webp \
        --with-freetype=/usr/include/ \
        --with-jpeg=/usr/include/; 

RUN NUMPROC=$(grep -c ^processor /proc/cpuinfo 2>/dev/null || 1) \
    && docker-php-ext-install -j${NUMPROC} gd

# Copy config.
COPY bashrc /root/.bashrc


# Usefull bash alias for docker exec.
RUN ln -s /bin/bash /bash && \
    ln -s /bin/sh /sh

# Cleanup.
RUN apk del tzdata && \
    rm -rf /var/cache/apk/*

# Use the default production configuration
RUN cp "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"

# Install composer.
COPY --from=composer:1 /usr/bin/composer /usr/bin/composer

RUN addgroup -S -g "${LOCAL_UID}" apache \
 && adduser -S -D -u "${LOCAL_UID}" -s /sbin/nologin -h /var/www -G apache apache \
 && chown -R apache:www-data /var/www/

# Fix composer cache folder permission to run composer as apache user.
RUN chmod +x /usr/bin/composer \
    #&& chown -R apache:www-data /var/www \
    # Copy root bashrc config for Apache user when running cmd.
    && cp /root/.bashrc /var/www/.bashrc

# Install prestissimo and php code sniffer with Drupal standards.
# USER apache
# RUN /usr/bin/composer global require "hirak/prestissimo:^0.3" "drupal/coder" "drush/drush" \
#     && ~/.composer/vendor/bin/phpcs --config-set installed_paths ~/.composer/vendor/drupal/coder/coder_sniffer

USER root


RUN set -ex; \
    \
    # We keep drush 8 as default for PHP 7.x because it's used for Drupal 7 as well.
    #####
    su-exec apache composer global require drush/drush; \
    drush_launcher_url="https://github.com/drush-ops/drush-launcher/releases/download/0.9.0/drush.phar"; \
    wget -O drush.phar "${drush_launcher_url}"; \
    chmod +x drush.phar; \
    mv drush.phar /usr/local/bin/drush; 

# Clean.
RUN rm -rf /var/www/.composer/cache/* \
    && rm -rf /var/cache/apk/*

# Phpfpm port.
EXPOSE 9000

VOLUME ["/var/www/html"]