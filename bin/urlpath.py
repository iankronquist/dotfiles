#!/usr/bin/env python3

# Written by chatgpt because I'm lazy

import argparse
import os
from urllib.parse import quote

def convert_to_url_path(file_path):
    return "file://" + quote(file_path)

def convert_to_markdown_link(file_path):
    url_path = convert_to_url_path(file_path)
    return f"[{os.path.basename(file_path)}]({url_path})"

def main():
    parser = argparse.ArgumentParser(description="Convert file path to URL or Markdown link")
    parser.add_argument("file_path", help="File path to convert")
    parser.add_argument("--markdown", action="store_true", help="Convert to Markdown link")
    args = parser.parse_args()

    if args.markdown:
        print(convert_to_markdown_link(args.file_path))
    else:
        print(convert_to_url_path(args.file_path))

if __name__ == "__main__":
    main()
