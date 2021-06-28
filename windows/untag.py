import sys
import string


def is_hex_string(s):
    # Is the set of actual characters - set of allowed characters == empty set?
    return set(s) - set(string.hexdigits + 'xX') == set()

def num_string_to_tag(s):
    tag = ''
    if s.startswith('0x') or s.startswith('0X'):
        s = s[2:]
    for pair in list(zip(s,s[1:]))[::2]: # iterate pairwise
        # Convert the pair to a base 16 int, and then convert it to a character and add it to the tag
        tag += chr(int(pair[0] + pair[1], 16))
    tag = tag[::-1] # reverse
    return tag

def main(argv):
    if len(argv) != 2 or not is_hex_string(argv[1]):
        print("usage: ", argv[0], "HEXNUMBER")
        return -1
    s = argv[1]
    tag = num_string_to_tag(s)
    print(tag)
    return 0

if __name__ == '__main__':
    exit(main(sys.argv))