#!/bin/bash

if [[ $(uname) == "Darwin" ]]; then
	echo "Installing OSX specific configuration files"
	link_files "osx"
	echo "Installing Xcode"
	xcode-select --install
	echo "Installing Homebrew"
	curl -L https://raw.githubusercontent.com/Homebrew/install/master/install > brewinstall && less brewinstall && echo "Should I run this script?" && read CONFIRM
	if [[ $CONFIRM == "yes" ]]; then 
		chmod +x brewinstall
		./brewinstall
		echo "Installing Homebrew packages"
		brew install $(cat osx/brewfiles)
	fi
	rm brewinstall

	osx = [".bash_profile,.bash_profile"]
	link_files $osx
	brew install osx/brewfiles
elif [[ $(uname) == "Linux" ]]; then
	linux = [".xinitrc,.xinitrc", ".Xresources,.Xresources",
		".Xmodmap,.Xmodmap"]
	linux_dirs = [".i3,.i3", ".backgrounds,.backgrounds"]
	link_files $linux
	link_directories $linux_dirs
fi

PREFIX=$HOME
mkdir "$PREFIX/.ssh"
mkdir $HOME/gg

# All systems:
all_systems = [".ssh/config,.sshconfig", ".gitconfig,.gitconfig",
	".inputrc,.inputrc", ".bashrc,.bashrc", ".aliases,.aliases",
	".vimrc,.vimrc"]
all_systems_dirs = ["bin,bin", ".vim,.vim"]

link_files $all_systems
link_directories $all_systems_dirs

link_files() {
	HERE=$(PWD)
	# $1 should be a list of comma separated src,dest tuples
	for tuple in $1; do IFS=",";
		set $tuple
		echo $PREFIX/$1, $HERE/$2
		#rm $PREFIX/$1
		#ln -s $PREFIX/$1 $2
	done
}


link_directories() {
	HERE=$(PWD)
	# $1 should be a list of comma separated src,dest tuples
	for tuple in $1; do IFS=",";
		set $tuple
		echo $PREFIX/$1, $HERE/$2
		#rm $PREFIX/$1
		#ln $PREFIX/$1 $2
	done
}
