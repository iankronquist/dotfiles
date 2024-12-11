#!/usr/bin/env python3

'''
I use python as my calculator. Set up useful aliases etc.
'''

kb=1024
mb=1024*kb
gb=1024*mb
tb=1024*gb
page=0x1000
locals_iter = locals().copy().items()


def dec(c):
    return str(c)
import sys
def _displayhook(o):
    if type(o).__name__ in ('int', 'long'):
        print(hex(o))
        __builtins__._ = o
    else:
        sys.__displayhook__(o)
sys.displayhook = _displayhook


for (name, value) in locals_iter:
    if name.startswith('_'):
        continue
    print(name, (value))

import code
code.interact(local=locals())
