CURRENT_DIR = $(shell pwd)
DOCKER_NAME ?= avdteam/base
FLAVOR ?= 3.6
BRANCH ?= $(shell git symbolic-ref --short HEAD)
# Docker ENV Var for run
ANSIBLE_VERSION ?=
PIP_REQ ?= NONE
# New Flavor creation
TEMPLATE ?= _template


.PHONY: help
help: ## Display help message
	@grep -E '^[0-9a-zA-Z_-]+\.*[0-9a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.PHONY: build
build: ## Build docker image
	if [ $(BRANCH) = 'master' ]; then \
      docker build --rm --pull -t $(DOCKER_NAME):$(FLAVOR) $(FLAVOR) ;\
	else \
	  docker build --rm --pull -t $(DOCKER_NAME):$(FLAVOR)-$(BRANCH) $(FLAVOR) ;\
    fi

.PHONY: run
run: ## run docker image
	if [ $(BRANCH) = 'master' ]; then \
		docker run --rm -it -v $(CURRENT_DIR)/:/projects \
			-e AVD_REQUIREMENTS=$(PIP_REQ) \
			-e AVD_ANSIBLE=$(ANSIBLE_VERSION) \
			-v /etc/hosts:/etc/hosts $(DOCKER_NAME):$(FLAVOR) ;\
	else \
		docker run --rm -it -v $(CURRENT_DIR)/:/projects \
			-e AVD_REQUIREMENTS=$(PIP_REQ) \
			-e AVD_ANSIBLE=$(ANSIBLE_VERSION) \
			-v /etc/hosts:/etc/hosts $(DOCKER_NAME):$(FLAVOR)-$(BRANCH) ;\
	fi


.PHONY: new-flavor
new-flavor: ## Create a new python flavor
	cp -r $(TEMPLATE) $(FLAVOR)
	sed -i '' 's/FLAVOR/$(FLAVOR)/' $(FLAVOR)/Dockerfile