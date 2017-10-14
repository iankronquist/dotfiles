#
# ~/.bashrc
#
# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Get all of my aliases
source $HOME/.aliases

# Source my workflow script
source ~/gg/gg/gg

# Source git auto complete script from the git git repo.
source ~/bin/git-completion.bash

# Set editor
export EDITOR=vim

# Log bash history
export HISTTIMEFORMAT="%d/%m/%y %T "
export HISTSIZE=10000

# Set special colors for various things
export CLICOLOR=1
# For GCC 4.9+
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'


if [[ $(uname) == "Darwin" ]]; then
	export HOMEBREW_NO_ANALYTICS=1
	# Path munging!
	# Get the go version from brew
	export GOVERSION=$(brew list go | head -n 1 | cut -d '/' -f 6)
	export GOPATH=$HOME/gopath
	export GOROOT=$(brew --prefix)/Cellar/go/$GOVERSION/libexec
	# Homebrew
	export PATH="/usr/local/bin:$PATH"
	# Homebrew cross compilers
	export PATH="$PATH:/usr/local/cross/bin/"
	# Homebrew custom LLVM
	export PATH="$PATH:/usr/local/opt/llvm/share/llvm:/usr/local/opt/llvm/bin"
	# MacTex
	export PATH="$PATH:/Library/TeX/Root/bin/x86_64-darwin/"

elif ! [[ $(uname) =~ 'Linux' ]]; then
	export PATH="$PATH:$HOME/cross/bin/"
fi

# Dotfile scripts
export PATH="$PATH:$HOME/bin"
# Go
export PATH="$PATH:$GOPATH"
# Rust
export PATH="$PATH:$HOME/.cargo/bin"

# Mess with my prompt

#to get the current git branch, if any
__git_ps1 () 
{ 
    local b="$(git symbolic-ref HEAD 2>/dev/null)";
    if [ -n "$b" ]; then
        printf "(%s)" "${b##refs/heads/}";
    fi
}

export PROMPT_COMMAND=__prompt_command

__prompt_command() {

	local EXIT="$?"
	local RED='\[\033[0;31m\]'
	local BOLD_GREEN='\[\033[1;32m\]'
	local BOLD_BLUE='\[\033[1;34m\]'
	local RESET_COLOR='\[\033[0;00m\]'
	local FANCY_SYMBOL='→'
	PS1=""

	# If the last command failed, display the return code in red.
	if [ $EXIT != 0 ]; then
		PS1+="${RED}${EXIT} ${RESET_COLOR}"
	fi

	# Only display username on wide terminals
	if [ $COLUMNS -gt 150 ]; then
		PS1+="${BOLD_GREEN}\u@${RESET_COLOR}"
	fi

	PS1+="${BOLD_GREEN}\h:${BOLD_BLUE}(\W)${RESET_COLOR}$(__git_ps1) ${BOLD_BLUE}${FANCY_SYMBOL} ${RESET_COLOR}"
}


# Handy scripts

# Look up a word
function dict () {
	curl -s dict://dict.org/d:$1 | less
}

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


if [[ $(uname) == "Darwin" ]]; then

	# Add ssh keys
	export DOCKER_HOST=tcp://192.168.59.103:2376
	export DOCKER_CERT_PATH=$HOME/.boot2docker/certs/boot2docker-vm
	export DOCKER_TLS_VERIFY=1
	# Source bash completion
	#source /usr/share/bash-completion/bash_completion

	# Taken from "rbenv init -"
	export PATH=$HOME/.rbenv/shims:$PATH
	export RBENV_SHELL=bash

	rbenv() {
		typeset command
		command="$1"
		if [ "$#" -gt 0 ]; then
			shift
		fi

		case "$command" in
			rehash|shell)
				eval `rbenv "sh-$command" "$@"`;;
			*)
				command rbenv "$command" "$@";;
		esac
	}
elif [[ $(uname) == "Linux" ]]; then
	if [[ $(hostname) == "kartal" ]]; then
		if ! [[ $(ssh-add -l) =~ 'id_ecdsa_github' ]]; then
			ssh-add ~/.ssh/id_ecdsa_github
		fi
	fi
fi
