FROM alpine:3.18

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
    && echo "@php http://dl-cdn.alpinelinux.org/alpine/v3.18/community" >> /etc/apk/repositories \
    && apk add --update --no-cache \
    ca-certificates \
    curl \
    openssh-client \
    libmemcached-libs \
    libevent \
    libssl1.1 \
    musl \
    yaml \
    php81 \
    php81-pecl-apcu \
    php81-pecl-event \
    php81-pecl-memcached \
    php81-pecl-yaml \
    php81-bcmath \
    php81-common \
    php81-ctype \
    php81-curl \
    php81-dom \
    php81-fileinfo \
    php81-iconv \
    php81-intl \
    php81-openssl \
    php81-opcache \
    php81-mbstring \
    php81-mysqlnd \
    php81-mysqli \
    php81-pcntl \
    php81-pgsql \
    php81-pdo_mysql \
    php81-pdo_pgsql \
    php81-pdo_sqlite \
    php81-phar \
    php81-posix \
    php81-simplexml \
    php81-session \
    php81-soap \
    php81-sockets \
    php81-sodium \
    php81-tokenizer \
    php81-xml \
    php81-xmlreader \
    php81-xmlwriter \
    php81-zip \
    php81-zlib

ENV PHP_INI_DIR /etc/php81

#RUN ln -s /usr/bin/php81 /usr/bin/php
#RUN ln -s /usr/bin/pecl81 /usr/bin/pecl

COPY php/conf.d/*.ini $PHP_INI_DIR/conf.d/

WORKDIR /srv

ARG BUILD_DATE
ARG VCS_REF

LABEL org.label-schema.vcs-ref=$VCS_REF \
    org.label-schema.build-date=$BUILD_DATE

# Fix for iconv: https://github.com/docker-library/php/issues/240
ENV LD_PRELOAD /usr/lib/preloadable_libiconv.so php
