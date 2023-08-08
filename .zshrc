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

__conda_setup="$('/opt/homebrew/Caskroom/miniconda/base/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
	eval "$__conda_setup"
else
	if [ -f "/opt/homebrew/Caskroom/miniconda/base/etc/profile.d/conda.sh" ]; then
# . "/opt/homebrew/Caskroom/miniconda/base/etc/profile.d/conda.sh"  # commented out by conda initialize
	else
		export PATH="/opt/homebrew/Caskroom/miniconda/base/bin:$PATH"
	fi
fi
unset __conda_setup
if [ `uname -m` = "x86_64" ]; then
	conda activate 86_env
fi

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/Users/sergio/miniforge3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/Users/sergio/miniforge3/etc/profile.d/conda.sh" ]; then
        . "/Users/sergio/miniforge3/etc/profile.d/conda.sh"
    else
        export PATH="/Users/sergio/miniforge3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<


plugins=(
	asdf
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

. "$HOME/.asdf/asdf.sh"

zle -N zle-keymap-select
zle-line-init() {
zle -K viins # initiate `vi insert` as keymap
echo -ne "\e[5 q"
}
zle -N zle-line-init
echo -ne '\e[5 q' # Use beam shape cursor on startup.
preexec() { echo -ne '\e[5 q' ;} # Use beam shape cursor for each new prompt.

export FZF_DEFAULT_COMMAND='ag -p ~/.gitignore -g ""'

enable-fzf-tab

# export PATH=/home/sergio/.fnm:$PATH
# eval "`fnm env`"
export PATH=$PATH:$HOME/.local/bin
export PATH=$PATH:$HOME/.local/bin/scripts
# zprof



