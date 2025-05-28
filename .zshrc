# shellcheck shell=bash

export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="ys"
DISABLE_UPDATE_PROMPT=true
DISABLE_AUTO_UPDATE="true"

autoload edit-command-line; zle -N edit-command-line
autoload -Uz compinit && compinit
autoload -Uz promptinit && promptinit
zstyle ':completion:*' menu select
zstyle ":completion:*:git-checkout:*" sort false
zstyle ':completion:*:descriptions' format '[%d]'
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always $realpath'
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}'
setopt autocd autopushd pushdignoredups histignorealldups numericglobsort appendhistory 

# This has to be before the plugins
[[ -d "/opt/homebrew/opt/python@3.13/libexec/bin" ]] && export PATH="$PATH:/opt/homebrew/opt/python@3.13/libexec/bin"

plugins=(
    fzf-tab
    git
    z
    zsh-autosuggestions
    zsh-fzf-history-search
    zsh-syntax-highlighting
    # autoswitch_virtualenv
)

source "$ZSH/oh-my-zsh.sh"


[ -f "$HOME/.zsh_functions" ] && source "$HOME/.zsh_functions"
[ -f "$HOME/.zshrc_local" ] && source "$HOME/.zshrc_local"


# Vim mode
bindkey -v

bindkey '^e' edit-command-line

bindkey -M viins '^R' fzf_history_search
# bindkey -M viins '^F' history-incremental-pattern-search-forward
bindkey "^?" backward-delete-char

# Changes cursor to fit vi mode
function zle-keymap-select {
if [[ ${KEYMAP} == vicmd ]] ||
    [[ $1 = 'block' ]]; then
    echo -ne '\e[1 q'
elif [[ ${KEYMAP} == main ]] ||
    [[ ${KEYMAP} == viins ]] ||
    [[ ${KEYMAP} = '' ]] ||
    [[ $1 = 'beam' ]]; then
    echo -ne '\e[5 q'
fi
}

zle -N zle-keymap-select
zle-line-init() {
zle -K viins # initiate `vi insert` as keymap
echo -ne "\e[5 q"
}
zle -N zle-line-init
echo -ne '\e[5 q' # Use beam shape cursor on startup.
preexec() { echo -ne '\e[5 q' ;} # Use beam shape cursor for each new prompt.

enable-fzf-tab

eval "$(direnv hook zsh)"
eval "$(atuin init zsh --disable-up-arrow)"
eval "$(fnm env --use-on-cd --version-file-strategy=recursive)"

source "$HOMEBREW_PREFIX/opt/modules/init/zsh"

autoload -U +X bashcompinit && bashcompinit

source "$HOME/.cargo/env"

# env

export XDG_CONFIG_HOME="$HOME/.config"
export MANPAGER='nvim +Man!'
export PAGER="less -F -X"
export EDITOR="nvim"

GPG_TTY=$(tty)
export GPG_TTY
export NIXPKGS_ALLOW_UNFREE=1
export FZF_DEFAULT_COMMAND='fd --type f'

export PATH="$PATH:$HOME/.local/bin"
export PATH="$PATH:$HOME/.local/bin/scripts"
export PATH="$PATH:$HOME/.local/bin/scripts/private"
export PATH="$PATH:$HOME/.cargo/bin"
export PATH="$PATH:$HOME/.bun/bin"
[[ -d "$HOME/Library/Python/3.13/bin" ]] && export PATH="$PATH:$HOME/Library/Python/3.13/bin"

# alias

alias act='act --container-architecture linux/amd64' # for M1
alias ka="killall"
alias calc="python -i ~/.config/math_mode.py"
alias config="/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME"
# alias gd="git difftool"
alias cd..="cd .."
alias df="df -h"
alias grep="grep -E --color=auto"
alias diff="diff -u"
alias ls='ls -h --color=auto'
alias diff="diff --color=auto"
alias sdn="sudo shutdown now"

alias e="nvim" && alias vi="nvim" && alias vim="nvim"
alias v="source .venv/bin/activate"
alias f='nvim $(fzf)'
alias SS="sudo systemctl"
alias r="ranger"
alias lg="lazygit"
alias lazyconf="lazygit --git-dir=$HOME/.cfg/ --work-tree=$HOME"
alias rp="realpath"
alias fm="fastmod"
alias dt="difft"
alias tidy="tidy --tidy-mark no"
alias yt="yt-dlp --add-metadata -i" # Download video link
alias yta="yt -x -f bestaudio/best" # Download only audio

alias -g G="|& rg -i"
alias -g CP="|& pbcopy"
alias -g V="|& vim -"
alias -g TEE="> >(tee -a stdout.log) 2> >(tee -a stderr.log >&2)"

gs () {
    git branch -vv
    git status
}
