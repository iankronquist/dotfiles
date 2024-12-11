#!/usr/bin/env python3
import re
import sys
import subprocess

immediate = sys.argv[1]
reg = sys.argv[2] if len(sys.argv) > 2 else None
program = f'''
long li(void);
long li(void) {{
    return {immediate} ;
}}
'''

command = 'clang -c -O2 -S -x c -Wall -Werror  - -o -'.split(' ')

cmd_result = subprocess.run(command, capture_output=True, text=True, input=program)

matches = re.search(r':$(.*)(?=\n\s*ret)', cmd_result.stdout, re.MULTILINE | re.DOTALL)
found = matches.groups()[0]
if reg:
    found = found.replace('x0', reg)
    found = found.replace('w0', reg)
print(found)



