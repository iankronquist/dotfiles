#
# ~/.bashrc
#
# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Get all of my aliases
source $HOME/.aliases

# Source git auto complete script from the git git repo.
source ~/bin/git-completion.bash

# Set editor
export EDITOR=vim

# Set special colors for various things
export CLICOLOR=1
export LSCOLORS=GxFxCxDxBxegedabagaced
# For GCC 4.9
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# Path munging!
# Get the go version from brew
export GOVERSION=$(brew list go | head -n 1 | cut -d '/' -f 6)
export GOPATH=$HOME/gopath
export GOROOT=$(brew --prefix)/Cellar/go/$GOVERSION/libexec

export PATH="/usr/local/bin:$PATH:$HOME/bin/:$HOME/bin/bin:$GOPATH"

# Mess with my prompt

#to get the current git branch, if any
__git_ps1 () 
{ 
    local b="$(git symbolic-ref HEAD 2>/dev/null)";
    if [ -n "$b" ]; then
        printf "(%s)" "${b##refs/heads/}";
    fi
}
PS1='\[\033[0;32m\]\u:\[\033[0;34m\](\W)\[\033[00m\]$(__git_ps1) \[\033[0;34m\]→ \[\033[00m\]'

# Handy scripts

# Look up a word
function dict () {
	curl dict://dict.org/d:$1 | less
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
