# AVD Image options

## Run image for testing with native ansible version

### Run container and get a shell using __Makefile__ command

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

> Only available in current repository

### Run container and get a shell using native __docker__ command

```shell
$ docker run --rm -it -v ${HOME}/arista-ansible/docker-avd-base/:/projects \
        -v /etc/hosts:/etc/hosts avdteam/base:3.8 ;\

➜  /projects git:(devel) ✗
➜  /projects git:(devel) ✗ python --version
Python 3.8.3
➜  /projects git:(devel) ✗ python3 --version
Python 3.8.3
➜  /projects git:(devel) ✗ ansible --version
ansible 2.9.6
```

## Run image for testing with custom ansible version

### Run container with a specific version of ansible using __Makefile__ command

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

> Only available in current repository

### Run container with a specific version of ansible using native __docker__ command

```shell
$ docker run --rm -it -v ${HOME}/arista-ansible/docker-avd-base/:/projects \
        -e AVD_REQUIREMENTS=NONE \
        -e AVD_ANSIBLE=2.9.9 \
        -v /etc/hosts:/etc/hosts avdteam/base:3.8

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