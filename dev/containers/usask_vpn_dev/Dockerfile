FROM ubuntu:24.04

# Non interactive mode
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y \
      neovim \
      openconnect \
      git \
      curl \
      sudo \
      zsh \
      iproute2 \
      ca-certificates \
      wget \
      make \
      build-essential \
      libssl-dev \
      zlib1g-dev \
      libbz2-dev \
      libreadline-dev \
      libsqlite3-dev \
      llvm \
      libncursesw5-dev \
      xz-utils \
      tk-dev \
      libxml2-dev \
      libxmlsec1-dev \
      libffi-dev \
      liblzma-dev \
      locales && \
    locale-gen en_US.UTF-8 && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

ENV LANG=en_US.UTF-8
ENV LC_ALL=en_US.UTF-8

# Create non-root user
RUN useradd -m -s /usr/bin/zsh hamis && echo "hamis ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

# Download and extract Neovim 0.11.2 Linux tar.gz into /opt/nvim
RUN curl -LO https://github.com/neovim/neovim/releases/download/v0.11.2/nvim-linux-arm64.tar.gz && \
    tar -xzf nvim-linux-arm64.tar.gz && \
    mv nvim-linux-arm64 /opt/nvim && \
    ln -s /opt/nvim/bin/nvim /usr/local/bin/nvim && \
    rm nvim-linux-arm64.tar.gz

USER hamis
ENV HOME=/home/hamis
WORKDIR /home/hamis

# Install Oh My Zsh
RUN git clone https://github.com/ohmyzsh/ohmyzsh.git ~/.oh-my-zsh && \
    cp ~/.oh-my-zsh/templates/zshrc.zsh-template ~/.zshrc && \
    sed -i 's/ZSH_THEME=".*"/ZSH_THEME="robbyrussell"/' ~/.zshrc

# Install pyenv
RUN curl https://pyenv.run | bash

# pyenv env setup
ENV PYENV_ROOT="/home/hamis/.pyenv"
ENV PATH="$PYENV_ROOT/bin:$PATH"

RUN echo 'export LANG=en_US.UTF-8' >> ~/.zshrc && \
    echo 'export LC_ALL=en_US.UTF-8' >> ~/.zshrc && \
    echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.zshrc && \
    echo 'export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.zshrc && \
    echo 'eval "$(pyenv init --path)"' >> ~/.zprofile && \
    echo 'eval "$(pyenv init -)"' >> ~/.zshrc && \
    echo 'eval "$(pyenv virtualenv-init -)"' >> ~/.zshrc && \
    echo 'export NVM_DIR="$HOME/.nvm"' >> ~/.zshrc && \
    echo '[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"' >> ~/.zshrc && \
    echo '[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"' >> ~/.zshrc

# Install Node.js and npm (via NVM in your case, so make sure Node is installed in the container user context)
# Install Bitwarden CLI via npm and its missing dependency (semver)
# Install Node.js via NVM and Bitwarden CLI via npm
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash && \
    export NVM_DIR="$HOME/.nvm" && \
    [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh" && \
    nvm install --lts && \
    npm install -g @bitwarden/cli semver


CMD ["zsh"]

