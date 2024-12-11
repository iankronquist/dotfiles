#!/usr/bin/env python3
import argparse

def reformat_path(path, unixify=False, windowsify=False, wslify=False, urlify=False, unescape=False):
    if unixify:
        path = path.replace("\\", "/")
    elif windowsify:
        path = path.replace("/", "\\")
    elif wslify:
        # FIXME should work for drives other than C:
        path = path.replace("C:", "")
        path = path.replace("\\", "/")
        path = "/mnt/c" + path
    elif urlify:
        path = path.replace("\\", "%2F")
        # FIXME should I use a different escape code for actual forward slashes?
        path = path.replace("/", "%2F")
    elif unescape:
        path = path.replace("\\\\", "\\")
        path = path.replace("\\/", "/")
    else:
        path = path.replace("\\", "\\\\")
    return path

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description='Naively reformats path separators.')
    parser.add_argument('path', type=str, help='The path to escape.')
    parser.add_argument('-u', '--unixify', action='store_true', help='Format as a unix-style path.')
    parser.add_argument('-w', '--windowsify', action='store_true', help='Format as a windows-style path.')
    parser.add_argument('-s', '--wslify', action='store_true', help='Format as a WSL-style path.')
    parser.add_argument('-r', '--urlify', action='store_true', help='Format as a URL-encoded path.')
    parser.add_argument('-e', '--unescape', action='store_true', help='Unescape the path.')

    args = parser.parse_args()

    formatted_path = reformat_path(args.path, args.unixify, args.windowsify, args.wslify, args.urlify, args.unescape)
    print(formatted_path)
