#!/usr/bin/env python3

import sys
import subprocess
import re


fileName = sys.argv[1]
lineNumber = sys.argv[2]

remotes = subprocess.check_output(['git', 'remote', '-v']).decode('ascii')

#REGEX='ssh://git@stash\.sd\.apple\.com/(\w+)/(\w+)(\.git)? \(fetch\)'
REGEX='.*stash\.sd\.apple\.com/(\w+)/(\w+)(\.git)? \(fetch\)'

match = re.match(REGEX, remotes)
if not match:
    print('uh oh', remotes)
    raise remotes
print(match.groups())
