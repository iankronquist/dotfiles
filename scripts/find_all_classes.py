import sys
import elftools
from macholib.MachO import MachO
from macholib.mach_o import LC_SEGMENT_64, LC_SEGMENT
from io import BytesIO

# Function to extract a specific section from a Mach-O segment
def extract_section_data(cmd, section_name):
    for section in cmd[2]:
        if section.sectname.strip(b'\x00').decode('utf-8') == section_name:
            # Seek to the file offset of the section and read its content
            return section.section_data
    return None

# Function to locate the __DWARF segment and extract DWARF sections
def extract_dwarf_sections(macho):
    dwarf_sections = {}
    for header in macho.headers:
        for cmd in header.commands:
            if cmd[0].cmd in (LC_SEGMENT_64, LC_SEGMENT):
                segment = cmd[1]
                segname = segment.segname.strip(b'\x00').decode('utf-8')
                if segname == '__DWARF':
                    #sections = [section.sectname.strip(b'\x00') for section in cmd[2]]
                    for section in cmd[2]:
                        if b'debug' in section.sectname:
                            name = section.sectname.strip(b'\x00')
                            dwarf_sections[name] = BytesIO(section.section_data)
                    #print(sections)
                    ## Extract all relevant DWARF sections
                    #dwarf_sections['.debug_info'] = extract_section_data(cmd, '__debug_info')
                    #dwarf_sections['.debug_abbrev'] = extract_section_data(cmd, '__debug_abbrev')
                    #dwarf_sections['.debug_line'] = extract_section_data(cmd, '__debug_line')
                    #dwarf_sections['.debug_str'] = extract_section_data(cmd, '__debug_str')
    return dwarf_sections

# Load the Mach-O file
macho_file_path = sys.argv[1]
macho = MachO(macho_file_path)

# Extract DWARF sections
debug_sections = dwarf_sections = extract_dwarf_sections(macho)

# Check the extracted sections
for section_name, section_data in dwarf_sections.items():
    if section_data:
        print(f"Extracted {section_name} section, size: {len(section_data)} bytes")
        print(f"Extracted {section_name} section, size: {len(section_data)} bytes")
    else:
        print(f"{section_name} section not found or empty")

from elftools import dwarf

from elftools.dwarf.dwarfinfo import DWARFInfo, DwarfConfig

dwarf_info = dwarfinfo = DWARFInfo(
                config=DwarfConfig(little_endian=True, machine_arch='AArch64', default_address_size=8),
                    #little_endian=self.little_endian,
                    #default_address_size=self.elfclass // 8,
                    #machine_arch=self.get_machine_arch()),
                debug_line_sec=debug_sections[b'__debug_line'],
                debug_aranges_sec=debug_sections[b'__debug_aranges'],
                debug_loc_sec=debug_sections[b'__debug_loc'],
                debug_info_sec=debug_sections[b'__debug_info'],
                debug_frame_sec=debug_sections[b'__debug_frame'],
                debug_ranges_sec=debug_sections[b'__debug_ranges'],
                debug_abbrev_sec=debug_sections[b'__debug_abbrev'],
                debug_str_sec=debug_sections[b'__debug_str'],
                eh_frame_sec=None,
                debug_pubtypes_sec=None,
                debug_pubnames_sec=None,
                debug_addr_sec=None,
                debug_str_offsets_sec=None,
                debug_line_str_sec=None,
                debug_loclists_sec=None,
                debug_rnglists_sec=None,
                debug_sup_sec=None,
                gnu_debugaltlink_sec=None,
                #gnu_debuglink_sec=None
                )
def iterate_dies_by_tag(dwarf_info, tag):
    # Iterate over Compilation Units (CUs) in the DWARF info
    for CU in dwarf_info.iter_CUs():
        # Iterate over DIEs in the CU
        for DIE in CU.iter_DIEs():
            # Filter by the tag
            if DIE.tag == tag:
                print(f"Found {tag}:")
                print(describe_DIE(DIE))
                # Access attributes if needed
                for attr_name, attr_value in DIE.attributes.items():
                    print(f'    {attr_name}: {attr_value}')

iterate_dies_by_tag(dwarf_info, 'DW_TAG_subprogram')

import pdb;pdb.set_trace()


