export CLICOLOR=1
export LSCOLORS=GxFxCxDxBxegedabagaced
#export WORKON_HOME=~/venv
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'
export PYTHONSTARTUP=$HOME/.pythonrc.py
REPORTTIME=1


export PATH="/usr/local/bin:$HOME/bin:$PATH:~/.cabal/bin"
for file in $( ls $HOME/.zshrc.d/*  | grep -ve ".swp$" | grep -ve ".bak$")
do
	source $file
done
