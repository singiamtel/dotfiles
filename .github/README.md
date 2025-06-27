# My dotfiles

This repository keeps all of the config files I use on my workflow

## Installation requirements

- zsh + [Antidote](https://antidote.sh/)

```bash
echo ".cfg" >> .gitignore
git clone --bare git@github.com:singiamtel/dotfiles.git $HOME/.cfg
alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
config config --local status.showUntrackedFiles no
config checkout
```
