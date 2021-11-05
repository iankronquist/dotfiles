import sys

s = sys.argv[1]

s = s.replace(' ', '')

# Should this swizzle dwords?
print(''.join(map(lambda x: chr(int(x, 16)), [s[i:i+2] for i in range(0, len(s),2)])))

