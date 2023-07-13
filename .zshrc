
setopt BASH_REMATCH

autoload compinit
compinit
# Autocomplete targets for Makefiles
zstyle ':completion:*:*:make:*' tag-order 'targets'


bindkey -e
bindkey \^U backward-kill-line
bindkey \^W forward-word
bindkey \^B backward-word



zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
export PATH=$PATH:$HOME/bin:'/Applications/Visual Studio Code.app/Contents/Resources/app/node_modules.asar.unpacked/vscode-ripgrep/bin/'

source ~/.aliases
source ~/bin/gg

# Set special colors for various things
export CLICOLOR=1
# For GCC 4.9+
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# Set editor
export EDITOR=vim


# My goodness, zsh prompts are almost as bad as bash prompts.

# $? is return value of the previous command
# %F{blue} makes the prompt foreground blue. Reset to the previous foreground with %f.
# ${...:0:15} takes a slice of the first 15 characters
# $(git rev-parse ...) gets the current git branch/commit
# $'\n' makes a literal newline so it's a multi line prompt
# %# makes a % for normal users and a # for root
# %f resets the foreground color to whatever it was originally
setopt prompt_subst
prompt='$? %F{blue}%~ %* $(git rev-parse --abbrev-ref HEAD 2>/dev/null)'$'\n''%# %f'

export MANPATH="/opt/homebrew/share/man${MANPATH+:$MANPATH}:";
export INFOPATH="/opt/homebrew/share/info:${INFOPATH:-}";

projver () {
    BUILD=$1
    PROJ=$2
    TRAIN=`echo "$BUILD" | grep -oE '^[A-Z][a-zA-Z]+'`
    echo "ls -l ~rc/Software/$TRAIN/Updates/$BUILD/Projects/$PROJ"
    ls -l ~rc/Software/$TRAIN/Updates/$BUILD/Projects/$PROJ
}


#export PYTHONPATH=$PYTHONPATH:/opt/homebrew/lib/python3.9/site-packages/
# Shorthands for Astris ports
ACC=8000
ISP=8006
GFX=8008
DISP=8009
SIODMA=8010
PMP=8011
SMC=8012
AOP=8013
MTP=8014
SEP=8015
AVEASC=8016
ANE=8017
ANS2=8018

#export HISTFILESIZE=1000000000
#export HISTSIZE=1000000000
#export HISTIGNORE=&
export HISTSIZE=1000000000
export HISTFILESIZE=1000000000
export SAVEHIST=1000000000
#export HISTCONTROL=ignoreboth
#setopt INC_APPEND_HISTORY
#setopt EXTENDED_HISTORY
#setopt extendedhistory
#setopt histexpiredupsfirst
#setopt histfindnodups
#setopt histignorealldups
#setopt histignoredups
#setopt histignorespace
#setopt histreduceblanks
#setopt histsavenodups
#setopt histverify
setopt incappendhistory
#setopt sharehistory

# Braindead zsh defaults
alias history='history 0'

# zsh shell expansion won't pass * down to the command, which makes it so you
# have to always put grep arguments which use * in quotes, which is annoying
# for every day command line use.
setopt +o nomatch
test -e /Users/ian/.iterm2_shell_integration.zsh && source /Users/ian/.iterm2_shell_integration.zsh || true

if ! grep -q "pam_tid.so" /etc/pam.d/sudo ; then
	echo "touch ID no longer enabled for sudo. Insert the following line as line 2 in /etc/pam.d/sudo:"
	echo "  auth   sufficient  pam_tid.so  # enables touch id auth for sudo"
fi

test -e ~/.iterm2_shell_integration.zsh && source ~/.iterm2_shell_integration.zsh || true
