#!/usr/bin/env python3
r"""
Convert Windows paths and environment variables to macOS format.

This script converts:
1. Path separators: \ → /
2. Environment variables: %HOME% → $HOME, %USERPROFILE% → $HOME
3. Windows executable extensions: .exe removed from paths
4. Drive letters: C:\ style paths converted to Unix paths
"""

import os
import re
import sys
import argparse
from pathlib import Path
from typing import List, Tuple


class WindowsToMacOSConverter:
    """Converter for Windows paths to macOS format."""
    
    def __init__(self, dry_run: bool = False, verbose: bool = False):
        self.dry_run = dry_run
        self.verbose = verbose
        self.files_processed = 0
        self.files_modified = 0
        self.changes_made = 0
        
    def convert_content(self, content: str) -> Tuple[str, int]:
        """
        Convert Windows paths in content to macOS format.
        
        Returns:
            Tuple of (converted_content, number_of_changes)
        """
        original = content
        changes = 0
        
        # 1. Convert %HOME% to $HOME
        new_content = re.sub(r'%HOME%', r'$HOME', content)
        if new_content != content:
            changes += content.count('%HOME%')
            content = new_content
            
        # 2. Convert %USERPROFILE% to $HOME
        new_content = re.sub(r'%USERPROFILE%', r'$HOME', content)
        if new_content != content:
            changes += content.count('%USERPROFILE%')
            content = new_content
            
        # 3. Convert backslash path separators to forward slashes
        # Look for patterns like: ~\..\roms\, path\to\file, etc.
        # Be careful not to affect escaped characters in regex or other contexts
        # Pattern: word or special chars followed by backslash followed by word/dot
        new_content = re.sub(r'([~\w\.])(\\+)([~\w\.\-])', r'\1/\3', content)
        if new_content != content:
            changes += (len(content) - len(content.replace('\\', ''))) - (len(new_content) - len(new_content.replace('\\', '')))
            content = new_content
        
        # 3b. Convert trailing backslashes in paths (e.g., path=./dir\)
        new_content = re.sub(r'([/\w\.]+)\\(\s*$|\s)', r'\1/\2', content, flags=re.MULTILINE)
        if new_content != content:
            changes += 1
            content = new_content
        
        # 3c. Convert leading backslashes in paths (e.g., \dev_hdd0/path)
        new_content = re.sub(r'^\\([/\w])', r'/\1', content, flags=re.MULTILINE)
        if new_content != content:
            changes += 1
            content = new_content
        
        # 3d. Convert backslash before wildcards (e.g., path\*.ext)
        new_content = re.sub(r'([/\w\.])\\(\*)', r'\1/\2', content)
        if new_content != content:
            changes += content.count('\\*')
            content = new_content
        
        # 4. Remove .exe extensions from paths (but keep in quotes for compatibility)
        # Pattern: .exe preceded by alphanumeric/underscore/dash, possibly in quotes
        new_content = re.sub(r'(["\']?)(\w+)\.exe(["\']?)', r'\1\2\3', content)
        if new_content != content:
            changes += original.count('.exe') - new_content.count('.exe')
            content = new_content
            
        # 5. Convert drive letter paths (C:\path → /path)
        new_content = re.sub(r'[A-Za-z]:\\', r'/', content)
        if new_content != content:
            changes += 1
            content = new_content
        
        # 6. Convert path patterns like :\assets to proper Unix paths
        # This is for RetroArch configs that use :\ prefix
        new_content = re.sub(r'= ":\\', r'= "$HOME/', content)
        if new_content != content:
            changes += 1
            content = new_content
            
        return content, changes
    
    def should_process_file(self, filepath: Path) -> bool:
        """Check if file should be processed based on extension."""
        # Process common config file types
        extensions = {
            '.cfg', '.ini', '.conf', '.xml', '.json',
            '.lst', '.info', '.po', '.pot', '.txt'
        }
        return filepath.suffix.lower() in extensions
    
    def process_file(self, filepath: Path) -> bool:
        """
        Process a single file and convert Windows paths.
        
        Returns:
            True if file was modified, False otherwise
        """
        self.files_processed += 1
        
        try:
            # Read file content
            with open(filepath, 'r', encoding='utf-8', errors='ignore') as f:
                original_content = f.read()
            
            # Convert content
            converted_content, changes = self.convert_content(original_content)
            
            # Check if any changes were made
            if changes == 0:
                if self.verbose:
                    print(f"  No changes: {filepath}")
                return False
            
            # Write back if not dry run
            if not self.dry_run:
                with open(filepath, 'w', encoding='utf-8') as f:
                    f.write(converted_content)
            
            self.files_modified += 1
            self.changes_made += changes
            
            status = "[DRY RUN] " if self.dry_run else ""
            print(f"{status}Modified: {filepath} ({changes} changes)")
            
            return True
            
        except Exception as e:
            print(f"Error processing {filepath}: {e}", file=sys.stderr)
            return False
    
    def process_directory(self, directory: Path) -> None:
        """Process all files in a directory recursively."""
        for filepath in directory.rglob('*'):
            if filepath.is_file() and self.should_process_file(filepath):
                self.process_file(filepath)
    
    def print_summary(self) -> None:
        """Print summary of conversion."""
        print("\n" + "=" * 70)
        print("CONVERSION SUMMARY")
        print("=" * 70)
        print(f"Files processed: {self.files_processed}")
        print(f"Files modified:  {self.files_modified}")
        print(f"Total changes:   {self.changes_made}")
        if self.dry_run:
            print("\nNote: This was a DRY RUN. No files were actually modified.")
        print("=" * 70)


def main():
    """Main entry point."""
    parser = argparse.ArgumentParser(
        description='Convert Windows paths to macOS format in configuration files.'
    )
    parser.add_argument(
        'paths',
        nargs='+',
        help='Files or directories to process'
    )
    parser.add_argument(
        '--dry-run',
        action='store_true',
        help='Show what would be changed without modifying files'
    )
    parser.add_argument(
        '--verbose',
        action='store_true',
        help='Show detailed output including files with no changes'
    )
    
    args = parser.parse_args()
    
    converter = WindowsToMacOSConverter(dry_run=args.dry_run, verbose=args.verbose)
    
    # Process each path
    for path_str in args.paths:
        path = Path(path_str)
        
        if not path.exists():
            print(f"Error: Path does not exist: {path}", file=sys.stderr)
            continue
        
        if path.is_file():
            if converter.should_process_file(path):
                converter.process_file(path)
            else:
                print(f"Skipping (unsupported type): {path}")
        elif path.is_dir():
            print(f"Processing directory: {path}")
            converter.process_directory(path)
    
    converter.print_summary()
    
    return 0 if converter.files_modified > 0 or args.dry_run else 1


if __name__ == '__main__':
    sys.exit(main())
