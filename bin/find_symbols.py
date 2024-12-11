#!/usr/bin/env python3
import os
import re
import sys

def list_get(list, index):
    if len(list) <= index:
        return None
    return list[index]

# See man 5 tags
def symbol_type_to_name(symbol_type):
    return {
            'p': 'function prototype',
            'e': 'enum value',
            'g': 'enumeration name',
            'c': 'class',
            'f': 'function',
            'd': 'macro definition',
            'm': 'member',
            's': 'struct',
            't': 'type definition',
            'u': 'union',
            'v': 'variable',
            'F': 'file name',
            }.get(symbol_type[0]) or ' symbol '

def is_interesting(symbol_type):
    return symbol_type[0] in { 'p', 'e', 'f', 'c', 'd', 's', 'u' }


def format_symbol(symbol):
    if not symbol:
        return ''

    symbol_name = symbol['symbol']
    symbol_type_name = symbol['symbol_type_name']
    requested_file_path = symbol['requested_file_path']
    requested_line = symbol['requested_line']
    container = symbol['container']
    return (f'{symbol_type_name} {symbol_name} at {requested_file_path}:{requested_line} {container}')


def find_symbols(ctagdb, requested_file_path, requested_line, verbose=False, filter_symbol_types=True):
    ctagdb = open(ctagdb)
    entries = list()
    for line in ctagdb.readlines():
        if not line or line.startswith('!'):
            continue
        entry = tuple(line.split('\t'))
        path = entry[1]
        if os.path.exists(path) and os.path.samefile(path, requested_file_path):
            entries.append(entry)

    found = []
    with open(requested_file_path) as source_file:
        source_lines = source_file.readlines()
        for entry in entries:
            vim_regex = entry[2]
            symbol_type = list_get(entry, 3)
            if not (filter_symbol_types and symbol_type and is_interesting(symbol_type)):
                continue
            # Translate from vim regex to python regex
            # hax galore
            python_regex = re.sub(r'\/(.*)\/.*', r'\1', vim_regex)
            python_regex = re.escape(python_regex)
            python_regex = python_regex.replace('\\^', '^')
            python_regex = python_regex.replace('\\$', '')
            if not python_regex:
                import pdb;pdb.set_trace()
            for (line_number, line) in enumerate(source_lines):
                if re.match(python_regex, line):
                    found.append((line_number, entry))
                    break
    found.sort()
    if verbose:
        print(found)

    best = None
    for (index, (line_number, entry)) in enumerate(found):
        if line_number > requested_line:
            break
        best = index

    if best is not None:
        line_number, entry = found[best]
        symbol = entry[0]
        path = entry[1]
        _regex = entry[2]
        symbol_type = list_get(entry, 3)
        symbol_type_name = symbol_type_to_name(symbol_type)
        #container = list_get(entry, 5) or ''
        container = ''
        #return (f'{symbol_type_name} {symbol} at {requested_file_path}:{requested_line} {container}')
        return { 'symbol': symbol, 'symbol_type_name': symbol_type_name, 'symbol_line': line_number, 'requested_file_path': requested_file_path, 'requested_line': requested_line, 'container': container }
    else:
        return None

if __name__ == '__main__':
    import argparse
    parser = argparse.ArgumentParser(description='Find symbol closest before the given file and line')

    parser.add_argument('file', type=str, help='The file')
    parser.add_argument('line', type=int, help='The line number')

    # Optional arguments
    parser.add_argument('--ctags-db', type=str, help='Path to the ctags database file', default='tags')
    parser.add_argument('--verbose', action='store_true')
    args = parser.parse_args()
    result = find_symbols(args.ctags_db, args.file, args.line, args.verbose)
    print(format_symbol(result))

