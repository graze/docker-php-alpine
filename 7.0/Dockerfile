FROM alpine:3.5

LABEL maintainer="developers@graze.com" \
    license="MIT" \
    org.label-schema.schema-version="1.0" \
    org.label-schema.vendor="graze" \
    org.label-schema.name="php-alpine" \
    org.label-schema.description="small php image based on alpine" \
    org.label-schema.vcs-url="https://github.com/graze/docker-php-alpine"

RUN apk add --no-cache \
    ca-certificates \
    curl \
    openssh-client \
    yaml \
    pcre \
    libmemcached-libs \
    libevent \
    libssl1.0 \
    zlib \
    php7 \
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
    php7-mysqlnd \
    php7-mysqli \
    php7-pcntl \
    php7-pgsql \
    php7-pdo_mysql \
    php7-pdo_pgsql \
    php7-pdo_sqlite \
    php7-phar \
    php7-posix \
    php7-session \
    php7-soap \
    php7-sockets \
    php7-xml \
    php7-xmlreader \
    php7-zip \
    php7-zlib \
    && apk add --no-cache --repository http://dl-cdn.alpinelinux.org/alpine/edge/community/ --allow-untrusted \
    gnu-libiconv

# install and remove building packages
ENV PHPIZE_DEPS autoconf file g++ gcc libc-dev make pkgconf re2c php7-dev php7-pear \
    yaml-dev pcre-dev zlib-dev libmemcached-dev cyrus-sasl-dev libevent-dev openssl-dev

ENV PHP_INI_DIR /etc/php7

RUN set -xe \
    && apk add --no-cache \
    --virtual .phpize-deps \
    $PHPIZE_DEPS \
    && sed -i 's/^exec $PHP -C -n/exec $PHP -C/g' $(which pecl) \
    && pecl channel-update pecl.php.net \
    && pecl install yaml apcu memcached event \
    && echo "extension=yaml.so" > $PHP_INI_DIR/conf.d/01_yaml.ini \
    && echo "extension=apcu.so" > $PHP_INI_DIR/conf.d/01_apcu.ini \
    && echo "extension=event.so" > $PHP_INI_DIR/conf.d/01_event.ini \
    && echo "extension=memcached.so" > $PHP_INI_DIR/conf.d/20_memcached.ini \
    && rm -rf /usr/share/php7 \
    && rm -rf /tmp/* \
    && apk del .phpize-deps

RUN ln -s /usr/bin/php7 /usr/bin/php

COPY php/php.ini $PHP_INI_DIR/

WORKDIR /srv

ARG BUILD_DATE
ARG VCS_REF

LABEL org.label-schema.vcs-ref=$VCS_REF \
    org.label-schema.build-date=$BUILD_DATE

# Fix for iconv: https://github.com/docker-library/php/issues/240
ENV LD_PRELOAD /usr/lib/preloadable_libiconv.so php
