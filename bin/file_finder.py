#!/usr/bin/env python3

import re
import subprocess
import argparse
import plistlib




parser = argparse.ArgumentParser(description='Find files used in executable')
parser.add_argument('macho', metavar='MACHO', type=str, help='The macho to search for')
args = parser.parse_args()

plist = subprocess.run(['dsymForUUID', args.macho], stdout=subprocess.PIPE)

got = plistlib.loads(plist.stdout)

REGEX=r'.*DW_AT_decl_file.*\("(.*)"\)'
files = set()
for uuid, info in got.items():
    bin_path = info['DBGDwarfBinaryPath']
    print('DBGDwarfBinaryPath', bin_path, uuid)
    dumped = subprocess.run(['dwarfdump', bin_path], stdout=subprocess.PIPE)
    for line in dumped.stdout.decode('utf8').split('\n'):
        match = re.match(REGEX, line)
        if match:
            file = match.groups()[0]
            files.add(file)
file_list = list(files)
file_list.sort()
print('\n'.join(file_list))
