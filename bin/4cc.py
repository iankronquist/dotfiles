#!/usr/bin/env python3

import sys

for arg in sys.argv[1:]:
    n = int(arg, 0)
    if n > 2**32:
        print(f'{n}\tis too big for a 4cc code')
        continue
    code = ''
    iter = n
    while iter > 0:
        code += chr(iter & 0xff)
        iter >>= 8
    code = code[::-1]
    print(f'{hex(n)}\t{code}')

