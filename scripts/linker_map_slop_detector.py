import re
import sys

def parse_linker_map(file_path):
    # Regular expression to match lines with address, size, and symbol
    pattern = re.compile(r"^(0x[0-9a-fA-F]+)\s+(0x[0-9a-fA-F]+)\s+\[[\s\d]+\]\s+(.+)$")
    
    symbols = []
    
    with open(file_path, "r") as f:
        for line in f:
            match = pattern.match(line)
            if match:
                address = int(match.group(1), 16)
                size = int(match.group(2), 16)
                symbol_name = match.group(3).strip()
                end_address = address + size
                symbols.append((address, end_address, symbol_name))
    
    return symbols

from pprint import pprint
def find_slop_space(symbols):
    # Sort symbols by their start address
    symbols.sort(key=lambda x: x[0])
    #pprint(symbols)

    slop_spaces = []
    
    # Check for gaps between symbols
    for i in range(1, len(symbols)):
        current_symbol_end = symbols[i-1][1]
        next_symbol_start = symbols[i][0]
        
        if next_symbol_start > current_symbol_end:
            slop_spaces.append((current_symbol_end, next_symbol_start, next_symbol_start - current_symbol_end, symbols[i-1][2], symbols[i][2]))

    return slop_spaces

def main():
    file_path = sys.argv[1]
    symbols = parse_linker_map(file_path)
    slop_spaces = find_slop_space(symbols)
    
    slop_spaces.sort(key=lambda x: x[2])
    print(f"size\tstart\tend\tfirst sym\tsecond sym")
    for start, end, size, s0, s1 in slop_spaces:
        #print(f"Slop space found: Start = 0x{start:X}, End = 0x{end:X}, Size = {size} bytes between {s0} and {s1}")
        print(f"0x{size:x}\t0x{start:x}\t0x{end:x}\t{s0}\t{s1}")

if __name__ == "__main__":
    main()

