#!/usr/bin/env python3
# Model: ChatGPT-4, Date: 2025-02-10
import argparse
import sys
import struct
import re

def bf16_to_float(bf16):
    """Convert BF16 to float32."""
    bf16 = int(bf16, 16)  # Convert hex string to int
    float_bits = bf16 << 16  # Shift to match FP32 format
    return struct.unpack('f', struct.pack('I', float_bits))[0]

def float_to_bf16(value):
    """Convert float32 to BF16."""
    float_bits = struct.unpack('I', struct.pack('f', float(value)))[0]
    bf16_bits = float_bits >> 16  # Extract top 16 bits
    return f"{bf16_bits:04X}"  # Return as uppercase hex string

def process_input(input_str):
    """Process input string to determine if it's a hex number and convert accordingly."""
    input_str = input_str.replace(',', ' ')  # Remove commas
    hex_match = re.fullmatch(r'[0-9A-Fa-f]+', input_str)
    if hex_match:
        return bf16_to_float(input_str)
    else:
        return float_to_bf16(input_str)

def main():
    parser = argparse.ArgumentParser(description="Convert BF16 to float and vice versa.")
    parser.add_argument('values', nargs='*', help="Hex BF16 values or floats to convert.")
    args = parser.parse_args()
    
    if not args.values:
        # Read from stdin if no command-line arguments are given
        for line in sys.stdin:
            for token in line.replace(',', ' ').split():
                try:
                    print(token, '->', process_input(token))
                except ValueError:
                    print(f"Invalid input: '{token}'", file=sys.stderr)
    else:
        # Process command-line arguments
        for token in args.values:
            for sub_token in token.split(','):
                if not sub_token:
                    continue
                try:
                    print(sub_token, '->', process_input(sub_token))
                except ValueError:
                    print(f"Invalid input: '{sub_token}'", file=sys.stderr)

if __name__ == "__main__":
    main()

