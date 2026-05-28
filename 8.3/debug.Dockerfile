FROM graze/php-alpine:8.3

RUN apk add --update --no-cache \
    php83-phpdbg

ARG BUILD_DATE
ARG VCS_REF

LABEL org.label-schema.vcs-ref=$VCS_REF \
    org.label-schema.build-date=$BUILD_DATE
