# EmulatorLauncher.Core

Cross-platform emulator launcher for RetroBat, migrated from .NET Framework to .NET 8.

## Overview

This is the .NET 8 rewrite of the original emulatorLauncher project, designed to work on:
- macOS (Apple Silicon - arm64)
- Windows (x64)
- Linux (x64)

## Architecture

### Original (.NET Framework)
- Windows-only (x86)
- SharpDX for controller input (DirectInput/XInput)
- Windows Forms UI
- 150+ emulator generators

### New (.NET 8 Cross-Platform)
- Cross-platform (macOS/Windows/Linux)
- SDL3 for controller input (cross-platform)
- Console application (no UI dependencies)
- Modular generator architecture

## Building

```bash
# Build for current platform
dotnet build

# Build for macOS Apple Silicon
dotnet build -r osx-arm64

# Build for Windows x64
dotnet build -r win-x64

# Publish single-file executable
dotnet publish -c Release -r osx-arm64 --self-contained false -p:PublishSingleFile=true
```

## Usage

```bash
emulatorLauncher -system <system> -rom <path> [-emulator <name>] [-core <name>]
```

Example:
```bash
emulatorLauncher -system nes -rom mario.nes -emulator libretro -core nestopia
```

## Controller Support

### Windows
- Uses SharpDX (DirectInput/XInput) for backward compatibility

### macOS/Linux  
- Uses SDL3 GameController API
- Automatic controller detection and mapping
- Supports PlayStation, Xbox, Switch Pro, and generic controllers

## Migration Status

- [x] Project structure created
- [x] Basic argument parsing
- [x] Platform detection
- [ ] SDL3 controller integration
- [ ] Generator base class migration
- [ ] RetroArch generator (priority #1)
- [ ] Configuration file parsing
- [ ] Process management
- [ ] macOS .app bundle support
- [ ] Additional emulator generators

## Dependencies

- .NET 8 Runtime
- Newtonsoft.Json (JSON parsing)
- SDL3 (macOS/Linux - controller support)
- SharpDX (Windows - controller support)

## Contributing

See the main repository [bayramog/retrobat-macos](https://github.com/bayramog/retrobat-macos) for contribution guidelines.

## License

Same license as original RetroBat project.
