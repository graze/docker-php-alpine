FROM graze/php-alpine:8.1

RUN apk add --update --no-cache \
    php81-phpdbg

ARG BUILD_DATE
ARG VCS_REF

LABEL org.label-schema.vcs-ref=$VCS_REF \
    org.label-schema.build-date=$BUILD_DATE
