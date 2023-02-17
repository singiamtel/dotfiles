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
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'exa -1 --color=always $realpath'
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}'
setopt autocd autopushd pushdignoredups histignorealldups numericglobsort appendhistory extendedglob

plugins=(
	git
	z
	fzf-tab
	zsh-autosuggestions
)

source $ZSH/oh-my-zsh.sh

[ -f "$HOME/.zsh_alias" ] && source $HOME/.zsh_alias
[ -f "$HOME/.zsh_functions" ] && source $HOME/.zsh_functions
[ -f "$HOME/.zsh_local_alias" ] && source $HOME/.zsh_local_alias

# Vim mode
bindkey -v

bindkey '^e' edit-command-line

bindkey -M viins '^R' history-incremental-pattern-search-backward
bindkey -M viins '^F' history-incremental-pattern-search-forward
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

source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

export PATH=/home/sergio/.fnm:$PATH
export PATH=$PATH:$HOME/.local/bin
export PATH=$PATH:$HOME/.local/bin/scripts
eval "`fnm env`"
# zprof
