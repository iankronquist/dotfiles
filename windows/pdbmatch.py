import ctypes
import sys

PE_SIG = 0x5a4d



def help(name):
    sys.stderr.write('{} <exe> <pdb>\n'.format(name))


def main():
    if len(sys.argv) != 3:
        help(sys.argv[0])
        exit(-1)

if __name__ == '__main__':
        main()
