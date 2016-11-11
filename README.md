# PHP7 Alpine Base Image

[![](https://images.microbadger.com/badges/image/graze/php-alpine.svg)](https://microbadger.com/images/graze/php-alpine "Get your own image badge on microbadger.com")


Public image for php7 alpine with a set of common extensions

## Building

    $ make

## Pulling

    $ docker pull graze/php-alpine

## Usage

    $ docker run --rm graze/php-alpine -v $(pwd):/srv php some/script.php
