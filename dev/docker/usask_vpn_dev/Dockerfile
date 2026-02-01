# -----------------------------------------------------------------------------
# dev-docker (openSUSE Tumbleweed)
#
# Goals:
# - Non-root dev user (hamis) with passwordless sudo
# - Tools: git/curl/wget/zsh/openconnect/iproute2/build deps
# - Neovim pinned (tarball install)
# - oh-my-zsh
# - pyenv
# - nvm + Node LTS + Bitwarden CLI
# -----------------------------------------------------------------------------

FROM opensuse/tumbleweed

# ----- Versions / pins (edit here) -------------------------------------------
# ARG NVIM_VERSION="v0.11.2"
ARG NVM_VERSION="v0.40.3"
ARG HOST_SSH_GID="67278"
ARG PYTHON_VERSION="3.13"
# Define ARGs with defaults (Mac standard 501/20)
# ARG USER_ID=501
# ARG GROUP_ID=20


# ----- Locale / environment ---------------------------------------------------
ENV LANG="en_US.UTF-8" \
    LC_ALL="en_US.UTF-8"

# ----- System packages --------------------------------------------------------
# Notes:
# - --no-recommends keeps the image smaller.
# - openSUSE uses zypper (not apt). After install, clean metadata.
# Ensure zypper is fully non-interactive and auto-imports GPG keys
RUN zypper --non-interactive refresh && \
    zypper --non-interactive install --no-confirm \
      # basics
      sudo zsh git wget findutils gawk terminfo ncurses-utils \
      # SSH client tools
      openssh-clients \
      # terminal QoL
      ripgrep fd fzf rsync tmux less man \
      # archives
      zip unzip \
      # networking / VPN
      iproute2 \
      # neovim
      neovim ctags \
      # build toolchain (for pyenv builds)
      make gcc gcc-c++ \
      # autogen
      autoconf automake libtool \
      gettext-tools \
      gnutls-devel \
      # Python build deps
      libopenssl-devel zlib-devel libbz2-devel readline-devel sqlite3-devel \
      libffi-devel xz-devel tk-devel \
      libxml2-devel \
      # expect script
      password-store expect \
      # convenience
      which hostname && \
    # Install patterns using non-interactive flags
    zypper --non-interactive install --type pattern devel_basis && \
    # Clean up to reduce image size
    zypper clean --all

# ----- openconnect helper script (vpnc-script) --------------------------------
# Clone OpenConnect source into ~/sources (idempotent + single layer)
RUN mkdir -p "$HOME/sources" \
    && git clone --depth=1 https://gitlab.com/openconnect/openconnect "$HOME/sources/openconnect"

# Prepare user-local installation prefix (~/.local/opt/openconnect)
RUN mkdir -p "$HOME/.local/opt/openconnect"

# Generate build system, configure with user-local prefix, compile, and install
WORKDIR $HOME/sources/openconnect
RUN ./autogen.sh \
    && ./configure --prefix="$HOME/.local/opt/openconnect" \
    && make -j"$(nproc)" \
    && make install

# Expose openconnect via ~/.local/bin for PATH-based discovery
RUN mkdir -p "$HOME/.local/bin" \
    && ln -sf "$HOME/.local/opt/openconnect/bin/openconnect" "$HOME/.local/bin/openconnect"

# openconnect expects an external helper script usually called "vpnc-script". :contentReference[oaicite:3]{index=3}
# On openSUSE it may come from a package (often named vpnc-scripts in OBS) :contentReference[oaicite:4]{index=4}
# or be installed by openconnect packaging. We ensure it's present at a stable path.
RUN (zypper -n install --no-recommends vpnc-scripts || true) && \
    if [ -x /usr/sbin/vpnc-script ]; then \
      ln -sf /usr/sbin/vpnc-script /usr/local/sbin/vpnc-script; \
    elif [ -x /usr/share/vpnc-scripts/vpnc-script ]; then \
      ln -sf /usr/share/vpnc-scripts/vpnc-script /usr/local/sbin/vpnc-script; \
    else \
      curl -fsSL -o /usr/local/sbin/vpnc-script https://gitlab.com/openconnect/vpnc-scripts/raw/master/vpnc-script && \
      chmod +x /usr/local/sbin/vpnc-script; \
    fi


# ----- Create non-root user ---------------------------------------------------
# Create the group if it doesn't exist, then the user
# Note: --non-unique / -o allows using a UID/GID that might already exist in the base image
# RUN groupadd -g ${GROUP_ID} macgroup || true && \
#     useradd -m -s /usr/bin/zsh -u ${USER_ID} -g ${GROUP_ID} -o hamis && \
#     echo "hamis ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/hamis && \
#     chmod 0440 /etc/sudoers.d/hamis

RUN useradd -m -s /usr/bin/zsh hamis && \
    echo "hamis ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/hamis && \
    chmod 0440 /etc/sudoers.d/hamis

RUN groupadd -g ${HOST_SSH_GID} hostssh 2>/dev/null || true && \
    usermod -aG ${HOST_SSH_GID} hamis

USER hamis
ENV HOME=/home/hamis
WORKDIR /home/hamis

# ----- Make .gnupg dir --------------------------------------------------------
RUN mkdir /home/hamis/.gnupg && \
    chmod 700 /home/hamis/.gnupg

# ----- Neovim (pinned) --------------------------------------------------------
# Install prebuilt Neovim tarball into /opt and link into ~/.local/bin
# (Matches Neovim install guidance; arm64 tarballs are available.) :contentReference[oaicite:3]{index=3}
# RUN mkdir -p "$HOME/.local/bin" "$HOME/.local/opt" && \
#     curl -fL -o /tmp/nvim.tar.gz \
#       "https://github.com/neovim/neovim/releases/download/${NVIM_VERSION}/nvim-linux-arm64.tar.gz" && \
#     tar -xzf /tmp/nvim.tar.gz -C "$HOME/.local/opt" && \
#     ln -sf "$HOME/.local/opt/nvim-linux-arm64/bin/nvim" "$HOME/.local/bin/nvim" && \
#     rm -f /tmp/nvim.tar.gz

# Ensure user-local binaries are on PATH
ENV PATH="$HOME/.local/bin:$PATH"

# ----- Oh My Zsh --------------------------------------------------------------
RUN git clone --depth=1 https://github.com/ohmyzsh/ohmyzsh.git "$HOME/.oh-my-zsh" && \
    cp "$HOME/.oh-my-zsh/templates/zshrc.zsh-template" "$HOME/.zshrc" && \
    sed -i 's/ZSH_THEME=".*"/ZSH_THEME="robbyrussell"/' "$HOME/.zshrc"

# ----- pyenv ------------------------------------------------------------------
# pyenv installer: https://pyenv.run (same as your Ubuntu version)
RUN curl -fsSL https://pyenv.run | bash

ENV PYENV_ROOT="$HOME/.pyenv"
ENV PATH="$PYENV_ROOT/bin:$PATH"

# Shell init for pyenv + nvm (zsh)
RUN { \
      echo 'export LANG=en_US.UTF-8'; \
      echo 'export LC_ALL=en_US.UTF-8'; \
      echo 'export PYENV_ROOT="$HOME/.pyenv"'; \
      echo 'export PATH="$PYENV_ROOT/bin:$PATH"'; \
      echo 'eval "$(pyenv init -)"'; \
      echo 'eval "$(pyenv virtualenv-init -)"'; \
      echo 'export NVM_DIR="$HOME/.nvm"'; \
      echo '[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"'; \
      echo '[ -s "$NVM_DIR/bash_completion" ] && . "$NVM_DIR/bash_completion"'; \
    } >> "$HOME/.zshrc"

# ----- Python (pyenv) ---------------------------------------------------------
# Install and set Python 3.13 as global default
RUN export PYENV_ROOT="$HOME/.pyenv" && \
    export PATH="$PYENV_ROOT/bin:$PATH" && \
    eval "$(pyenv init -)" && \
    pyenv install ${PYTHON_VERSION} && \
    pyenv global ${PYTHON_VERSION} && \
    pyenv rehash


# ----- nvm + Node LTS + Bitwarden CLI -----------------------------------------
# nvm upstream install docs: curl .../vX.Y.Z/install.sh | bash :contentReference[oaicite:4]{index=4}
RUN curl -fsSL "https://raw.githubusercontent.com/nvm-sh/nvm/${NVM_VERSION}/install.sh" | bash && \
    export NVM_DIR="$HOME/.nvm" && \
    . "$NVM_DIR/nvm.sh" && \
    nvm install --lts && \
    npm install -g @bitwarden/cli

CMD ["zsh"]

