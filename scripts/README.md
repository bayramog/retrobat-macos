# GitHub Issues Creation Tools

This directory contains multiple tools to help create GitHub issues for the RetroBat macOS port project.

## Available Methods

### Method 1: Bash Script (create-github-issues.sh) - Recommended

This script automatically creates all 17 initial GitHub issues as defined in [ISSUES.md](../ISSUES.md) using the GitHub CLI (`gh`).

### Prerequisites

1. **GitHub CLI (`gh`)** must be installed
   - macOS: `brew install gh`
   - Linux: Follow instructions at https://cli.github.com/

2. **GitHub Authentication**
   - You must be authenticated with GitHub CLI
   - Run: `gh auth login`
   - Follow the prompts to authenticate

### Usage

```bash
# Navigate to the scripts directory
cd scripts

# Run the script
./create-github-issues.sh
```

### What the Script Does

The script creates 17 GitHub issues in the `bayramog/retrobat-macos` repository:

1. **Issue #1**: Setup macOS Development Environment for RetroBat Port
2. **Issue #2**: Port RetroBuild.exe to .NET 6+ for Cross-Platform Support
3. **Issue #3**: Replace Windows System Tools with macOS-Compatible Versions
4. **Issue #4**: Port RetroBat's EmulationStation Fork to macOS
5. **Issue #5**: Migrate emulatorLauncher from .NET Framework to .NET 6+ for macOS Support
6. **Issue #6**: Convert All Configuration Files from Windows to macOS Path Format
7. **Issue #7**: Integrate RetroArch for macOS Apple Silicon
8. **Issue #8**: Create Emulator Compatibility Matrix for macOS
9. **Issue #9**: Create .dmg and .pkg Installers for macOS
10. **Issue #10**: Setup Code Signing and Notarization for macOS Distribution
11. **Issue #11**: Implement Automated Build System for macOS Releases
12. **Issue #12**: Implement and Test Controller Support for macOS
13. **Issue #13**: Create Comprehensive macOS User Documentation
14. **Issue #14**: Test and Optimize Performance on Apple Silicon
15. **Issue #15**: Organize Beta Testing for macOS Release
16. **Issue #16**: Update README.md to Include macOS Support
17. **Issue #17**: Prepare Release Notes for First macOS Release

### Labels

Each issue is created with appropriate labels:
- `macos` - All issues
- `setup`, `porting`, `tools`, `documentation`, `testing`, etc. - Specific to each issue
- `critical` - For high-priority blocking issues

### Issue Structure

Each issue includes:
- **Title**: Clear, descriptive title
- **Description**: Detailed explanation of the task
- **Tasks**: Checklist of specific tasks to complete
- **Dependencies**: Other issues or external dependencies
- **Acceptance Criteria**: Definition of done
- **Priority**: High, Medium, or Low
- **Resources**: Links to relevant documentation

### Method 2: Python Script (create_issues.py)

For users who prefer Python or need more control, use the Python script:

#### Prerequisites
- Python 3.6+
- requests library: `pip install requests`
- GitHub personal access token

#### Usage
```bash
# Set your GitHub token
export GITHUB_TOKEN="your_token_here"

# Run the script
python3 create_issues.py
```

#### Advantages
- More portable across different systems
- Better error handling
- Can be easily extended or modified
- Works with GitHub personal access tokens

### Method 3: CSV Import (issues.csv)

For manual import or use with project management tools:

1. Open the `issues.csv` file
2. Use GitHub's bulk import feature (if available) or
3. Import into your project management tool
4. Create issues manually by copying from the CSV

The CSV contains all issue data in a structured format with columns:
- Title
- Labels
- Body (description and tasks)
- Priority

### Method 4: Manual Creation

If automated methods don't work, create issues manually:

1. Go to https://github.com/bayramog/retrobat-macos/issues/new
2. Open [ISSUES.md](../ISSUES.md)
3. Copy each issue section one by one
4. Fill in the GitHub issue form manually

## Troubleshooting

**Error: "gh: To use GitHub CLI in a GitHub Actions workflow, set the GH_TOKEN environment variable"**

This means you're not authenticated. Run:
```bash
gh auth login
```

**Error: "HTTP 401: Unauthorized"**

Your GitHub token may have expired. Re-authenticate:
```bash
gh auth refresh
```

**Error: "HTTP 403: Forbidden"**

You don't have permission to create issues in this repository. Make sure you:
- Have push access to the repository
- Are authenticated as the correct user

### Manual Issue Creation

If you prefer to create issues manually or the script doesn't work, you can:

1. Go to https://github.com/bayramog/retrobat-macos/issues/new
2. Copy the content from [ISSUES.md](../ISSUES.md)
3. Create each issue one by one

### Alternative: Using GitHub API

You can also create issues using the GitHub API:

```bash
# Set your GitHub token
export GITHUB_TOKEN="your_token_here"

# Create an issue
curl -X POST \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: Bearer $GITHUB_TOKEN" \
  https://api.github.com/repos/bayramog/retrobat-macos/issues \
  -d '{
    "title": "Issue title",
    "body": "Issue description",
    "labels": ["macos", "setup"]
  }'
```

## Project Planning

After creating all issues, consider:

1. **Creating Milestones** to group related issues:
   - M1: Development Setup (Issues 1-3)
   - M2: Core Porting (Issues 4-5)
   - M3: Integration (Issues 6-8)
   - M4: Distribution (Issues 9-11)
   - M5: Testing & Documentation (Issues 12-15)
   - M6: Release (Issues 16-17)

2. **Creating a Project Board** to track progress visually

3. **Assigning Issues** to team members

4. **Setting Due Dates** based on the timeline in [MACOS_MIGRATION_PLAN.md](../MACOS_MIGRATION_PLAN.md)

## Support

For questions about the macOS port or these issues, please:
- Open a discussion in the repository
- Contact the RetroBat team on Discord
- Reference the migration plan and architecture documents
