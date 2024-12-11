#!/usr/bin/env python3

import re
import os
import json
import sys
import argparse
import subprocess

import clang_path

def is_git_ignored(path):
    if '.git' in path:
        return True
    cmd = subprocess.run(['git', 'check-ignore', '-q', path])
    assert (cmd.returncode == 1 or cmd.returncode == 0)
    return cmd.returncode == 0


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

INCLUDE_FOLDER_NAMES = set([
    'include',
    'Headers',
    ])


def find_include_folders(path, find_all):
    found = set()
    for root, directories, _ in os.walk(path):
        for directory in directories:
            if find_all or directory in INCLUDE_FOLDER_NAMES:
                found.add(os.path.join(root, directory))
        # dirset = { directory.lower() for directory in directories }
        # intersection = dirset.intersection(INCLUDE_FOLDER_NAMES)
        # if intersection:
        #     found.update(intersection)
    return found

def find_tighbeam(path, derived_data):
    tightbeams = set()
    for root, _directories, files in os.walk(path):
        for file in files:
            if file.endswith('.tightbeam'):
                tightbeams.add(os.path.join(root, file))

    modules = set()
    for file in tightbeams:
        with open(file, 'r') as f:
            for line in f.readlines():
                matched = re.match(r'module\s*(\w)+', line)
                if matched:
                    modules.add(matched.groups()[0])

    generated = set()
    for root, _directories, files in os.walk(derived_data):
        for file in files:
            for module in modules:
                if file.startswith(module):
                    compiler = source_file_to_compiler(os.path.join(root, file))
                    if compiler:
                        generated.add(file)
    return generated

def insert_before_each_element(insertion, list):
    new_list = []
    for element in list:
        new_list += [insertion, element]
    return new_list

def create_compile_commands(path, gitignore, subdirs, clang_c_headers, clang_cpp_headers, ccargs):
    commands = []
    clang_cpp_headers = insert_before_each_element(' -I ', clang_cpp_headers)
    clang_c_headers = insert_before_each_element(' -I ', clang_c_headers)
    for root, dirs, files in os.walk(path):
        if gitignore:
            dirs[:] = [d for d in dirs if not is_git_ignored(os.path.join(root, d))]
        if subdirs is not None:
            subdirs.extend([os.path.join(root, d) for d in dirs])
        for file in files:
            compiler = source_file_to_compiler(file)
            if not compiler:
                continue
            file_path = os.path.join(root, file)
            if gitignore and is_git_ignored(file_path):
                continue
            root_args = ['-I', root]
            output = os.path.join('/tmp/bs/', file_path)
            if file_path.endswith('.c'):
                headers = clang_c_headers
            else:
                headers = clang_cpp_headers
            command = {
                "directory": os.path.realpath('.'),
                "arguments": (compiler + headers + ccargs + root_args + [file_path, '-o', output]),
                "file": file_path,
                'output': output,
            }
            commands.append(command)
    return commands

def write_compile_commands(args, path, commands, clang_headers, clang_cpp_headers):
    compile_commands_path = os.path.join(path, 'compile_commands.json')
    with open(compile_commands_path, 'w') as f:
        json.dump(commands, f, indent=2)
    with open('generate_compile_commands.txt', 'w') as f:
        f.write('command:\n' + ' '.join(args) + '\n')
        f.write('detected C headers:\n' + '\n'.join(clang_headers) + '\n')
        f.write('detected C++ headers:\n' + '\n'.join(clang_cpp_headers) + '\n')

def main(argv):
    parser = argparse.ArgumentParser(description='Search for files and folders.')

    parser.add_argument('--path', nargs='?', default='.', type=str, help='The path to search')

    parser.add_argument('--search-for-tightbeams', action='store_true', help='search for generated tightbeam files')
    parser.add_argument('--guess-include-folders', action='store_true', 
                        help='If a folder is named include, add it to the include path')


    parser.add_argument('--gitignore', action='store_true', 
                        help='Filter out files ignored by git')

    parser.add_argument('--include-all-subdirs', action='store_true', 
                        help='Add all subdirs to include path')

    #parser.add_argument('--exclude', action='append', help='Exclude directories')
    parser.add_argument('-sdk', nargs='?', default=None, help='SDK override')


    parser.add_argument('extra_args', nargs=argparse.REMAINDER, 
                        help='Additional arguments after --')


    args = parser.parse_args()

    headers = set()

    if args.guess_include_folders or args.include_all_subdirs:
        headers.update(find_include_folders(args.path, args.include_all_subdirs))


    #excludes = set(map(os.path.normpath, args.exclude)) if args.exclude else set()

    #path_index = argv.index('--') if '--' in argv else len(argv)
    path = args.path #argv[1] if len(argv) > 1 else '.'
    cc_args = args.extra_args #argv[path_index + 1:]
    if cc_args:
        cc_args.remove('--')
    clang_c_headers = clang_path.clang_paths(args.sdk, None, language='c')
    clang_cpp_headers = clang_path.clang_paths(args.sdk, None, language='c++')
    #headers.update(clang_headers)
    #if excludes:
    #    cleaned_headers = set()
    #    for exclude in excludes:
    #        for header in headers:
    #            if not os.path.normpath(header).startswith(exclude):
    #                cleaned_headers.add(header)
    #    headers = cleaned_headers


    #other_headers = headers - excludes
    #for header in headers:
    #    if header not in cc_args:
    #        cc_args += ['-I', header]

    #subdirs = [] if args.include_all_subdirs else None
    commands = create_compile_commands(path, args.gitignore, None, clang_c_headers, clang_cpp_headers, cc_args)

    write_compile_commands(argv, path, commands, clang_c_headers, clang_cpp_headers)
    return 0

if __name__ == "__main__":
    sys.exit(main(sys.argv))
