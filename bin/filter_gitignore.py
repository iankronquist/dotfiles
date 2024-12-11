#!/usr/bin/env python3
import shlex
import subprocess
import os
import sys
import fnmatch
from typing import Set

def cmd(cmd: str) -> subprocess.CompletedProcess:
    args = shlex.split(cmd)
    return subprocess.run(args, capture_output=True)
    
def filter_files(files: [str], ignore_file_name:str) -> Set[str]:
    try:
        files = map(os.path.normpath, files)
        files = set(files)
        with open(ignore_file_name) as gitignore:
            for ignore_line in gitignore.readlines():
                # According to man gitignore:
                # •   If there is a separator at the beginning or middle (or both) of the
                #     pattern, then the pattern is relative to the directory level of the
                #     particular .gitignore file itself. Otherwise the pattern may also
                #     match at any level below the .gitignore level.
                # I'm not quite sure how to turn that into a filter rule, so a hack for now
                # if '/' in ignore_line[:-1]:
                #     ignore_line = os.path.join(os.path.dirname(os.path.realpath(ignore_file_name)), ignore_line)

                # HACK
                if ignore_line and ignore_line[0] == '/':
                    ignore_line[1:]
                files_to_ignore = fnmatch.filter(files, ignore_line.strip())
                files -= set(files_to_ignore)
    except FileNotFoundError as e:
        pass
    return files

# Get the list of files from the command line, excluding the script name
files = sys.argv[1:] if len(sys.argv) > 0 else []

# Try to get root of git repo.
git_root_result = cmd('git rev-parse --show-toplevel')
# If we are in a git repo...
if git_root_result.returncode == 0:
    # The git root should be on stdout, convert it to something usable
    git_root = (git_root_result.stdout.decode('utf-8') or '').strip()
    # Open the .gitignore file if it exists and filter out the files
    files = filter_files(files, os.path.join(git_root, '.gitignore'))


# Filter from global gitignore
# Technically this is configured from the global git config, but I will hard
# code this to match my setup.
files = filter_files(files, os.path.expanduser('~/.gitignore'))

# Display output
print(' '.join(files))
