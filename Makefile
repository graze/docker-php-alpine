SHELL = /bin/bash

EXECUTABLES = docker
CHECK := $(foreach executable,$(EXECUTABLES),\
	$(if $(shell which $(executable)),"",$(error "No executable found for $(executable).")))

.PHONY: build

build:
	docker build -t graze/php-alpine:latest -t graze/php-alpine:7.0 .
