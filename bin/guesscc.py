#!/usr/bin/env python3
import os
import json
import sys

import clang_path

def source_file_to_compiler(filename):
    base, ext = os.path.splitext(filename)
    c = ['clang', '-c']
    cpp = ['clang++', '-c']
    swift = ['swift',]
    return {
            '.c': c,
            '.m': c,
            '.cc': cpp,
            '.cpp': cpp,
            '.cxx': cpp,
            '.swift': swift,
            }.get(ext)

def create_compile_commands(path, args):
    commands = []
    for root, _, files in os.walk(path):
        for file in files:
            compiler = source_file_to_compiler(file)
            if not compiler:
                continue
            command = {
                "directory": os.path.dirname(file),
                "command": ' '.join(compiler + args + [file]),
                "file": file
            }
            commands.append(command)
    return commands

def write_compile_commands(args, path, commands, clang_headers):
    compile_commands_path = os.path.join(path, 'compile_commands.json')
    with open(compile_commands_path, 'w') as f:
        json.dump(commands, f, indent=2)
    with open('generate_compile_commands.txt', 'w') as f:
        f.write('command:\n' + ' '.join(args) + '\n')
        f.write('detected headers:\n' + '\n'.join(clang_headers) + '\n')

def main(argv):
    path_index = argv.index('--') if '--' in argv else len(argv)
    path = argv[1] if len(argv) > 1 else '.'
    cc_args = argv[path_index + 1:]
    clang_headers = clang_path.clang_paths()
    for header in clang_headers:
        if header not in cc_args:
            cc_args += ['-I', header]

    commands = create_compile_commands(path, cc_args)
    write_compile_commands(argv, path, commands, clang_headers)
    return 0

if __name__ == "__main__":
    sys.exit(main(sys.argv))
