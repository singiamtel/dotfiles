# My dotfiles

This repository keeps all of the config files I use on my workflow

## Installation requirements

- neovim + Vim-Plug: https://github.com/junegunn/vim-plug
- zsh + Oh-My-Zsh: https://github.com/ohmyzsh/ohmyzsh

```bash
echo ".cfg" >> .gitignore
git clone --bare <remote-git-repo-url> $HOME/.cfg
alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
config config --local status.showUntrackedFiles no
config checkout
```

## Other configs
- compton
- redshift
- xdg-tools
- Zathura
- Alacritty
- tmux