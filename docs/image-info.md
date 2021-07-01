# AVD Base Image Information

__Docker image:__ [`avdteam/base`](https://hub.docker.com/repository/docker/avdteam/base)

## Description

## Image information

### Installed elements during build

- Python 3 as default  python interpreter
- Requirements from [arista.cvp](https://github.com/aristanetworks/ansible-cvp)
- Requirements from [arista.avd](https://github.com/aristanetworks/ansible-avd)

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

- Use [__Makefile__](./../Makefile) command:

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

- Use native __docker__ command:

```shell
$ docker build --rm --pull -t avdteam:base:3.6
```

In this command, replace `3.6` by flavor you want to build.

### Create a new flavor

```shell
$ make new-flavor FLAVOR=3.9
cp -r _template 3.9
sed -i '' 's/FLAVOR/3.9/' 3.9/Dockerfile
```

Then build your image.