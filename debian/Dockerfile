FROM python:3.6-slim as builder

# Default Ansible Version
ARG ANSIBLE=UNSET
# FROM python:3.7-slim AS compile-image
ENV PATH=/root/.local/bin:$PATH
RUN apt-get update
RUN apt-get install -y --no-install-recommends build-essential gcc wget git

RUN pip3 install --upgrade pip
# RUN pip install --user  poetry==1.0.0
RUN wget --quiet https://raw.githubusercontent.com/aristanetworks/ansible-avd/devel/development/requirements.txt
RUN pip3 install --no-cache-dir --user -r requirements.txt
RUN wget --quiet https://raw.githubusercontent.com/aristanetworks/ansible-avd/devel/development/requirements-dev.txt
RUN pip3 install --no-cache-dir --user -r requirements-dev.txt
RUN ANSIBLE_VERSION=$(pip3 freeze | grep -e 'ansible==' | awk -F '==' '{print $2}'); \
    if [ $ANSIBLE = "UNSET" ] || [ $ANSIBLE_VERSION = $ANSIBLE ]; \
    then \
        echo "Correct ansible version"; \
    else \
        pip3 install --no-cache-dir --user ansible==$ANSIBLE; fi


FROM python:3.6-slim as runner

LABEL maintainer="Arista Ansible Team <ansible@arista.com>"
LABEL com.example.version="1.0.2"
LABEL vendor1="Arista"
LABEL com.example.release-date="2020-02-21"
LABEL com.example.version.is-production="False"

WORKDIR /tmp
ENV DEBIAN_FRONTEND noninteractive
ENV PIP_PACKAGES "cryptography"
ENV PATH=/root/.local/bin:$PATH

# Install dependencies.
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
    build-essential \
    wget \
    git \
    zsh \
    git-extras \
    openssh-client \
    && rm -rf /var/lib/apt/lists/* \
    && rm -Rf /usr/share/doc && rm -Rf /usr/share/man \
    && apt-get clean

COPY --from=builder /root/.local/ /root/.local

# RUN wget https://raw.githubusercontent.com/aristanetworks/ansible-avd/devel/development/requirements.txt
# RUN pip3 install --no-cache-dir --user  -r requirements.txt
# RUN wget https://raw.githubusercontent.com/aristanetworks/ansible-avd/devel/development/requirements-dev.txt
# RUN pip3 install --no-cache-dir --user  -r requirements-dev.txt

WORKDIR /projects

# Install Oh My ZSH to provide improved shell
RUN wget --quiet https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | zsh || true
RUN echo 'plugins=(ansible common-aliases safe-paste git jsontools history git-extras)' >> $HOME/.zshrc

# Enable SSH Agent
RUN echo 'eval `ssh-agent -s`' >> $HOME/.zshrc

# Use ZSH as default shell with default oh-my-zsh theme
CMD ["/bin/zsh"]
