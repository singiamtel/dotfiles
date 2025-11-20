# shellcheck shell=bash

# Autoload functions
fpath=($(brew --prefix)/share/zsh/site-functions $fpath) # macos
autoload edit-command-line; zle -N edit-command-line
autoload -Uz compinit && compinit
autoload -U +X bashcompinit && bashcompinit
autoload -Uz promptinit && promptinit

# Completion styling
zstyle ':completion:*' menu select
zstyle ":completion:*:git-checkout:*" sort false
zstyle ':completion:*:descriptions' format '[%d]'
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}'

# Shell options
setopt autocd autopushd pushdignoredups histignorealldups numericglobsort appendhistory 

# History configuration
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt hist_ignore_dups
setopt hist_ignore_space
setopt share_history

# PATH setup
[[ -d "/opt/homebrew/opt/python@3.13/libexec/bin" ]] && export PATH="$PATH:/opt/homebrew/opt/python@3.13/libexec/bin" # macos
export GOPATH="$HOME/.local/share/go"
export PATH="$PATH:$HOME/.local/bin"
export PATH="$PATH:$HOME/.local/bin/scripts"
export PATH="$PATH:$HOME/.local/bin/scripts/private"
export PATH="$PATH:$HOME/.cargo/bin"
export PATH="$PATH:$HOME/.bun/bin"
export PATH="$PATH:$GOPATH/bin"

source "/opt/homebrew/opt/antidote/share/antidote/antidote.zsh"
antidote load "${ZDOTDIR:-$HOME}/.zsh_plugins.txt"

# Git aliases (replacing the git plugin)
alias g='git'
alias ga='git add'
alias gaa='git add --all'
alias gb='git branch'
alias gba='git branch -a'
alias gbd='git branch -d'
alias gc='git commit -v'
alias gca='git commit -v -a'
alias gcam='git commit -a -m'
alias gcb='git checkout -b'
alias gco='git checkout'
alias gd='git diff'
alias gds='git diff --staged'
alias gf='git fetch'
alias gl='git pull'
alias glog='git log --oneline --decorate --graph'
alias gp='git push'
alias gpsup='git push --set-upstream origin $(git branch --show-current)'
alias grb='git rebase'
alias gst='git status'
alias gcp='git cherry-pick'
alias grv='git remote -v'
alias gra='git remote a'
alias grr='git remote rm'
alias gsh='git show'
alias gcl='git clone'

# fzf-tab configuration
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always $realpath'
enable-fzf-tab

# Source additional config files
[ -f "$HOME/.zsh_functions" ] && source "$HOME/.zsh_functions"
[ -f "$HOME/.zshrc_local" ] && source "$HOME/.zshrc_local"

# Vim mode
bindkey -v
bindkey '^e' edit-command-line
bindkey -M viins '^R' fzf_history_search
bindkey "^?" backward-delete-char

# Cursor shape changes for vi mode
function zle-keymap-select {
    if [[ ${KEYMAP} == vicmd ]] || [[ $1 = 'block' ]]; then
        echo -ne '\e[1 q'
    elif [[ ${KEYMAP} == main ]] || [[ ${KEYMAP} == viins ]] || [[ ${KEYMAP} = '' ]] || [[ $1 = 'beam' ]]; then
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

# External tool initialization
eval "$(/opt/homebrew/bin/brew shellenv)"

# eval "$(fnm env --version-file-strategy=recursive)"
eval "$(mise activate zsh)"

eval "$(atuin init zsh --disable-up-arrow)"
eval "$(starship init zsh)"
eval "$(zoxide init zsh)"

source "$HOMEBREW_PREFIX/opt/modules/init/zsh"
source "$HOME/.cargo/env"

# Environment variables
export XDG_CONFIG_HOME="$HOME/.config"
export MANPAGER='nvim +Man!'
export PAGER="less -F -X -R"
export EDITOR="nvim"
GPG_TTY=$(tty)
export GPG_TTY
export NIXPKGS_ALLOW_UNFREE=1
export FZF_DEFAULT_COMMAND='fd --type f'

# Aliases
# alias act='act --container-architecture linux/amd64' # for M1
alias ka="killall"
alias calc="uvx --with numpy python -i ~/.config/math_mode.py"
alias config="/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME"
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
alias xhjb="noglob xh --offline --print=B fake.url" # https://blog.stulta.dev/posts/annoying_json/
alias npx="bunx"

alias -g '...'='../..'
alias -g '....'='../../..'
alias -g '.....'='../../../..'
alias -g '......'='../../../../..'
alias -g '.......'='../../../../../..'
alias -g '........'='../../../../../../..'
alias -g G="|& rg -i"
alias -g GA="|& rg -A 5 -B 5 -i"
alias -g CP="|& pbcopy"
alias -g V="|& vim -"
alias -g TEE="> >(tee -a stdout.log) 2> >(tee -a stderr.log >&2)"

# Custom functions
gs () {
    git branch -vv
    git status
}

[[ "$TERM_PROGRAM" == "kiro" ]] && . "$(kiro --locate-shell-integration-path zsh)"

export PATH="/opt/homebrew/opt/postgresql@18/bin:$PATH"
export PATH="/opt/homebrew/opt/rustup/bin:$PATH"

# Added by Antigravity
export PATH="$HOME/.antigravity/antigravity/bin:$PATH"

# bun completions
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"
