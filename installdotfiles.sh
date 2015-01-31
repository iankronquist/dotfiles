#!/bin/bash

# A little hacky, but a lot simpler than some I've seen

if [[ $(uname) == "Darwin" ]]; then
	echo "Installing OSX specific configuration files"
	link_files "osx"
	echo "Installing Xcode"
	xcode-select --install
	echo "Installing Homebrew"
	curl -L https://raw.github.com/Homebrew/homebrew/go/install > brewinstall && less brewinstall && echo "Should I run this script?" && read CONFIRM
	if [[ $CONFIRM == "yes" ]]; then 
		chmod +x brewinstall
		./brewinstall
		echo "Installing Homebrew packages"
		brew install $(cat osx/brewfiles)
	fi
	rm brewinstall
elif [[ $(uname) == "Linux" ]]; then
	echo "Installing Linux specific configuration files"
	link_files "linux"
else
	echo "Unknown system. exiting"
	exit
fi


link_files () {
	for file in $(ls -a $1); do
		if [[ $file != "." && $file != ".." && $file != "osx" && $file != "linux" && $file != "$0" ]]; then
			ln -s `pwd`/$file $HOME/$file
		fi
	done
}

mkdir $HOME/gg
link_files "."
