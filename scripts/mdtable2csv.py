import csv
import re
import argparse

def escape_commas(cell: str) -> str:
    """Escapes commas in a table cell."""
    return f'"{cell}"' if ',' in cell else cell

def transform_markdown_links(cell: str) -> str:
    """Transforms markdown links [text](url) to HTML links <a href="url">text</a>."""
    markdown_link_pattern = re.compile(r'\[([^\]]+)\]\(([^)]+)\)')
    #return markdown_link_pattern.sub(r'<a href="\2">\1</a>', cell)
    return cell

def process_cell(cell: str) -> str:
    """Processes each cell to escape commas and transform markdown links."""
    cell = escape_commas(cell)
    return transform_markdown_links(cell)

def markdown_table_to_csv(markdown: str, output_file: str):
    """
    Extracts the first table from the markdown content and converts it to CSV.
    The CSV will have commas in the cells properly escaped and markdown links transformed.
    """
    # Regex to match markdown tables
    table_pattern = re.compile(r'\|.*\|\s*\n\|\s*[-:| ]*\s*\n(?:\|.*\|\s*\n)*', re.MULTILINE)
    table_match = table_pattern.search(markdown)

    if not table_match:
        print("No table found in the markdown document.")
        return

    table = table_match.group(0).strip().splitlines()

    # Extract headers and rows
    headers = [col.strip() for col in table[0].split('|')[1:-1]]  # Extract header cells
    rows = [[col.strip() for col in row.split('|')[1:-1]] for row in table[2:]]  # Extract body rows

    # Write to CSV
    with open(output_file, 'w', newline='', encoding='utf-8') as csv_file:
        writer = csv.writer(csv_file)
        writer.writerow([process_cell(header) for header in headers])  # Write headers
        for row in rows:
            writer.writerow([process_cell(cell) for cell in row])  # Write each row

def main():
    # Set up argument parsing
    parser = argparse.ArgumentParser(description="Convert a Markdown table to CSV.")
    parser.add_argument('input_file', type=str, help="Path to the input Markdown file.")
    parser.add_argument('output_file', type=str, help="Path to the output CSV file.")

    args = parser.parse_args()

    # Read the markdown content from the input file
    with open(args.input_file, 'r', encoding='utf-8') as f:
        markdown_content = f.read()

    # Convert the markdown table to CSV
    markdown_table_to_csv(markdown_content, args.output_file)
    print(f"CSV file generated: {args.output_file}")

if __name__ == "__main__":
    main()

