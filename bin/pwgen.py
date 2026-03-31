#!/usr/bin/env python

import random
import string

pw = ''.join(random.sample(list(set(string.printable) - set(string.whitespace)), 32))
print(pw)
