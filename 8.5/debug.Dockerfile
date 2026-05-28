FROM graze/php-alpine:8.5

RUN apk add --update --no-cache \
    php85-phpdbg

ARG BUILD_DATE
ARG VCS_REF

LABEL org.label-schema.vcs-ref=$VCS_REF \
    org.label-schema.build-date=$BUILD_DATE
