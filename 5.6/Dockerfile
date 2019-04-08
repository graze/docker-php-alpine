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
    libmemcached-libs \
    libevent \
    libssl1.0 \
    yaml \
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
    php5-mysqli \
    php5-pcntl \
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
    php5-zlib \
    && apk add --no-cache --repository http://dl-cdn.alpinelinux.org/alpine/edge/community/ --allow-untrusted \
    gnu-libiconv

# install and remove building packages
ENV PHPIZE_DEPS autoconf file g++ gcc libc-dev make pkgconf re2c php5-dev php5-pear \
    yaml-dev zlib-dev libmemcached-dev cyrus-sasl-dev libevent-dev openssl-dev

ENV PHP_INI_DIR /etc/php5

RUN set -xe \
    && apk add --no-cache \
    --virtual .phpize-deps \
    $PHPIZE_DEPS \
    && sed -i 's/^exec $PHP -C -n/exec $PHP -C/g' $(which pecl) \
    && pecl channel-update pecl.php.net \
    && pecl install yaml-1.3.1 memcached-2.2.0 event \
    && echo "extension=yaml.so" > $PHP_INI_DIR/conf.d/yaml.ini \
    && echo "extension=memcached.so" > $PHP_INI_DIR/conf.d/memcached.ini \
    && echo "extension=event.so" > $PHP_INI_DIR/conf.d/z-event.ini \
    && rm -rf /usr/share/php \
    && rm -rf /tmp/* \
    && apk del .phpize-deps
COPY php/php.ini $PHP_INI_DIR/

WORKDIR /srv

ARG BUILD_DATE
ARG VCS_REF

LABEL org.label-schema.vcs-ref=$VCS_REF \
    org.label-schema.build-date=$BUILD_DATE

# Fix for iconv: https://github.com/docker-library/php/issues/240
ENV LD_PRELOAD /usr/lib/preloadable_libiconv.so php
