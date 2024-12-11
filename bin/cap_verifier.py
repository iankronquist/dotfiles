#!/usr/bin/env python3

'''
Verifies bitfields in capability headers are not contradictory.
Currently just parses #defines with regexes
'''

import re

CAP_FIELD_REGEX = '#define\s+CAP_FIELD_(\w+)_(\w+)\s(\w+)'

OBJ_SIZE_MIN_BITS = 4
CAP_SIZE_BITS = 5
CAP_FIELD_TYPE_WORD = 0
CAP_FIELD_TYPE_BASE = 58
CAP_FIELD_TYPE_BITS = 6
CAP_FIELD_TYPE_SHIFT = 0
CAP_FIELD_FTID_WORD = 0
CAP_FIELD_FTID_BASE = 56
CAP_FIELD_FTID_BITS = 2
CAP_FIELD_FTID_SHIFT = 0
CAP_FIELD_OBJECT_WORD = 0
CAP_FIELD_OBJECT_BASE = 0
CAP_FIELD_OBJECT_BITS = 28
CAP_FIELD_OBJECT_SHIFT = OBJ_SIZE_MIN_BITS
CAP_FIELD_CDT_L_WORD = 2
CAP_FIELD_CDT_L_BASE = 0
CAP_FIELD_CDT_L_BITS = 27
CAP_FIELD_CDT_L_SHIFT = CAP_SIZE_BITS
CAP_FIELD_CDT_H_WORD = 3
CAP_FIELD_CDT_H_BASE = 55
CAP_FIELD_CDT_H_BITS = 1
CAP_FIELD_CDT_H_SHIFT = 0
CAP_FIELD_CDT_P_WORD = 3
CAP_FIELD_CDT_P_BASE = 28
CAP_FIELD_CDT_P_BITS = 27
CAP_FIELD_CDT_P_SHIFT = CAP_SIZE_BITS
CAP_FIELD_CDT_T_WORD = 3
CAP_FIELD_CDT_T_BASE = 27
CAP_FIELD_CDT_T_BITS = 1
CAP_FIELD_CDT_T_SHIFT = 0
CAP_FIELD_CDT_N_WORD = 3
CAP_FIELD_CDT_N_BASE = 0
CAP_FIELD_CDT_N_BITS = 27
CAP_FIELD_CDT_N_SHIFT = CAP_SIZE_BITS

DEFAULT_SPANS = [
{
    'name': 'type',
'WORD': CAP_FIELD_TYPE_WORD,
'BASE': CAP_FIELD_TYPE_BASE,
'BITS': CAP_FIELD_TYPE_BITS,
},
{
    'name': 'ftid',
'WORD': CAP_FIELD_FTID_WORD,
'BASE': CAP_FIELD_FTID_BASE,
'BITS': CAP_FIELD_FTID_BITS,
},
#{
#    'name': 'object',
#'WORD': CAP_FIELD_OBJECT_WORD,
#'BASE': CAP_FIELD_OBJECT_BASE,
#'BITS': CAP_FIELD_OBJECT_BITS,
#},

{
    'name': 'cdt_l',
'WORD': CAP_FIELD_CDT_L_WORD,
'BASE': CAP_FIELD_CDT_L_BASE,
'BITS': CAP_FIELD_CDT_L_BITS,
},
{
    'name': 'cdt_h',
'WORD': CAP_FIELD_CDT_H_WORD,
'BASE': CAP_FIELD_CDT_H_BASE,
'BITS': CAP_FIELD_CDT_H_BITS,
},
{
    'name': 'cdt_p',
'WORD': CAP_FIELD_CDT_P_WORD,
'BASE': CAP_FIELD_CDT_P_BASE,
'BITS': CAP_FIELD_CDT_P_BITS,
},
{
    'name': 'cdt_t',
'WORD': CAP_FIELD_CDT_T_WORD,
'BASE': CAP_FIELD_CDT_T_BASE,
'BITS': CAP_FIELD_CDT_T_BITS,
},
{
    'name': 'cdt_n',
'WORD': CAP_FIELD_CDT_N_WORD,
'BASE': CAP_FIELD_CDT_N_BASE,
'BITS': CAP_FIELD_CDT_N_BITS,
},
]


WORD_BITS = 64
PRE_DEFINES = {
        'OBJ_SIZE_MIN_BITS': 4,
        'WORD_BITS': 64,
        'CAP_SIZE_BITS': 5,
        'FTABLE_FRAME_SIZE_BITS': 14,
        'PAGE_SIZE_BITS': 14,
        'CAP_FIELD_ARM64_SPACE_PERM_BITS': 2,
        'CAP_FIELD_ARM32_SPACE_PERM_BITS': 2,

        }

FILTER_CAPS = set([
'ARM64_SPACE_TABLE',
'ARM32_SPACE_TABLE',
'ARCH_SPACE_PERM',
'PLAT_DART_TABLE',
        ])


class Span:
    def __init__(self, name, thing):
        #print(name, thing)
        word = thing['WORD']
        base = thing['BASE']
        bits = thing['BITS']
        #shift = thing['SHIFT']
        self.name = name
        self.begin = word * WORD_BITS + base
        assert(bits > 0)
        self.end = self.begin + bits - 1
        #assert(bits + base < WORD_BITS)

    def _index_intersects(self, index):
        return self.begin <= index and index <= self.end

    def intersects_with(self, other):
        if other.name and self.name != other.name:
            return False
        return self._index_intersects(other.begin) or self._index_intersects(other.end)

def verify_cap_header(cap_header_file_name):
    fields = dict()
    # First, gather matches
    #print(cap_header_file_name)
    with open(cap_header_file_name, 'r') as cap_header_file:
        for line in cap_header_file.readlines():
            found = re.match(CAP_FIELD_REGEX, line)
            if not found:
                continue
            (obj_field, kind, where) = found.groups()
            if where in PRE_DEFINES.keys():
                where = PRE_DEFINES[where]
            else:
                where = int(where, 0)
            if not fields.get(obj_field):
                fields[obj_field] = dict()
            if fields[obj_field].get(kind):
                print('Warning: duplicate field for', obj_field, 'of', kind, 'choosing the largest one')
                print('in', cap_header_file_name)
                print('field sizes are:', 'old', fields[obj_field][kind], 'new', where)
                fields[obj_field][kind] = max(where,fields[obj_field][kind])
            else:
                fields[obj_field][kind] = where
    spans = [Span(thing['name'], thing) for thing in DEFAULT_SPANS]
    for (name, field) in fields.items():

        if name in FILTER_CAPS:
            continue
        spans.append(Span(name, field))
    for span in spans:
        for other in spans:
            if span == other:
                continue
            if span.intersects_with(other) and other.name:
                print(cap_header_file_name)
                print(span.name, 'intersects with', other.name)
                print(span.name, span.begin, span.end)
                print(other.name or 'Generic', other.begin, other.end)
    print([span.name for span in spans])


if __name__ == '__main__':
    import sys
    for file_name in sys.argv[1:]:
        verify_cap_header(file_name)
    print('[Done]')
