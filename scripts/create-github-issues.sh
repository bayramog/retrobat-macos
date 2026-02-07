#!/bin/bash
set -e

# Script to create GitHub issues for RetroBat macOS port
# Based on ISSUES.md

REPO="bayramog/retrobat-macos"

echo "Creating GitHub issues for RetroBat macOS port..."
echo "Repository: $REPO"
echo ""

# Issue 1: Setup macOS Development Environment
echo "Creating Issue #1: Setup macOS Development Environment..."
gh issue create \
  --repo "$REPO" \
  --title "Setup macOS Development Environment for RetroBat Port" \
  --label "macos,setup,documentation" \
  --body '## Description

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
High'

# Issue 2: Migrate RetroBuild to .NET 6+
echo "Creating Issue #2: Migrate RetroBuild to .NET 6+..."
gh issue create \
  --repo "$REPO" \
  --title "Port RetroBuild.exe to .NET 6+ for Cross-Platform Support" \
  --label "macos,porting,build-system" \
  --body '## Description

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

### Technical Details
```csharp
// Replace Windows-specific paths
string path = Path.Combine(baseDir, filename);

// Platform detection
if (RuntimeInformation.IsOSPlatform(OSPlatform.OSX))
{
    // macOS logic
}
```

### Acceptance Criteria
- RetroBuild compiles and runs on macOS
- Can download and extract files on macOS
- Build configuration works for both platforms
- Code is maintainable and well-documented

### Priority
High'

# Issue 3: Replace System Tools with macOS Equivalents
echo "Creating Issue #3: Replace System Tools with macOS Equivalents..."
gh issue create \
  --repo "$REPO" \
  --title "Replace Windows System Tools with macOS-Compatible Versions" \
  --label "macos,tools,dependencies" \
  --body '## Description

Replace Windows-only binaries in system/tools/ with macOS-compatible versions or native tools.

### Tools to Replace
- `7za.exe` → macOS 7z binary or native tar/gzip
- `wget.exe` → macOS wget or curl
- `curl.exe` → native macOS curl
- `SDL2.dll` → SDL2.framework (required for EmulationStation)
- `SDL3.dll` → SDL3.framework (optional)

### Tasks
- [ ] Create macOS tools directory structure
- [ ] Add p7zip for macOS (via Homebrew or bundle binary)
- [ ] Configure to use native macOS curl
- [ ] Configure to use native or Homebrew wget
- [ ] Add SDL2 framework for macOS (required for EmulationStation)
- [ ] Add SDL3 framework for macOS (optional, for enhanced features)
- [ ] Update build.ini with macOS tool paths
- [ ] Update RetroBuild to detect platform and use correct tools
- [ ] Test extraction and download functionality
- [ ] Document tool dependencies in README

### File Changes
- `build.ini` - Add macOS-specific tool paths
- `system/tools/` - Add macos subdirectory
- RetroBuild source - Add platform-specific tool selection

### Acceptance Criteria
- All required tools available on macOS
- File operations (extract, download) work correctly
- Build process uses correct tools for each platform
- Dependencies documented

### Priority
High'

# Issue 4: Port RetroBat EmulationStation to macOS
echo "Creating Issue #4: Port RetroBat EmulationStation to macOS..."
gh issue create \
  --repo "$REPO" \
  --title "Port RetroBat'\''s EmulationStation Fork to macOS" \
  --label "macos,emulationstation,ui,porting,critical" \
  --body '## Description

Port RetroBat'\''s own EmulationStation fork (based on Batocera) to macOS to maintain 100% feature parity with Windows version.

### Rationale
- RetroBat'\''s ES has more advanced theme engine than ES-DE
- Integrated content downloader and scraper
- Deep integration with RetroBat configuration system
- RetroBat team won'\''t adopt ES-DE
- See [EMULATIONSTATION_DECISION.md](EMULATIONSTATION_DECISION.md) for full details

### Technical Approach
Port C++ codebase from Windows to macOS:
- Replace DirectX → OpenGL/Metal
- Use SDL2 for cross-platform input/graphics
- All dependencies available via Homebrew

### Tasks

#### Phase 1: Analysis (Week 5-6)
- [ ] Clone RetroBat EmulationStation repository
- [ ] Audit codebase for Windows-specific code
- [ ] Document DirectX usage patterns
- [ ] List all dependencies (SDL2, Boost, FreeImage, etc.)
- [ ] Create detailed porting checklist
- [ ] Test basic compilation on macOS

#### Phase 2: Dependencies (Week 6)
- [ ] Install dependencies via Homebrew: `brew install sdl2 boost freeimage freetype eigen curl cmake`
- [ ] Verify library versions and compatibility
- [ ] Setup CMake build configuration for macOS
- [ ] Test minimal build

#### Phase 3: Core Porting (Week 7-9)
- [ ] Replace DirectX rendering with OpenGL/Metal
- [ ] Update window creation for macOS
- [ ] Port input handling to SDL2 APIs
- [ ] Convert Windows file paths to Unix
- [ ] Replace Windows registry with config files
- [ ] Update CMakeLists.txt for macOS target
- [ ] Handle macOS app bundle structure
- [ ] Implement platform detection (#ifdef __APPLE__)

#### Phase 4: Integration (Week 9-10)
- [ ] Test Carbon theme rendering
- [ ] Verify theme animations and transitions
- [ ] Test content downloader functionality
- [ ] Test scraper integration
- [ ] Verify emulator launching interface
- [ ] Test configuration system
- [ ] Validate controller input

#### Phase 5: Polish (Week 10-11)
- [ ] Optimize for Apple Silicon (Metal)
- [ ] Performance tuning for 60 FPS UI
- [ ] Apply macOS UI/UX conventions
- [ ] Code signing preparation
- [ ] Bug fixes and refinements
- [ ] Documentation

### Dependencies
- Homebrew (for installing libraries)
- CMake 3.x
- SDL2, Boost, FreeImage, FreeType, Eigen3, cURL

### Acceptance Criteria
- RetroBat EmulationStation compiles and runs on macOS
- All RetroBat themes work identically to Windows
- Content downloader functional
- Scraper works correctly
- Controller input works
- Emulator launching works
- Performance acceptable (60 FPS UI on M1/M2)
- No feature regressions from Windows version

### Resources
- RetroBat ES: https://github.com/RetroBat-Official/emulationstation
- Batocera ES: https://github.com/batocera-linux/batocera-emulationstation
- SDL2 Docs: https://wiki.libsdl.org/SDL2/

### Timeline
**Estimated Duration**: 7 weeks (Week 5-11)
**Complexity**: High (C++ porting, graphics API migration)
**Priority**: Critical (blocks all UI functionality)'

# Issue 5: Port emulatorLauncher to .NET 6+
echo "Creating Issue #5: Port emulatorLauncher to .NET 6+..."
gh issue create \
  --repo "$REPO" \
  --title "Migrate emulatorLauncher from .NET Framework to .NET 6+ for macOS Support" \
  --label "macos,porting,emulatorlauncher,critical" \
  --body '## Description

Port the emulatorLauncher C# application to .NET 6+ to enable cross-platform support for macOS Apple Silicon.

### Current State
- Written in C# for .NET Framework (Windows-only)
- Uses XInput/DirectInput for controllers
- Windows-specific process management

### Tasks
- [ ] Clone emulatorLauncher source from upstream
- [ ] Analyze code for Windows dependencies
- [ ] Create .NET 6+ solution/project files
- [ ] Migrate core launcher functionality
- [ ] Replace controller input system
  - Remove XInput/DirectInput dependencies
  - Implement SDL3 controller support
- [ ] Update process management for cross-platform
- [ ] Handle macOS app bundles (.app directories)
- [ ] Update file path handling
- [ ] Add platform detection and platform-specific code paths
- [ ] Test with RetroArch on macOS
- [ ] Test with standalone emulators
- [ ] Create unit tests
- [ ] Document code changes

### Technical Challenges
1. **Controller Input**: Replace Windows APIs with SDL2/SDL3
2. **Process Management**: Cross-platform process spawning
3. **App Bundles**: Handle .app structure on macOS
4. **Configuration**: Platform-specific config paths

### Acceptance Criteria
- emulatorLauncher compiles on macOS
- Can launch RetroArch with correct parameters
- Controller configuration works
- Process monitoring and cleanup functions
- Compatible with existing configuration format

### Dependencies
- Issue #3 (SDL2/SDL3 framework)
- Issue #4 (EmulationStation port)

### Resources
- Upstream: https://github.com/RetroBat-Official/emulatorlauncher
- SDL3 GameController API: https://wiki.libsdl.org/SDL3/CategoryGamepad

### Priority
Critical'

# Issue 6: Update Configuration Files for macOS Paths
echo "Creating Issue #6: Update Configuration Files for macOS Paths..."
gh issue create \
  --repo "$REPO" \
  --title "Convert All Configuration Files from Windows to macOS Path Format" \
  --label "macos,configuration,paths" \
  --body '## Description

Update all configuration files to use Unix-style paths and macOS environment variables.

### Scope
- `system/templates/emulationstation/` - All EmulationStation configs
- `system/templates/retroarch/` - RetroArch configs
- `system/templates/*/` - All emulator-specific configs
- `system/configgen/` - Configuration generation files

### Changes Required
1. Path separators: `\` → `/`
2. Environment variables: `%HOME%` → `$HOME`
3. User profile: `%USERPROFILE%` → `$HOME`
4. Drive letters: Remove `C:\` style paths
5. Executable extensions: `.exe` → remove or platform-detect

### Tasks
- [ ] Create automated conversion script
- [ ] Run script on all template files
- [ ] Manually verify critical configuration files
- [ ] Test with actual emulators
- [ ] Update es_systems.cfg
- [ ] Update es_padtokey.cfg
- [ ] Update retroarch.cfg
- [ ] Create platform-specific config directories
- [ ] Document configuration system

### Acceptance Criteria
- All configuration files use Unix paths
- macOS environment variables used correctly
- Configurations tested with actual emulators
- No Windows-specific paths remaining
- Script documented and reusable

### Priority
High'

# Issue 7: RetroArch Integration for macOS
echo "Creating Issue #7: RetroArch Integration for macOS..."
gh issue create \
  --repo "$REPO" \
  --title "Integrate RetroArch for macOS Apple Silicon" \
  --label "macos,retroarch,emulator" \
  --body '## Description

Integrate RetroArch for macOS as the primary multi-system emulator.

### Tasks
- [ ] Identify official RetroArch macOS builds
- [ ] Update build.ini with macOS RetroArch URL
- [ ] Download and test RetroArch on Apple Silicon
- [ ] Configure default RetroArch settings
- [ ] Download and configure libretro cores
- [ ] Test major systems (NES, SNES, Genesis, PS1)
- [ ] Configure shaders for macOS
- [ ] Test controller input
- [ ] Setup core info files
- [ ] Document RetroArch configuration

### Test Systems
- Nintendo Entertainment System (NES)
- Super Nintendo (SNES)
- Sega Genesis
- PlayStation 1
- Game Boy / Game Boy Color
- Game Boy Advance

### Acceptance Criteria
- RetroArch launches on macOS
- All test systems work
- Controllers properly configured
- Save states functional
- Shaders working
- Performance acceptable on M1/M2

### Resources
- RetroArch Buildbot: https://buildbot.libretro.com/
- RetroArch Docs: https://docs.libretro.com/

### Priority
High'

# Issue 8: Map macOS-Compatible Emulators
echo "Creating Issue #8: Map macOS-Compatible Emulators..."
gh issue create \
  --repo "$REPO" \
  --title "Create Emulator Compatibility Matrix for macOS" \
  --label "macos,emulators,documentation,research" \
  --body '## Description

Research and document which emulators have macOS versions and create a compatibility matrix.

### Tasks
- [ ] Audit all emulators in emulators_names.lst
- [ ] Research macOS availability for each
- [ ] Document native vs. unavailable emulators
- [ ] Create compatibility matrix document
- [ ] Find alternatives for unavailable emulators
- [ ] Update emulatorLauncher with macOS paths
- [ ] Download and test top 20 emulators
- [ ] Document installation paths
- [ ] Create emulator download script

### Emulator Categories
1. **Native macOS Support** - Has official macOS build
2. **LibRetro Core** - Available through RetroArch
3. **No Support** - Windows-only, no alternative
4. **Alternative Available** - Different emulator for same system

### Priority Emulators
1. RetroArch (multi-system)
2. Dolphin (GameCube/Wii)
3. PCSX2 (PlayStation 2)
4. Citra (3DS)
5. Cemu (Wii U)
6. DuckStation (PS1)
7. RPCS3 (PS3)
8. MAME (Arcade)
9. DOSBox (DOS)
10. PPSSPP (PSP)

### Deliverables
- `MACOS_EMULATOR_COMPATIBILITY.md`
- Updated emulator path mappings
- Download script for macOS emulators

### Acceptance Criteria
- Complete compatibility matrix
- Top 20 emulators tested
- Alternatives identified for incompatible systems
- Documentation complete

### Priority
Medium'

# Issue 9: Create macOS Installer Package
echo "Creating Issue #9: Create macOS Installer Package..."
gh issue create \
  --repo "$REPO" \
  --title "Create .dmg and .pkg Installers for macOS" \
  --label "macos,installer,distribution" \
  --body '## Description

Create proper macOS installation packages for RetroBat distribution.

### Tasks
- [ ] Design app bundle structure
- [ ] Create Info.plist
- [ ] Create app icon (.icns)
- [ ] Setup folder layout
- [ ] Create installation script
- [ ] Build .dmg disk image
  - Design DMG background
  - Add applications folder symlink
  - Configure window layout
- [ ] Build .pkg installer package
  - Define installation locations
  - Create pre/post install scripts
  - Setup launch agents if needed
- [ ] Test installation process
- [ ] Document installation steps

### Acceptance Criteria
- .dmg installs via drag-and-drop
- .pkg installs correctly
- App launches after installation
- All resources accessible
- Uninstallation clean

### Tools
- `hdiutil` for DMG creation
- `pkgbuild` for package creation
- `productbuild` for distribution package

### Priority
Medium'

# Issue 10: Implement Code Signing and Notarization
echo "Creating Issue #10: Implement Code Signing and Notarization..."
gh issue create \
  --repo "$REPO" \
  --title "Setup Code Signing and Notarization for macOS Distribution" \
  --label "macos,security,distribution" \
  --body '## Description

Implement Apple code signing and notarization to allow distribution outside Mac App Store.

### Requirements
- Apple Developer account
- Developer ID Application certificate
- Developer ID Installer certificate

### Tasks
- [ ] Obtain Apple Developer ID
- [ ] Generate certificates
- [ ] Configure signing in build script
- [ ] Sign all binaries and frameworks
- [ ] Sign app bundle
- [ ] Submit for notarization
- [ ] Staple notarization ticket
- [ ] Test on clean Mac
- [ ] Document signing process
- [ ] Setup CI/CD signing (if applicable)

### Acceptance Criteria
- App successfully signed
- Notarization approved by Apple
- Launches without security warnings
- Gatekeeper acceptance verified
- Process documented

### Resources
- https://developer.apple.com/documentation/security/notarizing_macos_software_before_distribution

### Priority
Medium'

# Issue 11: Create Build Automation Script for macOS
echo "Creating Issue #11: Create Build Automation Script..."
gh issue create \
  --repo "$REPO" \
  --title "Implement Automated Build System for macOS Releases" \
  --label "macos,build-system,automation" \
  --body '## Description

Create comprehensive build script to automate the entire macOS build process.

### Tasks
- [ ] Create main build script (build-macos.sh)
- [ ] Implement dependency checking
- [ ] Add .NET project building
- [ ] Add resource downloading
- [ ] Add file organization
- [ ] Add signing integration
- [ ] Add DMG creation
- [ ] Add PKG creation
- [ ] Add build verification
- [ ] Create CI/CD GitHub Actions workflow
- [ ] Document build process

### Acceptance Criteria
- Build runs from scratch successfully
- All components included in output
- Signing works (with credentials)
- CI/CD pipeline functional
- Build reproducible
- Documentation complete

### Priority
Medium'

# Issue 12: Controller Support Testing and Configuration
echo "Creating Issue #12: Controller Support Testing..."
gh issue create \
  --repo "$REPO" \
  --title "Implement and Test Controller Support for macOS" \
  --label "macos,controllers,testing" \
  --body '## Description

Ensure controller support works properly on macOS using SDL3.

### Controllers to Test
- Xbox Series X/S Controller (USB)
- Xbox Series X/S Controller (Bluetooth)
- PlayStation 5 DualSense (USB)
- PlayStation 5 DualSense (Bluetooth)
- Nintendo Switch Pro Controller
- 8BitDo Controllers
- Generic USB controllers

### Tasks
- [ ] Implement SDL3 controller detection
- [ ] Test controller connectivity (USB)
- [ ] Test controller connectivity (Bluetooth)
- [ ] Configure button mappings
- [ ] Test in EmulationStation
- [ ] Test in RetroArch
- [ ] Test in standalone emulators
- [ ] Create controller configuration guide
- [ ] Document known issues
- [ ] Create troubleshooting guide

### Testing Checklist
For each controller:
- [ ] Detection in ES
- [ ] Button mapping
- [ ] Analog sticks
- [ ] Triggers
- [ ] D-pad
- [ ] Rumble support
- [ ] Disconnection handling

### Acceptance Criteria
- Major controllers work out of box
- Button mapping intuitive
- Configuration persists
- Troubleshooting documented

### Priority
High'

# Issue 13: Documentation for macOS Users
echo "Creating Issue #13: Documentation for macOS Users..."
gh issue create \
  --repo "$REPO" \
  --title "Create Comprehensive macOS User Documentation" \
  --label "macos,documentation" \
  --body '## Description

Create complete documentation for macOS users.

### Documents to Create

#### 1. INSTALL_MACOS.md
- System requirements
- Installation steps
- First-time setup
- ROM organization
- BIOS files

#### 2. MACOS_USER_GUIDE.md
- EmulationStation navigation
- Adding games
- Controller configuration
- Emulator settings
- Themes and customization

#### 3. TROUBLESHOOTING_MACOS.md
- Common issues
- Performance problems
- Controller issues
- Emulator-specific problems
- Crash debugging

#### 4. MACOS_FAQ.md
- Frequently asked questions
- Compatibility questions
- Performance optimization
- Feature requests

### Tasks
- [ ] Write INSTALL_MACOS.md
- [ ] Write MACOS_USER_GUIDE.md
- [ ] Write TROUBLESHOOTING_MACOS.md
- [ ] Write MACOS_FAQ.md
- [ ] Update main README.md
- [ ] Add screenshots
- [ ] Create video tutorial (optional)
- [ ] Review with beta testers

### Acceptance Criteria
- All documents complete
- Screenshots included
- Clear and beginner-friendly
- Technical details accurate
- Searchable/indexed

### Priority
High'

# Issue 14: Performance Testing and Optimization
echo "Creating Issue #14: Performance Testing and Optimization..."
gh issue create \
  --repo "$REPO" \
  --title "Test and Optimize Performance on Apple Silicon" \
  --label "macos,performance,testing" \
  --body '## Description

Ensure RetroBat performs well on Apple Silicon Macs.

### Testing Areas
1. EmulationStation UI performance
2. RetroArch performance
3. Standalone emulator performance
4. Memory usage
5. Battery impact (laptops)
6. Thermal performance

### Test Hardware
- Mac Mini M1
- MacBook Pro M1/M2
- Mac Studio M1 Max/Ultra
- iMac M3

### Tasks
- [ ] Benchmark EmulationStation scrolling
- [ ] Test RetroArch core performance
- [ ] Profile memory usage
- [ ] Test battery life impact
- [ ] Monitor thermal behavior
- [ ] Identify bottlenecks
- [ ] Implement optimizations
- [ ] Retest after optimizations
- [ ] Document performance characteristics
- [ ] Create performance guide

### Performance Metrics
- ES menu scrolling: 60 FPS minimum
- RetroArch emulation: Full speed for supported systems
- Memory usage: < 1GB for ES, reasonable for emulators
- Battery impact: Documented per system

### Acceptance Criteria
- Performance meets or exceeds expectations
- No major bottlenecks
- Battery usage reasonable
- Performance documented

### Priority
Medium'

# Issue 15: Beta Testing Program
echo "Creating Issue #15: Beta Testing Program..."
gh issue create \
  --repo "$REPO" \
  --title "Organize Beta Testing for macOS Release" \
  --label "macos,testing,community" \
  --body '## Description

Setup and run beta testing program before public release.

### Tasks
- [ ] Define beta testing goals
- [ ] Create beta testing guide
- [ ] Recruit beta testers (10-20 people)
- [ ] Create feedback form/template
- [ ] Distribute beta build
- [ ] Monitor and collect feedback
- [ ] Triage and fix reported issues
- [ ] Run second beta round if needed
- [ ] Document common issues
- [ ] Update documentation based on feedback
- [ ] Thank beta testers

### Beta Testing Focus Areas
1. Installation process
2. First-time setup experience
3. Controller configuration
4. Emulator compatibility
5. Performance on various hardware
6. Documentation clarity
7. Overall user experience

### Beta Tester Requirements
- macOS Ventura or later
- Apple Silicon Mac
- Various controllers
- Willing to provide detailed feedback
- Available for 2-4 weeks

### Deliverables
- Beta testing report
- Issue list with priorities
- Updated documentation
- Improved user experience

### Acceptance Criteria
- At least 10 beta testers participate
- Major issues identified and fixed
- Documentation validated
- User experience refined
- Ready for public release

### Priority
Medium'

# Issue 16: Update Main README for macOS Support
echo "Creating Issue #16: Update Main README for macOS Support..."
gh issue create \
  --repo "$REPO" \
  --title "Update README.md to Include macOS Support" \
  --label "macos,documentation" \
  --body '## Description

Update the main README.md to properly reflect macOS support.

### Changes Required
- [ ] Update system requirements section
- [ ] Add macOS to supported platforms
- [ ] Update dependencies section
- [ ] Add macOS installation instructions
- [ ] Update screenshots (if showing UI)
- [ ] Add macOS-specific notes
- [ ] Update download links
- [ ] Add badge for macOS support

### Acceptance Criteria
- README clearly shows macOS support
- Installation instructions accurate
- Links functional
- Professional appearance

### Priority
High'

# Issue 17: Create Release Notes for macOS Version
echo "Creating Issue #17: Create Release Notes for macOS Version..."
gh issue create \
  --repo "$REPO" \
  --title "Prepare Release Notes for First macOS Release" \
  --label "macos,documentation,release" \
  --body '## Description

Create comprehensive release notes for the first macOS version.

### Content
- Overview of macOS port
- System requirements
- Installation instructions
- Known issues
- Emulator compatibility list
- Controller support status
- Performance notes
- What'\''s different from Windows
- Future plans
- Credits and acknowledgments

### Tasks
- [ ] Write release announcement
- [ ] List all features
- [ ] Document known limitations
- [ ] Create compatibility table
- [ ] Add screenshots
- [ ] Prepare FAQ
- [ ] Plan release schedule
- [ ] Coordinate with team

### Format
- Markdown for GitHub release
- HTML for website
- Plain text for email
- Social media posts

### Acceptance Criteria
- Complete and accurate information
- Professional tone
- Exciting for community
- Clear about limitations
- Ready for publication

### Priority
Low'

echo ""
echo "✅ All 17 issues have been created successfully!"
echo ""
echo "You can view them at: https://github.com/$REPO/issues"
