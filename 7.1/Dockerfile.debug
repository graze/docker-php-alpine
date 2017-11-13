FROM graze/php-alpine:7.1

RUN apk add --no-cache \
    php7-phpdbg

ARG BUILD_DATE
ARG VCS_REF

LABEL org.label-schema.vcs-ref=$VCS_REF \
    org.label-schema.build-date=$BUILD_DATE
