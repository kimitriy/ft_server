# getting base image debian
FROM debian:buster

LABEL maintainer="rburton <rburton@student.21-school.ru>"

RUN apt-get update
RUN apt-get upgrade -y
RUN apt-get -y install vim
RUN apt-get -y install wget
RUN apt-get -y install nginx
RUN apt-get -y install mariadb-server
RUN apt-get -y install php7.3 php-mysql php-fpm php-pdo php-gd php-cli php-mbstring

COPY ./src/default etc/nginx/sites-available

RUN openssl req -x509 -nodes -days 365 \
    -subj "/C=RU/ST=TATARSTAN/L=KAZAN/0=21SCHOOL, Inc./0U=IT/CN=yourdomain.com" \
    -newkey rsa:2048 -keyout /etc/ssl/nginx-selfsigned.key -out /etc/ssl/nginx-selfsigned.crt

WORKDIR /var/www/html/

RUN wget https://files.phpmyadmin.net/phpMyAdmin/5.0.4/phpMyAdmin-5.0.4-all-languages.tar.gz
RUN tar -xf phpMyAdmin-5.0.4-all-languages.tar.gz
RUN rm phpMyAdmin-5.0.4-all-languages.tar.gz
RUN mv phpMyAdmin-5.0.4-all-languages phpmyadmin

COPY ./src/config.inc.php phpmyadmin

RUN wget https://wordpress.org/latest.tar.gz
RUN tar -xvzf latest.tar.gz
RUN rm latest.tar.gz

COPY ./src/wp-config.php /var/www/html
WORKDIR /
COPY ./src/autoindex.sh ./
RUN chmod 777 autoindex.sh

EXPOSE 80 443
RUN rm -rf /var/www/html/index.nginx-debian.html
COPY ./src/init.sh ./
CMD bash init.sh