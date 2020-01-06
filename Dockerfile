FROM alpine:3.10
MAINTAINER marek.haluska@gmail.com

RUN apk --no-cache add shadow apache2 php7-apache2 php7-curl php7-gd php7-mysqli php7-openssl php7-pdo_mysql php7-zip \
    php7-ctype php7-xml php7-simplexml php7-session && \
    mkdir -p /run/apache2 && cd /etc/apache2/conf.d && rm -fv info.conf userdir.conf

ADD docker-entrypoint.sh /docker-entrypoint.sh

EXPOSE 80

# VOLUME /var/www/localhost/htdocs
WORKDIR /var/www/localhost/htdocs

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["/usr/sbin/httpd","-D","FOREGROUND"]
