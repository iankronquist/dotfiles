#!/usr/bin/env python3
# Model: GPT-4, Date: 2025-01-08
import re
import sys
import os

def replace_rdar_links_in_file(file_path):
    """
    Replaces rdar:// links in a markdown file with markdown syntax links.
    
    Args:
        file_path (str): Path to the markdown file.
    """
    if not os.path.isfile(file_path):
        print(f"Error: File '{file_path}' not found.")
        return

    with open(file_path, 'r', encoding='utf-8') as file:
        content = file.read()

    # Regex pattern to match rdar:// links not already in markdown format
    pattern = r'(?<!\[)(rdar://\d+)(?!\))'

    # Replace matches with markdown link format
    updated_content = re.sub(pattern, r'[\1](\1)', content)

    # Write the updated content back to the file
    with open(file_path, 'w', encoding='utf-8') as file:
        file.write(updated_content)

    print(f"Processed file: {file_path}")

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: python replace_rdar_links.py <file1.md> [<file2.md> ...]")
        sys.exit(1)

    for markdown_file in sys.argv[1:]:
        replace_rdar_links_in_file(markdown_file)

