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
    gnu-libiconv \
    openssh-client \
    libmemcached-libs \
    libevent \
    libssl1.1 \
    musl \
    yaml \
    php82 \
    php82-pecl-apcu \
    php82-pecl-memcached \
    php82-pecl-yaml \
    php82-bcmath \
    php82-common \
    php82-ctype \
    php82-curl \
    php82-dom \
    php82-fileinfo \
    php82-iconv \
    php82-intl \
    php82-openssl \
    php82-opcache \
    php82-mbstring \
    php82-mysqlnd \
    php82-mysqli \
    php82-pcntl \
    php82-pgsql \
    php82-pdo_mysql \
    php82-pdo_pgsql \
    php82-pdo_sqlite \
    php82-phar \
    php82-posix \
    php82-simplexml \
    php82-session \
    php82-soap \
    php82-sockets \
    php82-sodium \
    php82-tokenizer \
    php82-xml \
    php82-xmlreader \
    php82-xmlwriter \
    php82-zip \
    php82-zlib

# Fix for php82 pecl event not in v3.18
RUN apk add php82-pecl-event --update-cache --repository http://dl-cdn.alpinelinux.org/alpine/v3.19/community/ --allow-untrusted

ENV PHP_INI_DIR /etc/php82

RUN ln -s /usr/bin/php82 /usr/bin/php
RUN ln -s /usr/bin/pecl82 /usr/bin/pecl

COPY php/conf.d/*.ini $PHP_INI_DIR/conf.d/

WORKDIR /srv

ARG BUILD_DATE
ARG VCS_REF

LABEL org.label-schema.vcs-ref=$VCS_REF \
    org.label-schema.build-date=$BUILD_DATE

# Fix for iconv: https://github.com/docker-library/php/issues/240
ENV LD_PRELOAD /usr/lib/preloadable_libiconv.so php
