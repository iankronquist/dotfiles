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

#os.chdir(os.path.expanduser('~'))
for (source_file, symlink) in links.items():
	source_file = os.path.realpath(os.path.join(here, source_file))
	print(symlink)
	symlink = os.path.expanduser(symlink)
	print(symlink)
	print(source_file, symlink)
	if os.path.islink(symlink):
		if os.readlink(symlink) == source_file:
			print('link exists, continuing')
			continue
	elif os.path.exists(symlink):
		old = symlink + '.old'
		print('file', symlink, 'exists, renaming to', old)
		os.rename(symlink, old)
	os.symlink(source_file, symlink)
