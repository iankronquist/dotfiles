#!/usr/bin/env python3
import sys
from macholib.MachO import MachO
from macholib.mach_o import segment_command_64, section_64

def parse_macho(filename):
    try:
        macho = MachO(filename)
    except Exception as e:
        print(f"Error opening Mach-O file: {e}")
        return

    for header in macho.headers:
        for command in header.commands:
            print(len(command))
            load_cmd, cmd, data = command
            if isinstance(cmd, segment_command_64) and cmd.segname.decode('utf-8').startswith('__TEXT'):
                parse_segment(header, cmd, data)
                break

def parse_segment(header, segment, data):
    num_sections = segment.nsects
    offset = 0

    print(num_sections)
    print(data)
    for section in data:
        print(section.sectname)
        parse_section(header, section)
    #for _ in range(num_sections):
    #    section = section_64.from_fileobj(data, _endian_=header.endian)
    #    if section.sectname.decode('utf-8').strip() == '__text':
    #        print(f"Found __text section at offset {section.offset}")
    #        parse_section(header, section)
    #    offset += sizeof(section_64)

def parse_section(header, section):
    data = (section.section_data)
    addr = section.addr

    for i in range(0, len(data), 4):
        word = data[i:i+4]
        if len(word) < 4:
            word += b'\x00' * (4 - len(word))  # Padding if the last word is incomplete
        hex_word = word.hex()
        print(f"0x{addr + i:08x}: {hex_word}")

if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("Usage: python script.py <macho_filename>")
        sys.exit(1)

    macho_filename = sys.argv[1]
    parse_macho(macho_filename)

