FROM alpine:3.13

LABEL maintainer="developers@graze.com" \
    license="MIT" \
    org.label-schema.schema-version="1.0" \
    org.label-schema.vendor="graze" \
    org.label-schema.name="php-alpine" \
    org.label-schema.description="small php image based on alpine" \
    org.label-schema.vcs-url="https://github.com/graze/docker-php-alpine"

RUN set -xe \
    && apk add --update --no-cache \
    ca-certificates \
    curl \
    gnu-libiconv \
    openssh-client \
    libmemcached-libs \
    libevent \
    libssl1.1 \
    musl \
    yaml \
    php8 \
    php8-pecl-apcu \
    php8-pecl-event \
    php8-pecl-memcached \
    php8-pecl-yaml \
    php8-bcmath \
    php8-common \
    php8-ctype \
    php8-curl \
    php8-dom \
    php8-fileinfo \
    php8-iconv \
    php8-intl \
    php8-openssl \
    php8-opcache \
    php8-mbstring \
    php8-mysqlnd \
    php8-mysqli \
    php8-pcntl \
    php8-pgsql \
    php8-pdo_mysql \
    php8-pdo_pgsql \
    php8-pdo_sqlite \
    php8-phar \
    php8-posix \
    php8-simplexml \
    php8-session \
    php8-soap \
    php8-sockets \
    php8-sodium \
    php8-tokenizer \
    php8-xml \
    php8-xmlreader \
    php8-xmlwriter \
    php8-zip \
    php8-zlib

ENV PHP_INI_DIR /etc/php8

RUN ln -s /usr/bin/php8 /usr/bin/php
RUN ln -s /usr/bin/pecl8 /usr/bin/pecl

COPY php/conf.d/*.ini $PHP_INI_DIR/conf.d/

WORKDIR /srv

ARG BUILD_DATE
ARG VCS_REF

LABEL org.label-schema.vcs-ref=$VCS_REF \
    org.label-schema.build-date=$BUILD_DATE

# Fix for iconv: https://github.com/docker-library/php/issues/240
ENV LD_PRELOAD /usr/lib/preloadable_libiconv.so php
