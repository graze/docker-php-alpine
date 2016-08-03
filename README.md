# PHP7 Alpine Base Image

Public image for php7 alpine with a set of common extensions

## Building

    $ make

## Pulling

    $ docker pull graze/php-alpine

## Usage

    $ docker run --rm graze/php-alpine -v $(pwd):/srv php some/script.php
