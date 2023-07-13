import os

links = {
	".bash_profile": "~/.bash_profile",
	".sshconfig": "~/.ssh/config",
	".gitconfig": "~/.gitconfig",
	".gitignore": "~/.gitignore",
	".bashrc": "~/.bashrc",
	".aliases": "~/.aliases",
	".lldbinit": "~/.lldbinit",
	".tmux.conf": "~/.tmux.conf",
	".zshrc": "~/.zshrc",
	".inputrc": "~/.inputrc",
	".vimrc": "~/.vimrc",
	".vim": "~/.vim",
	"bin": "~/bin",
}


here = os.path.dirname(os.path.abspath(__file__))

for (source_file, symlink) in links.items():
	source_file = os.path.realpath(os.path.join(here, source_file))
	symlink = os.path.realpath(os.path.expanduser(symlink))
	print(source_file, symlink)
	os.symlink(source_file, symlink)
