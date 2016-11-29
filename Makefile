SHELL = /bin/bash

EXECUTABLES = docker
CHECK := $(foreach executable,$(EXECUTABLES),\
	$(if $(shell which $(executable)),"",$(error "No executable found for $(executable).")))

.PHONY: build
.DEFAULT: build
build:
	docker build -t graze/php-alpine:latest -t graze/php-alpine:7.0 .
	docker build -t graze/php-alpine:test -t graze/php-alpine:7.0-test -f Dockerfile.test .
