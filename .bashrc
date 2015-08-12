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
# For GCC 4.9
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

export N_PREFIX=$HOME/bin

WORKSTATIONS="aqua green blue cyan diamond emerald honey neon orange pink silver taupe violet xray yellow"

if [[ $(uname) == "Darwin" ]]; then
	# Path munging!
	# Get the go version from brew
	export GOVERSION=$(brew list go | head -n 1 | cut -d '/' -f 6)
	export GOPATH=$HOME/gopath
	export GOROOT=$(brew --prefix)/Cellar/go/$GOVERSION/libexec
	export PATH=/usr/local/opt/llvm/bin:$PATH:/usr/local/opt/llvm/share/llvm
elif [[ $WORKSTATIONS =~ $(hostname) ]]; then
	#workstation specific settings
	eval `keychain --eval id_rsa fir_rsa`
	ssh-add ~/.ssh/workstation.pem
	# OpenStack Variables
	export OS_USERNAME=iankronquist
	export OS_TENANT=OSL
	#export OS_FLOATING_IP=10.1.100.90i # make sure to rename the ip to your name in the dns
	export OS_PRIVATE_SSH_KEY=~/.ssh/workstation.pem # I suggest creating an openstack specific ssh key
	export OS_PUBLIC_SSH_KEY=~/.ssh/workstation.pem.pub # I suggest creating an openstack specific ssh key
	export OS_SSH_KEYPAIR=workstation # name it the same as your openstack account
	export OS_PASSWORD=`cat $HOME/.openstack_password`
	export OS_AUTH_URL=http://openstack.osuosl.org:35357/v2.0/
	export OS_SECURITY_GROUP_NO_FIREWALL=no-firewall
	export OS_FLOATING_IP_POOL=nova
	export OS_FLAVOR_REF=m1.small
	#export KITCHEN_YAML=.kitchen.cloud.yml

	# FIXME: clean this mess up.
	export PATH=/home/iankronquist/.chefdk/gem/ruby/2.1.0/bin:/home/iankronquist/.chefdk/bin:/usr/local/bin:/home/iankronquist/bin:/home/iankronquist/.rvm/bin:/opt/chef/bin:/opt/chef/embedded/bin:/home/tschuy/.chefdk/gem/ruby/2.1.0/bin:/usr/local/bin:/home/iankronquist/bin:/home/iankronquist/.rvm/bin:/opt/chef/bin:/opt/chef/embedded/bin:/usr/local/bin:/usr/local/bin:/usr/bin:/bin:/usr/local/games:/usr/games:/home/iankronquist/bin/:/home/iankronquist/bin/bin::/home/iankronquist/bin/:/home/iankronquist/bin/bin::/home/iankronquist/bin/:/home/iankronquist/bin/bin
	export PATH=/opt/chefdk/bin:$PATH
	export PATH=/home/iankronquist/bin/n/versions/node/0.12.2/bin:$PATH
fi

export PATH="/usr/local/bin:$HOME/bin/:$HOME/bin/bin:$GOPATH:$PATH"

# Mess with my prompt

#to get the current git branch, if any
__git_ps1 () 
{ 
    local b="$(git symbolic-ref HEAD 2>/dev/null)";
    if [ -n "$b" ]; then
        printf "(%s)" "${b##refs/heads/}";
    fi
}
PS1='\[\033[1;32m\]\u@\h:\[\033[1;34m\](\W)\[\033[00m\]$(__git_ps1) \[\033[0;34m\]→ \[\033[00m\]'


# FIXME: This is a hack, and I should be smarter about my configuration management
if [[ $(hostname) =~ "puppettop" ]]; then
	eval "$(rbenv init -)";

	vmlist()
	{
		curl --url http://vcloud.delivery.puppetlabs.net/vm 2> /dev/null | ruby -e 'require "json"; JSON.parse(STDIN.read).each { |vm| puts vm }'
	}
	vmget() {
		curl -d --url http://vcloud.delivery.puppetlabs.net/vm/$1 2> /dev/null | ruby -e 'require "json"; resp = JSON.parse(STDIN.read); puts resp["'$1'"]["hostname"]'
	}
	vmssh() {
		ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -i ~/.ssh/id_rsa-acceptance root@$1 "${@:2}"
	}
	vmrm() {
		curl -X DELETE --url http://vcloud.delivery.puppetlabs.net/vm/$1
	}
	vmwinssh() {
		# msiexec /i http://downloads.puppetlabs.com/windows/puppet-agent-x64-latest.msi
		ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -i ~/.ssh/id_rsa-acceptance Administrator@$1 "${@:2}"
	}
fi
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
	if ! [[ `ssh-add -l` =~ 'id_rsa_github' ]]
	then
		ssh-add ~/.ssh/id_rsa_github
	fi
	if ! [[ `ssh-add -l` =~ 'id_rsa_workstation' ]]
	then
		ssh-add ~/.ssh/id_rsa_workstation
	fi
fi
