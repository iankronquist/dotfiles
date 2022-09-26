#!/usr/bin/env python3
import sys
import math

for arg in sys.argv[1:]:
    n = int(arg, 16)
    print(hex(n))
    print('max is', int(math.log(n, 2)))
    for bit in range(0, int(math.log(n, 2))+1):
        if (n & (1 << bit)) != 0:
            print(bit, "is set")

