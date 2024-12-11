#!/usr/bin/env python3
import subprocess
import re
import os
import json
import urllib.parse
import find_symbols


def get_git_url():
    cmd = ['git', 'remote', 'get-url', '--push', 'origin']
    result = subprocess.run(cmd, stdout=subprocess.PIPE)
    return result.stdout.decode("utf-8")

def get_git_describe():
    cmd = ['git', 'describe']
    result = subprocess.run(cmd, stdout=subprocess.PIPE)
    return result.stdout.decode("utf-8").strip()



def get_git_head():
    #cmd = ['git', 'symbolic-ref', 'HEAD']
    cmd = ['git', 'rev-parse', '--short', 'HEAD']
    result = subprocess.run(cmd, stdout=subprocess.PIPE)
    return result.stdout.decode("utf-8").strip()

def get_path_to_repo_root():
    cmd = ['git', 'rev-parse', '--show-prefix']
    result = subprocess.run(cmd, stdout=subprocess.PIPE)
    path = result.stdout.decode("utf-8").strip()
    #root = os.path.basename(path)
    #return root
    return path

def get_path_to_toplevel():
    cmd = ['git', 'rev-parse', '--show-toplevel']
    result = subprocess.run(cmd, stdout=subprocess.PIPE)
    path = result.stdout.decode("utf-8").strip()
    root = os.path.basename(path)
    if not root:
        import pdb;pdb.set_trace()
    return root



def rewrite_url(url):
    # Won't work for http remotes, but I don't deal with those at work.
    match = re.match(r'ssh://git@(.*)/(.*)/([a-zA-Z0-9]*)(\.git)?', url)
    if not match:
        return url
    groups = match.groups()
    host = groups[0]
    org = groups[1]
    repo = groups[2]
    # This replacement is stash specific. I should do something different for github pie
    return f'https://{host}/projects/{org}/repos/{repo}/browse'


def markdown(repo_root, file_name, url, symbol_info, line):
    description = get_git_describe()
    if symbol_info:
        return f'[Git tag: {description} {symbol_info}]({url})'
    else:
        line_txt = ''
        if line:
            line_txt = ' line {line}'
        return f'[Git tag: {description} file {file_name}{line_txt}]({url})'

def html(repo_root, file_name, url, line, symbol_info):
    description = get_git_describe()
    if symbol_info:
        return f'<a href="{url}">Git tag: {description} {symbol_info}</a>'
    else:
        line = ':' + str(line) if line else ''
        return f'<a href="{url}">{symbol_info} Git tag: {description} {file_name}{line}</a>'

def summary(repo_root, file_name, url, line, symbol_info):
    description = get_git_describe()
    if symbol_info:
        symbol_info += ' '
    return f'{symbol_info}Git tag: {description}\n{url}'

def read_file_range(file_name, selection_start, selection_end, declaration_line=None):
    selection_start = json.loads(args.selection_start)
    selection_end = json.loads(args.selection_end)
    selection_end_number = int(selection_end[1])
    selection_start_number = int(selection_start[1])
    if selection_end_number >= selection_start_number:
        with open(file_name) as f:
            lines = f.readlines()
            declaration = ''
            if declaration_line is not None and declaration_line != selection_start_number-1:
                declaration = lines[declaration_line]
            fence_suffix = ''
            _file_name_base, file_name_extension = os.path.splitext(file_name)
            if file_name_extension:
                fence_suffix = file_name_extension[1:]

            #import pdb;pdb.set_trace()
            txt = ('```' + fence_suffix + '\n')
            if declaration:
                txt += declaration + '...\n'
            txt += '\t' + ('\t'.join(lines[selection_start_number-1:selection_end_number-1+1]))
            txt += ('```\n')
            return txt

def find_file(start_dir, file_name):
    home_dir = os.path.expanduser('~')
    current_dir = os.path.abspath(start_dir)

    while True:
        tags_path = os.path.join(current_dir, file_name)
        if os.path.isfile(tags_path):
            return tags_path
        if current_dir == home_dir or current_dir == '/':
            break
        current_dir = os.path.dirname(current_dir)

    return None
if __name__ == '__main__':
    import argparse
    parser = argparse.ArgumentParser(description='Generate a stash link for a specific file and line.')
    parser.add_argument('file_name', nargs='?', type=str, help='The name of the file')
    parser.add_argument('line_number', nargs='?', type=int, help='The line number')
    parser.add_argument('--selection_start', type=str, help='Start of visual selection')
    parser.add_argument('--selection_end', type=str, help='End of visual selection')
    parser.add_argument('--markdown', action='store_true', help='Output in markdown format')
    parser.add_argument('--html', action='store_true', help='Output in html format')
    parser.add_argument('--summary', action='store_true', help='Output in plain text summary format')
    parser.add_argument('--ctags-db', nargs='?', type=str, default=None, help='ctags db')
    args = parser.parse_args()

    file_name = args.file_name
    line = args.line_number
    url = get_git_url()
    url = rewrite_url(url)
    if file_name:
        repo_root = get_path_to_repo_root()
        #if repo_root:
        #    relpath = os.path.relpath(repo_root, file_name)
        url += '/' + repo_root + file_name
    repo_name = get_path_to_toplevel()
    # Put the branch into the url
    encoded = urllib.parse.quote(get_git_head())
    url += '?at=' + encoded
    ctags_db = args.ctags_db or find_file('.', 'tags')
    if line:
        url += '#' + str(line)
    try:
        symbol_info = find_symbols.find_symbols(ctags_db, args.file_name, args.line_number, verbose=False, filter_symbol_types=True)
        symbol_info_formatted = find_symbols.format_symbol(symbol_info)
    except Exception:
        symbol_info = {}
        symbol_info_formatted = ''
    # Apparently slack doesn't support markdown links by default, which is unfortunate
    if file_name and args.markdown:
        url = markdown(repo_name, file_name, url, symbol_info_formatted , line)
    elif file_name and args.html:
        url = html(repo_name, file_name, url, line, symbol_info_formatted)
    elif args.summary:
        url = summary(repo_name, file_name, url, line, symbol_info_formatted)
    print(url)
    if file_name and args.selection_start and args.selection_end:
        if symbol_info is not None:
            line = symbol_info.get('symbol_line')
        else:
            line = args.line_number
        txt = read_file_range(file_name, args.selection_start, args.selection_end, line)
        if txt:
            print(txt)

