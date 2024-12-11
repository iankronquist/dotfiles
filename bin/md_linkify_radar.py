#!/usr/bin/env python3

import sys
import re

fname = sys.argv[1]
if not fname.endswith('.md'):
    exit(-1)

with open(fname, 'r') as f:
    content = f.read()
    fixed = re.sub(r'(rdar://[\w/]+)', '[\\1](\\1)', content)
    if content != fixed:
        f.write(fixed)
