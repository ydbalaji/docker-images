#!/bin/bash

if ! [ -f /usr/bin/php ] && [ -f /usr/bin/php7 ]; then
  ln -s /usr/bin/php7 /usr/bin/php
fi

# Common commands for permissions fix.

# Set uid/gid to fix data permissions.
if [ "$LOCAL_UID" != "" ]; then
  /scripts/change_uid_gid.sh apache:www-data $LOCAL_UID:$LOCAL_GID
fi

echo "[i] Starting Php-fpm..."

if [ -f /usr/sbin/php-fpm ]
then
  exec /usr/sbin/php-fpm -F
elif [ -f /usr/sbin/php-fpm7 ]
then
  exec /usr/sbin/php-fpm7 -F
fi