SHELL = /bin/bash

docker_bats := docker run --rm \
		-v $$(pwd):/app -v /var/run/docker.sock:/var/run/docker.sock \
		-e container \
		graze/bats

build_args := --build-arg BUILD_DATE=$(shell date -u +"%Y-%m-%dT%H:%M:%SZ") \
              --build-arg VCS_REF=$(shell git rev-parse --short HEAD)

latest_5 := 5.6
latest_7 := 7.4
latest_8 := 8.0
latest := 7.4

.PHONY: build build-quick
.PHONY: tag
.PHONY: test
.PHONY: push
.PHONY: clean
.PHONY: deploy

.DEFAULT: build
build: build-5.6 build-7.0 build-7.1 build-7.2 build-7.3 build-7.4
build-quick:
	make build cache="" pull=""

tag: tag-5.6 tag-7.0 tag-7.1 tag-7.2 tag-7.3 tag-7.4
test: test-5.6 test-7.0 test-7.1 test-7.2 test-7.3 test-7.4
push: push-5.6 push-7.0 push-7.1 push-7.2 push-7.3 push-7.4
clean: clean-5.6 clean-7.0 clean-7.1 clean-7.2 clean-7.3 clean-7.4
deploy: deploy-5.6 deploy-7.0 deploy-7.1 deploy-7.2 deploy-7.3 deploy-7.4

build-%: cache ?= --no-cache
build-%: pull ?= --pull
build-%: ## build a generic image
	docker build ${build_args} ${cache} ${pull} -t graze/php-alpine:$* $*/.
	docker build ${build_args} ${cache} -t graze/php-alpine:$*-test -f $*/debug.Dockerfile $*/.

clean-%: ## Clean up the images
	docker rmi $$(docker images -q graze/php-alpine:$**) || echo "no images"

deploy-%: ## Deploy a specific version
	make tag-$* push-$*

test-%: ## Test a version
	container=graze/php-alpine:$* ${docker_bats} ./common/php.bats ./$*/php.bats
	container=graze/php-alpine:$*-test ${docker_bats} ./common/php.bats ./$*/php.bats ./$*/php_debug.bats
	${docker_bats} ./$*/tags.bats

tag-%: ## Tag an image
	@if [ "$*" = "${latest_5}" ]; then \
		echo "Tagging latest 5.x version ($*)"; \
		docker tag graze/php-alpine:$*-test graze/php-alpine:5-test; \
		docker tag graze/php-alpine:$* graze/php-alpine:5; \
	fi
	@if [ "$*" = "${latest_7}" ]; then \
		echo "Tagging latest 7.x version ($*)"; \
		docker tag graze/php-alpine:$*-test graze/php-alpine:7-test; \
		docker tag graze/php-alpine:$* graze/php-alpine:7; \
	fi
	@if [ "$*" = "${latest_8}" ]; then \
		echo "Tagging latest 8.x version ($*)"; \
		docker tag graze/php-alpine:$*-test graze/php-alpine:8-test; \
		docker tag graze/php-alpine:$* graze/php-alpine:8; \
	fi
	@if [ "$*" = "${latest}" ]; then \
		echo "Tagging latest version ($*)"; \
		docker tag graze/php-alpine:$*-test graze/php-alpine:test; \
		docker tag graze/php-alpine:$* graze/php-alpine:latest; \
	fi

push-%: ## Push an image
	docker push graze/php-alpine:$*-test
	docker push graze/php-alpine:$*
	@if [ "$*" = "${latest_5}" ]; then \
		echo "Pushing latest 5.x version ($*)"; \
		docker push graze/php-alpine:5-test; \
		docker push graze/php-alpine:5; \
	fi
	@if [ "$*" = "${latest_7}" ]; then \
		echo "Pushing latest 7.x version ($*)"; \
		docker push graze/php-alpine:7-test; \
		docker push graze/php-alpine:7; \
	fi
	@if [ "$*" = "${latest}" ]; then \
		echo "Pushing latest version ($*)"; \
		docker push graze/php-alpine:test; \
		docker push graze/php-alpine:latest; \
	fi
