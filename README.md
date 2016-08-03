# Stats Docker Images

This is a stats specific image for running everything stats does.

All tags are under the `graze/stats` docker repository

## Main Images

These images are based on `alpine:edge` and use packages to install the required components

| make target | tags                     | description                                                    | size     |
|-------------|--------------------------|----------------------------------------------------------------|----------|
| php7        | `7.0`                    | base php7 image with php and extensions on alpine              | 73.97 MB |
| php7-cli    | `cli` `7.0-cli` `latest` | Command line php7 image with extra tools for data manipulation | 157.1 MB |
| php7-apache | `apache` `7.0-apache`    | Apache web server php7 image                                   | 84.77 MB |

## Building

To build both `php7-cli` and `php7-apache` run in `stats/`

    $ make

## Pulling

    $ docker pull graze/stats

## Deploying to live

    $ make deploy

## Test Images

Ignore these for now

| make target          | tag                   | description                                                      | size     |
|----------------------|-----------------------|------------------------------------------------------------------|----------|
| old/build            | `5.6-old`             | Image based on graze/php:5.5                                     | 697.9 MB |
| old/php7             | `7.0-old`             | Command line php7 image with extra tools for data manipulation   | 752.4 MB |
| official/php5        | `5.6-official`        | php5.6 image based on the official php alpine image              | 276.4 MB |
| official/php5-apache | `5.6-official-apache` | php5.6 image with apache based off the official php alpine image | 280 MB   |
| official/php7        | `7.0-official`        | php7 image based on the official php alpine image                | 337.5 MB |
| official/php7-apache | `7.0-official-apache` | php7 image with apache based on the official php alpine image    | 341 MB   |
