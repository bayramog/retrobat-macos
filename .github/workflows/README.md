# GitHub Actions Workflows

## Create macOS Port Issues

**File:** `create-macos-issues.yml`

**Purpose:** Automatically create all 17 GitHub issues for the RetroBat macOS port project.

### How to Use

1. **Navigate to Actions Tab**
   - Go to your repository on GitHub
   - Click on the "Actions" tab at the top

2. **Select the Workflow**
   - Find "Create macOS Port Issues" in the workflows list
   - Click on it

3. **Run the Workflow**
   - Click the "Run workflow" button (top right)
   - Select the branch (usually `main` or `copilot/create-initial-issues`)
   - Click "Run workflow"

4. **Wait for Completion**
   - The workflow takes about 10-20 seconds to complete
   - All 17 issues will be created with proper labels, descriptions, and task lists

### What Gets Created

The workflow creates all 17 issues as defined in `ISSUES.md`:

- **3 Foundation issues** - Development environment setup
- **2 Core Component issues** (Critical) - EmulationStation & emulatorLauncher ports
- **3 Integration issues** - Config files, RetroArch, emulator compatibility
- **3 Distribution issues** - Installers, code signing, build automation
- **4 Testing & Documentation issues** - Controllers, docs, performance, beta testing
- **2 Release issues** - README update, release notes

### Requirements

- Repository owner or write access
- Issues must not already exist (workflow creates new issues)

### Troubleshooting

**Issue: "Resource not accessible by integration"**
- Make sure you have write access to the repository
- Check that the workflow has `issues: write` permission (it should by default)

**Issue: "Issues already exist"**
- The script doesn't check for duplicates
- If issues already exist with the same titles, you'll get duplicates
- Delete existing issues first if needed

**Issue: Workflow not showing up**
- Make sure the workflow file is in `.github/workflows/` directory
- Make sure it's on the branch you're viewing from
- Refresh the Actions page

### Alternative Methods

If the GitHub Actions workflow doesn't work for you, see:
- `scripts/create-github-issues.sh` - Bash script for local use
- `scripts/create_issues.py` - Python script alternative
- `CREATING_ISSUES.md` - Complete guide with all methods
