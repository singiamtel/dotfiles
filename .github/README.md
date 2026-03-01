# My dotfiles

This repository keeps all of the config files I use on my workflow

## Docker

Run the pre-configured environment with your current directory mounted as a workspace:

```bash
docker run -it --rm \
  -v $(pwd):/workspace \
  -w /workspace \
  ghcr.io/singiamtel/dotfiles:latest
```

Or build locally first:

```bash
docker build -t dotfiles .github/
docker run -it --rm \
  -v $(pwd):/workspace \
  -w /workspace \
  dotfiles
```

## Installation requirements

- zsh + [Antidote](https://antidote.sh/)

```bash
echo ".cfg" >> .gitignore
git clone --bare git@github.com:singiamtel/dotfiles.git $HOME/.cfg
alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
config config --local status.showUntrackedFiles no
config checkout
```
