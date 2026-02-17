# Dotfiles Docker Container

This repository includes a Docker container with all dotfiles pre-configured.

## Building Locally

```bash
docker build -t dotfiles .
```

## Using the Published Image

Once the GitHub Action has published the image, pull and run it:

```bash
# Pull the image
docker pull ghcr.io/YOUR_USERNAME/dotfiles:latest

# Run with an interactive shell
docker run -it --rm \
  -v $(pwd):/workspace \
  ghcr.io/YOUR_USERNAME/dotfiles:latest

# Or with docker-compose
docker-compose run --rm dotfiles
```

## Persistent Development Container

For a persistent container with your project mounted:

```bash
docker run -it --name dev \
  -v $(pwd):/workspace \
  -v dev-home:/home/dev \
  ghcr.io/YOUR_USERNAME/dotfiles:latest
```

## What's Included

- **Shell**: zsh with your config and functions
- **Editor**: neovim with your config
- **Terminal**: tmux with your config
- **Tools**: git, ranger, fzf, ripgrep, fd, bat, lazygit, htop
- **Dotfiles**: All configs from `.config/`

## GitHub Actions

The container is automatically built and pushed on:
- Push to `master` branch
- New tags (e.g., `v1.0.0`)
- Manual workflow dispatch

Images are published to GitHub Container Registry (ghcr.io).
