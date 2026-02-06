# RetroBat Architecture Overview

## Current Windows Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                     User Interface Layer                     │
│                                                               │
│  ┌────────────────────────────────────────────────────┐    │
│  │         EmulationStation Frontend (C++/SDL)        │    │
│  │  - Game library browsing                           │    │
│  │  - Theme system                                    │    │
│  │  - Controller input                                │    │
│  │  - Settings management                             │    │
│  └────────────────────────────────────────────────────┘    │
└───────────────────────────┬─────────────────────────────────┘
                            │
                            │ Command execution
                            │
┌───────────────────────────▼─────────────────────────────────┐
│                    Launcher Layer (C# .NET)                  │
│                                                               │
│  ┌────────────────────────────────────────────────────┐    │
│  │              emulatorLauncher.exe                  │    │
│  │  - Parse game/system information                   │    │
│  │  - Configure emulator settings                     │    │
│  │  - Map controllers (XInput/DirectInput)            │    │
│  │  - Start emulator process                          │    │
│  │  - Monitor and manage process                      │    │
│  └────────────────────────────────────────────────────┘    │
└───────────────────────────┬─────────────────────────────────┘
                            │
                            │ Process spawning
                            │
┌───────────────────────────▼─────────────────────────────────┐
│                     Emulator Layer                           │
│                                                               │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐     │
│  │  RetroArch   │  │   Dolphin    │  │   PCSX2      │     │
│  │  (libretro)  │  │  (GC/Wii)    │  │   (PS2)      │     │
│  └──────────────┘  └──────────────┘  └──────────────┘     │
│                                                               │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐     │
│  │    MAME      │  │     Cemu     │  │   RPCS3      │     │
│  │  (Arcade)    │  │   (Wii U)    │  │   (PS3)      │     │
│  └──────────────┘  └──────────────┘  └──────────────┘     │
│                                                               │
│               ... 50+ more emulators ...                     │
└─────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────┐
│                    Build/Installation Layer                  │
│                                                               │
│  ┌────────────────────────────────────────────────────┐    │
│  │              RetroBuild.exe (C# .NET)              │    │
│  │  - Download emulators and cores                    │    │
│  │  - Extract archives                                │    │
│  │  - Configure system files                          │    │
│  │  - Create directory structure                      │    │
│  └────────────────────────────────────────────────────┘    │
│                                                               │
│  ┌────────────────────────────────────────────────────┐    │
│  │           InstallerHost.exe (Installer)            │    │
│  │  - Windows installer package                       │    │
│  │  - Install dependencies (VC++, DirectX)            │    │
│  │  - Create shortcuts                                │    │
│  └────────────────────────────────────────────────────┘    │
└─────────────────────────────────────────────────────────────┘
```

## Target macOS Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                     User Interface Layer                     │
│                                                               │
│  ┌────────────────────────────────────────────────────┐    │
│  │   RetroBat EmulationStation (Ported C++/SDL2)      │    │
│  │  - Game library browsing                           │    │
│  │  - Advanced theme system (full RetroBat features)  │    │
│  │  - SDL2 controller input                           │    │
│  │  - Settings management                             │    │
│  │  - Content downloader & scraper                    │    │
│  │  - Native Apple Silicon support (OpenGL/Metal)     │    │
│  └────────────────────────────────────────────────────┘    │
└───────────────────────────┬─────────────────────────────────┘
                            │
                            │ Command execution
                            │
┌───────────────────────────▼─────────────────────────────────┐
│               Launcher Layer (.NET 6+/8 Cross-platform)      │
│                                                               │
│  ┌────────────────────────────────────────────────────┐    │
│  │         emulatorLauncher (macOS native binary)     │    │
│  │  - Parse game/system information                   │    │
│  │  - Configure emulator settings                     │    │
│  │  - Map controllers (SDL3)                          │    │
│  │  - Handle .app bundles                             │    │
│  │  - Start emulator process                          │    │
│  │  - Monitor and manage process                      │    │
│  │  - Platform detection (macOS/Windows)              │    │
│  └────────────────────────────────────────────────────┘    │
└───────────────────────────┬─────────────────────────────────┘
                            │
                            │ Process spawning
                            │
┌───────────────────────────▼─────────────────────────────────┐
│                  Emulator Layer (macOS Native)               │
│                                                               │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐     │
│  │  RetroArch   │  │   Dolphin    │  │   PCSX2      │     │
│  │  (ARM64)     │  │  (ARM64)     │  │  (ARM64)     │     │
│  └──────────────┘  └──────────────┘  └──────────────┘     │
│                                                               │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐     │
│  │    MAME      │  │     Cemu     │  │   RPCS3      │     │
│  │  (ARM64)     │  │   (ARM64)    │  │  (ARM64)     │     │
│  └──────────────┘  └──────────────┘  └──────────────┘     │
│                                                               │
│          ... macOS-compatible emulators ...                  │
└─────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────┐
│                    Build/Installation Layer                  │
│                                                               │
│  ┌────────────────────────────────────────────────────┐    │
│  │       RetroBuild (.NET 6+/8 Cross-platform)        │    │
│  │  - Platform detection (macOS/Windows)              │    │
│  │  - Download platform-specific emulators            │    │
│  │  - Extract archives (7z/tar)                       │    │
│  │  - Configure system files                          │    │
│  │  - Create directory structure                      │    │
│  │  - Handle macOS app bundles                        │    │
│  └────────────────────────────────────────────────────┘    │
│                                                               │
│  ┌────────────────────────────────────────────────────┐    │
│  │        macOS Installer (.dmg / .pkg)               │    │
│  │  - Create RetroBat.app bundle                      │    │
│  │  - Install SDL3 framework                          │    │
│  │  - Setup directory structure                       │    │
│  │  - Code signing & notarization                     │    │
│  └────────────────────────────────────────────────────┘    │
└─────────────────────────────────────────────────────────────┘

                        Support Layer
┌─────────────────────────────────────────────────────────────┐
│                                                               │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐     │
│  │  Homebrew    │  │   SDL3       │  │  .NET 8      │     │
│  │ Dependencies │  │  Framework   │  │  Runtime     │     │
│  └──────────────┘  └──────────────┘  └──────────────┘     │
└─────────────────────────────────────────────────────────────┘
```

## Component Breakdown

### 1. EmulationStation Frontend

**Current (Windows)**:
- Custom build of EmulationStation
- Windows-specific SDL2
- Windows paths and conventions

**Target (macOS)**:
- Port RetroBat EmulationStation fork (cross-platform C++)
- Native macOS support with OpenGL/Metal
- SDL2 for graphics and controller support
- Unix paths

**Migration Strategy**:
- Port RetroBat's own EmulationStation fork to macOS
- Maintain 100% feature parity with Windows version
- Replace DirectX with OpenGL/Metal
- Full Carbon theme compatibility

### 2. emulatorLauncher

**Current (Windows)**:
- C# .NET Framework (Windows-only)
- XInput/DirectInput for controllers
- Windows process management
- Windows registry access
- Windows file paths

**Target (macOS)**:
- C# .NET 6+ or .NET 8 (cross-platform)
- SDL3 for controllers
- Cross-platform process management
- No registry (use config files)
- Unix file paths

**Key Changes**:
```csharp
// Before (Windows-specific)
using SharpDX.XInput;
using System.Windows.Forms;

// After (Cross-platform)
using SDL2; // or SDL3
using System.Runtime.InteropServices;

// Platform detection
if (RuntimeInformation.IsOSPlatform(OSPlatform.OSX))
{
    // macOS-specific code
    var appPath = Path.Combine(emulatorsPath, "Dolphin.app", "Contents", "MacOS", "Dolphin");
}
else if (RuntimeInformation.IsOSPlatform(OSPlatform.Windows))
{
    // Windows-specific code
    var appPath = Path.Combine(emulatorsPath, "dolphin-emu", "Dolphin.exe");
}
```

### 3. RetroBuild

**Current (Windows)**:
- C# .NET Framework
- Uses wget.exe, curl.exe, 7za.exe (Windows binaries)
- Hardcoded Windows paths
- Downloads Windows-specific emulators

**Target (macOS)**:
- C# .NET 6+/8 (cross-platform)
- Uses native macOS tools or Homebrew
- Platform-aware paths
- Downloads platform-specific emulators

**Configuration Structure**:
```ini
# build.ini (Enhanced)
[Common]
retrobat_version=8.0.0
branch=beta

[Windows]
architecture=win64
retroarch_url=https://buildbot.libretro.com/.../windows/...
emulationstation_url=https://.../EmulationStation-Win32.zip

[macOS]
architecture=arm64  # or x86_64
retroarch_url=https://buildbot.libretro.com/.../apple/osx/arm64/...
emulationstation_url=https://.../EmulationStation-DE-macOS.dmg
```

### 4. Emulators

**Categories**:

1. **RetroArch (Cross-platform libretro)**
   - Already supports macOS Apple Silicon
   - Same cores work across platforms
   - Unified configuration

2. **Native macOS Emulators**
   - Dolphin (GC/Wii) - Native Apple Silicon build
   - PCSX2 (PS2) - Native macOS build
   - Citra (3DS) - Native macOS build
   - RPCS3 (PS3) - Native macOS build
   - MAME - Native macOS build
   - And many more...

3. **Windows-Only Emulators**
   - Some arcade emulators
   - Some PC emulators
   - Legacy emulators
   - **Solution**: Provide alternatives or mark as unavailable

### 5. Configuration System

**File Structure**:
```
system/
├── configgen/
│   ├── templates_files.lst
│   ├── systems_names.lst
│   ├── emulators_names.lst
│   └── lrcores_names.lst
├── templates/
│   ├── emulationstation/
│   │   ├── es_systems.cfg      # Main system definitions
│   │   └── es_padtokey.cfg     # Keyboard mapping
│   ├── retroarch/
│   │   └── retroarch.cfg       # RetroArch config
│   └── [emulator_name]/
│       └── config files
└── tools/
    ├── windows/
    │   ├── 7za.exe
    │   ├── wget.exe
    │   └── curl.exe
    └── macos/                   # NEW
        ├── 7z (symlink to brew)
        └── SDL3.framework
```

**Path Translation**:
```
Windows:
  %HOME%\emulatorLauncher.exe
  C:\RetroBat\system\tools\7za.exe
  ~\..\roms\nes

macOS:
  $HOME/emulatorLauncher
  /Applications/RetroBat.app/Contents/Resources/system/tools/7z
  $HOME/RetroBat/roms/nes
```

## Data Flow

### Game Launch Flow

```
1. User selects game in EmulationStation
   ↓
2. ES parses es_systems.cfg to find launch command
   ↓
3. ES executes: emulatorLauncher -system nes -rom game.nes
   ↓
4. emulatorLauncher:
   a. Reads system configuration
   b. Detects platform (macOS)
   c. Finds emulator path (platform-specific)
   d. Configures controller mapping (SDL3)
   e. Generates emulator config
   f. Starts emulator process
   ↓
5. Emulator runs game
   ↓
6. User exits game
   ↓
7. emulatorLauncher cleans up and exits
   ↓
8. Control returns to EmulationStation
```

### Build Flow

```
1. User runs RetroBuild
   ↓
2. RetroBuild reads build.ini
   ↓
3. Platform detection (Windows/macOS)
   ↓
4. Download platform-specific components:
   - EmulationStation (ES-DE for macOS)
   - RetroArch (platform-specific)
   - Emulators (platform-specific)
   - Cores (platform-specific)
   ↓
5. Extract archives
   ↓
6. Configure system files
   ↓
7. Setup directory structure
   ↓
8. (macOS) Create app bundle
   ↓
9. (macOS) Sign and notarize
   ↓
10. Package for distribution
```

## File System Layout

### Windows Layout
```
C:\RetroBat\
├── retrobat.exe
├── emulatorLauncher.exe
├── system\
│   ├── configgen\
│   ├── templates\
│   └── tools\
├── emulators\
│   ├── retroarch\
│   ├── dolphin-emu\
│   └── ...
├── roms\
│   ├── nes\
│   ├── snes\
│   └── ...
└── bios\
```

### macOS Layout (Proposed)
```
/Applications/RetroBat.app/
└── Contents/
    ├── Info.plist
    ├── MacOS/
    │   ├── RetroBat              # Launcher script
    │   └── emulatorLauncher      # .NET binary
    ├── Resources/
    │   ├── retrobat.icns
    │   ├── system/
    │   │   ├── configgen/
    │   │   ├── templates/
    │   │   └── tools/
    │   ├── bios/
    │   └── EmulationStation-DE.app/
    └── Frameworks/
        └── SDL3.framework

~/RetroBat/                        # User data directory
├── roms/
│   ├── nes/
│   ├── snes/
│   └── ...
├── emulators/                     # User-installed emulators
│   ├── RetroArch.app/
│   ├── Dolphin.app/
│   └── ...
├── saves/
├── screenshots/
└── config/                        # User configs
```

## Controller Input Pipeline

### Windows Flow
```
Physical Controller
   ↓
USB/Bluetooth Driver
   ↓
XInput/DirectInput API
   ↓
emulatorLauncher (C# SharpDX)
   ↓
Controller Config Generation
   ↓
Emulator-specific Config
   ↓
Emulator
```

### macOS Flow
```
Physical Controller
   ↓
USB/Bluetooth Driver
   ↓
IOKit (macOS)
   ↓
SDL3
   ↓
emulatorLauncher (C# + SDL3 bindings)
   ↓
Controller Config Generation
   ↓
Emulator-specific Config
   ↓
Emulator
```

## Dependencies

### Windows Dependencies (Current)
- .NET Framework 4.x
- Visual C++ Redistributables (2010, 2015, 2017, 2019)
- DirectX End-User Runtime
- Windows-specific DLLs (SharpDX, etc.)

### macOS Dependencies (Target)
- .NET 6+ or .NET 8 Runtime
- SDL2 Framework (for EmulationStation)
- SDL3 Framework (optional, for enhanced controller support)
- Boost libraries
- FreeImage, FreeType, Eigen3
- Homebrew (for dependencies and optional tools)
- macOS 13.0 (Ventura) or later
- No Visual C++, no DirectX needed

## Performance Considerations

### Apple Silicon Advantages
- ARM64 native performance
- Unified memory architecture
- Efficient power consumption
- Metal graphics API

### Optimization Areas
1. **Emulator Selection**: Prefer ARM64 native over x86_64 Rosetta
2. **Graphics**: Use Metal when available
3. **Memory**: Leverage unified memory
4. **Thermal**: Monitor and optimize for sustained performance

## Security Considerations

### Code Signing Requirements
- All binaries must be signed
- Frameworks must be signed
- App bundle must be signed
- Notarization required for distribution

### Sandboxing
- Consider app sandboxing for security
- May require entitlements for file access
- ROM directories outside sandbox need permission

## Maintenance Strategy

### Dual Platform Support
- Shared codebase where possible
- Platform-specific code isolated
- Automated testing for both platforms
- Synchronized releases

### Update Mechanism
- Check for updates on launch
- Download platform-specific updates
- Graceful fallback if update fails
- User notification system

## Testing Strategy

### Unit Tests
- Platform detection
- Path handling
- Configuration parsing
- Controller mapping

### Integration Tests
- EmulationStation launch
- Emulator launching
- Controller input
- Save state management

### Platform Tests
- macOS Ventura (M1)
- macOS Sonoma (M2)
- macOS Sequoia (M3)
- Intel Macs (x86_64)

## Success Metrics

### Functional
- ✅ All core features work
- ✅ Major emulators functional
- ✅ Controllers properly mapped
- ✅ Performance comparable to native emulators

### Non-Functional
- ✅ Installation under 5 minutes
- ✅ First launch configuration under 3 minutes
- ✅ Game launch time under 10 seconds
- ✅ Memory usage reasonable (<1GB for ES)
- ✅ Clean uninstallation

---

This architecture provides a clear roadmap for the Windows to macOS port while maintaining compatibility and performance.
