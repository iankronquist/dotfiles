#!/usr/bin/env python3

# Generated by prompting chatgpt
import os
import argparse
import subprocess

def generate_markdown_checkboxes(directory, tracked_files, level=0):
    """
    Generates a nested list of markdown formatted checkboxes for the given directory,
    filtering out files not tracked by git if tracked_files is provided.

    Args:
    directory (str): The path of the directory to iterate over.
    tracked_files (set): A set of tracked files if filtering is enabled, otherwise None.
    level (int): The current level of indentation (used for recursion).

    Returns:
    str: A string representing the nested list of markdown formatted checkboxes.
    """
    markdown = ""
    indent = "  " * level
    try:
        for entry in sorted(os.listdir(directory)):
            entry_path = os.path.abspath(os.path.join(directory, entry))
            if tracked_files is None or entry_path in tracked_files or any(f.startswith(entry_path + os.sep) for f in tracked_files):
                markdown += f"{indent}- [ ] {entry}\n"
                if os.path.isdir(entry_path):
                    markdown += generate_markdown_checkboxes(entry_path, tracked_files, level + 1)
    except PermissionError:
        pass  # Skip directories for which we do not have permission to read
    return markdown

def get_tracked_files(directory):
    """
    Retrieves a set of files tracked by git, relative to the specified directory.

    Args:
    directory (str): The directory to get the tracked files for.

    Returns:
    set: A set of tracked file paths relative to the specified directory.
    """
    result = subprocess.run(['git', 'ls-files'], stdout=subprocess.PIPE, text=True, cwd=directory)
    tracked_files = set(result.stdout.splitlines())
    return {os.path.abspath(os.path.join(directory, f)) for f in tracked_files}

def save_markdown_to_file(markdown, file_path):
    """
    Saves the markdown content to a file.

    Args:
    markdown (str): The markdown content to save.
    file_path (str): The path of the file to save the markdown content.
    """
    with open(file_path, 'w') as file:
        file.write(markdown)

def main():
    parser = argparse.ArgumentParser(description="Generate a nested list of markdown formatted checkboxes for a directory.")
    parser.add_argument("directory", type=str, help="The path of the directory to iterate over.")
    parser.add_argument("--output_file", "-o", type=str, help="The path of the output markdown file. If not provided, prints to stdout.")
    parser.add_argument("--only_tracked", "-t", action="store_true", help="Filter out files which aren't tracked in the git repo.")
    
    args = parser.parse_args()
    
    tracked_files = None
    if args.only_tracked:
        tracked_files = get_tracked_files(args.directory)

    markdown_content = generate_markdown_checkboxes(args.directory, tracked_files)
    
    if args.output_file:
        save_markdown_to_file(markdown_content, args.output_file)
        print(f"Markdown content has been saved to {args.output_file}")
    else:
        print(markdown_content)

if __name__ == "__main__":
    main()