FROM alpine:3.7
MAINTAINER marek.haluska@gmail.com

RUN addgroup -g 9999 -S apache && adduser -h /var/www -s /sbin/nologin -G apache -S -D -u 9999 apache && \
    # Install apache2 and php7
    apk --no-cache add apache2 php7-apache2 php7-curl php7-gd php7-mysqli php7-openssl php7-pdo_mysql php7-zip php7-ctype && \
    mkdir -p /run/apache2 && cd /etc/apache2/conf.d && rm -fv info.conf userdir.conf

ADD docker-entrypoint.sh /docker-entrypoint.sh

EXPOSE 80

# VOLUME /var/www/localhost/htdocs
WORKDIR /var/www/localhost/htdocs

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["/usr/sbin/httpd","-D","FOREGROUND"]