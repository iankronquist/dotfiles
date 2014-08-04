#!/bin/bash

# A little hacky, but a lot simpler than some I've seen

if [[ $(uname) == "Darwin" ]]; then
	echo "Installing OSX specific configuration files"
	echo "Installing dev tools"
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
	echo "Copying plists"
	cp osx/com.apple.Terminal.plist ~/Library/Preferences/com.apple.Terminal.plist
elif [[ $(uname) == "Linux" ]]; then
	echo "Installing Linux specific configuration files"
	mv linux/.* .
else
	echo "Unknown system. exiting"
	exit
fi

mkdir $HOME/git

for file in $(ls -a); do
	if [[ $file != "." && $file != ".." && $file != "osx" && $file != "linux" && $file != "$0" ]]; then
		ln $file $HOME/$file
	fi
done
