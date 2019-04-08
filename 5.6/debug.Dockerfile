FROM graze/php-alpine:5.6

RUN apk add --no-cache \
    php5-xdebug

RUN set -xe \
    && echo "zend_extension=xdebug.so" >> $PHP_INI_DIR/conf.d/xdebug.ini

COPY php/php.ini $PHP_INI_DIR/

ARG BUILD_DATE
ARG VCS_REF

LABEL org.label-schema.vcs-ref=$VCS_REF \
    org.label-schema.build-date=$BUILD_DATE
