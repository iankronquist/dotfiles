#!/usr/bin/env python3

import sys

def unhex_string(string):
    return ''.join([chr(int(string[i*2:i*2+2],16)) for i in range(len(string)//2)])

if __name__ == '__main__':
    for arg in sys.argv[1:]:
        if not arg:
            continue
        if arg.startswith('0x'):
            arg = arg[2:]
        print(unhex_string(arg))
