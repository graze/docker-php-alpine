FROM alpine:3.9

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
    && echo "https://dl.bintray.com/php-alpine/v3.9/php-7.3" >> /etc/apk/repositories \
    && echo "@php https://dl.bintray.com/php-alpine/v3.9/php-7.3" >> /etc/apk/repositories \
    && apk add --update --no-cache \
    ca-certificates \
    curl \
    openssh-client \
    libmemcached-libs \
    libevent \
    libssl1.1 \
    musl \
    yaml \
    php \
    php-apcu \
    php-bcmath \
    php-ctype \
    php-curl \
    php-dom \
    php-iconv \
    php-intl \
    php-json \
    php-openssl \
    php-opcache \
    php-mbstring \
    php-memcached \
    php-mysqlnd \
    php-mysqli \
    php-pcntl \
    php-pgsql \
    php-pdo_mysql \
    php-pdo_pgsql \
    php-pdo_sqlite \
    php-phar \
    php-posix \
    php-session \
    php-soap \
    php-sockets \
    php-sodium \
    php-xml \
    php-xmlreader \
    php-zip \
    php-zlib \
    && apk add --no-cache --repository http://dl-cdn.alpinelinux.org/alpine/edge/community/ --allow-untrusted \
    gnu-libiconv

# install and remove building packages
ENV PHPIZE_DEPS autoconf file g++ gcc libc-dev make pkgconf re2c php-dev php-pear \
    yaml-dev libevent-dev openssl-dev

ENV PHP_INI_DIR /etc/php7

RUN ln -s /usr/bin/php7 /usr/bin/php

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

COPY php/conf.d/00_memlimit.ini $PHP_INI_DIR/conf.d/00_memlimit.ini

WORKDIR /srv

ARG BUILD_DATE
ARG VCS_REF

LABEL org.label-schema.vcs-ref=$VCS_REF \
    org.label-schema.build-date=$BUILD_DATE

# Fix for iconv: https://github.com/docker-library/php/issues/240
ENV LD_PRELOAD /usr/lib/preloadable_libiconv.so php
