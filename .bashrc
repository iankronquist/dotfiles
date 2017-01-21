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
PS1='\[\033[1;32m\]\h:\[\033[1;34m\](\W)\[\033[00m\]$(__git_ps1) \[\033[0;34m\]→ \[\033[00m\]'


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
fi

if ! [[ `ssh-add -l` =~ 'id_rsa_github' ]]
then
	ssh-add ~/.ssh/id_rsa_github
fi
if ! [[ `ssh-add -l` =~ 'id_ecdsa_github' ]]
then
	ssh-add ~/.ssh/id_ecdsa_github
fi
