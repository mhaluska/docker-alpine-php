FROM alpine:3.8
MAINTAINER marek.haluska@gmail.com

RUN apk --no-cache add shadow apache2 php5-apache2 php5-curl php5-gd php5-mysqli php5-openssl php5-pdo_mysql php5-zip \
    php5-ctype php5-xml && \
    mkdir -p /run/apache2 && cd /etc/apache2/conf.d && rm -fv info.conf userdir.conf

ADD docker-entrypoint.sh /docker-entrypoint.sh

EXPOSE 80

WORKDIR /var/www/localhost/htdocs

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["/usr/sbin/httpd","-D","FOREGROUND"]
