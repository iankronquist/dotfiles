Ian's Dotfiles
==============

It's handy to keep your dotfiles under source control

Installation
------------
There are two ways to install these dotfiles:
1. Use ansible. This is the recommended method. Obviously ansible will need to
be installed.
If I have hosts named ash and puck in my ssh config, I can install my dotfiles
on them by running:
```sh
	$ ansible-playbook ansible-playbook/config.yml -i 'ash,puck,'
```

Some packages like git will need to be installed to install the dotfiles. A
playbook to install git and some common C, C++, and Python developer tools can
be run with:

```sh
	$ ansible-playbook ansible-playbook/install_packages.yml -i 'ash,puck,'
```

2. Just execute the inadequately tested `installdotfiles.sh` script.

Files and their purposes
------------------------
This is a quick summary for the curious.
```
.
├── .aliases: My aliases for long or very common commands.
├── .bash_profile: Mostly useful on OSX when bash looks for this file instead
│                  of .bashrc.
├── .bashrc: Configures Bash including the prompt, aliases, helpful scripts,
│            environment variables, ssh keychain, etc.
├── .gitconfig: git aliases, preferences, etc.
├── .inputrc: Sets up vim-like input for Bash
├── .sshconfig: Configures how to authenticate with many hosts.
├── .vim: Stores vim plugins, colors, etc.
├── .vimrc: Configures vim indentation, spell checking, ui fanciness, etc.
├── .zshrc: I don't use this really.
├── .zshrc.d: Or this either.
├── ansible-playbook: These are the ansible playbooks used to deploy the
│   │                  dotfiles.
│   ├── config.yml
│   ├── install_pacakges.yml
│   └── vars.yml: This file contains hashes which specify how to install the
│                 dotfiles.
├── bin
│   ├── git-completion.bash: This is an autocomplete script from git's git repo
│   ├── git-lines: A custom git command.
│   └── git-undo: Another custom git command.
├── installdotfiles.sh
├── linux: Files only useful on Linux
│   ├── .Xmodmap: Custom keybindings like swapping control and esc.
│   ├── .Xresources: Settings for Xterm and other things.
│   ├── .i3
│   │   └── config: settings for the i3 tiling window manager
└── osx: Files only useful on OSX
    └── brewfiles: A list of packages installed with homebrew.
```
