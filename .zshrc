export CLICOLOR=1
export LS_COLORS=exfxcxdxbxegedabagacad
#export WORKON_HOME=~/venv
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'
export PYTHONSTARTUP=$HOME/.pythonrc.py
REPORTTIME=1

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

export PATH="/usr/local/bin:$HOME/bin:$PATH:~/.cabal/bin"
for file in $( ls $HOME/.zshrc.d/*  | grep -ve ".swp$" | grep -ve ".bak$")
do
	source $file
done
