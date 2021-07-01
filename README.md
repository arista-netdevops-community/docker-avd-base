![](https://img.shields.io/badge/Arista-CVP%20Automation-blue)  ![](https://img.shields.io/badge/Arista-EOS%20Automation-blue) ![GitHub](https://img.shields.io/github/license/arista-netdevops-community/docker-avd-base) ![Docker Pulls](https://img.shields.io/docker/pulls/avdteam/base) ![Docker Image Size (tag)](https://img.shields.io/docker/image-size/avdteam/base/latest) ![Docker Image Version (tag latest semver)](https://img.shields.io/docker/v/avdteam/base/latest)

# AVD Base Image

Image with all python requirements installed to then run [__Arista Validated Design__](https://github.com/aristanetworks/ansible-avd) collection with a minimal configuration overhead. It can be used to support local development using following workflow

__Docker image:__ [`avdteam/base`](https://hub.docker.com/repository/docker/avdteam/base)

<p align="center"><img src="medias/AVD%20-%20Docker%20Logo%20transparent%20bg.png" alt="Arista AVD Docker Image" width="400"/></p>

__Table of content__
- [AVD Base Image](#avd-base-image)
	- [Description](#description)
		- [Available variables](#available-variables)
	- [How to leverage image](#how-to-leverage-image)
		- [Arista Validated Design](#arista-validated-design)
		- [Generic Arista Automation Purpose](#generic-arista-automation-purpose)
	- [Run container](#run-container)
		- [Start isolated shell](#start-isolated-shell)
		- [Start shell in your project](#start-shell-in-your-project)
		- [Update container image](#update-container-image)
	- [Additional Resources](#additional-resources)
	- [License](#license)

## Description

### Available variables

These variables are used in `CMD` to customize container content using [`-e` option of docker](https://docs.docker.com/engine/reference/commandline/run/#set-environment-variables--e---env---env-file) cli:

- `AVD_REQUIREMENTS`: Path to a `requirements.txt` to install during container startup.
- `AVD_ANSIBLE`: Ansible version to install in container when booting up
- `AVD_UID`: set __uid__ for avd user in container.
- `AVD_GID`: set __gid__ for avd user in container.
- `AVD_GIT_USER`: Username to configure in .gitconfig file.
  - Can be set with `AVD_GIT_USER=$(git config --get user.name)`
- `AVD_GIT_EMAIL`: Email to configure in .gitconfig file.
  - Can be set with `AVD_GIT_EMAIL=$(git config --get user.email)`

To see how to customize your container with these options, you can refer to [How to install ansible and Python requirements page](docs/run-options.md)

## How to leverage image

This image can be leveraged in different use-cases such as ansible or gNMI automation for Arista products.

In every scenario, you can use an isolated shell to test your automation workflow or you can start a shell with a mount point to use your local content.

### Arista Validated Design

This docker image was primarily built to support development and playbook execution of [Arista Validated Design project](https://github.com/aristanetworks/ansible-avd).

Here are some repositories leveraging [__`avdteam/base`__](https://hub.docker.com/repository/docker/avdteam/base):

- [Ansible AVD & Cloudvision example](https://github.com/arista-netdevops-community/ansible-avd-cloudvision-demo)
- [Ansible AVD & CVP TOI lab](https://github.com/arista-netdevops-community/ansible-cvp-toi)

### Generic Arista Automation Purpose

Docker image has been extended to support all Arista automation tools.

Here are some EOS automation examples leveraging [__`avdteam/base`__](https://hub.docker.com/repository/docker/avdteam/base):

- [eAPI automation example repository](https://github.com/arista-netdevops-community/arista_eos_automation_with_eAPI)
- [Ansible automation repository](https://github.com/arista-netdevops-community/arista_eos_automation_with_ansible)
- [Pyang and Pyangbind repository](https://github.com/arista-netdevops-community/gnmi_demo_with_arista_eos)
- [Netconf example](https://github.com/arista-netdevops-community/arista_eos_automation_with_ncclient)

## Run container

### Start isolated shell

```shell
$ docker run --rm -it avdteam/base:3.6
➜  /projects
```

You can also configure your shell with an alias to make it easy to start container

```shell
# Configure alias in bashrc
alias avd-shell='docker run -it --rm avdteam/base:latest zsh'

# Run alias command
$ avd-shell
➜  /projects
```

### Start shell in your project

```shell
$ docker run --rm -it -v ${PWD}:/projects avdteam/base:3.6
➜  /projects ls
Makefile  README.md  activate-arista.cvp-logs.env
```

You can also configure your shell with an alias to make it easy to start container

```shell
# Configure alias in bashrc
alias avd-shell='docker run -it --rm \
	-v ${PWD}/:/projects \
	avdteam/base:latest zsh'

# Run alias command
$ avd-shell
➜  /projects
Makefile  README.md  activate-arista.cvp-logs.env
```

### Update container image

To update container image, just run docker command:

```shell
$ docker pull avdteam/base:3.6
3.6: Pulling from avdteam/base
Digest: sha256:1602b5ab710c3a3ac9a8e93c1672c295afcd262c01b6201c0f5f83b50ff42705
Status: Image is up to date for avdteam/base:3.6
docker.io/avdteam/base:3.6
```

## Additional Resources

- [Build and Maintain avd-docker-image](docs/image-info.md)
- [Options to run avd image and make custom container](docs/run-options.md)
- [Leverage avdteam/base image in VSCode for development and testing](docs/avd-vscode-docker.md)

## License

Project is published under [Apache 2.0 License](./LICENSE)
