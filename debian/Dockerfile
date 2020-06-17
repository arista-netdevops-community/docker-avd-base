FROM python:3.6-slim as builder

ENV PATH=/root/.local/bin:$PATH
RUN apt-get update
RUN apt-get install -y --no-install-recommends build-essential gcc wget git

RUN pip3 install --upgrade pip
RUN wget --quiet https://raw.githubusercontent.com/aristanetworks/ansible-avd/devel/development/requirements.txt
RUN pip3 install --no-cache-dir --user -r requirements.txt
RUN wget --quiet https://raw.githubusercontent.com/aristanetworks/ansible-avd/devel/development/requirements-dev.txt
RUN pip3 install --no-cache-dir --user -r requirements-dev.txt


FROM python:3.6-slim as runner

LABEL maintainer="Arista Ansible Team <ansible@arista.com>"
LABEL com.example.version="1.0.2"
LABEL vendor1="Arista"
LABEL com.example.release-date="2020-06-17"
LABEL com.example.version.is-production="False"

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
COPY entrypoint.sh /bin/entrypoint.sh
RUN chmod +x /bin/entrypoint.sh

# Create the /project directory and add it as a mountpoint
WORKDIR /projects
VOLUME ["/projects"]

# Install Oh My ZSH to provide improved shell
RUN wget --quiet https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | zsh || true \
    && echo 'plugins=(ansible common-aliases safe-paste git jsontools history git-extras)' >> $HOME/.zshrc \
    && echo 'eval `ssh-agent -s`' >> $HOME/.zshrc \
    && echo 'export TERM=xterm' >>  $HOME/.zshrc

# Enable SSH Agent
RUN echo 'eval `ssh-agent -s`' >> $HOME/.zshrc

# Use ZSH as default shell with default oh-my-zsh theme
ENV PATH=$PATH:/root/.local/bin
CMD [ "/bin/entrypoint.sh" ]
