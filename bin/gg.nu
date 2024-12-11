# vim: set syntax=python:
echo "hello world"

def gg [name: string = ""] {
	let PROJECTS_DIR = "~/gg/"
	echo $PROJECTS_DIR
	echo $name
	if $name == "" {
		echo 'y' $name
		cd $PROJECTS_DIR
		ls
		return 0
	} else if $name =~ 'http' or $name =~ 'git.*@' or $name =~ 'git://' {
		echo "$PROJECTS_DIR" 
		cd "$PROJECTS_DIR"
		# Run git clone and save messages on stdout and stderr
		CLONE_OUTPUT=$(git clone --recurse-submodules $1 $2 2>&1 | tee /dev/tty | head -n 1)

		# If the clone succeeded, find the directory created from the message
		# git wrote on stderr. Else, print git's problem and return with its exit
		# code.
		if  $env.LAST_EXIT_CODE == 0 {
			GIT_CLONE_DIR=$(echo $env.CLONE_OUTPUT |
				sed "s/^[^']*'//; s/'[^']*$//")
				cd $env.GIT_CLONE_DIR
		} else {
				echo $env.CLONE_OUTPUT
				return $env.LAST_EXIT_CODE
		}

	} else if ("$PROJECTS_DIR/$name" | path exists) {
		cd "$PROJECTS_DIR/$name"
	} else {
		echo "No project named" $name "was found."
		return 0
	}
}
