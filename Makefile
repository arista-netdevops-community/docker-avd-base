CURRENT_DIR = $(shell pwd)
DOCKER_NAME ?= avdteam/base
DOCKER_TAG ?= debian
ANSIBLE_VERSION ?= 2.9.6

.PHONY: help
help: ## Display help message
	@grep -E '^[0-9a-zA-Z_-]+\.*[0-9a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.PHONY: build
build: ## Build docker image
	docker build -t $(DOCKER_NAME):$(DOCKER_TAG) $(DOCKER_TAG)

.PHONY: run
run: ## run docker image
	docker run --rm -it -v $(CURRENT_DIR)/:/projects \
		-v /etc/hosts:/etc/hosts $(DOCKER_NAME):$(DOCKER_TAG)

.PHONY: test-build
test-build: ## Build a new image of avd container with specific docker version
	#docker build --no-cache -t $(CONTAINER) .
	docker build -t $(DOCKER_NAME):$(DOCKER_TAG)-$(ANSIBLE_VERSION) $(DOCKER_TAG) --build-arg ANSIBLE=$(ANSIBLE_VERSION)

.PHONY: test-run
test: ## run docker test image
	docker run --rm -it -v $(HOME)/.ssh:$(HOME_DIR_DOCKER)/.ssh \
		-v $(HOME)/.gitconfig:$(HOME_DIR_DOCKER)/.gitconfig \
		-v $(CURRENT_DIR)/:/projects \
		-v /etc/hosts:/etc/hosts $(DOCKER_NAME):$(DOCKER_TAG)-$(ANSIBLE_VERSION)