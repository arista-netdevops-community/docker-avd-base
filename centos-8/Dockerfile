FROM python:3.6-slim as builder

# Default Ansible Version
ARG ANSIBLE=UNSET
# FROM python:3.7-slim AS compile-image
RUN apt-get update
RUN apt-get install -y --no-install-recommends build-essential gcc wget git

# COPY requirements-test.txt .
RUN pip3 install --upgrade pip
# RUN pip install --user  poetry==1.0.0
RUN wget --quiet https://raw.githubusercontent.com/aristanetworks/ansible-avd/devel/development/requirements.txt
RUN pip3 install --user  -r requirements.txt
RUN wget --quiet https://raw.githubusercontent.com/aristanetworks/ansible-avd/devel/development/requirements-dev.txt
RUN pip3 install --user  -r requirements-dev.txt
RUN ANSIBLE_VERSION=$(pip3 freeze | grep -e 'ansible==' | awk -F '==' '{print $2}'); \
    if [ $ANSIBLE = "UNSET" ] || [ $ANSIBLE_VERSION = $ANSIBLE ]; \
    then \
        echo "Correct ansible version"; \
    else \
        pip3 install --no-cache-dir --user ansible==$ANSIBLE; fi


FROM centos:8 as base
LABEL maintainer="Arista Ansible Team <ansible@arista.com>"

# Default ARG values
# Set term option
ARG TERM=xterm

# Install necessary packages
# Install systemd -- See https://hub.docker.com/_/centos/
RUN yum clean all; \
    (cd /lib/systemd/system/sysinit.target.wants/; for i in *; do [ $i == systemd-tmpfiles-setup.service ] || rm -f $i; done); \
    rm -f /lib/systemd/system/multi-user.target.wants/*;\
    rm -f /etc/systemd/system/*.wants/*;\
    rm -f /lib/systemd/system/local-fs.target.wants/*; \
    rm -f /lib/systemd/system/sockets.target.wants/*udev*; \
    rm -f /lib/systemd/system/sockets.target.wants/*initctl*; \
    rm -f /lib/systemd/system/basic.target.wants/*;\
    rm -f /lib/systemd/system/anaconda.target.wants/*;

# Install YUM requirements.
RUN yum -y install epel-release initscripts \
    && yum -y install \
    findutils \
    git \
    which \
    zsh \
    wget \
    python3 \
    git-extras \
    net-tools \
    && yum clean all

COPY --from=builder /root/.local/ /root/.local

# Create the /project directory and add it as a mountpoint
WORKDIR /projects
VOLUME ["/projects"]

# Install Oh My ZSH to provide improved shell
# Force to switch to ZSH even if bash is started explicitely
RUN wget --quiet https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | zsh || true \
    && echo 'plugins=(ansible common-aliases safe-paste git jsontools history git-extras)' >> $HOME/.zshrc \
    && echo 'eval `ssh-agent -s`' >> $HOME/.zshrc \
    && echo 'export TERM=xterm' >>  $HOME/.bashrc \
    && echo 'export TERM=xterm' >>  $HOME/.zshrc

# Use ZSH as default shell with default oh-my-zsh theme
ENV PATH=$PATH:/root/.local/bin
CMD ["/bin/zsh"]