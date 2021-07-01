# How to use AVD image with VSCODE

## About

This how-to explains how to leverage __avdteam/base__ image as shell under [VScode](https://code.visualstudio.com/) to get a consistent developement and testing environment regardless operating system running Ansible. This how-to is applicable to any OS where VScode can be installed.

__Table of content__
- [How to use AVD image with VSCODE](#how-to-use-avd-image-with-vscode)
  - [About](#about)
  - [Devcontainer with docker image](#devcontainer-with-docker-image)
    - [Requirements](#requirements)
    - [Configure devcontainer](#configure-devcontainer)
    - [Open content in container](#open-content-in-container)
  - [Devcontainer with docker image](#devcontainer-with-docker-image-1)
    - [Requirements](#requirements-1)
    - [Configure devcontainer](#configure-devcontainer-1)
    - [Open content in container](#open-content-in-container-1)

## Devcontainer with docker image

### Requirements

- [VScode](https://code.visualstudio.com/) installed on your system.
- [Docker installed](https://docs.docker.com/get-docker/) and running.
- GIT installed and configured.

For windows user, [WSL](https://docs.microsoft.com/en-us/windows/wsl/install-win10) should be configured on your system

### Configure devcontainer

VScode provides a function to open a workspace in either remote ssh server, in a WSL instance (for windows only) or [in a container](https://code.visualstudio.com/docs/remote/containers). In this how-to, we will leverage this functionality with [__`avdteam/base`__](https://hub.docker.com/repository/docker/avdteam/base)

```shell
$ pwd
/home/tom/arista-ansible

# create VScode folder
$ mkdir .devcontainer

# edit configuration
$ vim .devcontainer/devcontainer.json
```

Copy following content to `devcontainer.json`:

```json
{
    "name": "AVD development",
    "image": "avdteam/base:3.6",

    "settings": {
        "python.linting.enabled": true,
        "python.linting.pylintEnabled": true,
        "python.linting.flake8Path": "/root/.local/bin/flake8",
        "python.linting.pycodestylePath": "/usr/local/py-utils/bin/pycodestyle",
        "python.linting.pydocstylePath": "/usr/local/py-utils/bin/pydocstyle",
        "python.linting.pylintPath": "/root/.local/bin/pylint",
        "python.testing.pytestPath": "/root/.local/bin/pytest"
    },

    "extensions": [
         "ms-python.python",
         "vscoss.vscode-ansible",
         "timonwong.ansible-autocomplete",
         "codezombiech.gitignore",
         "tuxtina.json2yaml",
         "jebbs.markdown-extended",
         "donjayamanne.python-extension-pack",
         "njpwerner.autodocstring",
         "quicktype.quicktype",
         "jack89ita.copy-filename",
         "mhutchie.git-graph",
         "eamodio.gitlens",
         "yzhang.markdown-all-in-one",
         "davidanson.vscode-markdownlint",
         "christian-kohler.path-intellisense",
         "ms-python.vscode-pylance",
         "tht13.python"
    ],
    "containerEnv": {
        "ANSIBLE_CONFIG": "./ansible.cfg"
    }
}

```

### Open content in container

After you configured `.devcontainer/devcontainer.json` correctly, you can open VScode and start local container with following actions:

![](../medias/vscode-docker-open-container.png)

VScode will do the following configuration:

- Download [__`avdteam/base`__](https://hub.docker.com/repository/docker/avdteam/base)
- Install extensions in new container
- Configure paths for python tools
- Configure path for ansible.cfg (to fix issue with windows and mount point)

Once container is running, you can continue to edit your files in VScode and your shell will be executed inside a container.


```shell
Agent pid 186
➜  arista-ansible pwd
/workspaces/arista-ansible

➜  arista-ansible
```

> When using devcontainer feature, git information is shared from host and allow user to run git commands with all correct information.

## Devcontainer with docker image

### Requirements

- [VScode](https://code.visualstudio.com/) installed on your system.
- [Docker installed](https://docs.docker.com/get-docker/) and running.
- GIT installed and configured.

For windows user, [WSL](https://docs.microsoft.com/en-us/windows/wsl/install-win10) should be configured on your system

### Configure devcontainer

VScode provides a function to open a workspace in either remote ssh server, in a WSL instance (for windows only) or [in a container](https://code.visualstudio.com/docs/remote/containers). In this how-to, we will leverage this functionality with [__`avdteam/base`__](https://hub.docker.com/repository/docker/avdteam/base)

- On Linux or Macos:

```shell
$ pwd
/home/tom/arista-ansible

# create VScode folder
$ mkdir .devcontainer

# edit configuration
$ vim .devcontainer/devcontainer.json
```

Copy following content to `devcontainer.json`:

```json
{
  "name": "Docker from Docker Compose",
  "dockerComposeFile": "docker-compose.yml",
  "service": "ansible",
  "workspaceFolder": "/projects",

  "settings": {
    "terminal.integrated.shell.linux": "/bin/zsh"
	},

  "extensions": [
         "ms-python.python",
         "vscoss.vscode-ansible",
         "timonwong.ansible-autocomplete",
         "codezombiech.gitignore",
         "tuxtina.json2yaml",
         "jebbs.markdown-extended",
         "donjayamanne.python-extension-pack",
         "njpwerner.autodocstring",
         "quicktype.quicktype",
         "jack89ita.copy-filename",
         "mhutchie.git-graph",
         "eamodio.gitlens",
         "yzhang.markdown-all-in-one",
         "davidanson.vscode-markdownlint",
         "christian-kohler.path-intellisense",
         "ms-python.vscode-pylance",
         "tht13.python"
   ],
   "containerEnv": {
	    "ANSIBLE_CONFIG": "./ansible.cfg"
   }
}
```

Then create docker-compose.yml file under `.devcontainer/` folder with following content to run an ansible instance and 2 mkdocs to expose documentation for ansible-cvp and ansible-avd:

```yaml
version: "3"
services:
  ansible:
    image: avdteam/base:3.6
    volumes:
      - ../:/projects
    command: [ "/bin/sh", "-c", "while true; do sleep 30; done;" ]

  webdoc_cvp:
    image: titom73/mkdocs:latest
    volumes:
      - ../ansible-cvp:/docs
    ports:
      - 8001:8000
    entrypoint: ""
    command: ["sh", "-c", "pip install -r ansible_collections/arista/cvp/docs/requirements.txt && mkdocs serve --dev-addr=0.0.0.0:8000 -f mkdocs.yml"]

  webdoc_avd:
    image: titom73/mkdocs:latest
    volumes:
      - ../ansible-avd:/docs
    ports:
      - 8000:8000
    entrypoint: ""
    command: ["sh", "-c", "pip install -r ansible_collections/arista/avd/docs/requirements.txt && mkdocs serve --dev-addr=0.0.0.0:8000 -f mkdocs.yml"]

```

### Open content in container

After you configured `.devcontainer/devcontainer.json` correctly, you can open VScode and start local container with following actions:

![](../medias/vscode-docker-open-container.png)

VScode will do the following configuration:

- Download [__`avdteam/base`__](https://hub.docker.com/repository/docker/avdteam/base)
- Install extensions in new container
- Configure paths for python tools
- Configure path for ansible.cfg (to fix issue with windows and mount point)

Once container is running, you can continue to edit your files in VScode and your shell will be executed inside a container.


```shell
Agent pid 186
➜  arista-ansible pwd
/workspaces/arista-ansible

➜  arista-ansible
```

For other containers, you can access to documentation using your browser and following URLs:

- `ansible-cvp` documentation: http://127.0.0.01:8001
- `ansible-avd` documentation: http://127.0.0.01:8000
