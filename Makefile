CURRENT_DIR = $(shell pwd)
DOCKER_NAME ?= avdteam/base
FLAVOR ?= 3.6
BRANCH ?= $(shell git symbolic-ref --short HEAD)
# Docker ENV Var for run
ANSIBLE_VERSION ?=
PIP_REQ ?= NONE
# New Flavor creation
TEMPLATE ?= _template
UID ?= 1000
GID ?= 1000

.PHONY: help
help: ## Display help message
	@grep -E '^[0-9a-zA-Z_-]+\.*[0-9a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'


.PHONY: generate
generate:  ## Generate Dockerfile from template folder
	python docker-generator.py


.PHONY: build
build: ## Build docker image
	python docker-generator.py
	if [ $(BRANCH) = 'master' ]; then \
      docker build --rm --pull -t $(DOCKER_NAME):$(FLAVOR) -f $(FLAVOR)/Dockerfile .;\
	else \
	  docker build --rm --pull -t $(DOCKER_NAME):$(FLAVOR)-$(BRANCH) -f $(FLAVOR)/Dockerfile .;\
    fi


.PHONY: run
run: ## run docker image
	if [ $(BRANCH) = 'master' ]; then \
		docker run --rm -it -v $(CURRENT_DIR)/:/projects \
			-e AVD_REQUIREMENTS=$(PIP_REQ) \
			-e AVD_ANSIBLE=$(ANSIBLE_VERSION) \
			-e AVD_GIT_USER="$(shell git config --get user.name)" \
			-e AVD_GIT_EMAIL="$(shell git config --get user.email)" \
			-e AVD_UID=$(UID) \
			-e AVD_GID=$(GID) \
			-v /etc/hosts:/etc/hosts $(DOCKER_NAME):$(FLAVOR) ;\
	else \
		docker run --rm -it -v $(CURRENT_DIR)/:/projects \
			-e AVD_REQUIREMENTS=$(PIP_REQ) \
			-e AVD_ANSIBLE=$(ANSIBLE_VERSION) \
			-e AVD_GIT_USER="$(shell git config --get user.name)" \
			-e AVD_GIT_EMAIL="$(shell git config --get user.email)" \
			-e AVD_UID=$(UID) \
			-e AVD_GID=$(GID) \
			-v /etc/hosts:/etc/hosts $(DOCKER_NAME):$(FLAVOR)-$(BRANCH) ;\
	fi


.PHONY: new-flavor
new-flavor: ## Create a new python flavor
	cp -r $(TEMPLATE) $(FLAVOR)
	sed -i '' 's/FLAVOR/$(FLAVOR)/' $(FLAVOR)/Dockerfile
