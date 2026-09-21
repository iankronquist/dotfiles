# To profile shell startup time, uncomment the next line and the final line
# zmodload zsh/zprof

#export ZSHRC_LOAD_START=$(python -c 'from time import time; print int(round(time() * 1000))')
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


export PATH=$PATH:$HOME/scripts:$HOME/bin:$HOME/Library/Python/3.9/bin:'/Applications/Visual Studio Code.app/Contents/Resources/app/node_modules.asar.unpacked/vscode-ripgrep/bin/'

source ~/.aliases

# Set special colors for various things
export CLICOLOR=1
# For GCC 4.9+
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# Set editor
if command -v nvim &> /dev/null
then
export EDITOR=nvim
else
export EDITOR=vim
fi

#export NVIM_LISTEN_ADDRESS=$TMPDIR/nvimsocket



# My goodness, zsh prompts are almost as bad as bash prompts.

# $? is return value of the previous command
# %F{blue} makes the prompt foreground blue. Reset to the previous foreground with %f.
# ${...:0:15} takes a slice of the first 15 characters
# $(git rev-parse ...) gets the current git branch/commit
# $'\n' makes a literal newline so it's a multi line prompt
# %# makes a % for normal users and a # for root
# %f resets the foreground color to whatever it was originally
setopt prompt_subst
# Original prompt — kept for easy revert.
# prompt='$? %F{blue}%n %~ %* $(git symbolic-ref -q --short HEAD 2>/dev/null || git describe --tags --exact-match HEAD 2>/dev/null)'$'\n''%# %f'

# Labeled prompt with OSC 133 semantic shell integration markers.
# Labels (exit=, user=, cwd=, time=, branch=) make the prompt parseable by
# AI agents / scripts reading scrollback without positional guessing.
# OSC 133 markers let terminals (iTerm2, Ghostty, Kitty, WezTerm, VS Code,
# Zed) semantically parse prompts: jump-by-prompt, select-output-of-last-
# command, exit-code badges, scrollbar marks.
#   A — prompt start (emitted in precmd)
#   C — command output start (emitted in preexec, after Enter)
#   D;<exit> — previous command finished, carries its exit code
autoload -Uz add-zsh-hook
_osc133_precmd() {
  local last=$?
  print -n $'\e]133;D;'"${last}"$'\e\\\e]133;A\e\\'
}
_osc133_preexec() {
  print -n $'\e]133;C\e\\'
}
# Set _git_branch_display in precmd so the prompt itself stays a simple
# parameter expansion. Empty string when not in a repo so " branch=…" drops
# out cleanly. Wraps the value (not the label) in %F{blue}…%f.
_update_git_branch() {
  local b
  b=$(git symbolic-ref -q --short HEAD 2>/dev/null || git describe --tags --exact-match HEAD 2>/dev/null)
  if [[ -n $b ]]; then
    _git_branch_display=" branch=%F{blue}${b}%f"
  else
    _git_branch_display=""
  fi
}
add-zsh-hook precmd _osc133_precmd
add-zsh-hook precmd _update_git_branch
add-zsh-hook preexec _osc133_preexec
# Labels in default color; cwd and branch values in blue; exit code red iff non-zero.
# %(?.A.B) is zsh's ternary on $? — A when 0, B otherwise.
prompt='exit=%(?.%?.%F{red}%?%f) user=%n cwd=%F{blue}%~%f time=%*${_git_branch_display}'$'\n''%F{blue}%#%f '

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
setopt EXTENDED_HISTORY
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

if ! grep -q "pam_tid.so" /etc/pam.d/sudo ; then
	echo "touch ID no longer enabled for sudo. Insert the following line as line 2 in /etc/pam.d/sudo:"
	echo "  auth   sufficient  pam_tid.so  # enables touch id auth for sudo"
fi

if [ "$TERM_PROGRAM" = 'iTerm.app' ] ; then
	test -e ~/.iterm2_shell_integration.zsh && source ~/.iterm2_shell_integration.zsh || true
fi
# zprof

#alias [A=!!

#### Added by green-restore install-tools
autoload -Uz compinit && compinit
####
source ~/bin/gg
export HWTGENIE_TOKEN=$(cat ~/.hwtgenie)


# Opam disabled since I'm not using it now
# # BEGIN opam configuration
# # This is useful if you're using opam as it adds:
# #   - the correct directories to the PATH
# #   - auto-completion for the opam binary
# # This section can be safely removed at any time if needed.
# [[ ! -r '/Users/ian/.opam/opam-init/init.zsh' ]] || source '/Users/ian/.opam/opam-init/init.zsh' > /dev/null 2> /dev/null
# # END opam configuration
export PATH="$PATH:/Users/ian/shared/ravena/prebuilt/darwin-arm64"

#echo 'getting radar api token'
#export RADAR_API_TOKEN=$(appleconnect getToken -a $(appleconnect currentUser) -E PROD -I 900731       -t oauth -G pkce -C 41rih2rtlg4zyax6eztzug6ftnhkun -u https://radar-webservices.apple.com)

#export RADAR_API_TOKEN=$(/Users/ian/shared/ravena/.claude/skills/radar/scripts/radar-auth.sh ikronquist)
#
#
# Source the environment variables file if it exists. Mostly there to set up a hugging face read only access token.
[ -f ~/.env ] && source ~/.env
