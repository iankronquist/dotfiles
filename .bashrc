#
# ~/.bashrc
#
#gpg -ear 'Your Name' foo.txt
#gpg --output foo.txt --decrypt foo.txt.gpg
# If not running interactively, don't do anything
[[ $- != *i* ]] && return

#alias ls='ls --color=auto'

alias ll='ls -la'
alias venv=virtualenv
alias v='vim'
alias pp='echo cd `pwd` | pbcopy'
alias sl='ls'
alias opn=xdg-open
alias rebash="source ~/.bashrc"
#alias gg="cd ~/git"
alias gg='. gg'
alias gcc='gcc-4.8'
#alias test="./manage.py test -s --noinput --logging-clear-handlers --with-id --with-progressive --progressive-advisories"
#alias onid='ssh kronquii@shell.onid.oregonstate.edu'
#alias ash='ssh -i ~/.ssh/ashkeys/id_rsa iankronquist@ash.osuosl.org'
#alias engr='ssh kronquii@access.engr.oregonstate.edu'
#alias sp="sudo pm-suspend"
alias gitgraph="git log --graph --abbrev-commit --decorate --date=relative --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(black)- %an%C(reset)%C(bold red)%d%C(reset)' --all"
alias gitlines="git ls-files | xargs wc -l"
#alias wifi='sudo wifi-menu'
alias p='fc -ln -2 | pbcopy'
alias connect='nmcli -p dev wifi connect'
#alias connect\ access='connect OSU_Access'
#alias connect\ resnet='connect OSU_ResNet'
alias wifilist='nmcli -p dev wifi list'
alias wifimodinmodout='sudo rmmod iwldvm && sudo rmmod iwlwifi && sleep 3 && sudo modprobe iwldvm && sudo modprobe iwlwifi'
export CLICOLOR=1
export LSCOLORS=GxFxCxDxBxegedabagaced
export WORKON_HOME=~/venv
export PATH="/usr/local/bin:$PATH:~/bin:~/.gem/ruby/2.1.0/bin/"
# Add cabal binaries to your PATH:
export PATH=~/.cabal/bin:$PATH
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'
#export RUBYOPT=rubygems
export PYTHONSTARTUP=$HOME/.pythonrc.py

#to get the current git branch, if any
__git_ps1 () 
{ 
    local b="$(git symbolic-ref HEAD 2>/dev/null)";
    if [ -n "$b" ]; then
        printf "(%s)" "${b##refs/heads/}";
    fi
}

function dict () {
	curl dict://dict.org/d:$1 | less
}

man() {
    env LESS_TERMCAP_mb=$'\E[01;31m' \
    LESS_TERMCAP_md=$'\E[01;38;5;74m' \
    LESS_TERMCAP_me=$'\E[0m' \
    LESS_TERMCAP_se=$'\E[0m' \
    LESS_TERMCAP_so=$'\E[38;5;246m' \
    LESS_TERMCAP_ue=$'\E[0m' \
    LESS_TERMCAP_us=$'\E[04;38;5;146m' \
 	man "$@"  
}

#source git auto complete script from the git git repo.
source ~/bin/git-completion.bash

#PS1='\[\033[0;32m\]\u:\[\033[0;34m\](\W)\[\033[00m\]$(__git_ps1) \[\033[0;34m\]\$ \[\033[00m\]'
PS1='\[\033[0;32m\]\u:\[\033[0;34m\](\W)\[\033[00m\]$(__git_ps1) \[\033[0;34m\]→ \[\033[00m\]'

TERM='xterm-color'
export EDITOR=vim

#[[ -z $DISPLAY && $XDG_VTNR -eq 1 ]] && exec startx

#
## Reset
#Color_Off='\e[0m'       # Text Reset
#
## Regular Colors
#Black='\e[0;30m'        # Black
#Red='\e[0;31m'          # Red
#Green='\e[0;32m'        # Green
#Yellow='\e[0;33m'       # Yellow
#Blue='\e[0;34m'         # Blue
#Purple='\e[0;35m'       # Purple
#Cyan='\e[0;36m'         # Cyan
#White='\e[0;37m'        # White
#
## Bold
#BBlack='\e[1;30m'       # Black
#BRed='\e[1;31m'         # Red
#BGreen='\e[1;32m'       # Green
#BYellow='\e[1;33m'      # Yellow
#BBlue='\e[1;34m'        # Blue
#BPurple='\e[1;35m'      # Purple
#BCyan='\e[1;36m'        # Cyan
#BWhite='\e[1;37m'       # White
#
## Underline
#UBlack='\e[4;30m'       # Black
#URed='\e[4;31m'         # Red
#UGreen='\e[4;32m'       # Green
#UYellow='\e[4;33m'      # Yellow
#UBlue='\e[4;34m'        # Blue
#UPurple='\e[4;35m'      # Purple
#UCyan='\e[4;36m'        # Cyan
#UWhite='\e[4;37m'       # White
#
## Background
#On_Black='\e[40m'       # Black
#On_Red='\e[41m'         # Red
#On_Green='\e[42m'       # Green
#On_Yellow='\e[43m'      # Yellow
#On_Blue='\e[44m'        # Blue
#On_Purple='\e[45m'      # Purple
#On_Cyan='\e[46m'        # Cyan
#On_White='\e[47m'       # White
#
## High Intensity
#IBlack='\e[0;90m'       # Black
#IRed='\e[0;91m'         # Red
#IGreen='\e[0;92m'       # Green
#IYellow='\e[0;93m'      # Yellow
#IBlue='\e[0;94m'        # Blue
#IPurple='\e[0;95m'      # Purple
#ICyan='\e[0;96m'        # Cyan
#IWhite='\e[0;97m'       # White
#
## Bold High Intensity
#BIBlack='\e[1;90m'      # Black
#BIRed='\e[1;91m'        # Red
#BIGreen='\e[1;92m'      # Green
#BIYellow='\e[1;93m'     # Yellow
#BIBlue='\e[1;94m'       # Blue
#BIPurple='\e[1;95m'     # Purple
#BICyan='\e[1;96m'       # Cyan
#BIWhite='\e[1;97m'      # White
#
## High Intensity backgrounds
#On_IBlack='\e[0;100m'   # Black
#On_IRed='\e[0;101m'     # Red
#On_IGreen='\e[0;102m'   # Green
#On_IYellow='\e[0;103m'  # Yellow
#On_IBlue='\e[0;104m'    # Blue
#On_IPurple='\e[0;105m'  # Purple
#On_ICyan='\e[0;106m'    # Cyan
#On_IWhite='\e[0;107m'   # White

