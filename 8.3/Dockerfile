FROM php:8.3-cli-alpine3.19

LABEL maintainer="developers@graze.com" \
    license="MIT" \
    org.label-schema.schema-version="1.0" \
    org.label-schema.vendor="graze" \
    org.label-schema.name="php-alpine" \
    org.label-schema.description="small php image based on alpine" \
    org.label-schema.vcs-url="https://github.com/graze/docker-php-alpine"

RUN set -xe \
    && apk add --no-cache \
        openssh-client \
        icu-libs \
        libevent \
        libmemcached-libs \
        libpq \
        libzip \
        yaml \
    && apk add --no-cache --virtual .build-deps \
        $PHPIZE_DEPS \
        icu-dev \
        libevent-dev \
        libmemcached-dev \
        libxml2-dev \
        libzip-dev \
        linux-headers \
        postgresql-dev \
        yaml-dev \
        zlib-dev \
    && docker-php-ext-install -j$(nproc) \
        bcmath \
        intl \
        mysqli \
        pcntl \
        pdo_mysql \
        pdo_pgsql \
        pgsql \
        soap \
        sockets \
        zip \
    && yes '' | pecl install apcu event memcached yaml \
    # opcache ships as a shared module on 8.3 and isn't enabled by upstream
    && docker-php-ext-enable apcu memcached yaml sodium opcache \
    # event must load after sockets, hence the zz- prefix
    && docker-php-ext-enable --ini-name zz-docker-php-ext-event.ini event \
    && apk del --no-network .build-deps \
    && rm -rf /tmp/pear ~/.pearrc

COPY php/conf.d/*.ini $PHP_INI_DIR/conf.d/

WORKDIR /srv

# Restore the historical empty-entrypoint behaviour of this image
ENTRYPOINT []

ARG BUILD_DATE
ARG VCS_REF

LABEL org.label-schema.vcs-ref=$VCS_REF \
    org.label-schema.build-date=$BUILD_DATE
