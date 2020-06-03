# AVD Base Image User guide

## Requirements

- Any Docker engine
- [GNU make](https://www.gnu.org/software/make/manual/make.html)



## Build Image with AVD Ansible version

### Build image locally

__BUILD__ target uses 2 different variables

- `DOCKER_NAME`: complete name to use for image. If it must be uploaded on a docker registry, full name (ie: org/image name) should be defined. By default `avdteam/base`
- `DOCKER_TAG`: represents tags append to the docker image. It also points to an existing folder where Dockerfile for specific tag lives. By default `centos-8`

```shell
# Build using make
$ make build DOCKER_NAME=test/image

# Build using complete docker command
$ docker build -t test/image:centos-8 centos-8
```

### Run image

__RUN__ target uses 2 different variables

- `DOCKER_NAME`: complete name to use for image. If it must be uploaded on a docker registry, full name (ie: org/image name) should be defined. By default `avdteam/base`
- `DOCKER_TAG`: represents tags append to the docker image. It also points to an existing folder where Dockerfile for specific tag lives. By default `centos-8`

It also share local host content based on your shell position (`${PWD}`)

```shell
# Run using make
$ make run DOCKER_NAME=test/image

# Run using complete docker command
$ docker docker run --rm -it -v $(HOME)/.ssh:/root/.ssh \
		-v $(HOME)/.gitconfig:root/.gitconfig \
		-v $(PWD)/:/projects \
		-v /etc/hosts:/etc/hosts test/image:centos-8
```

## Build image to test specific ansible version

To help test [__AVD__](https://github.com/aristanetworks/ansible-avd) with a specific ansible version, it might be interested to build a docker image with a specific ansible version installed to override AVD requirements.

[Makefile](Makefile) introduce 2 targets to build and run specific image with a all variables explained [above](#build-image-with-avd-ansible-version) and a specific variable to override ansible version:

```shell
# Build using make
$ make test-build DOCKER_NAME=test/image ANSIBLE_VERSION=2.9.10

# Build using complete docker command
$ docker build -t test/image:centos-8-2.9.10 centos-8 --build-arg ANSIBLE=2.9.10

# Run using make
$ make test-run DOCKER_NAME=test/image ANSIBLE_VERSION=2.9.10

# Run using complete docker command
$ docker docker run --rm -it -v $(HOME)/.ssh:/root/.ssh \
		-v $(HOME)/.gitconfig:root/.gitconfig \
		-v $(PWD)/:/projects \
		-v /etc/hosts:/etc/hosts test/image:centos-8-2.9.10
```
