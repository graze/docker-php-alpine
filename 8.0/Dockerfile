FROM alpine:3.12

LABEL maintainer="developers@graze.com" \
    license="MIT" \
    org.label-schema.schema-version="1.0" \
    org.label-schema.vendor="graze" \
    org.label-schema.name="php-alpine" \
    org.label-schema.description="small php image based on alpine" \
    org.label-schema.vcs-url="https://github.com/graze/docker-php-alpine"

# trust this project public key to trust the packages.
ADD https://dl.bintray.com/php-alpine/key/php-alpine.rsa.pub /etc/apk/keys/php-alpine.rsa.pub

RUN set -xe \
    && apk add --no-cache --repository http://dl-cdn.alpinelinux.org/alpine/edge/community/ --allow-untrusted \
    gnu-libiconv \
    && echo "https://dl.bintray.com/php-alpine/v3.12/php-8.0" >> /etc/apk/repositories \
    && echo "@php https://dl.bintray.com/php-alpine/v3.12/php-8.0" >> /etc/apk/repositories \
    && apk add --update --no-cache \
    ca-certificates \
    curl \
    openssh-client \
    libmemcached-libs \
    libevent \
    libssl1.1 \
    musl \
    yaml \
    php8 \
    php8-apcu \
    php8-bcmath \
    php8-ctype \
    php8-curl \
    php8-dom \
    php8-iconv \
    php8-intl \
    php8-json \
    php8-openssl \
    php8-opcache \
    php8-mbstring \
    php8-memcached \
    php8-mysqlnd \
    php8-mysqli \
    php8-pcntl \
    php8-pgsql \
    php8-pdo_mysql \
    php8-pdo_pgsql \
    php8-pdo_sqlite \
    php8-phar \
    php8-posix \
    php8-session \
    php8-soap \
    php8-sockets \
    php8-sodium \
    php8-xml \
    php8-xmlreader \
    php8-zip \
    php8-zlib

# install and remove building packages
ENV PHPIZE_DEPS autoconf file g++ gcc libc-dev make pkgconf re2c php-dev php-pear \
    yaml-dev libevent-dev openssl-dev

ENV PHP_INI_DIR /etc/php8

RUN ln -s /usr/bin/php8 /usr/bin/php

RUN set -xe \
    && apk add --no-cache --repository "http://dl-cdn.alpinelinux.org/alpine/edge/testing" \
    --virtual .phpize-deps \
    $PHPIZE_DEPS \
    && sed -i 's/^exec $PHP -C -n/exec $PHP -C/g' $(which pecl) \
    && pecl channel-update pecl.php.net \
    && pecl install yaml event \
    && echo "extension=yaml.so" > $PHP_INI_DIR/conf.d/01_yaml.ini \
    && echo "extension=event.so" > $PHP_INI_DIR/conf.d/01_event.ini \
    && rm -rf /usr/share/php7 \
    && rm -rf /tmp/* \
    && apk del .phpize-deps

COPY php/conf.d/*.ini $PHP_INI_DIR/conf.d/

WORKDIR /srv

ARG BUILD_DATE
ARG VCS_REF

LABEL org.label-schema.vcs-ref=$VCS_REF \
    org.label-schema.build-date=$BUILD_DATE

# Fix for iconv: https://github.com/docker-library/php/issues/240
ENV LD_PRELOAD /usr/lib/preloadable_libiconv.so php
