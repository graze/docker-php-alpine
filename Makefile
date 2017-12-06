SHELL = /bin/bash

NOW ?= $(shell date -u +%Y%m%d-%H%M)

docker_bats := docker run --rm \
		-v $$(pwd):/app -v /var/run/docker.sock:/var/run/docker.sock \
		graze/bats

build_args := --build-arg BUILD_DATE=$(shell date -u +"%Y-%m-%dT%H:%M:%SZ") \
              --build-arg VCS_REF=$(shell git rev-parse --short HEAD)

.PHONY: build build-quick
.PHONY: tag tag-5.6 tag-7.0 tag-7.1 tag-7.2
.PHONY: test
.PHONY: push push-5.6 push-7.0 push-7.1 push-7.2
.PHONY: clean
.PHONY: deploy

.DEFAULT: build
build: build-5.6 build-7.0 build-7.1 build-7.2
build-quick:
	make build cache="" pull=""

tag: tag-5.6 tag-7.0 tag-7.1 tag-7.2
test: test-5.6 test-7.0 test-7.1 test-7.2
push: push-5.6 push-7.0 push-7.1 push-7.2
clean: clean-5.6 clean-7.0 clean-7.1 clean-7.2
deploy: deploy-5.6 deploy-7.0 deploy-7.1 deploy-7.2

build-%: cache ?= --no-cache
build-%: pull ?= --pull
build-%: ## build a generic image
	docker build ${build_args} ${cache} ${pull} -t graze/php-alpine:$* $*/.
	docker build ${build_args} ${cache} -t graze/php-alpine:$*-test -f $*/Dockerfile.debug $*/.

clean-%: ## Clean up the images
	docker rmi $$(docker images -q graze/php-alpine:$**) || echo "no images"

deploy-%: ## Deploy a specific version
	make tag-$* push-$* NOW=${NOW}

test-%: ## Test a version
	${docker_bats} ./$*/php$*.bats
	${docker_bats} ./$*/php$*_debug.bats

tag-5.6: ## Tag the 5.6 images
	docker tag graze/php-alpine:5.6 graze/php-alpine:5
	docker tag graze/php-alpine:5.6 graze/php-alpine:5-${NOW}
	docker tag graze/php-alpine:5.6 graze/php-alpine:5.6-${NOW}
	docker tag graze/php-alpine:5.6-test graze/php-alpine:5-test
	docker tag graze/php-alpine:5.6-test graze/php-alpine:5-test-${NOW}
	docker tag graze/php-alpine:5.6-test graze/php-alpine:5.6-test-${NOW}

push-5.6: ## Push 5.6 images
	docker push graze/php-alpine:5.6
	docker push graze/php-alpine:5
	docker push graze/php-alpine:5.6-test
	docker push graze/php-alpine:5-test
	docker push graze/php-alpine:5.6-${NOW}
	docker push graze/php-alpine:5-${NOW}
	docker push graze/php-alpine:5.6-test-${NOW}
	docker push graze/php-alpine:5-test-${NOW}

tag-7.0: ## Tag the 7.0 images
	docker tag graze/php-alpine:7.0 graze/php-alpine:7.0-${NOW}
	docker tag graze/php-alpine:7.0-test graze/php-alpine:7.0-test-${NOW}

push-7.0: ## Push 7.0 images
	docker push graze/php-alpine:7.0
	docker push graze/php-alpine:7.0-test
	docker push graze/php-alpine:7.0-${NOW}
	docker push graze/php-alpine:7.0-test-${NOW}

tag-7.1: ## Tag the 7.1 images
	docker tag graze/php-alpine:7.1 graze/php-alpine:7.1-${NOW}
	docker tag graze/php-alpine:7.1-test graze/php-alpine:7-test
	docker tag graze/php-alpine:7.1-test graze/php-alpine:7.1-test-${NOW}

push-7.1: ## Push 7.1 images
	docker push graze/php-alpine:7.1
	docker push graze/php-alpine:7.1-test
	docker push graze/php-alpine:7.1-${NOW}
	docker push graze/php-alpine:7.1-test-${NOW}

tag-7.2: ## Tag the 7.2 images
	docker tag graze/php-alpine:7.2 graze/php-alpine:latest
	docker tag graze/php-alpine:7.2 graze/php-alpine:7
	docker tag graze/php-alpine:7.2 graze/php-alpine:${NOW}
	docker tag graze/php-alpine:7.2 graze/php-alpine:7.2-${NOW}
	docker tag graze/php-alpine:7.2 graze/php-alpine:7-${NOW}
	docker tag graze/php-alpine:7.2-test graze/php-alpine:7-test
	docker tag graze/php-alpine:7.2-test graze/php-alpine:test
	docker tag graze/php-alpine:7.2-test graze/php-alpine:7.2-test-${NOW}
	docker tag graze/php-alpine:7.2-test graze/php-alpine:7-test-${NOW}
	docker tag graze/php-alpine:7.2-test graze/php-alpine:test-${NOW}

push-7.2: ## Push 7.2 images
	docker push graze/php-alpine:7.2
	docker push graze/php-alpine:7
	docker push graze/php-alpine:latest
	docker push graze/php-alpine:7.2-test
	docker push graze/php-alpine:7-test
	docker push graze/php-alpine:test
	docker push graze/php-alpine:7.2-${NOW}
	docker push graze/php-alpine:7-${NOW}
	docker push graze/php-alpine:${NOW}
	docker push graze/php-alpine:7.2-test-${NOW}
	docker push graze/php-alpine:7-test-${NOW}
	docker push graze/php-alpine:test-${NOW}
