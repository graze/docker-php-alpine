SHELL = /bin/bash

EXECUTABLES = docker
CHECK := $(foreach executable,$(EXECUTABLES),\
	$(if $(shell which $(executable)),"",$(error "No executable found for $(executable).")))

.PHONY: build
.DEFAULT: build
build: 7.0 7.1

.PHONY: 7.0
7.0:
	docker build -t graze/php-alpine:7.0 7.0/.
	docker build -t graze/php-alpine:7.0-test -f 7.0/Dockerfile.test 7.0/.

.PHONY: 7.1
7.1:
	docker build -t graze/php-alpine:latest -t graze/php-alpine:7.1 7.1/.
	docker build -t graze/php-alpine:test -t graze/php-alpine:7.1-test -f 7.1/Dockerfile.test 7.1/.
