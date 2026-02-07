# RetroBat macOS Beta Testing Guide

## Welcome Beta Tester! 🎮

Thank you for participating in the RetroBat macOS beta testing program. Your feedback is crucial for delivering a high-quality macOS experience to the gaming community.

## Table of Contents
1. [System Requirements](#system-requirements)
2. [Getting Started](#getting-started)
3. [Installation](#installation)
4. [Testing Areas](#testing-areas)
5. [Reporting Issues](#reporting-issues)
6. [Providing Feedback](#providing-feedback)
7. [Best Practices](#best-practices)
8. [Communication](#communication)
9. [FAQ](#faq)

## System Requirements

### Minimum Requirements
- **macOS Version**: macOS Ventura (13.0) or later
- **Processor**: Apple Silicon (M1 or newer)
- **RAM**: 8GB (16GB recommended)
- **Storage**: 20GB free space (more for ROM collections)
- **Hardware**: Mac with Apple Silicon chip

### Recommended for Best Experience
- macOS Sonoma (14.0) or Sequoia (15.0)
- Apple Silicon M2 or newer
- 16GB+ RAM
- 50GB+ free storage
- Game controllers (various brands for testing)

### Supported Controllers
- Xbox Series X|S Controller
- PlayStation 4/5 DualShock/DualSense
- Nintendo Switch Pro Controller
- 8BitDo Controllers
- Generic USB/Bluetooth controllers

## Getting Started

### 1. Pre-Installation Checklist
- [ ] Verify your Mac meets system requirements
- [ ] Update macOS to latest version
- [ ] Install Xcode Command Line Tools: `xcode-select --install`
- [ ] Install Homebrew: Visit [brew.sh](https://brew.sh)
- [ ] Backup important data
- [ ] Have at least 20GB free disk space

### 2. Install Homebrew Dependencies
```bash
brew install cmake sdl2 boost ffmpeg freeimage freetype curl
```

### 3. Download Beta Build
You will receive a download link via email or Discord with:
- **RetroBat-macOS-vX.X.X-beta.dmg** (DMG installer) or
- **RetroBat-macOS-vX.X.X-beta.zip** (Portable version)
- **SHA256 checksum file** for verification

### 4. Verify Download (Recommended)
```bash
# Compare with provided checksum
shasum -a 256 RetroBat-macOS-vX.X.X-beta.dmg
```

## Installation

### Method 1: DMG Installer (Recommended)
1. **Open the DMG file**
   - Double-click the downloaded DMG file
   - Wait for it to mount

2. **Install RetroBat**
   - Drag RetroBat.app to Applications folder
   - Or follow installer prompts if using PKG installer

3. **First Launch**
   - Open RetroBat from Applications folder
   - If macOS shows security warning:
     - Go to System Settings > Privacy & Security
     - Click "Open Anyway" for RetroBat
   - Complete initial setup wizard

### Method 2: Portable ZIP
1. **Extract the ZIP file**
   ```bash
   unzip RetroBat-macOS-vX.X.X-beta.zip
   cd RetroBat
   ```

2. **Remove quarantine attribute**
   ```bash
   xattr -cr RetroBat.app
   ```

3. **Launch RetroBat**
   ```bash
   open RetroBat.app
   ```

### Post-Installation
- [ ] Complete initial setup wizard
- [ ] Configure default settings
- [ ] Set up ROM directories
- [ ] Test controller connection
- [ ] Download at least one emulator

## Testing Areas

### Priority 1: Critical Functionality

#### Installation & Setup (Day 1-2)
- **Task**: Install RetroBat and complete initial setup
- **What to test**:
  - [ ] Download completes successfully
  - [ ] Installation process is smooth
  - [ ] First launch works without errors
  - [ ] Initial setup wizard is clear
  - [ ] Default directories are created
- **What to report**:
  - Any installation errors
  - Confusing setup steps
  - Missing or unclear instructions
  - Performance during installation

#### Controller Configuration (Day 2-3)
- **Task**: Connect and configure your game controllers
- **What to test**:
  - [ ] Controller auto-detection
  - [ ] Button mapping
  - [ ] Multiple controller support
  - [ ] Controller hot-plugging
  - [ ] Bluetooth vs USB connectivity
- **Test with**:
  - Xbox controllers
  - PlayStation controllers
  - Nintendo controllers
  - Generic/third-party controllers
- **What to report**:
  - Controllers not detected
  - Incorrect button mappings
  - Connection issues
  - Lag or input delay

#### Emulator Compatibility (Day 3-5)
- **Task**: Test emulators for various systems
- **What to test**:
  - [ ] Download and install emulators
  - [ ] Launch games via EmulationStation
  - [ ] Save/load states
  - [ ] Settings configuration
  - [ ] Performance and stability
- **Priority Systems**:
  - NES/SNES (RetroArch)
  - PlayStation 1 (DuckStation or RetroArch)
  - Nintendo 64 (Mupen64Plus)
  - GameCube (Dolphin)
  - Nintendo DS (MelonDS)
- **What to report**:
  - Emulators failing to launch
  - Games not loading
  - Crashes or freezes
  - Performance issues
  - Audio/video problems

### Priority 2: Important Features

#### EmulationStation Interface (Day 4-6)
- **Task**: Navigate and use the EmulationStation interface
- **What to test**:
  - [ ] Game library browsing
  - [ ] Search functionality
  - [ ] System selection
  - [ ] Settings menus
  - [ ] Theme support
  - [ ] Scraping game metadata
- **What to report**:
  - UI bugs or glitches
  - Navigation issues
  - Theme problems
  - Confusing layouts
  - Missing features

#### ROM Management (Day 5-7)
- **Task**: Add, organize, and manage your ROM collection
- **What to test**:
  - [ ] ROM scanning and detection
  - [ ] Multi-disc games
  - [ ] Compressed ROMs (zip, 7z)
  - [ ] ROM organization
  - [ ] Game metadata/artwork
- **What to report**:
  - ROMs not detected
  - Scanning issues
  - Compression problems
  - Organization difficulties

#### System Settings (Day 6-8)
- **Task**: Configure various system settings
- **What to test**:
  - [ ] Video settings
  - [ ] Audio settings
  - [ ] Input settings
  - [ ] Network settings
  - [ ] Update mechanism
- **What to report**:
  - Settings not saving
  - Options not working
  - Unclear settings
  - Missing features

### Priority 3: Polish & Documentation

#### Documentation Testing (Day 8-10)
- **Task**: Follow documentation and identify gaps
- **What to test**:
  - [ ] Installation guide accuracy
  - [ ] Configuration tutorials
  - [ ] Troubleshooting guides
  - [ ] Controller setup docs
  - [ ] FAQ completeness
- **What to report**:
  - Incorrect information
  - Missing steps
  - Unclear instructions
  - Suggested improvements

#### Performance Testing (Day 9-12)
- **Task**: Test performance across scenarios
- **What to test**:
  - [ ] Large ROM collections (100+ games)
  - [ ] High-resolution games
  - [ ] Long gaming sessions (2+ hours)
  - [ ] Multiple emulator switches
  - [ ] Memory usage over time
- **Hardware to test on**:
  - M1 Mac (if available)
  - M2 Mac (if available)
  - M3/M4 Mac (if available)
  - Different RAM configurations
- **What to report**:
  - Slowdowns or lag
  - High memory usage
  - Crashes after extended use
  - Battery drain (laptops)

#### Edge Cases (Day 11-14)
- **Task**: Try unusual scenarios
- **What to test**:
  - [ ] Unusual ROM file names
  - [ ] Very large ROM collections
  - [ ] External storage devices
  - [ ] Network shares
  - [ ] Multiple displays
  - [ ] Accessibility features
- **What to report**:
  - Unexpected behavior
  - Error messages
  - Data loss scenarios
  - Recovery issues

## Reporting Issues

### How to Report a Bug

#### Use the Beta Testing Feedback Form
1. Visit the provided feedback form URL
2. Fill out all required fields
3. Be specific and detailed
4. Include reproduction steps

#### Required Information
- **Issue Title**: Clear, concise summary
- **Severity**: Critical / High / Medium / Low
- **Category**: Installation / Setup / Controllers / Emulators / UI / Performance / Documentation
- **Description**: Detailed explanation
- **Steps to Reproduce**: Exact steps to recreate issue
- **Expected Behavior**: What should happen
- **Actual Behavior**: What actually happens
- **System Information**:
  - Mac model (e.g., MacBook Pro M2)
  - macOS version (e.g., Sonoma 14.3)
  - RetroBat version (beta build number)
  - Controller(s) used
- **Screenshots/Videos**: If applicable
- **Logs**: Include relevant log files

#### Severity Definitions
- **Critical**: Prevents installation or basic functionality
- **High**: Major feature broken, significant impact
- **Medium**: Feature partially broken, workaround exists
- **Low**: Minor issue, cosmetic problem

### Where to Find Logs
```bash
# RetroBat logs
~/Library/Application Support/RetroBat/logs/

# EmulationStation logs
~/Library/Application Support/RetroBat/es_log.txt

# System logs
log show --predicate 'process == "RetroBat"' --last 1h
```

### Bug Report Template
```markdown
**Title**: [Brief description]

**Severity**: Critical/High/Medium/Low

**Category**: Installation/Setup/Controllers/Emulators/UI/Performance/Documentation

**Description**:
[Detailed description of the issue]

**Steps to Reproduce**:
1. [First step]
2. [Second step]
3. [Third step]

**Expected Behavior**:
[What should happen]

**Actual Behavior**:
[What actually happens]

**System Information**:
- Mac Model: [e.g., MacBook Pro 14" M2]
- macOS Version: [e.g., Sonoma 14.3]
- RetroBat Version: [e.g., v1.0.0-beta1]
- Controller: [e.g., Xbox Series X Controller via Bluetooth]

**Screenshots/Videos**:
[Attach if applicable]

**Logs**:
[Paste relevant log excerpts]

**Additional Context**:
[Any other relevant information]
```

## Providing Feedback

### Types of Feedback We Need

#### Usability Feedback
- Is the installation process intuitive?
- Are the menus easy to navigate?
- Is the documentation clear?
- Are error messages helpful?
- What was confusing?

#### Feature Feedback
- What features are missing?
- What features work well?
- What would improve your experience?
- What unexpected behavior did you encounter?

#### Performance Feedback
- How is the overall performance?
- Are there any slowdowns?
- How is battery life (for laptops)?
- Does it feel responsive?

#### Documentation Feedback
- What information is missing?
- What is unclear?
- What additional guides would help?
- Are examples sufficient?

### Feedback Channels
1. **Primary**: Beta Testing Feedback Form
2. **Secondary**: Discord Beta Channel (invite provided)
3. **Direct**: Email to beta coordinator (if urgent)

### Weekly Check-ins
- We'll send weekly surveys
- Share your progress
- Report any blockers
- Ask questions

## Best Practices

### DO's ✅
- **Test regularly**: Use RetroBat for actual gaming sessions
- **Be detailed**: More information is always better
- **Try different scenarios**: Don't just stick to one emulator
- **Document everything**: Take notes as you test
- **Report promptly**: Don't wait until the end
- **Follow up**: Check if your issues are fixed in updates
- **Be honest**: Negative feedback is valuable
- **Ask questions**: No question is too simple

### DON'Ts ❌
- **Don't assume**: Report everything, even if it seems minor
- **Don't batch reports**: Report issues as you find them
- **Don't skip steps**: Follow the testing checklist
- **Don't share beta builds**: These are for testers only
- **Don't ignore updates**: Install beta updates when released
- **Don't test on production**: Keep your main gaming setup separate

## Communication

### Discord Beta Channel
- **Purpose**: Real-time communication, quick questions
- **Hours**: Monitored 9 AM - 9 PM PT
- **Etiquette**: Be respectful, stay on topic

### Email Updates
- Weekly progress updates
- New beta build announcements
- Important notices
- Response time: Within 24 hours

### Beta Coordinator
- **Role**: Your main point of contact
- **Availability**: Monday-Friday, 9 AM - 6 PM PT
- **For**: Urgent issues, private concerns, questions

## FAQ

### General Questions

**Q: How long will the beta last?**
A: 2-4 weeks, depending on issues found. We may run a second round if needed.

**Q: What if I find a critical bug?**
A: Report it immediately via the feedback form and mention it in Discord. Mark it as Critical severity.

**Q: Can I use my existing ROM collection?**
A: Yes! RetroBat supports standard ROM formats. Just point it to your ROM directories.

**Q: Will my data be safe?**
A: Yes, but we recommend backing up your ROM collection and saves before beta testing.

**Q: Can I stream or record my testing?**
A: Please check with the beta coordinator first. We generally allow this but may have restrictions.

**Q: What if RetroBat conflicts with my existing setup?**
A: Use a separate user account or test in a controlled environment. Don't test on your primary gaming setup.

### Technical Questions

**Q: Where are configuration files stored?**
A: `~/Library/Application Support/RetroBat/`

**Q: How do I completely uninstall RetroBat?**
A: Delete RetroBat.app and `~/Library/Application Support/RetroBat/`

**Q: Can I use RetroArch cores I already have?**
A: Yes, but test with the included versions first for consistency.

**Q: What if my controller isn't detected?**
A: Check System Settings > Privacy & Security > Input Monitoring. Grant permission to RetroBat.

**Q: How do I update to a new beta build?**
A: Download the new build and install over the existing one. Your settings should be preserved.

### Testing Questions

**Q: Do I need to test everything?**
A: No, focus on areas you're comfortable with. However, try to cover at least the Priority 1 items.

**Q: How many hours should I test?**
A: We estimate 10-15 hours over 2-4 weeks. More is better, but quality over quantity.

**Q: What if I don't have time to finish testing?**
A: That's okay! Report what you've found and let us know. We appreciate any feedback.

**Q: Should I test on multiple Macs?**
A: If you have access to multiple Macs with different specs, that's valuable! But one is fine.

**Q: Can I skip areas I'm not interested in?**
A: We encourage testing all areas, but focus on what you're most comfortable with.

## Thank You! 🙏

Your participation in this beta program is invaluable. You're helping make RetroBat macOS a great experience for the entire community. We appreciate your time, effort, and detailed feedback.

**Let's make RetroBat macOS amazing together!**

---

*For questions or support, contact the beta coordinator or post in the Discord beta channel.*

**Beta Program Version**: 1.0  
**Last Updated**: February 2026
