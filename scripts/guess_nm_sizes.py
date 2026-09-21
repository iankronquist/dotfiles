# chatgpt code
import sys

def parse_nm_line(line):
    """Parses an nm output line and extracts address, symbol type, and name."""
    parts = line.split()
    if len(parts) < 3:
        return None, None, None
    try:
        addr = int(parts[0], 16)
        sym_type = parts[1]
        name = ' '.join(parts[2:])
        return addr, sym_type, name
    except ValueError:
        return None, None, None

def main():
    nm_lines = []
    
    # Read from stdin
    for line in sys.stdin:
        addr, sym_type, name = parse_nm_line(line)
        if addr is not None and addr != 0:
            nm_lines.append((addr, line.strip()))
    
    # Sort by address
    nm_lines.sort(key=lambda x: x[0])
    
    # Calculate and print the differences
    for i in range(len(nm_lines) - 1):
        addr1, line1 = nm_lines[i]
        addr2, _ = nm_lines[i + 1]
        diff = addr2 - addr1
        print(f"0x{diff:08x} {line1}")
    
    # Print the last line with a dummy size of 0
    if nm_lines:
        _, last_line = nm_lines[-1]
        print(f"0x00000000 {last_line}")

if __name__ == "__main__":
    main()

