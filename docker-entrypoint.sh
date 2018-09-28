#!/bin/sh

## Apache2 configuration update
echo "Updating apache2 configuration..."
APACHE2_CONF="/etc/apache2/httpd.conf"
# Allow override, rewrite mod and disable indexes
sed -i 's#AllowOverride None#AllowOverride All#g' $APACHE2_CONF
sed -i 's#Options Indexes FollowSymLinks#Options FollowSymLinks#g' $APACHE2_CONF
sed -i 's#\#LoadModule rewrite_module#LoadModule rewrite_module#' $APACHE2_CONF
# Change logging to stdout/stderr, replace host with %{X-Forwarded-For}
sed -i 's#ErrorLog logs/error.log#ErrorLog /dev/stderr#' $APACHE2_CONF
sed -i 's#CustomLog logs/access.log#CustomLog /dev/stdout#' $APACHE2_CONF
sed -i 's#LogFormat "%h#LogFormat "%{X-Forwarded-For}i#' $APACHE2_CONF
# Performance and security customization
sed -i 's#\#ServerName www.example.com:80#ServerName 0.0.0.0:80#' $APACHE2_CONF
sed -i 's#ServerTokens OS#ServerTokens Prod#' $APACHE2_CONF
sed -i 's#ServerSignature On#ServerSignature Off#' $APACHE2_CONF
# Variables to allow adhoc change using docker env
MPM_CONF="/etc/apache2/conf.d/mpm.conf"
MPM_START="${MPM_START:-1}"
MPM_MINSPARE="${MPM_MINSPARE:-1}"
MPM_MAXSPARE="${MPM_MAXSPARE:-3}"
MPM_MAXREQ="${MPM_MAXREQ:-15}"
MPM_MAXCONN="${MPM_MAXCONN:-250}"
sed -i -e "s/\(.*\)\(StartServers\)\(.*\)/\1\2\t$MPM_START/g" $MPM_CONF
sed -i -e "s/\(.*\)\(MinSpareServers\)\(.*\)/\1\2\t$MPM_MINSPARE/g" $MPM_CONF
sed -i -e "s/\(.*\)\(MaxSpareServers\)\(.*\)/\1\2\t$MPM_MAXSPARE/g" $MPM_CONF
sed -i -e "s/\(.*\)\(MaxRequestWorkers\)\(.*\)/\1\2\t$MPM_MAXREQ/g" $MPM_CONF
sed -i -e "s/\(.*\)\(MaxConnectionsPerChild\)\(.*\)/\1\2\t$MPM_MAXCONN/g" $MPM_CONF

## PHP configucation update
echo "Updating php configuration..."
# Variables to allow adhoc change using docker env
PHP_INI="/etc/php7/php.ini"
PHP_TZ="${PHP_TZ:-Europe/Prague}"
PHP_POSTMAX="${PHP_POSTMAX:-10M}"
PHP_UPLOADMAX="${PHP_UPLOADMAX:-8M}"
PHP_URLFOPEN="${PHP_URLFOPEN:-Off}"
PHP_DISABLE_USERINI="${PHP_DISABLE_USERINI:-1}"
PHP_EXECMAX="${PHP_EXECMAX:-30}"
PHP_INPUTMAX="${PHP_INPUTMAX:-60}"
PHP_MEMLIMIT="${PHP_MEMLIMIT:-128M}"
# Fix TZ for sed replacement
PHP_TZ="$(echo $PHP_TZ | sed 's/\//\\\//')"
sed -i -e "s/\(;\)\?\(date.timezone\s\?=\)\(.*\)\?/\2 $PHP_TZ/" $PHP_INI
sed -i -e "s/\(post_max_size\s\?=\s\?\).*/\1$PHP_POSTMAX/" $PHP_INI
sed -i -e "s/\(upload_max_filesize\s\?=\s\?\).*/\1$PHP_UPLOADMAX/" $PHP_INI
sed -i -e "s/\(allow_url_fopen\s\?=\s\?\).*/\1$PHP_URLFOPEN/" $PHP_INI
sed -i -e "s/\(max_execution_time\s\?=\s\?\).*/\1$PHP_EXECMAX/" $PHP_INI
sed -i -e "s/\(max_input_time\s\?=\s\?\).*/\1$PHP_INPUTMAX/" $PHP_INI
sed -i -e "s/\(memory_limit\s\?=\s\?\).*/\1$PHP_MEMLIMIT/" $PHP_INI
sed -i -e "s/\(;\)\?\(error_log\s\?=\)\(.*\)\?/\2 \/dev\/stderr/" $PHP_INI
if [ "$PHP_DISABLE_USERINI" = "1" ]; then
	sed -i -e "s/\(;\)\?\(user_ini.filename\s\?=\)$/\2/" $PHP_INI
fi

# Set apache as owner/group
if [ "$(stat -c "%U-%G" /var/www/localhost/htdocs)" != "apache-apache" ]; then
	echo "Fixing webroot ownership..."
        chown -R apache:apache /var/www/localhost/htdocs
fi

echo "Entrypoint script finished!"

exec "$@"
