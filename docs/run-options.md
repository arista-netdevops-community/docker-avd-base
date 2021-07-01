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
