# PHP Alpine Base Images

[![Build Status](https://img.shields.io/travis/graze/docker-php-alpine/master.svg)](https://travis-ci.org/graze/docker-php-alpine)
[![Docker Pulls](https://img.shields.io/docker/pulls/graze/php-alpine.svg)](https://hub.docker.com/r/graze/php-alpine/)
[![Image Size](https://images.microbadger.com/badges/image/graze/php-alpine.svg)](https://microbadger.com/images/graze/php-alpine)

Public image for php in alpine with a set of common extensions

## Images

- `7.1`, `7`, `latest` [7.1/Dockerfile](https://github.com/graze/docker-php-alpine/blob/master/7.1/Dockerfile)
- `7.0` [7.0/Dockerfile](https://github.com/graze/docker-php-alpine/blob/master/7.0/Dockerfile)
- `5.6`, `5` [5.6/Dockerfile](https://github.com/graze/docker-php-alpine/blob/master/5.6/Dockerfile)

### Testing Images

Testing images are the same as the standard, but with xdebug (php5.6) or phpdbg (php7.*)

- `7.1-test`, `7-test`, `test` [7.1/Dockerfile.debug](https://github.com/graze/docker-php-alpine/blob/master/7.1/Dockerfile.debug)
- `7.0-test` [7.0/Dockerfile.debug](https://github.com/graze/docker-php-alpine/blob/master/7.0/Dockerfile.debug)
- `5.6-test`, `5-test` [5.6/Dockerfile.debug](https://github.com/graze/docker-php-alpine/blob/master/5.6/Dockerfile.debug)

## Building

    ~ $ make build-quick

## Pulling

    ~ $ docker pull graze/php-alpine

## Usage

    ~ $ docker run --rm graze/php-alpine -v $(pwd):/srv php some/script.php

## Running with phpdbg

    ~ $ docker run --rm graze/php-alpine:test -v $(pwd):/srv phpdbg7 some/script.php
