#!/usr/bin/env python3
import shlex
import subprocess
import os
import sys
#import fnmatch
import argparse
#from typing import Set

def cmd(cmd: str) -> subprocess.CompletedProcess:
    args = shlex.split(cmd)
    return subprocess.run(args, capture_output=True)


def clang_paths(args=None):
    if args:
        sdk = args.sdk
    else:
        sdk = os.environ.get('XCODE_SDK') or 'iphoneos.internal'
    sdk_arg = f'-sdk {sdk}'
    result = cmd(f'xcrun {sdk_arg} clang -x c -c -### /dev/null')

    if result.returncode != 0:
        sys.stderr.write(result.stderr.decode('utf8'))
        sys.stdout.write(result.stdout.decode('utf8'))
        exit(result.returncode)

    headers = set()
    add_next_arg = False

    include_flags = set(['-internal-externc-isystem', '-internal-isystem', '-I', '-isysroot'])
    for arg in result.stderr.decode('utf8').split():
        arg = arg.replace('"', '')
        if add_next_arg:
            headers.add(arg)
            add_next_arg = False
        elif arg in include_flags:
            add_next_arg = True
        elif arg.startswith('-I'):
            headers.add(arg[2:])
    return headers

if __name__ == '__main__':
    parser = argparse.ArgumentParser(description="get sdk path")
    parser.add_argument("-I", help="print output with c compiler style '-I' before every argument", action="store_true")
    parser.add_argument("-sdk", help="specify sdk", nargs='?', default='iphoneos.internal')
    args = parser.parse_args()
    headers = clang_paths(args)

    separator = ' -I ' if args.I else '\n'
    print(separator.join(headers))

