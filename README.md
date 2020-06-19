![](https://img.shields.io/badge/Arista-CVP%20Automation-blue)  ![](https://img.shields.io/badge/Arista-EOS%20Automation-blue) ![GitHub](https://img.shields.io/github/license/arista-netdevops-community/docker-avd-base) ![Docker Pulls](https://img.shields.io/docker/pulls/avdteam/base) ![Docker Image Size (tag)](https://img.shields.io/docker/image-size/avdteam/base/latest) ![Docker Image Version (tag latest semver)](https://img.shields.io/docker/v/avdteam/base/latest)
# AVD Base Image


Image with all python requirements installed to then run [__Arista Validated Design__](https://github.com/aristanetworks/ansible-avd) collection with a minimal configuration overhead. It can be used to support local development using following workflow

__Docker image:__ [`avdteam/base`](https://hub.docker.com/repository/docker/avdteam/base)

## Description

### Available Tags

- [`latest`](3.8/Dockerfile)
- [`3.6`](3.6/Dockerfile)
- [`3.7`](3.7/Dockerfile)
- [`3.8`](3.8/Dockerfile)
- [`centos-7`](centos-7/Dockerfile) (deprecated)
- [`centos-8`](centos-8/Dockerfile) (deprecated)

> Images with `-devel` suffic in tag are considered under development for different reasons (Dockerfile, requirements update, base image, ...) and are all coming from __devel__ branch of this repository. _Use them carefully._

### Available variables

These variables are used in `ENTRYPOINT` to customize container content:

- `AVD_REQUIREMENTS`: Path to a `requirements.txt` to install during container bootup.
- `AVD_ANSIBLE`: Ansible version to install in container when booting up

### Pull image

```shell
$ docker pull avdteam/base:latest
latest: Pulling from avdteam/base
8a29a15cefae: Already exists
95df01e08bce: Downloading [==============================================>    ]  33.55MB/36.35MB
512a8a4d71f7: Downloading [=========================================>         ]   45.1MB/53.85MB
209c1657264b: Download complete
bd6eece0221e: Downloading [===================>                               ]  52.04MB/132.1MB
036c486feecb: Waiting
```

### Start a container

```shell
# Within host shell
$ ls
ansible-cvp ansible-avd custom-project

$ docker run --rm -it -v $(HOME)/.ssh:/root/.ssh \
		-v $(HOME)/.gitconfig:root/.gitconfig \
		-v $(PWD)/:/projects \
		-v /etc/hosts:/etc/hosts avdteam/base:centos-8

# Within docker container
➜  /projects ls -l
ansible-cvp ansible-avd custom-project
```

In this setup, collections are stored on your host, but all the requirements are resolved within the container and is similar to a Python virtual environment approach.

## Image information

### Installed elements during build

- Python 3 as default  python interpreter
- Requirements from [arista.cvp](https://github.com/aristanetworks/ansible-cvp)
- Requirements from [arista.avd](https://github.com/aristanetworks/ansible-avd)

### Installed during container startup

- `ENTRYPOINT` configured to support ENV configuration.
- `CMD` is configured to run `zsh` as default shell

## Build local images

You can use this repository to build your own version to test lib upgrade or a new flavor. it creates an image based on:

- __`DOCKER_NAME`__: Name of the container. Default is `avdteam/base`
- __`FLAVOR`__: Python version to build image. it is also folder where `Dockerfile` is.
- __`BRANCH`__: git branch from where you build your image. if name is master, then it is skipped

```
DOCKER_NAME:BRANCH-FLAVOR
```

Examples:

```shell
$ docker images avdteam/base
REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
avdteam/base        devel-3.8           3d4f4674300b        26 minutes ago      646MB
avdteam/base        3.6                 56e4a9d36bdf        40 minutes ago      675MB
```

### Build process

```shell
$ make FLAVOR=3.8 build

Sending build context to Docker daemon  4.608kB
Step 1/21 : FROM python:3.7-slim as builder
 ---> 4cbd5021babc
Step 2/21 : ARG ANSIBLE=UNSET
 ---> Using cache
 ---> a41a97dc49b3
Step 3/21 : RUN apt-get update
 ---> Using cache
 ---> f052496c232e
```

- Run container and get a shell

```shell
$ make FLAVOR=3.8 run
➜  /projects git:(devel) ✗
➜  /projects git:(devel) ✗ python --version
Python 3.8.3
➜  /projects git:(devel) ✗ python3 --version
Python 3.8.3
➜  /projects git:(devel) ✗ ansible --version
ansible 2.9.6
```

- Run container with a specific version of ansible

```shell
$ make FLAVOR=3.8 ANSIBLE_VERSION=2.9.9 run
Requirement file not found, skipping...
Install ansible with version 2.9.9
WARNING: Running pip install with root privileges is generally not a good idea. Try `pip3 install --user` instead.
Collecting ansible==2.9.9
[...]
Successfully installed ansible-2.9.9
Agent pid 52
➜  /projects git:(devel) ✗ python --version
Python 3.8.3
➜  /projects git:(devel) ✗ python3 --version
Python 3.8.3
➜  /projects git:(devel) ✗ ansible --version
ansible 2.9.9
```

### Create a new flavor

```shell
$ make new-flavor FLAVOR=3.9
cp -r _template 3.9
sed -i '' 's/FLAVOR/3.9/' 3.9/Dockerfile
```

## License

Project is published under [Apache 2.0 License](./LICENSE)