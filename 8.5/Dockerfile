FROM alpine:3.23

LABEL maintainer="developers@graze.com" \
    license="MIT" \
    org.label-schema.schema-version="1.0" \
    org.label-schema.vendor="graze" \
    org.label-schema.name="php-alpine" \
    org.label-schema.description="small php image based on alpine" \
    org.label-schema.vcs-url="https://github.com/graze/docker-php-alpine"

# Fix for iconv: https://github.com/docker-library/php/issues/240
# gnu-libiconv 1.15-r3 is the last release that ships the LD_PRELOAD-compatible
# preloadable_libiconv.so; pull it from alpine 3.13/community over HTTPS and
# install the historical alpine signing key (pinned by sha256) so we don't need
# --allow-untrusted.
RUN set -xe \
    && wget -qO /etc/apk/keys/alpine-devel@lists.alpinelinux.org-4a6a0840.rsa.pub \
        https://raw.githubusercontent.com/alpinelinux/aports/master/main/alpine-keys/alpine-devel@lists.alpinelinux.org-4a6a0840.rsa.pub \
    && echo "9c102bcc376af1498d549b77bdbfa815ae86faa1d2d82f040e616b18ef2df2d4  /etc/apk/keys/alpine-devel@lists.alpinelinux.org-4a6a0840.rsa.pub" | sha256sum -c - \
    && apk add gnu-libiconv=1.15-r3 --update-cache --repository https://dl-cdn.alpinelinux.org/alpine/v3.13/community/

RUN set -xe \
    && echo "@php http://dl-cdn.alpinelinux.org/alpine/v3.23/community" >> /etc/apk/repositories \
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
    php85 \
    php85-pecl-apcu \
    php85-pecl-event \
    php85-pecl-memcached \
    php85-pecl-yaml \
    php85-bcmath \
    php85-common \
    php85-ctype \
    php85-curl \
    php85-dom \
    php85-fileinfo \
    php85-iconv \
    php85-intl \
    php85-openssl \
    php85-mbstring \
    php85-mysqlnd \
    php85-mysqli \
    php85-pcntl \
    php85-pgsql \
    php85-pdo_mysql \
    php85-pdo_pgsql \
    php85-pdo_sqlite \
    php85-phar \
    php85-posix \
    php85-simplexml \
    php85-session \
    php85-soap \
    php85-sockets \
    php85-sodium \
    php85-tokenizer \
    php85-xml \
    php85-xmlreader \
    php85-xmlwriter \
    php85-zip \
    php85-zlib

ENV PHP_INI_DIR /etc/php85

RUN ln -s /usr/bin/php85 /usr/bin/php
RUN ln -s /usr/bin/pecl85 /usr/bin/pecl

COPY php/conf.d/*.ini $PHP_INI_DIR/conf.d/

WORKDIR /srv

ARG BUILD_DATE
ARG VCS_REF

LABEL org.label-schema.vcs-ref=$VCS_REF \
    org.label-schema.build-date=$BUILD_DATE

# Fix for iconv: https://github.com/docker-library/php/issues/240
ENV LD_PRELOAD /usr/lib/preloadable_libiconv.so php
