# zmodload zsh/zprof
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="ys"
DISABLE_UPDATE_PROMPT=true
DISABLE_AUTO_UPDATE="true"

fpath+=~/.zfunc
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

[[ -d "/opt/homebrew/opt/python@3.13/libexec/bin" ]] && export PATH="$PATH:/opt/homebrew/opt/python@3.13/libexec/bin"
[[ -d "$HOME/Library/Python/3.13/bin" ]] && export PATH="$PATH:$HOME/Library/Python/3.13/bin"

plugins=(
    fzf-tab
    git
    z
    zsh-autosuggestions
    zsh-fzf-history-search
    zsh-syntax-highlighting
    autoswitch_virtualenv
)

source $ZSH/oh-my-zsh.sh


[ -f "$HOME/.zsh_alias" ] && source $HOME/.zsh_alias
[ -f "$HOME/.zsh_functions" ] && source $HOME/.zsh_functions
[ -f "$HOME/.zsh_local_alias" ] && source $HOME/.zsh_local_alias


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

export FZF_DEFAULT_COMMAND='ag -p ~/.gitignore'

enable-fzf-tab

eval "$(fnm env --use-on-cd --version-file-strategy=recursive)"
export PATH=$PATH:$HOME/.local/bin
export PATH=$PATH:$HOME/.local/bin/scripts
export PATH=$PATH:$HOME/.local/bin/scripts/private

eval "$(atuin init zsh --disable-up-arrow)"
source $HOMEBREW_PREFIX/opt/modules/init/zsh

autoload -U +X bashcompinit && bashcompinit
