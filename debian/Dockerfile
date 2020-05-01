FROM python:3.6-slim-buster

LABEL maintainer="Arista Ansible Team <ansible@arista.com>"
LABEL com.example.version="1.0.2"
LABEL vendor1="Arista"
LABEL com.example.release-date="2020-02-21"
LABEL com.example.version.is-production="False"


WORKDIR /tmp
ENV DEBIAN_FRONTEND noninteractive
ARG ANSIBLE=UNSET
ENV PIP_PACKAGES "cryptography"

# Install dependencies.
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
    sudo \
    systemd \
    systemd-sysv \
    build-essential \
    wget \
    libffi-dev \
    libssl-dev \
    git \
    sshpass \
    zsh \
    git-extras \
    openssh-client \
    && rm -rf /var/lib/apt/lists/* \
    && rm -Rf /usr/share/doc && rm -Rf /usr/share/man \
    && apt-get clean \
    && wget https://bootstrap.pypa.io/get-pip.py \
    && python get-pip.py

# Install pip requirements.
# Install python modules required by the repo
RUN wget https://raw.githubusercontent.com/aristanetworks/ansible-avd/master/development/requirements.txt \
    && pip3 install -r requirements.txt \
    && wget https://raw.githubusercontent.com/aristanetworks/ansible-avd/master/development/requirements-dev.txt \
    && pip3 install -r requirements-dev.txt
RUN ANSIBLE_VERSION=$(pip freeze | grep -e 'ansible==' | awk -F '==' '{print $2}'); if [ $ANSIBLE = 'UNSET' ] || [ $ANSIBLE_VERSION = $ANSIBLE ]; then echo "Correct ansible version"; else pip3 install ansible==$ANSIBLE; fi

WORKDIR /projects

# Install Oh My ZSH to provide improved shell
RUN wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | zsh || true
RUN echo 'plugins=(ansible common-aliases safe-paste git jsontools history git-extras)' >> $HOME/.zshrc

# Enable SSH Agent
RUN echo 'eval `ssh-agent -s`' >> $HOME/.zshrc

# Use ZSH as default shell with default oh-my-zsh theme
CMD ["/bin/zsh"]
