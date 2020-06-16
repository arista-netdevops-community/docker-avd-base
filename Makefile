CURRENT_DIR = $(shell pwd)
DOCKER_NAME ?= avdteam/base
DOCKER_TAG ?= centos-8
ANSIBLE_VERSION ?= 2.9.6
BRANCH ?= $(shell git symbolic-ref --short HEAD)

.PHONY: help
help: ## Display help message
	@grep -E '^[0-9a-zA-Z_-]+\.*[0-9a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.PHONY: build
build: ## Build docker image
	if [ $(BRANCH) = 'master' ]; then \
      docker build --rm --pull -t $(DOCKER_NAME):$(DOCKER_TAG) $(DOCKER_TAG) ;\
	else \
	  docker build --rm --pull -t $(DOCKER_NAME):$(BRANCH)-$(DOCKER_TAG) $(DOCKER_TAG) ;\
    fi

.PHONY: run
run: ## run docker image
	if [ $(BRANCH) = 'master' ]; then \
		docker run --rm -it -v $(CURRENT_DIR)/:/projects \
			-v /etc/hosts:/etc/hosts $(DOCKER_NAME):$(DOCKER_TAG) ;\
	else \
		docker run --rm -it -v $(CURRENT_DIR)/:/projects \
			-v /etc/hosts:/etc/hosts $(DOCKER_NAME):$(BRANCH)-$(DOCKER_TAG) ;\
	fi

.PHONY: build-test
build-test: ## Build a new image of avd container with specific docker version
	if [ $(BRANCH) = 'master' ]; then \
		docker build -t $(DOCKER_NAME):$(DOCKER_TAG)-$(ANSIBLE_VERSION) $(DOCKER_TAG) --build-arg ANSIBLE=$(ANSIBLE_VERSION) ;\
	else \
		docker build -t $(DOCKER_NAME):$(BRANCH)-$(DOCKER_TAG)-$(ANSIBLE_VERSION) $(DOCKER_TAG) --build-arg ANSIBLE=$(ANSIBLE_VERSION) ;\
	fi

.PHONY: run-test
run-test: ## run docker test image with specific ansible version
	if [ $(BRANCH) = 'master' ]; then \
		docker run --rm -it -v $(HOME)/.ssh:$(HOME_DIR_DOCKER)/.ssh \
			-v $(HOME)/.gitconfig:$(HOME_DIR_DOCKER)/.gitconfig \
			-v $(CURRENT_DIR)/:/projects \
			-v /etc/hosts:/etc/hosts $(DOCKER_NAME):$(DOCKER_TAG)-$(ANSIBLE_VERSION) ;\
	else \
		docker run --rm -it -v $(HOME)/.ssh:$(HOME_DIR_DOCKER)/.ssh \
			-v $(HOME)/.gitconfig:$(HOME_DIR_DOCKER)/.gitconfig \
			-v $(CURRENT_DIR)/:/projects \
			-v /etc/hosts:/etc/hosts $(DOCKER_NAME):$(BRANCH)-$(DOCKER_TAG)-$(ANSIBLE_VERSION) ;\
	fi