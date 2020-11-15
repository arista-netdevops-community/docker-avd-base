FROM python:3.6-slim as BUILDER

WORKDIR /tmp

# FROM python:3.7-slim AS compile-image
RUN apt-get update
RUN apt-get install -y --no-install-recommends build-essential gcc wget git

RUN useradd -md /home/avd -s /bin/zsh -u 1000 avd
USER avd

ENV PATH=$PATH:/home/avd/.local/bin
RUN pip3 install --upgrade pip
RUN wget --quiet https://raw.githubusercontent.com/aristanetworks/ansible-avd/devel/development/requirements.txt
RUN pip3 install --user  -r requirements.txt
RUN wget --quiet https://raw.githubusercontent.com/aristanetworks/ansible-avd/devel/development/requirements-dev.txt
RUN pip3 install --user  -r requirements-dev.txt


FROM python:3.6-slim as BASE

LABEL maintainer="Arista Ansible Team <ansible@arista.com>"
LABEL com.example.version="1.0.2"
LABEL vendor1="Arista"
LABEL com.example.release-date="2020-06-17"
LABEL com.example.version.is-production="False"

# Default ARG values
# Set term option
ARG TERM=xterm

ENV DEBIAN_FRONTEND noninteractive
ENV PROJECT_DIR /projects/

# Install dependencies.
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
    make \
    wget \
    curl \
    less \
    git \
    zsh \
    vim \
    sshpass \
    git-extras \
    openssh-client \
    && rm -rf /var/lib/apt/lists/* \
    && rm -Rf /usr/share/doc && rm -Rf /usr/share/man \
    && apt-get clean

RUN useradd -md /home/avd -s /bin/zsh -u 1000 avd
USER avd

# Copy python collection
COPY --from=BUILDER /home/avd/.local/ /home/avd/.local
ENV PATH=$PATH:/home/avd/.local/bin

# Install Oh My ZSH to provide improved shell
RUN wget --quiet https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | zsh || true \
    && echo 'plugins=(ansible common-aliases safe-paste git jsontools history git-extras)' >> $HOME/.zshrc \
    && echo 'eval `ssh-agent -s`' >> $HOME/.zshrc \
    && echo 'export TERM=xterm' >>  $HOME/.zshrc \
    && echo 'export PATH=$PATH:/home/avd/.local/bin' >> $HOME/.zshrc

# Set default folder
WORKDIR /projects
VOLUME ["/projects"]

# Use ZSH as default shell with default oh-my-zsh theme
USER root
COPY entrypoint.sh /bin/entrypoint.sh
RUN chmod +x /bin/entrypoint.sh
CMD [ "/bin/entrypoint.sh" ]
