FROM ubuntu:24.04

# Avoid interactive prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive
ENV LANG=C.UTF-8 LC_ALL=C.UTF-8

# Install basic dependencies
RUN apt-get update && apt-get install -y \
    zsh \
    git \
    tmux \
    ranger \
    curl \
    wget \
    build-essential \
    python3 \
    python3-venv \
    python3-pip \
    golang-go \
    pkg-config \
    libssl-dev \
    \
    bat \
    fzf \
    ripgrep \
    fd-find \
    htop \
    ca-certificates \
    unzip \
    && rm -rf /var/lib/apt/lists/*

# Install lazygit from GitHub releases (latest version, multi-arch)
RUN ARCH=$(uname -m) \
    && case $ARCH in \
        x86_64) LAZYGIT_ARCH="x86_64" ;; \
        aarch64) LAZYGIT_ARCH="arm64" ;; \
        armv7l) LAZYGIT_ARCH="arm" ;; \
        *) echo "Unsupported architecture: $ARCH" && exit 1 ;; \
    esac \
    && LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/' | cut -c 2-) \
    && curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/download/v${LAZYGIT_VERSION}/lazygit_${LAZYGIT_VERSION}_Linux_${LAZYGIT_ARCH}.tar.gz" \
    && tar xf lazygit.tar.gz \
    && mv lazygit /usr/local/bin \
    && rm lazygit.tar.gz

# Create user (same uid/gid as host for convenience)
ARG USERNAME=dev
ARG USER_UID=1000
ARG USER_GID=1000

RUN if id -u ubuntu >/dev/null 2>&1; then deluser ubuntu; fi \
    && if getent group $USER_GID >/dev/null 2>&1 && [ "$(getent group $USER_GID | cut -d: -f1)" != "$USERNAME" ]; then groupdel $(getent group $USER_GID | cut -d: -f1); fi \
    && groupadd --gid $USER_GID $USERNAME 2>/dev/null || true \
    && useradd --uid $USER_UID --gid $USER_GID -m $USERNAME \
    && apt-get update \
    && apt-get install -y sudo \
    && echo "$USERNAME ALL=(root) NOPASSWD:ALL" > /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME \
    && rm -rf /var/lib/apt/lists/*

# Install mise and neovim
USER $USERNAME
ENV PATH="/home/$USERNAME/.local/bin:/home/$USERNAME/.local/share/mise/shims:/home/$USERNAME/go/bin:${PATH}"
RUN curl https://mise.run | sh && \
    /home/$USERNAME/.local/bin/mise use -g neovim@latest && \
    /home/$USERNAME/.local/bin/mise use -g node@latest && \
    /home/$USERNAME/.local/bin/mise use -g go@latest && \
    /home/$USERNAME/.local/bin/mise use -g atuin@latest && \
    /home/$USERNAME/.local/bin/mise use -g rust@latest && \
    /home/$USERNAME/.local/bin/mise use -g cargo:eza && \
    /home/$USERNAME/.local/bin/mise use -g fzf@latest && \
    /home/$USERNAME/.local/bin/mise use -g fd@latest && \
    /home/$USERNAME/.local/share/mise/shims/npm install -g tree-sitter-cli neovim

# Install LSP servers via npm
RUN /home/$USERNAME/.local/share/mise/shims/npm install -g bash-language-server typescript typescript-language-server vscode-langservers-extracted
RUN /home/$USERNAME/.local/share/mise/shims/npm install -g @vue/language-server

# Install LSP servers via go (rust-analyzer uses a different method now, skip for now)
RUN /home/$USERNAME/.local/share/mise/shims/go install golang.org/x/tools/gopls@latest

# Install starship prompt
RUN curl -sS https://starship.rs/install.sh | sh -s -- --yes

# Install zoxide
RUN curl -sS https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash

# Install direnv
RUN curl -sfL https://direnv.net/install.sh | bash

# Install clang for C/C++ LSP support (as root)
USER root
RUN apt-get update && apt-get install -y clangd && rm -rf /var/lib/apt/lists/*
USER $USERNAME

# Install Python LSP server
RUN pip3 install --break-system-packages python-lsp-server
USER root

# Set working directory
WORKDIR /home/$USERNAME

# Copy dotfiles
COPY --chown=$USERNAME:$USER_GID . /tmp/dotfiles

# Install dotfiles using a script
RUN cd /tmp/dotfiles && \
    # Copy config files
    cp -r .config /home/$USERNAME/ && \
    cp .zshrc /home/$USERNAME/ && \
    cp .zsh_functions /home/$USERNAME/ && \
    cp .tmux.conf /home/$USERNAME/ && \
    # Setup neovim
    mkdir -p /home/$USERNAME/.config/nvim && \
    cp -r .config/nvim/* /home/$USERNAME/.config/nvim/ 2>/dev/null || true && \
    # Remove git config that rewrites HTTPS to SSH (breaks plugin installs in container)
    rm -f /home/$USERNAME/.config/git/config && \
    rm -f /home/$USERNAME/.gitconfig && \
    # Clean up
    rm -rf /tmp/dotfiles && \
    # Set zsh as default shell
    chsh -s /usr/bin/zsh $USERNAME

# Bootstrap neovim plugins (as the user so lazy.nvim installs to the right place)
# Download lazy.nvim tarball from GitHub to avoid git/SSH issues
# Use the latest release instead
RUN LAZYGIT_NVIM_TAG=$(curl -s "https://api.github.com/repos/folke/lazy.nvim/releases/latest" | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/') && \
    mkdir -p /home/$USERNAME/.local/share/nvim/lazy && \
    mkdir -p /home/$USERNAME/.local/state/nvim && \
    mkdir -p /home/$USERNAME/.config/git && \
    cd /home/$USERNAME/.local/share/nvim/lazy && \
    curl -L -o lazy.tar.gz "https://github.com/folke/lazy.nvim/archive/refs/tags/${LAZYGIT_NVIM_TAG}.tar.gz" && \
    tar xzf lazy.tar.gz && \
    mv lazy.nvim-* lazy.nvim && \
    rm lazy.tar.gz && \
    chown -R $USERNAME:$USER_GID /home/$USERNAME/.local/share/nvim && \
    chown -R $USERNAME:$USER_GID /home/$USERNAME/.local/state && \
    chown -R $USERNAME:$USER_GID /home/$USERNAME/.config/git && \
    chown $USERNAME:$USER_GID /home/$USERNAME/.config/nvim/lazy-lock.json 2>/dev/null || true

USER $USERNAME
# Configure git to always use HTTPS instead of SSH for github.com
RUN git config --global url."https://github.com/".insteadOf git@github.com: && \
    git config --global url."https://github.com/".insteadOf ssh://git@github.com/ && \
    HOME=/home/$USERNAME nvim --headless "+Lazy! sync" +qa && \
    HOME=/home/$USERNAME nvim --headless "+TSUpdate" +qa
USER root

# Set default shell
SHELL ["/bin/zsh", "-c"]

USER $USERNAME
# Ensure PATH is set for zsh
ENV PATH="/home/$USERNAME/.local/bin:/home/$USERNAME/.local/share/mise/shims:/home/$USERNAME/go/bin:/usr/local/bin:${PATH}"

# Default command
CMD ["/bin/zsh"]
