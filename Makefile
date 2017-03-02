SHELL = /bin/bash

EXECUTABLES = docker bats jq
CHECK := $(foreach executable,$(EXECUTABLES),\
	$(if $(shell which $(executable)),"",$(error "No executable found for $(executable).")))

.PHONY: build
.DEFAULT: build
build: build-7.0 build-7.0-debug build-7.1 build-7.1-debug

.PHONY: 7.0
build-7.0:
	docker build -t graze/php-alpine:7.0 7.0/.

build-7.0-debug:
	docker build -t graze/php-alpine:7.0-debug -f 7.0/Dockerfile.debug 7.0/.

.PHONY: 7.1
build-7.1:
	docker build -t graze/php-alpine:latest -t graze/php-alpine:7.1 7.1/.

build-7.1-debug:
	docker build -t graze/php-alpine:debug -t graze/php-alpine:7.1-debug -f 7.1/Dockerfile.debug 7.1/.

.PHONY: test
test: test-7.0 test-7.1

.PHONY: test-7.0
test-7.0:
	./7.0/php7.0.bats
	./7.0/php7.0_debug.bats

.PHONY: test-7.1
test-7.1:
	./7.1/php7.1.bats
	./7.1/php7.1_debug.bats
