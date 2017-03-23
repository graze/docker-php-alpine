SHELL = /bin/bash

EXECUTABLES = docker bats jq
CHECK := $(foreach executable,$(EXECUTABLES),\
	$(if $(shell which $(executable)),"",$(error "No executable found for $(executable).")))
NOW ?= $(shell date -u +%Y%m%d-%H%M)

.PHONY: build build-quick
.PHONY: tag tag-5.6 tag-7.0 tag-7.1
.PHONY: test test-5.6 test-7.0 test-7.1
.PHONY: push push-5.6 push-7.0 push-7.1
.PHONY: clean
.PHONY: deploy

.DEFAULT: build
build: build-5.6 build-7.0 build-7.1
build-quick:
	make build cache=""

test: test-5.6 test-7.0 test-7.1
tag: tag-5.6 tag-7.0 tag-7.1
push: push-5.6 push-7.0 push-7.1
clean: clean-5.6 clean-7.0 clean-7.1

deploy: build-quick tag push

build-%: cache ?=--pull --no-cache
build-%: ## build a generic image
	docker build ${cache} -t graze/php-alpine:$* $*/.
	docker build ${cache} -t graze/php-alpine:$*-test -f $*/Dockerfile.debug $*/.

clean-%: ## Clean up the images
	docker rmi $$(docker images -q graze/php-alpine:$**)

tag-5.6:
	docker tag graze/php-alpine:5.6 graze/php-alpine:5
	docker tag graze/php-alpine:5.6 graze/php-alpine:5-${NOW}
	docker tag graze/php-alpine:5.6 graze/php-alpine:5.6-${NOW}
	docker tag graze/php-alpine:5.6-test graze/php-alpine:5.6-test
	docker tag graze/php-alpine:5.6-test graze/php-alpine:5-test-${NOW}
	docker tag graze/php-alpine:5.6-test graze/php-alpine:5.6-test-${NOW}

test-5.6:
	./5.6/php5.6.bats
	./5.6/php5.6_debug.bats

push-5.6:
	docker push graze/php-alpine:5.6
	docker push graze/php-alpine:5
	docker push graze/php-alpine:5.6-${NOW}
	docker push graze/php-alpine:5-${NOW}
	docker push graze/php-alpine:5.6-test
	docker push graze/php-alpine:5-test
	docker push graze/php-alpine:5.6-test-${NOW}
	docker push graze/php-alpine:5-test-${NOW}

tag-7.0: ## Tag the 7.0 images
	docker tag graze/php-alpine:7.0 graze/php-alpine:7.0-${NOW}
	docker tag graze/php-alpine:7.0-test graze/php-alpine:7.0-test-${NOW}

test-7.0:
	./7.0/php7.0.bats
	./7.0/php7.0_debug.bats

push-7.0:
	docker push graze/php-alpine:7.0
	docker push graze/php-alpine:7.0-test
	docker push graze/php-alpine:7.0-${NOW}
	docker push graze/php-alpine:7.0-test-${NOW}

tag-7.1: ## Tag the 7.1 images
	docker tag graze/php-alpine:7.1 graze/php-alpine:latest
	docker tag graze/php-alpine:7.1 graze/php-alpine:7
	docker tag graze/php-alpine:7.1 graze/php-alpine:${NOW}
	docker tag graze/php-alpine:7.1 graze/php-alpine:7.1-${NOW}
	docker tag graze/php-alpine:7.1 graze/php-alpine:7-${NOW}
	docker tag graze/php-alpine:7.1-test graze/php-alpine:7-test
	docker tag graze/php-alpine:7.1-test graze/php-alpine:test
	docker tag graze/php-alpine:7.1-test graze/php-alpine:7.1-test-${NOW}
	docker tag graze/php-alpine:7.1-test graze/php-alpine:7-test-${NOW}
	docker tag graze/php-alpine:7.1-test graze/php-alpine:test-${NOW}

test-7.1:
	./7.1/php7.1.bats
	./7.1/php7.1_debug.bats

push-7.1:
	docker push graze/php-alpine:7.1
	docker push graze/php-alpine:7
	docker push graze/php-alpine:latest
	docker push graze/php-alpine:7.1-test
	docker push graze/php-alpine:7-test
	docker push graze/php-alpine:test
	docker push graze/php-alpine:7.1-${NOW}
	docker push graze/php-alpine:7-${NOW}
	docker push graze/php-alpine:${NOW}
	docker push graze/php-alpine:7.1-test-${NOW}
	docker push graze/php-alpine:7-test-${NOW}
	docker push graze/php-alpine:test-${NOW}
