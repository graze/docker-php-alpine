SHELL = /bin/bash

UNAME := $(shell uname -m)
PLATFORM = amd64
ifeq ($(UNAME), arm64)
  PLATFORM = arm64
  extra_bats_path = ./common/php-arm64.bats
endif

docker_bats := docker run --rm \
		--platform linux/${PLATFORM} \
		-v $$(pwd):/app -v /var/run/docker.sock:/var/run/docker.sock \
		-e container \
		graze/bats

build_args := --build-arg BUILD_DATE=$(shell date -u +"%Y-%m-%dT%H:%M:%SZ") \
              --build-arg VCS_REF=$(shell git rev-parse --short HEAD)

latest_5 := 5.6
latest_7 := 7.4
latest_8 := 8.2
latest := 8.2

.PHONY: build build-quick
.PHONY: tag
.PHONY: test
.PHONY: push
.PHONY: clean
.PHONY: deploy
.PHONY: prod-build prod-build-quick

.DEFAULT: build
build: build-5.6 build-7.0 build-7.1 build-7.2 build-7.3 build-7.4 build-8.0 build-8.1 build-8.2
build-quick:
	make build cache="" pull=""

build-quick-%:
	make build-$* cache="" pull=""

prod-build: prod-build-5.6 prod-build-7.0 prod-build-7.1 prod-build-7.2 prod-build-7.3 prod-build-7.4 prod-build-8.0 prod-build-8.1 prod-build-8.2
prod-build-quick:
	make prod-build cache="" pull=""

prod-build-quick-%:
	make prod-build-$* cache="" pull=""

tag: tag-5.6 tag-7.0 tag-7.1 tag-7.2 tag-7.3 tag-7.4 tag-8.0 tag-8.1 test-8.2
test: test-5.6 test-7.0 test-7.1 test-7.2 test-7.3 test-7.4 test-8.0 test-8.1 test-8.2
push: push-5.6 push-7.0 push-7.1 push-7.2 push-7.3 push-7.4 push-8.0 push-8.1 push-8.2
clean: clean-5.6 clean-7.0 clean-7.1 clean-7.2 clean-7.3 clean-7.4 clean-8.0 clean-8.1 clean-8.2
deploy: deploy-5.6 deploy-7.0 deploy-7.1 deploy-7.2 deploy-7.3 deploy-7.4 deploy-8.0 deploy-8.1 deploy-8.2

build-%: cache ?= --no-cache
build-%: pull ?= --pull
build-%: platform ?= --platform=linux/amd64,linux/arm64,linux/arm/v7
build-%: output-type ?= --output=type=docker
build-%: ## build a generic image
	docker buildx build ${output-type} ${platform} ${build_args} ${cache} ${pull} -t graze/php-alpine:$* $*/.
	docker buildx build ${output-type} ${platform} ${build_args} ${cache} -t graze/php-alpine:$*-test -f $*/debug.Dockerfile $*/.

prod-build-%: cache ?= --no-cache
prod-build-%: pull ?= --pull
prod-build-%: platform ?= --platform=linux/amd64,linux/arm64,linux/arm/v7
prod-build-%: output-type ?= --output=type=docker
prod-build-%:
	docker buildx build ${output-type} ${platform} ${build_args} ${cache} ${pull} -t graze/php-alpine:$* $*/.

clean-%: ## Clean up the images
	docker rmi $$(docker images -q graze/php-alpine:$**) || echo "no images"

deploy-%: ## Deploy a specific version
	make tag-$* push-$*

test-%: ## Test a version
	container=graze/php-alpine:$* ${docker_bats} ${extra_bats_path} ./common/php.bats ./$*/php.bats
	container=graze/php-alpine:$*-test ${docker_bats} ${extra_bats_path} ./common/php.bats ./$*/php.bats ./$*/php_debug.bats
	${docker_bats} ./$*/tags.bats

prod-test-%: ## Test a version
	container=graze/php-alpine:$* ${docker_bats} ${extra_bats_path} ./common/php.bats ./$*/php.bats

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
	@if [ "$*" = "${latest_8}" ]; then \
		echo "Pushing latest 8.x version ($*)"; \
		docker push graze/php-alpine:8-test; \
		docker push graze/php-alpine:8; \
	fi
	@if [ "$*" = "${latest}" ]; then \
		echo "Pushing latest version ($*)"; \
		docker push graze/php-alpine:test; \
		docker push graze/php-alpine:latest; \
	fi

prod-push-%: ## Push an image
	docker push graze/php-alpine:$*