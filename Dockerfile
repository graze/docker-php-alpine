FROM alpine:edge

MAINTAINER "Harry Bragg <harry.bragg@graze.com>"

LABEL license=MIT

RUN apk add --no-cache --repository "http://dl-cdn.alpinelinux.org/alpine/edge/testing" \
    ca-certificates \
    openssh \
    yaml-dev \
    php7 \
    php7-apcu \
    php7-bcmath \
    php7-ctype \
    php7-curl \
    php7-dom \
    php7-iconv \
    php7-intl \
    php7-json \
    php7-openssl \
    php7-opcache \
    php7-mbstring \
    php7-mcrypt \
    php7-memcached \
    php7-mysqlnd \
    php7-mysqli \
    php7-pgsql \
    php7-pdo_mysql \
    php7-pdo_pgsql \
    php7-pdo_sqlite \
    php7-phar \
    php7-posix \
    php7-soap \
    php7-sockets \
    php7-xml \
    php7-xmlreader \
    php7-zip \
    php7-zlib

# install and remove building packages
ENV PHPIZE_DEPS autoconf file g++ gcc libc-dev make pkgconf re2c php7-dev php7-pear

RUN set -xe \
    && apk add --no-cache --repository "http://dl-cdn.alpinelinux.org/alpine/edge/testing" \
        --virtual .phpize_deps \
        $PHPIZE_DEPS \
    && sed -i 's/^exec $PHP -C -n/exec $PHP -C/g' $(which pecl) \
    && pecl install yaml-2.0.0 \
    && echo "extension=yaml.so" > /etc/php7/conf.d/01_yaml.ini \
    && rm -rf /usr/share/php7 \
    && apk del .phpize_deps

RUN ln -s /usr/bin/php7 /usr/bin/php

COPY php/php.ini /etc/php7/

WORKDIR /srv
