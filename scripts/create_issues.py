#!/usr/bin/env python3
"""
Create GitHub issues for RetroBat macOS port.
This script reads issue definitions and creates them via GitHub API.
"""

import os
import sys
import json
import requests
from typing import List, Dict

# Repository configuration
REPO_OWNER = "bayramog"
REPO_NAME = "retrobat-macos"

# Issue definitions
ISSUES = [
    {
        "title": "Setup macOS Development Environment for RetroBat Port",
        "labels": ["macos", "setup", "documentation"],
        "body": """## Description

Setup the development environment required to build and test RetroBat on macOS Apple Silicon.

### Tasks
- [ ] Install .NET 6+ SDK for macOS
- [ ] Install Xcode and Command Line Tools
- [ ] Setup Homebrew package manager
- [ ] Install required dependencies (p7zip, wget, sdl3)
- [ ] Configure IDE (Visual Studio Code or JetBrains Rider)
- [ ] Clone emulatorLauncher source repository
- [ ] Verify build environment with test builds
- [ ] Document setup process in BUILDING_MACOS.md

### Dependencies
None - this is the first step

### Acceptance Criteria
- Development machine can build .NET 6+ projects
- All required tools are installed and accessible
- Documentation is complete and tested

### Priority
High"""
    },
    {
        "title": "Port RetroBuild.exe to .NET 6+ for Cross-Platform Support",
        "labels": ["macos", "porting", "build-system"],
        "body": """## Description

Migrate RetroBuild.exe from .NET Framework to .NET 6+ to enable cross-platform support for macOS.

### Current State
- RetroBuild.exe is compiled for Windows using .NET Framework
- Uses Windows-specific APIs and file paths

### Tasks
- [ ] Obtain or recreate RetroBuild source code
- [ ] Create new .NET 6+ project
- [ ] Migrate code to .NET 6+
- [ ] Replace Windows-specific file path handling
  - Use `Path.Combine()` instead of string concatenation
  - Use `Path.DirectorySeparatorChar`
- [ ] Add platform detection using `RuntimeInformation.IsOSPlatform()`
- [ ] Implement macOS-specific build logic
- [ ] Update command-line argument parsing for cross-platform
- [ ] Test on both Windows and macOS
- [ ] Update build.ini with platform-specific settings

### Acceptance Criteria
- RetroBuild compiles and runs on macOS
- Can download and extract files on macOS
- Build configuration works for both platforms
- Code is maintainable and well-documented

### Priority
High"""
    },
    # Additional issues would follow the same pattern...
    # For brevity, I'll add just a few more
]


def get_github_token() -> str:
    """Get GitHub token from environment."""
    token = os.environ.get('GITHUB_TOKEN') or os.environ.get('GH_TOKEN')
    if not token:
        print("Error: GITHUB_TOKEN or GH_TOKEN environment variable not set", file=sys.stderr)
        print("\nTo set your token:", file=sys.stderr)
        print("  export GITHUB_TOKEN='your_token_here'", file=sys.stderr)
        print("\nOr use gh CLI to authenticate:", file=sys.stderr)
        print("  gh auth login", file=sys.stderr)
        sys.exit(1)
    return token


def create_issue(token: str, issue_data: Dict) -> Dict:
    """Create a single GitHub issue."""
    url = f"https://api.github.com/repos/{REPO_OWNER}/{REPO_NAME}/issues"
    headers = {
        "Accept": "application/vnd.github+json",
        "Authorization": f"Bearer {token}",
        "X-GitHub-Api-Version": "2022-11-28"
    }
    
    response = requests.post(url, headers=headers, json=issue_data)
    response.raise_for_status()
    return response.json()


def main():
    """Main function to create all issues."""
    print(f"Creating GitHub issues for {REPO_OWNER}/{REPO_NAME}...")
    print()
    
    # Get authentication token
    token = get_github_token()
    
    # Create issues
    created_issues = []
    for i, issue in enumerate(ISSUES, 1):
        try:
            print(f"Creating Issue #{i}: {issue['title']}...")
            result = create_issue(token, issue)
            created_issues.append(result)
            print(f"  ✓ Created: {result['html_url']}")
        except requests.exceptions.HTTPError as e:
            print(f"  ✗ Failed: {e}", file=sys.stderr)
            if e.response.status_code == 401:
                print("  Authentication failed. Check your token.", file=sys.stderr)
                sys.exit(1)
            elif e.response.status_code == 403:
                print("  Permission denied. Check repository access.", file=sys.stderr)
                sys.exit(1)
        except Exception as e:
            print(f"  ✗ Failed: {e}", file=sys.stderr)
    
    print()
    print(f"✅ Created {len(created_issues)} issues successfully!")
    print(f"\nView all issues at: https://github.com/{REPO_OWNER}/{REPO_NAME}/issues")


if __name__ == "__main__":
    main()
