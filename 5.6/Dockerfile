FROM alpine:3.5

MAINTAINER "Harry Bragg <harry.bragg@graze.com>"

LABEL license=MIT

RUN apk add --no-cache --repository "http://dl-cdn.alpinelinux.org/alpine/edge/testing" \
    ca-certificates \
    openssh-client \
    php5 \
    php5-bcmath \
    php5-ctype \
    php5-curl \
    php5-dom \
    php5-iconv \
    php5-intl \
    php5-json \
    php5-openssl \
    php5-opcache \
    php5-mcrypt \
    php5-memcached \
    php5-mysqli \
    php5-pgsql \
    php5-pdo_mysql \
    php5-pdo_pgsql \
    php5-pdo_sqlite \
    php5-phar \
    php5-posix \
    php5-soap \
    php5-sockets \
    php5-xml \
    php5-xmlreader \
    php5-zip \
    php5-zlib

# install and remove building packages
ENV PHPIZE_DEPS autoconf file g++ gcc libc-dev make pkgconf re2c php5-dev php5-pear yaml-dev

RUN set -xe \
    && apk add --no-cache --repository "http://dl-cdn.alpinelinux.org/alpine/edge/testing" \
        --virtual .phpize-deps \
        $PHPIZE_DEPS \
    && sed -i 's/^exec $PHP -C -n/exec $PHP -C/g' $(which pecl) \
    && pecl install yaml \
    && echo "extension=yaml.so" > /etc/php5/conf.d/yaml.ini \
    && rm -rf /usr/share/php7 \
    && apk del .phpize-deps

COPY php/php.ini /etc/php5/

WORKDIR /srv