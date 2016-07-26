FROM ubuntu:12.04

MAINTAINER "Lukas Brzobohaty" <brzda.l@gmail.com>

ENV TZ Europe/Prague

ENV DEPENDENCY_PACKAGES="libapache2-mod-php5"
ENV BUILD_PACKAGES="apache2 php5 php5-gd php5-mysql php5-curl php5-memcached php5-mcrypt"

RUN a2enmod rewrite

COPY 5.3/site-default /etc/apache2/sites-enabled/000-default
COPY 5.3/php.ini /etc/php5/apache2/php.ini

EXPOSE 80

CMD ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]