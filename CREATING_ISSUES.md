# Guide: Creating GitHub Issues for RetroBat macOS Port

This guide explains how to create the initial 17 GitHub issues for the RetroBat macOS port project, as defined in [ISSUES.md](ISSUES.md).

## Overview

The [ISSUES.md](ISSUES.md) file contains detailed specifications for 17 GitHub issues that need to be created to track the macOS port project. These issues cover everything from development environment setup to final release preparation.

## Why Create These Issues?

These issues provide:
- **Project Planning**: Clear roadmap with milestones and dependencies
- **Task Tracking**: Organized checklist of work items
- **Team Coordination**: Assign tasks and track progress
- **Documentation**: Keep history of decisions and implementation details
- **Community Engagement**: Allow contributors to see and participate in the project

## Quick Start

### Option 1: Automated Creation with Bash Script (Recommended)

If you have the GitHub CLI installed and authenticated:

```bash
cd scripts
./create-github-issues.sh
```

### Option 2: Automated Creation with Python Script

If you prefer Python or need more control:

```bash
cd scripts
export GITHUB_TOKEN="your_github_token"
python3 create_issues.py
```

### Option 3: Manual Creation

For manual control or if scripts don't work:

1. Review the detailed instructions in [scripts/README.md](scripts/README.md)
2. Use the CSV file [scripts/issues.csv](scripts/issues.csv) as reference
3. Create issues one by one at: https://github.com/bayramog/retrobat-macos/issues/new

## The 17 Issues

Here's a summary of what will be created:

### Phase 1: Foundation (Issues 1-3)
1. **Setup macOS Development Environment** - Development tools and prerequisites
2. **Port RetroBuild to .NET 6+** - Cross-platform build system
3. **Replace Windows Tools with macOS Equivalents** - System utilities migration

### Phase 2: Core Components (Issues 4-5)
4. **Port RetroBat EmulationStation to macOS** - Main UI frontend (CRITICAL)
5. **Port emulatorLauncher to .NET 6+** - Emulator launching system (CRITICAL)

### Phase 3: Configuration & Integration (Issues 6-8)
6. **Update Configuration Files** - Path format conversion
7. **Integrate RetroArch for macOS** - Primary emulator integration
8. **Create Emulator Compatibility Matrix** - Document available emulators

### Phase 4: Distribution (Issues 9-11)
9. **Create macOS Installer Package** - .dmg and .pkg creation
10. **Implement Code Signing and Notarization** - Apple distribution requirements
11. **Create Build Automation Script** - CI/CD pipeline

### Phase 5: Testing & Documentation (Issues 12-15)
12. **Controller Support Testing** - Gamepad compatibility
13. **Create macOS User Documentation** - User guides and tutorials
14. **Performance Testing and Optimization** - Apple Silicon optimization
15. **Beta Testing Program** - Community testing coordination

### Phase 6: Release (Issues 16-17)
16. **Update Main README** - Document macOS support
17. **Create Release Notes** - First release announcement

## Prerequisites for Running Scripts

### For Bash Script (create-github-issues.sh)

1. **GitHub CLI** - Install from https://cli.github.com/
   - macOS: `brew install gh`
   - Linux: Follow CLI installation guide

2. **Authentication** - Login to GitHub:
   ```bash
   gh auth login
   ```

### For Python Script (create_issues.py)

1. **Python 3.6+** - Usually pre-installed on macOS/Linux

2. **Requests Library**:
   ```bash
   pip install requests
   ```

3. **GitHub Token** - Create at https://github.com/settings/tokens
   - Required scopes: `repo` (full control of private repositories)
   - Set as environment variable:
     ```bash
     export GITHUB_TOKEN="your_token_here"
     ```

## After Creating Issues

Once all issues are created, consider:

### 1. Create Milestones

Group issues by phase:

- **M1: Development Setup** (Issues 1-3)
- **M2: Core Porting** (Issues 4-5)
- **M3: Integration** (Issues 6-8)
- **M4: Distribution** (Issues 9-11)
- **M5: Testing & Docs** (Issues 12-15)
- **M6: Release** (Issues 16-17)

### 2. Create Labels

Ensure these labels exist:
- `macos` - All macOS-related work
- `critical` - Must-have for release
- `porting`, `documentation`, `testing`, etc.

### 3. Setup Project Board

Create a GitHub Project board to visualize:
- To Do
- In Progress
- Done

### 4. Assign Issues

Assign issues to team members based on expertise:
- C++ developers → Issue #4 (EmulationStation)
- C# developers → Issues #2, #5 (Build tools, Launcher)
- DevOps → Issues #9-11 (Distribution)
- Technical writers → Issues #13, #16-17 (Documentation)

### 5. Set Dependencies

Link related issues:
- Issue #5 depends on #3 (SDL frameworks)
- Issue #4 depends on #1 (development environment)
- Issues #9-10 depend on #4, #5 (core components)

## Timeline

According to [MACOS_MIGRATION_PLAN.md](MACOS_MIGRATION_PLAN.md), the estimated timeline is:

- **Total Duration**: ~21 weeks (5 months)
- **Critical Path**: EmulationStation port (7 weeks)
- **First Milestone**: Development environment (1-2 weeks)
- **Beta Testing**: Week 16-17
- **Public Release**: Week 19-21

## Need Help?

If you encounter issues:

1. **Check the documentation**: [scripts/README.md](scripts/README.md)
2. **Review ISSUES.md**: Detailed issue specifications
3. **Consult MACOS_MIGRATION_PLAN.md**: Technical details
4. **GitHub Discussions**: Ask questions in repository discussions
5. **Discord**: Join RetroBat community Discord

## Additional Resources

- **ISSUES.md** - Complete issue specifications with full details
- **MACOS_MIGRATION_PLAN.md** - Technical migration strategy
- **ARCHITECTURE.md** - System architecture overview
- **EMULATIONSTATION_DECISION.md** - EmulationStation porting rationale
- **scripts/** - All automation tools and scripts

## Status

This guide was created to facilitate the initial setup of the macOS port project. The issues defined here represent the complete roadmap for bringing RetroBat to macOS Apple Silicon with full feature parity with the Windows version.

---

**Ready to get started?** Head to the [scripts/](scripts/) directory and choose your preferred method for creating the issues!
