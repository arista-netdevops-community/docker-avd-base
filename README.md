# AVD Base Image

## Tags

- [`latest`](centos-8/Dockerfile) / [`centos-8`](centos-8/Dockerfile)
- [`centos-7`](centos-7/Dockerfile)
- [`debian`](debian/Dockerfile)

## Installed elements during build

- Python 3 as default  python interpreter
- Requirements from [arista.cvp](https://github.com/aristanetworks/ansible-cvp)
- Requirements from [arista.avd](https://github.com/aristanetworks/ansible-avd)

## Installed during container startup

None

## Description

Image with all python requirements installed to then run AVD collection with a minimal configuration overhead. It can be used to support local development using following workflow:

```shell
$ ls
ansible-cvp ansible-avd custom-project

$ docker run --rm -it -v $(HOME)/.ssh:/root/.ssh \
		-v $(HOME)/.gitconfig:root/.gitconfig \
		-v $(PWD)/:/projects \
		-v /etc/hosts:/etc/hosts avdteam/base:centos-8

➜  /projects ls -l
ansible-cvp ansible-avd custom-project
```

In this setup, collections are stored on your host, but all the requirements are resolved within the container and is similar to a Python virtual environment approach.
