import re
import sys

'''
Find which DLL a given address belongs to
Usage:
in windbg run:
> .logopen foo.txt
> !dlls
> .logopen foo.txt

Then run:
python dlls.py /path/to/foo.txt 0x7ffdbeef
'''

addr_re = '0x[0-9a-fA-F]+'
def group(x):
	return '(' + x + ')'
# HACK: This path regex is very crude
#path_re = '[\w\.:\\\d]+'
path_re = '.+'
dll_re = group(addr_re) + ':\s+' + group(path_re)


info_re = '\s+Base\s+' + group(addr_re) + '\s+EntryPoint\s+' + group(addr_re) + '\s+Size\s+' + group(addr_re) + '\s+DdagNode\s+' + group(addr_re)
dll_file = sys.argv[1]
addr = int(sys.argv[2], 16)

dlls = {}

this_file = ''

with open(dll_file, 'r') as f:
	for line in f.readlines():
		m = re.match(dll_re, line)
		if m:
			g = m.groups()
			this_file = g[1]
			continue
		
		m = re.match(info_re, line)
		if m:
			assert this_file not in dlls
			assert this_file != ''
			g = m.groups()
			dlls[this_file] = {
				'Base': int(g[0], 16),
				'EntryPoint': int(g[1], 16),
				'Size': int(g[2], 16),
			}
			this_file = ''
			continue

for k,v in dlls.items():
	if v['Base'] <= addr <= v['Base'] + v['Size']:
		print hex(addr), 'is in', k
		print v
