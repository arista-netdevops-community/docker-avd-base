CURRENT_DIR = $(shell pwd)
DOCKER_NAME ?= avdteam/base
DOCKER_TAG ?= centos-8
ANSIBLE_VERSION ?=
PIP_REQ ?= NONE
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
			-e AVD_REQUIREMENTS=$(PIP_REQ) \
			-e AVD_ANSIBLE=$(ANSIBLE_VERSION) \
			-v /etc/hosts:/etc/hosts $(DOCKER_NAME):$(DOCKER_TAG) ;\
	else \
		docker run --rm -it -v $(CURRENT_DIR)/:/projects \
			-e AVD_REQUIREMENTS=$(PIP_REQ) \
			-e AVD_ANSIBLE=$(ANSIBLE_VERSION) \
			-v /etc/hosts:/etc/hosts $(DOCKER_NAME):$(BRANCH)-$(DOCKER_TAG) ;\
	fi
