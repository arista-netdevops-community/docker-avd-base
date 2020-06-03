![](https://img.shields.io/badge/Arista-CVP%20Automation-blue)  ![](https://img.shields.io/badge/Arista-EOS%20Automation-blue) ![GitHub](https://img.shields.io/github/license/arista-netdevops-community/docker-avd-base) ![Docker Pulls](https://img.shields.io/docker/pulls/avdteam/base) ![Docker Image Size (tag)](https://img.shields.io/docker/image-size/avdteam/base/latest) ![Docker Image Version (tag latest semver)](https://img.shields.io/docker/v/avdteam/base/latest)
# AVD Base Image


Image with all python requirements installed to then run [__Arista Validated Design__](https://github.com/aristanetworks/ansible-avd) collection with a minimal configuration overhead. It can be used to support local development using following workflow

__Docker image:__ [`avdteam/base`](https://hub.docker.com/repository/docker/avdteam/base)

## Available Tags

- [`latest`](centos-8/Dockerfile) / [`centos-8`](centos-8/Dockerfile)
- [`centos-7`](centos-7/Dockerfile)
- [`debian`](debian/Dockerfile)

## Description

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

- No ENTRYPOINT configured
- CMD is configured to run `zsh` as default shell

