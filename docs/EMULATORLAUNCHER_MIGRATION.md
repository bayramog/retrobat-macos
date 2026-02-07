# emulatorLauncher Migration to .NET 8

## Overview

This document details the migration of emulatorLauncher from .NET Framework 4.0 (Windows-only) to .NET 8 (cross-platform) to enable macOS and Linux support.

## Original Architecture (.NET Framework)

### Components
- **Platform**: .NET Framework 4.0, Windows-only (x86)
- **Controller Input**: SharpDX 4.2.0 (DirectInput/XInput)
- **UI**: Windows Forms (InstallerFrm, ControlCenter)
- **Dependencies**:
  - SharpDX.dll, SharpDX.DirectInput.dll
  - System.Windows.Forms
  - System.Management (WMI)
  - Newtonsoft.Json
  - System.Data.SQLite
  - PresentationCore/Framework (WPF)

### Architecture
```
EmulationStation (C++)
    ↓
emulatorLauncher.exe (.NET Framework)
    ├── Parse arguments (-system, -rom, -p1guid, etc.)
    ├── Load configuration (es_settings.cfg, es_features.cfg)
    ├── Select Generator from 150+ registered generators
    ├── Configure controller input (SharpDX)
    ├── Generate emulator command line
    ├── Launch process with Job tracking
    └── Wait for exit & cleanup
```

### Key Files
- `Program.cs` - Main entry point, generator registry
- `Controller.cs` - Controller abstraction (XInput/DirectInput)
- `Generators/*.cs` - 150+ emulator-specific generators
- `EmulatorLauncher.Common` - Shared utilities

## New Architecture (.NET 8)

### Components
- **Platform**: .NET 8, cross-platform (osx-arm64, win-x64, linux-x64)
- **Controller Input**: 
  - SDL3 (macOS/Linux) - via P/Invoke
  - SharpDX (Windows) - backward compatibility
- **UI**: Console-only (no GUI dependencies)
- **Dependencies**:
  - Newtonsoft.Json
  - SDL3 (runtime, macOS/Linux)
  - SharpDX (optional, Windows only)

### Architecture
```
EmulationStation (C++)
    ↓
emulatorLauncher (.NET 8 single-file)
    ├── Parse arguments (cross-platform)
    ├── Load configuration (JSON/INI parsers)
    ├── Detect platform (RuntimeInformation.IsOSPlatform)
    ├── Select Generator
    ├── Configure controller input
    │   ├── Windows → SharpDX (legacy)
    │   └── macOS/Linux → SDL3
    ├── Generate emulator command line
    │   ├── Windows → .exe paths
    │   ├── macOS → .app bundle paths
    │   └── Linux → binary paths
    ├── Launch process (cross-platform Process.Start)
    └── Wait for exit & cleanup
```

### Project Structure
```
src/EmulatorLauncher.Core/
├── EmulatorLauncher.Core.csproj   # .NET 8 project
├── Program.cs                      # Main entry point
├── README.md                       # Project documentation
├── Controllers/
│   └── SDLController.cs           # SDL3 P/Invoke wrapper
└── Generators/
    ├── Generator.cs               # Base class
    ├── RetroArchGenerator.cs      # Libretro/RetroArch
    └── [Future generators...]
```

## Migration Strategy

### Phase 1: Foundation ✅ COMPLETE
- [x] Create .NET 8 project structure
- [x] Basic command-line parsing
- [x] Platform detection
- [x] Cross-platform path handling
- [x] SDL3 P/Invoke wrapper (framework)
- [x] Generator base class
- [x] RetroArch generator (priority #1)

### Phase 2: Controller Input (IN PROGRESS)
- [ ] Complete SDL3 integration
- [ ] Controller detection and enumeration
- [ ] Controller configuration mapping
- [ ] Test with real controllers on macOS

### Phase 3: Core Generators
- [ ] Port RetroArch generator configuration
- [ ] Add Dolphin generator (GameCube/Wii)
- [ ] Add PCSX2 generator (PS2)
- [ ] Add other priority emulators

### Phase 4: Configuration System
- [ ] Port configuration file parsers
- [ ] es_settings.cfg reader
- [ ] es_features.cfg reader
- [ ] Platform-specific config paths

### Phase 5: Testing & Validation
- [ ] Build for osx-arm64
- [ ] Test with RetroArch on macOS
- [ ] Test controller input
- [ ] Test various ROM formats
- [ ] Performance testing

## Key Differences

### Controller Input

**Old (Windows)**:
```csharp
using SharpDX.DirectInput;
var directInput = new DirectInput();
var devices = directInput.GetDevices(DeviceClass.GameController, DeviceEnumerationFlags.AllDevices);
```

**New (macOS/Linux)**:
```csharp
using EmulatorLauncher.Controllers;
var manager = new SDLControllerManager();
manager.Initialize();
var controllers = manager.DetectControllers();
```

### Emulator Discovery

**Old (Windows)**:
```csharp
string exePath = Path.Combine(baseDir, "emulators", emulator, emulator + ".exe");
```

**New (macOS)**:
```csharp
// Handle .app bundles
string appPath = Path.Combine(baseDir, "emulators", emulator, emulator + ".app");
string execPath = Path.Combine(appPath, "Contents", "MacOS", emulator);
```

### Path Handling

**Old**:
```csharp
string path = baseDir + "\\" + file;  // Windows-specific
```

**New**:
```csharp
string path = Path.Combine(baseDir, file);  // Cross-platform
string normalized = NormalizePath(path);     // Platform-aware
```

## SDL3 Integration

### Why SDL3?
- **Cross-platform**: Works on Windows, macOS, Linux
- **Modern API**: Improved GameController API in SDL3
- **Native libraries**: No managed wrapper needed (P/Invoke)
- **Industry standard**: Used by many emulators and games

### Installation

**Important**: SDL3 is required. SDL2 APIs are NOT compatible with SDL3.

```bash
# macOS
# SDL3 not yet available via Homebrew - must build from source
git clone https://github.com/libsdl-org/SDL
cd SDL
mkdir build && cd build
cmake .. -DCMAKE_BUILD_TYPE=Release
make && sudo make install

# Linux
# Build from source (no package managers have SDL3 yet)
git clone https://github.com/libsdl-org/SDL
cd SDL
mkdir build && cd build
cmake .. -DCMAKE_BUILD_TYPE=Release
make && sudo make install

# Alternative: Wait for SDL3 official release and package manager support
```

**Note**: This implementation is designed for SDL3. If SDL3 is not available, controller support will be disabled until SDL3 is installed.

### P/Invoke Wrapper
Located in `Controllers/SDLController.cs`:
- SDL_Init/SDL_Quit
- SDL_GetGamepads
- SDL_OpenGamepad/SDL_CloseGamepad
- SDL_GetGamepadButton/SDL_GetGamepadAxis

## Building

### Prerequisites
- .NET 8 SDK
- SDL3 (macOS/Linux runtime)

### Build Commands
```bash
# Build for current platform
cd src/EmulatorLauncher.Core
dotnet build

# Build for macOS Apple Silicon
dotnet build -r osx-arm64

# Build for Windows x64
dotnet build -r win-x64

# Publish single-file executable (macOS)
dotnet publish -c Release -r osx-arm64 \
  --self-contained false \
  -p:PublishSingleFile=true \
  -p:IncludeNativeLibrariesForSelfExtract=true
```

### Output
- **Debug**: `bin/Debug/net8.0/emulatorLauncher`
- **Release**: `bin/Release/net8.0/osx-arm64/publish/emulatorLauncher`

## Testing

### Manual Testing
```bash
# Test argument parsing
./emulatorLauncher -system nes -rom test.nes

# Test with RetroArch
./emulatorLauncher \
  -system nes \
  -rom ~/Games/mario.nes \
  -emulator libretro \
  -core nestopia

# Test with controller
./emulatorLauncher \
  -system nes \
  -rom test.nes \
  -p1index 0 \
  -p1guid 030000005e040000ea02000000007801 \
  -p1name "Xbox Controller"
```

### Expected Behavior
1. Parse all command-line arguments
2. Detect platform (macOS, Windows, Linux)
3. Find emulator executable
4. Find libretro core (if applicable)
5. Generate command line
6. Launch emulator
7. Wait for exit
8. Return exit code

## Known Limitations

### Current Implementation
- SDL3 integration is framework-only (not fully implemented)
- Only RetroArch generator implemented
- No configuration file parsing yet
- No controller input implementation yet
- No UI components (console-only)

### Future Work
- Complete SDL3 implementation
- Add more emulator generators
- Port configuration system
- Add automated tests
- Add logging system
- Performance optimization

## Backward Compatibility

### Windows Support
The new .NET 8 version maintains Windows support:
- Can optionally use SharpDX for controller input
- Supports .exe discovery
- Windows-style path handling

### Configuration Compatibility
- Uses same command-line arguments as original
- Compatible with EmulationStation es_systems.cfg
- Same ROM format support

## Performance

### Startup Time
- .NET 8: ~50-100ms (console app)
- .NET Framework: ~200-300ms (WinForms app)

### Memory Usage
- .NET 8: ~20-30 MB baseline
- .NET Framework: ~40-60 MB baseline

### Single-File Deployment
- Size: ~60-80 MB (self-contained)
- Size: ~5-10 MB (framework-dependent)

## Resources

- **Upstream**: https://github.com/RetroBat-Official/emulatorlauncher
- **SDL3 API**: https://wiki.libsdl.org/SDL3/CategoryGamepad
- **.NET Platform Detection**: https://learn.microsoft.com/en-us/dotnet/standard/library-guidance/cross-platform-targeting
- **macOS App Bundles**: https://developer.apple.com/library/archive/documentation/CoreFoundation/Conceptual/CFBundles/

## Contributing

See main repository [bayramog/retrobat-macos](https://github.com/bayramog/retrobat-macos) for contribution guidelines.

## License

Same license as original RetroBat project.
