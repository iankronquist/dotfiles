#!/usr/bin/env python3
import sys
import math
import argparse

parser = argparse.ArgumentParser(description='Process some integers.')
parser.add_argument('integers', metavar='N', type=lambda x: int(x, 0), nargs='+',
                    help='an integer for the accumulator')
parser.add_argument('--width', type=int)
parser.add_argument('--set', action='store_true',)
parser.add_argument('--clear', action='store_true',)
args = parser.parse_args()
print(args)

show_set = args.set or (not args.clear)
show_clear = args.clear

for n in args.integers:
    print(hex(n))
    maximum = int(math.log(n, 2))
    print('max is', maximum)
    iterate_until = args.width or (maximum + 1)
    for bit in range(0, iterate_until):
        bit_is_set = (n & (1 << bit)) != 0
        if bit_is_set and show_set:
            print(bit, "\tis set")
        if not bit_is_set and show_clear:
            print(bit, "\tis clear")

