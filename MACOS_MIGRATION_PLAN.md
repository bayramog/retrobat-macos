# RetroBat macOS Apple Silicon Migration Plan

## Executive Summary

This document outlines the comprehensive plan to port RetroBat from Windows to macOS Apple Silicon (M1/M2/M3). RetroBat is currently a Windows-only application that provides a unified frontend for retro gaming emulators using EmulationStation.

## Current Architecture Analysis

### Core Components
1. **RetroBuild.exe** - C# .NET build tool for assembling RetroBat distribution
2. **InstallerHost.exe** - Windows installer executable
3. **EmulationStation** - Frontend UI (uses Windows build)
4. **emulatorLauncher** - C# .NET application to launch emulators
5. **System tools** - Windows binaries (7za.exe, wget.exe, curl.exe)
6. **Configuration files** - Windows-specific paths and settings

### Windows-Specific Dependencies
- .NET Framework / Mono .NET
- Visual C++ Redistributables (2010, 2015, 2017, 2019)
- DirectX
- Windows paths (`C:\`, `%HOME%`, backslashes)
- Windows executables (.exe files)
- XInput/DirectInput for controllers
- Windows-specific emulator builds

## Migration Strategy

### Phase 1: Foundation & Planning (Week 1-2)

#### 1.1 Platform Requirements Research
**Goal**: Identify all macOS alternatives and requirements

**Tasks**:
- Research .NET Core/.NET 6+ cross-platform capabilities
- Identify macOS-compatible versions of all emulators
- Research SDL3 for controller support on macOS
- Investigate macOS app bundling and signing requirements

**Deliverables**:
- Platform compatibility matrix
- Dependency mapping document
- Architecture decision records

#### 1.2 Repository Structure Planning
**Goal**: Plan new directory structure for cross-platform support

**Proposed Structure**:
```
retrobat-macos/
├── build/
│   ├── windows/        # Windows-specific build scripts
│   ├── macos/          # macOS-specific build scripts
│   └── common/         # Shared build logic
├── installers/
│   ├── windows/        # Windows installer resources
│   └── macos/          # macOS .pkg/.dmg resources
├── src/
│   ├── RetroBuild/     # Build tool source (migrate to .NET 6+)
│   └── EmulatorLauncher/ # Launcher source (from upstream)
└── system/
    ├── configs/
    │   ├── windows/
    │   └── macos/
    └── tools/
        ├── windows/
        └── macos/
```

### Phase 2: Development Environment Setup (Week 2-3)

#### 2.1 macOS Development Prerequisites
**Tasks**:
- Setup .NET 6+ SDK on macOS
- Install Xcode and Command Line Tools
- Setup Homebrew for package management
- Configure Visual Studio Code or Rider for .NET development

#### 2.2 Build System Migration
**Goal**: Port RetroBuild.exe to cross-platform .NET

**Migration Steps**:
1. Analyze current RetroBuild.exe source code
2. Migrate to .NET 6+ (cross-platform)
3. Replace Windows-specific APIs:
   - File operations: Use `Path.Combine()` instead of string concatenation
   - Process execution: Ensure cross-platform process spawning
   - Network operations: Verify HttpClient compatibility
4. Implement platform detection (`RuntimeInformation.IsOSPlatform()`)
5. Create platform-specific build logic

**Code Changes Required**:
```csharp
// Replace:
string path = baseDir + "\\" + filename;

// With:
string path = Path.Combine(baseDir, filename);

// Add platform detection:
if (RuntimeInformation.IsOSPlatform(OSPlatform.OSX))
{
    // macOS-specific logic
}
else if (RuntimeInformation.IsOSPlatform(OSPlatform.Windows))
{
    // Windows-specific logic
}
```

### Phase 3: System Tools Replacement (Week 3-4)

#### 3.1 Binary Tools Migration
**Tasks**:
- Replace `7za.exe` with `7z` macOS binary or native tools
- Remove `wget.exe` and `curl.exe` (use native macOS versions)
- Port or find SDL3 framework for macOS
- Update `build.ini` with platform-specific tool paths

**Tool Mapping**:
| Windows Tool | macOS Alternative | Installation |
|--------------|-------------------|--------------|
| 7za.exe | 7z | `brew install p7zip` |
| wget.exe | wget | `brew install wget` or use curl |
| curl.exe | curl | Built-in to macOS |
| SDL3.dll | SDL3.framework | `brew install sdl3` |

#### 3.2 Path Handling Updates
**Goal**: Replace all Windows-specific paths

**Changes Required**:
1. Update `system/configgen/` configuration files
2. Replace `\` with `/` in all path references
3. Replace `%HOME%` with `$HOME` or `${HOME}`
4. Replace `%USERPROFILE%` with `$HOME`
5. Update path resolution in configuration parsers

**File Updates**:
- `system/templates/emulationstation/es_systems.cfg`
- `system/templates/emulationstation/es_padtokey.cfg`
- All emulator configuration templates
- `build.ini`

### Phase 4: EmulationStation Port (Week 4-6)

#### 4.1 EmulationStation Evaluation
**Options**:
1. **EmulationStation Desktop Edition (ES-DE)** - Recommended
   - Already cross-platform (Windows, Linux, macOS)
   - Active development
   - Native Apple Silicon support
   - URL: https://es-de.org/

2. **Port RetroBat's EmulationStation fork**
   - More work required
   - May need significant modifications

**Recommendation**: Use ES-DE as base and adapt RetroBat's configurations

#### 4.2 EmulationStation Configuration
**Tasks**:
1. Download ES-DE for macOS
2. Adapt `es_systems.cfg` for macOS:
   - Update command paths
   - Replace Windows executables with macOS equivalents
   - Adjust ROM paths to macOS conventions
3. Test theme compatibility (Carbon theme)
4. Verify controller configuration

**Example Configuration Change**:
```xml
<!-- Windows -->
<command>"%HOME%\emulatorLauncher.exe" -system %SYSTEM% -rom %ROM%</command>

<!-- macOS -->
<command>"$HOME/emulatorLauncher" -system %SYSTEM% -rom %ROM%</command>
```

### Phase 5: EmulatorLauncher Migration (Week 6-8)

#### 5.1 EmulatorLauncher Architecture
**Current**: C# .NET Framework (Windows-only)
**Target**: .NET 6+ (cross-platform)

**Migration Steps**:
1. Clone emulatorLauncher source from upstream
2. Update project files to target .NET 6+
3. Replace Windows-specific APIs:
   - Controller input (XInput → SDL3)
   - Process management
   - File system operations
4. Implement macOS-specific features

#### 5.2 Controller Support Migration
**Windows**: XInput, DirectInput
**macOS**: SDL3, IOKit

**Implementation**:
```csharp
// Use SDL3 for cross-platform controller support
// Reference: SDL_GameController API
// Ensure controller detection works on macOS
```

#### 5.3 Process Management
**Tasks**:
- Replace Windows process spawning with cross-platform `Process.Start()`
- Update process monitoring for macOS
- Handle macOS app bundles (.app directories) properly
- Implement proper process cleanup

### Phase 6: Emulator Compatibility (Week 8-10)

#### 6.1 Emulator Inventory
**Categories**:
1. **Native macOS Support**: RetroArch, Dolphin, PCSX2, Citra, etc.
2. **Requires Porting**: Windows-only emulators
3. **Not Compatible**: Emulators with no macOS equivalent

#### 6.2 RetroArch Integration
**Tasks**:
- Download RetroArch for macOS (Apple Silicon)
- Update build.ini with macOS RetroArch URL
- Configure RetroArch cores for macOS
- Test controller configuration
- Verify shaders and graphics settings

**URL Update**:
```ini
# build.ini
retroarch_url_macos=https://buildbot.libretro.com/stable/1.19.1/apple/osx/arm64/RetroArch.dmg
```

#### 6.3 Standalone Emulators
**High Priority Emulators**:
| Emulator | System | macOS Support | Status |
|----------|--------|---------------|--------|
| RetroArch | Multi | ✅ Native | Ready |
| Dolphin | GC/Wii | ✅ Native | Ready |
| PCSX2 | PS2 | ✅ Native | Ready |
| Citra | 3DS | ✅ Native | Ready |
| Cemu | Wii U | ✅ Native | Ready |
| DuckStation | PS1 | ✅ Native | Ready |
| RPCS3 | PS3 | ✅ Native | Ready |
| MAME | Arcade | ✅ Native | Ready |
| DOSBox | DOS | ✅ Native | Ready |

**Update Configuration**:
- Create macOS emulator path mappings
- Update `emulators_names.lst` with macOS paths
- Configure launch commands for .app bundles

### Phase 7: Configuration Files Migration (Week 10-11)

#### 7.1 Batch Processing
**Goal**: Update all configuration files for macOS

**Script Required**:
```bash
#!/bin/bash
# Convert Windows paths to Unix paths
find system/templates -type f -exec sed -i '' 's/\\/\//g' {} \;
find system/templates -type f -exec sed -i '' 's/%HOME%/$HOME/g' {} \;
find system/templates -type f -exec sed -i '' 's/%USERPROFILE%/$HOME/g' {} \;
```

#### 7.2 File-by-File Updates
**Critical Files**:
- `system/templates/emulationstation/es_systems.cfg`
- `system/templates/emulationstation/es_padtokey.cfg`
- `system/templates/retroarch/retroarch.cfg`
- All emulator-specific configs in `system/templates/`

### Phase 8: Installer Creation (Week 11-12)

#### 8.1 macOS Packaging Options
**Option 1: .dmg (Disk Image)**
- Drag-and-drop installation
- No admin rights required
- Easy distribution

**Option 2: .pkg (Installer Package)**
- More control over installation
- Can install to system directories
- Better for dependencies

**Recommendation**: Create both formats

#### 8.2 App Bundle Structure
**Goal**: Create proper macOS app bundle

**Structure**:
```
RetroBat.app/
├── Contents/
│   ├── Info.plist
│   ├── MacOS/
│   │   ├── RetroBat (launcher script)
│   │   └── emulatorLauncher
│   ├── Resources/
│   │   ├── retrobat.icns
│   │   ├── system/
│   │   ├── bios/
│   │   └── roms/
│   └── Frameworks/
│       └── SDL3.framework
```

#### 8.3 Code Signing
**Requirements**:
- Apple Developer account (for distribution)
- Certificates and provisioning profiles
- Notarization for macOS 10.15+

**Steps**:
1. Create signing certificate
2. Sign all binaries and frameworks
3. Notarize the app
4. Staple the notarization ticket

### Phase 9: Build Automation (Week 12-13)

#### 9.1 Build Script
**Goal**: Create automated macOS build process

**Script**: `build-macos.sh`
```bash
#!/bin/bash
set -e

echo "Building RetroBat for macOS..."

# Configuration
VERSION="8.0.0"
ARCH="arm64"  # Apple Silicon

# Create directories
mkdir -p build/macos/RetroBat.app/Contents/{MacOS,Resources,Frameworks}

# Build .NET components
dotnet publish src/RetroBuild -c Release -r osx-${ARCH}
dotnet publish src/EmulatorLauncher -c Release -r osx-${ARCH}

# Download dependencies
./scripts/download-retroarch-macos.sh
./scripts/download-emulators-macos.sh

# Copy resources
cp -r system build/macos/RetroBat.app/Contents/Resources/
cp -r bios build/macos/RetroBat.app/Contents/Resources/

# Create Info.plist
./scripts/create-info-plist.sh

# Sign the app
codesign --deep --force --verify --verbose --sign "Developer ID Application" build/macos/RetroBat.app

# Create DMG
./scripts/create-dmg.sh

echo "Build complete: build/macos/RetroBat-${VERSION}-macOS-${ARCH}.dmg"
```

#### 9.2 Dependency Management
**Tasks**:
- Create Brewfile for dependencies
- Document manual installation steps
- Create setup verification script

**Brewfile**:
```ruby
# Brewfile
brew "p7zip"
brew "wget"
brew "sdl3"
brew "dotnet"
```

### Phase 10: Testing (Week 13-14)

#### 10.1 Test Plan
**Test Categories**:
1. Installation testing
2. EmulationStation UI testing
3. Emulator launching testing
4. Controller input testing
5. Configuration persistence testing
6. Update mechanism testing

#### 10.2 Hardware Testing
**Required Hardware**:
- Mac with M1 chip (minimum)
- Mac with M2/M3 chip (optimal)
- Various USB controllers (Xbox, PlayStation, etc.)
- Bluetooth controllers

#### 10.3 Compatibility Testing
**Test Matrix**:
| macOS Version | M1 | M2 | M3 | Status |
|---------------|----|----|----|----|
| Ventura 13.x  | ✅ | ✅ | ✅ | |
| Sonoma 14.x   | ✅ | ✅ | ✅ | |
| Sequoia 15.x  | ✅ | ✅ | ✅ | |

### Phase 11: Documentation (Week 14-15)

#### 11.1 User Documentation
**Documents to Create**:
1. `INSTALL_MACOS.md` - macOS installation guide
2. `MACOS_COMPATIBILITY.md` - Emulator compatibility list
3. `TROUBLESHOOTING_MACOS.md` - Common issues and solutions
4. Update `README.md` with macOS information

#### 11.2 Developer Documentation
**Documents to Create**:
1. `BUILDING_MACOS.md` - Build instructions for developers
2. `ARCHITECTURE_MACOS.md` - Technical architecture overview
3. `PORTING_GUIDE.md` - Guide for porting additional features

### Phase 12: Release & Distribution (Week 15-16)

#### 12.1 Release Preparation
**Checklist**:
- [ ] All tests passing
- [ ] Documentation complete
- [ ] Code signed and notarized
- [ ] Release notes prepared
- [ ] Download URLs verified
- [ ] Beta testing complete

#### 12.2 Distribution Channels
**Primary**:
- GitHub Releases (main distribution)
- Direct download from website

**Future**:
- Homebrew Cask (homebrew-cask PR)
- MacPorts (port submission)

## Technical Challenges & Solutions

### Challenge 1: .NET Compatibility
**Issue**: Original code uses .NET Framework (Windows-only)
**Solution**: Migrate to .NET 6+ which is fully cross-platform

### Challenge 2: Controller Input
**Issue**: XInput/DirectInput are Windows-specific
**Solution**: Use SDL3 for cross-platform controller support

### Challenge 3: EmulationStation Build
**Issue**: No official macOS build of RetroBat's EmulationStation
**Solution**: Use EmulationStation Desktop Edition (ES-DE)

### Challenge 4: Path Handling
**Issue**: Thousands of Windows paths in config files
**Solution**: Automated sed scripts + manual verification

### Challenge 5: Emulator Compatibility
**Issue**: Some emulators don't have macOS versions
**Solution**: Document incompatible emulators, provide alternatives

### Challenge 6: Code Signing
**Issue**: macOS requires signed apps for distribution
**Solution**: Setup Developer ID, implement signing in build process

## Risk Assessment

### High Risk
1. **emulatorLauncher complexity** - May have deep Windows dependencies
   - Mitigation: Evaluate early, consider rewrite if necessary
2. **Emulator compatibility** - Some emulators may not work
   - Mitigation: Focus on popular emulators first

### Medium Risk
1. **Configuration migration** - Many files to update
   - Mitigation: Automated scripts with validation
2. **Controller support** - SDL3 may have different behavior
   - Mitigation: Extensive testing with multiple controllers

### Low Risk
1. **Build tools** - .NET 6+ is proven cross-platform
   - Mitigation: Standard migration path
2. **File paths** - Straightforward string replacement
   - Mitigation: Automated with testing

## Success Criteria

### Minimum Viable Product (MVP)
- [ ] RetroBat launches on macOS Apple Silicon
- [ ] EmulationStation UI functional
- [ ] RetroArch integration working
- [ ] Top 10 emulators functional
- [ ] Controller support working
- [ ] Installation via .dmg

### Full Release
- [ ] All testable emulators working
- [ ] Complete documentation
- [ ] Code signed and notarized
- [ ] CI/CD pipeline for macOS
- [ ] Community beta testing successful
- [ ] Performance on par with Windows version

## Timeline Summary

| Phase | Duration | Deliverable |
|-------|----------|-------------|
| Planning | 2 weeks | Migration plan, architecture docs |
| Dev Setup | 1 week | Working dev environment |
| System Tools | 1 week | macOS tool replacements |
| EmulationStation | 2 weeks | ES-DE integration |
| EmulatorLauncher | 2 weeks | Cross-platform launcher |
| Emulator Compat | 2 weeks | Major emulators working |
| Config Files | 1 week | All configs updated |
| Installer | 1 week | .dmg and .pkg creation |
| Build Automation | 1 week | Automated build process |
| Testing | 1 week | Comprehensive testing |
| Documentation | 1 week | User and dev docs |
| Release | 1 week | Public release |
| **Total** | **~16 weeks** | **RetroBat for macOS** |

## Next Steps

1. **Immediate (This Week)**:
   - Create GitHub issues for each major task
   - Setup macOS development environment
   - Clone emulatorLauncher source
   - Begin .NET 6+ migration research

2. **Short Term (Next 2 Weeks)**:
   - Start RetroBuild migration
   - Evaluate ES-DE integration
   - Create proof-of-concept build

3. **Medium Term (Next Month)**:
   - Complete emulatorLauncher port
   - Integrate RetroArch
   - Test with major emulators

4. **Long Term (Next 3 Months)**:
   - Beta testing program
   - Complete all emulator integrations
   - Public release

## Resources

### Documentation
- .NET 6+ Cross-Platform: https://docs.microsoft.com/en-us/dotnet/core/
- SDL3 Documentation: https://wiki.libsdl.org/SDL3/
- EmulationStation-DE: https://es-de.org/
- macOS App Distribution: https://developer.apple.com/distribution/

### Code Repositories
- emulatorLauncher: https://github.com/RetroBat-Official/emulatorlauncher
- EmulationStation: https://github.com/RetroBat-Official/emulationstation
- ES-DE: https://gitlab.com/es-de/emulationstation-de

### Community
- RetroBat Discord: https://discord.gg/GVcPNxwzuT
- RetroBat Forum: https://social.retrobat.org/forum

## Conclusion

This migration is a significant undertaking but entirely feasible. The key success factors are:
1. Leveraging existing cross-platform tools (.NET 6+, SDL3, ES-DE)
2. Systematic approach to configuration migration
3. Focus on emulator compatibility
4. Thorough testing on Apple Silicon

With proper planning and execution, RetroBat can provide an excellent retro gaming experience on macOS Apple Silicon.
