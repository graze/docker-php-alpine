FROM alpine:3.19

LABEL maintainer="developers@graze.com" \
    license="MIT" \
    org.label-schema.schema-version="1.0" \
    org.label-schema.vendor="graze" \
    org.label-schema.name="php-alpine" \
    org.label-schema.description="small php image based on alpine" \
    org.label-schema.vcs-url="https://github.com/graze/docker-php-alpine"

# Fix for iconv: https://github.com/docker-library/php/issues/240
RUN apk add gnu-libiconv=1.15-r3 --update-cache --repository http://dl-cdn.alpinelinux.org/alpine/v3.13/community/ --allow-untrusted

RUN set -xe \
    && echo "@php http://dl-cdn.alpinelinux.org/alpine/v3.19/community" >> /etc/apk/repositories \
    && apk add --update --no-cache \
    ca-certificates \
    curl \
    gnu-libiconv \
    openssh-client \
    libmemcached-libs \
    libevent \
    libssl3 \
    musl \
    yaml \
    php83 \
    php83-pecl-apcu \
    php83-pecl-event \
    php83-pecl-memcached \
    php83-pecl-yaml \
    php83-bcmath \
    php83-common \
    php83-ctype \
    php83-curl \
    php83-dom \
    php83-fileinfo \
    php83-iconv \
    php83-intl \
    php83-openssl \
    php83-opcache \
    php83-mbstring \
    php83-mysqlnd \
    php83-mysqli \
    php83-pcntl \
    php83-pgsql \
    php83-pdo_mysql \
    php83-pdo_pgsql \
    php83-pdo_sqlite \
    php83-phar \
    php83-posix \
    php83-simplexml \
    php83-session \
    php83-soap \
    php83-sockets \
    php83-sodium \
    php83-tokenizer \
    php83-xml \
    php83-xmlreader \
    php83-xmlwriter \
    php83-zip \
    php83-zlib

ENV PHP_INI_DIR /etc/php83

RUN ln -s /usr/bin/php83 /usr/bin/php
RUN ln -s /usr/bin/pecl83 /usr/bin/pecl

COPY php/conf.d/*.ini $PHP_INI_DIR/conf.d/

WORKDIR /srv

ARG BUILD_DATE
ARG VCS_REF

LABEL org.label-schema.vcs-ref=$VCS_REF \
    org.label-schema.build-date=$BUILD_DATE

# Fix for iconv: https://github.com/docker-library/php/issues/240
ENV LD_PRELOAD /usr/lib/preloadable_libiconv.so php
