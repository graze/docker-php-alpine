SHELL = /bin/bash

EXECUTABLES = docker bats jq
CHECK := $(foreach executable,$(EXECUTABLES),\
	$(if $(shell which $(executable)),"",$(error "No executable found for $(executable).")))
NOW ?= $(shell date -u +%Y%m%d-%H%M)

.PHONY: build build-quick build-5.6 build-5.6-debug build-7.0 build-7.0-debug build-7.1 build-7.1-debug
.PHONY: test test-5.6 test-7.0 test-7.1
.PHONY: push push-5.6 push-7.0 push-7.1

.DEFAULT: build
build: build-5.6 build-5.6-debug build-7.0 build-7.0-debug build-7.1 build-7.1-debug
build-quick:
	make build cache=""

test: test-5.6 test-7.0 test-7.1
push: push-5.6 push-5.6-debug push-7.0 push-7.0-debug push-7.1 push-7.1-debug

build-5.6: cache ?=--pull --no-cache
build-5.6: ## Build the 5.6 image
	docker build ${cache} \
		-t graze/php-alpine:5.6 \
		-t graze/php-alpine:5 \
		-t graze/php-alpine:5.6-${NOW} \
		-t graze/php-alpine:5-${NOW} \
		5.6/.

build-5.6-debug: cache ?=--pull --no-cache
build-5.6-debug: ## Build the 5.6 debug image
	docker build ${cache} \
		-t graze/php-alpine:5.6-debug \
		-t graze/php-alpine:5.6-test \
		-t graze/php-alpine:5.6-debug-${NOW} \
		-t graze/php-alpine:5.6-test-${NOW} \
		-t graze/php-alpine:5-debug \
		-t graze/php-alpine:5-test \
		-t graze/php-alpine:5-debug-${NOW} \
		-t graze/php-alpine:5-test-${NOW} \
		-f 5.6/Dockerfile.debug 5.6/.

test-5.6:
	./5.6/php5.6.bats
	./5.6/php5.6_debug.bats

push-5.6:
	docker push graze/php-alpine:5.6
	docker push graze/php-alpine:5
	docker push graze/php-alpine:5.6-${NOW}
	docker push graze/php-alpine:5-${NOW}

push-5.6-debug:
	docker push graze/php-alpine:5.6-debug
	docker push graze/php-alpine:5.6-test
	docker push graze/php-alpine:5.6-debug-${NOW}
	docker push graze/php-alpine:5.6-test-${NOW}
	docker push graze/php-alpine:5-debug
	docker push graze/php-alpine:5-test
	docker push graze/php-alpine:5-debug-${NOW}
	docker push graze/php-alpine:5-test-${NOW}

build-7.0: cache ?=--pull --no-cache
build-7.0: ## Build the 7.0 image
	docker build ${cache} \
		-t graze/php-alpine:7.0 \
		-t graze/php-alpine:7.0-${NOW} \
		7.0/.

build-7.0-debug: cache ?=--pull --no-cache
build-7.0-debug: ## Build the 7.0 debug image
	docker build ${cache} \
		-t graze/php-alpine:7.0-debug \
		-t graze/php-alpine:7.0-test \
		-t graze/php-alpine:7.0-debug-${NOW} \
		-t graze/php-alpine:7.0-test-${NOW} \
		-f 7.0/Dockerfile.debug 7.0/.

test-7.0:
	./7.0/php7.0.bats
	./7.0/php7.0_debug.bats

push-7.0:
	docker push graze/php-alpine:7.0
	docker push graze/php-alpine:7.0-${NOW}

push-7.0-debug:
	docker push graze/php-alpine:7.0-debug
	docker push graze/php-alpine:7.0-test
	docker push graze/php-alpine:7.0-debug-${NOW}
	docker push graze/php-alpine:7.0-test-${NOW}

build-7.1: cache ?=--pull --no-cache
build-7.1: ## Build the 7.1 image
	docker build ${cache} \
		-t graze/php-alpine:latest \
		-t graze/php-alpine:7.1 \
		-t graze/php-alpine:7 \
		-t graze/php-alpine:${NOW} \
		-t graze/php-alpine:7.1-${NOW} \
		-t graze/php-alpine:7-${NOW} \
		7.1/.

build-7.1-debug: cache ?=--pull --no-cache
build-7.1-debug: ## Build the 7.1 debug image
	docker build ${cache} \
		-t graze/php-alpine:debug \
		-t graze/php-alpine:test \
		-t graze/php-alpine:debug-${NOW} \
		-t graze/php-alpine:test-${NOW} \
		-t graze/php-alpine:7.1-debug \
		-t graze/php-alpine:7.1-test \
		-t graze/php-alpine:7.1-debug-${NOW} \
		-t graze/php-alpine:7.1-test-${NOW} \
		-t graze/php-alpine:7-debug \
		-t graze/php-alpine:7-test \
		-t graze/php-alpine:7-debug-${NOW} \
		-t graze/php-alpine:7-test-${NOW} \
		-f 7.1/Dockerfile.debug 7.1/.

test-7.1:
	./7.1/php7.1.bats
	./7.1/php7.1_debug.bats

push-7.1:
	docker push graze/php-alpine:latest
	docker push graze/php-alpine:7.1
	docker push graze/php-alpine:7
	docker push graze/php-alpine:${NOW}
	docker push graze/php-alpine:7.1-${NOW}
	docker push graze/php-alpine:7-${NOW}

push-7.1-debug:
	docker push graze/php-alpine:debug
	docker push graze/php-alpine:test
	docker push graze/php-alpine:debug-${NOW}
	docker push graze/php-alpine:test-${NOW}
	docker push graze/php-alpine:7.1-debug
	docker push graze/php-alpine:7.1-test
	docker push graze/php-alpine:7.1-debug-${NOW}
	docker push graze/php-alpine:7.1-test-${NOW}
	docker push graze/php-alpine:7-debug
	docker push graze/php-alpine:7-test
	docker push graze/php-alpine:7-debug-${NOW}
	docker push graze/php-alpine:7-test-${NOW}
