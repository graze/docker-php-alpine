FROM graze/php-alpine:8.3

# The base image is built FROM php:8.3-cli-alpine which ships phpdbg as
# part of the PHP build, so no extra packages are needed for the test
# variant. This Dockerfile exists so we still produce a separate
# graze/php-alpine:8.3-test tag.

ARG BUILD_DATE
ARG VCS_REF

LABEL org.label-schema.vcs-ref=$VCS_REF \
    org.label-schema.build-date=$BUILD_DATE
