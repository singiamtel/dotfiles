FROM ubuntu:24.04

# Avoid interactive prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive

# Install basic dependencies
RUN apt-get update && apt-get install -y \
    zsh \
    git \
    neovim \
    tmux \
    ranger \
    curl \
    wget \
    build-essential \
    python3 \
    python3-pip \
    nodejs \
    npm \
    bat \
    fzf \
    ripgrep \
    fd-find \
    htop \
    ca-certificates \
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
    HOME=/home/$USERNAME nvim --headless "+Lazy! sync" +qa
USER root

# Set default shell
SHELL ["/bin/zsh", "-c"]

USER $USERNAME

# Default command
CMD ["/bin/zsh"]
