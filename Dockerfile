FROM php:7.0-apache

MAINTAINER "Lukas Brzobohaty" <brzda.l@gmail.com>

RUN a2enmod rewrite
RUN a2enmod headers

ENV TZ Europe/Prague

ENV DEPENDENCY_PACKAGES="libpq-dev libcurl4-openssl-dev libpng12-dev libjpeg-dev libfreetype6-dev libpng-dev libmcrypt-dev libxml2-dev"
ENV BUILD_PACKAGES=""

RUN sed -i  "s/http:\/\/httpredir\.debian\.org\/debian/ftp:\/\/ftp\.debian\.org\/debian/g" /etc/apt/sources.list

RUN apt-get clean \
    && apt-get update \
    && apt-get install -f -y $DEPENDENCY_PACKAGES $BUILD_PACKAGES \
    && apt-get autoremove -y \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* 
	
	
RUN docker-php-ext-configure pgsql -with-pgsql=/usr/include/postgresql \
    && docker-php-ext-configure gd --enable-gd-native-ttf --with-png-dir=/usr/include --with-jpeg-dir=/usr/include --with-freetype-dir=/usr/include/freetype2 \
    && docker-php-ext-configure bcmath \
    && docker-php-ext-install -j$(nproc) pdo pdo_pgsql pgsql pdo_mysql mysqli curl gd mbstring json bcmath mcrypt zip fileinfo soap calendar
	
# php.ini
COPY conf/php.ini /usr/local/etc/php/
