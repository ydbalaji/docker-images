FROM ubuntu:latest

LABEL maintainer="Balaji Y D"

RUN apt-get update
RUN apt-get -y upgrade

ENV DEBIAN_FRONTEND noninteractive

# Install apache, curl and lynx-cur are for debugging the container.
RUN apt-get update \
    && apt-get install -y apache2 \
    && apt-get install -y openssl \
    && apt-get install -y vim \
    && apt-get install -y ssl-cert \
    && apt-get install -y curl 

# Manually set up the apache environment variables
ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOG_DIR /var/log/apache2
ENV APACHE_LOCK_DIR /var/lock/apache2
ENV APACHE_PID_FILE /var/run/apache2.pid

RUN a2enmod ssl \
    && a2enmod headers \
    && a2enmod rewrite \
    && a2dismod mpm_prefork \
    && a2dismod mpm_event \
    && a2enmod mpm_worker \
    && a2enmod proxy_fcgi \
    && a2enmod http2 \
    && a2enmod proxy \
    && a2enmod proxy_http \
    && a2enmod remoteip \
    && a2ensite default-ssl \
    && c_rehash /etc/ssl/certs/ \
    && a2ensite default-ssl.conf

EXPOSE 80
EXPOSE 443

# ADD app /var/www/html
VOLUME ["/var/www/html"]

# By default, simply start apache.
CMD /usr/sbin/apache2ctl -D FOREGROUND