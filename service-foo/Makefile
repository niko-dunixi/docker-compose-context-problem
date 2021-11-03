DOCKER_NAME := $(notdir $(shell pwd))
DOCKER_TAG := latest

.PHONY: build
build:
	docker build --tag $(DOCKER_NAME):$(DOCKER_TAG) .

.PHONY: run
run: build
	docker run --rm -it -p 8080:8080 $(DOCKER_NAME):$(DOCKER_TAG)

.PHONY: test
test:
	cargo test