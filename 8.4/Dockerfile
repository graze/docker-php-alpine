FROM alpine:3.21

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
    && echo "@php http://dl-cdn.alpinelinux.org/alpine/v3.21/community" >> /etc/apk/repositories \
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
    php84 \
    php84-pecl-apcu \
    php84-pecl-event \
    php84-pecl-memcached \
    php84-pecl-yaml \
    php84-bcmath \
    php84-common \
    php84-ctype \
    php84-curl \
    php84-dom \
    php84-fileinfo \
    php84-iconv \
    php84-intl \
    php84-openssl \
    php84-opcache \
    php84-mbstring \
    php84-mysqlnd \
    php84-mysqli \
    php84-pcntl \
    php84-pgsql \
    php84-pdo_mysql \
    php84-pdo_pgsql \
    php84-pdo_sqlite \
    php84-phar \
    php84-posix \
    php84-simplexml \
    php84-session \
    php84-soap \
    php84-sockets \
    php84-sodium \
    php84-tokenizer \
    php84-xml \
    php84-xmlreader \
    php84-xmlwriter \
    php84-zip \
    php84-zlib

ENV PHP_INI_DIR /etc/php84

RUN ln -s /usr/bin/php84 /usr/bin/php
RUN ln -s /usr/bin/pecl84 /usr/bin/pecl

COPY php/conf.d/*.ini $PHP_INI_DIR/conf.d/

WORKDIR /srv

ARG BUILD_DATE
ARG VCS_REF

LABEL org.label-schema.vcs-ref=$VCS_REF \
    org.label-schema.build-date=$BUILD_DATE

# Fix for iconv: https://github.com/docker-library/php/issues/240
ENV LD_PRELOAD /usr/lib/preloadable_libiconv.so php
