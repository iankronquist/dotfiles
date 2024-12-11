#!/usr/bin/env python

import random
import string

pw = ''.join(random.sample(string.printable, 32))
print(pw)
