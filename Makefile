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
		-e GIT_CONFIG_COUNT=1 \
		-e GIT_CONFIG_KEY_0=safe.directory \
		-e GIT_CONFIG_VALUE_0=/app \
		graze/bats

build_args := --build-arg BUILD_DATE=$(shell date -u +"%Y-%m-%dT%H:%M:%SZ") \
              --build-arg VCS_REF=$(shell git rev-parse --short HEAD)

VERSIONS := $(shell jq -r '.[].version' versions.json)

latest_5 := 5.6
latest_7 := 7.4
latest_8 := 8.5
latest := 8.5

.PHONY: build build-quick
.PHONY: tag
.PHONY: test
.PHONY: push
.PHONY: clean
.PHONY: deploy
.PHONY: prod-build prod-build-quick

.DEFAULT: build
build: $(addprefix build-,$(VERSIONS))
build-quick:
	make build cache="" pull=""

build-quick-%:
	make build-$* cache="" pull=""

prod-build: $(addprefix prod-build-,$(VERSIONS))
prod-build-quick:
	make prod-build cache="" pull=""

prod-build-quick-%:
	make prod-build-$* cache="" pull=""

tag: $(addprefix tag-,$(VERSIONS))
test: $(addprefix test-,$(VERSIONS))
push: $(addprefix push-,$(VERSIONS))
clean: $(addprefix clean-,$(VERSIONS))
deploy: $(addprefix deploy-,$(VERSIONS))

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