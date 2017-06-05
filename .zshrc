# Log bash history
export HISTTIMEFORMAT="%d/%m/%y %T "
export HISTSIZE=10000
REPORTTIME=1

# Set editor
export EDITOR=vim


export CLICOLOR=1
export LS_COLORS=exfxcxdxbxegedabagacad
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

export PYTHONSTARTUP=$HOME/.pythonrc.py

autoload compinit
compinit

zstyle ':completion:*' completer _expand _complete _ignored _correct _approximate
zstyle ':completion:*' expoand prefix
zstyle ':completion:*' ignore-parents parent pwd ..
zstyle ':completion:*' list-suffixes
zstyle ':completion:*' max-errors 2
zstyle ':completion:*' menu select
zstyle ':completion:*:default' list-colors  yes
zstyle ':completion:*:descriptions' format "Completing %B%d%B"

export PATH="/usr/local/bin:$HOME/bin:$PATH"
#export PATH="$PATH:~/.cabal/bin"
#for file in $( ls $HOME/.zshrc.d/*  | grep -ve ".swp$" | grep -ve ".bak$")
#do
#	source $file
#done

__git_ps1 () {
    local b="$(git symbolic-ref HEAD 2>/dev/null)";
    if [ -n "$b" ]; then
        printf "%s" "${b##refs/heads/}";
    fi
}

autoload -U colors && colors
PS1="%{$fg[green]%}%m %{$fg[blue]%}%~ %{$reset_color%}$(__git_ps1) %{$fg[blue]%}z %{$reset_color%}"

if [[ $(uname) == "Darwin" ]]; then
	export HOMEBREW_NO_ANALYTICS=1
	# Path munging!
	# Get the go version from brew
	export GOVERSION=$(brew list go | head -n 1 | cut -d '/' -f 6)
	export GOPATH=$HOME/gopath
	export GOROOT=$(brew --prefix)/Cellar/go/$GOVERSION/libexec
	# Cross compilers
	export PATH=/usr/local/cross/bin/:$PATH
	# Latex
	export PATH=/Library/TeX/Root/bin/x86_64-darwin/:$PATH
	# Golang
	export PATH=$PATH:$GOPATH/bin

	# Does not play nice with brew
	#if [[ -d $HOME/.nix-profile ]]; then
	#	#source $HOME/.nix-profile/etc/profile.d/nix.sh
	#fi
fi

# Color man pages
man() {
	env LESS_TERMCAP_mb=$'\E[01;31m' \
		LESS_TERMCAP_md=$'\E[01;38;5;74m' \
		LESS_TERMCAP_me=$'\E[0m' \
		LESS_TERMCAP_se=$'\E[0m' \
		LESS_TERMCAP_so=$'\E[38;5;46m' \
		LESS_TERMCAP_ue=$'\E[0m' \
		LESS_TERMCAP_us=$'\E[04;38;5;146m' \
		man "$@"
}
