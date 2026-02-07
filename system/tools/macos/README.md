# macOS System Tools

This directory contains macOS-specific tools and documentation for RetroBat on macOS.

## Overview

Unlike Windows, macOS uses system tools from PATH rather than bundled binaries. The required tools should be installed via Homebrew or are available natively.

## Required Tools

### Core Build Tools

1. **p7zip** (7z command)
   - Purpose: Archive extraction and creation
   - Installation: `brew install p7zip`
   - Path: Available in system PATH as `7z`
   - Windows equivalent: `7za.exe`

2. **wget**
   - Purpose: Download files from web
   - Installation: `brew install wget`
   - Path: Available in system PATH as `wget`
   - Windows equivalent: `wget.exe`

3. **curl**
   - Purpose: Download files and API calls
   - Installation: Built-in on macOS (no installation needed)
   - Path: Available in system PATH as `curl`
   - Windows equivalent: `curl.exe`

4. **git**
   - Purpose: Clone repositories
   - Installation: Built-in with Xcode Command Line Tools
   - Path: Available in system PATH as `git`
   - Windows equivalent: `git.exe`

### SDL Libraries (for EmulationStation)

EmulationStation requires SDL2 for graphics, input, and audio on macOS.

#### SDL2 (Required)
- Purpose: Cross-platform multimedia library for EmulationStation
- Installation: `brew install sdl2`
- Location: `/opt/homebrew/lib/libSDL2.dylib` (Apple Silicon) or `/usr/local/lib/libSDL2.dylib` (Intel)
- Windows equivalent: `SDL2.dll` (bundled in emulationstation directory)

#### SDL3 (Optional)
- Purpose: Next-generation SDL for enhanced features
- Installation: `brew install sdl3` (if available) or build from source
- Location: `/opt/homebrew/lib/libSDL3.dylib` (Apple Silicon) or `/usr/local/lib/libSDL3.dylib` (Intel)
- Windows equivalent: `SDL3.dll` (in system/tools/)
- Note: Only needed for emulators that specifically require SDL3

## Tool Configuration

### build-macos.ini

The macOS build configuration uses system tools from PATH:

```ini
7za_path=7z
wget_path=wget
curl_path=curl
```

### RetroBuild Detection

RetroBuild automatically detects the platform and uses appropriate tool paths:

- **Windows**: Uses bundled tools from `system/tools/` (e.g., `7za.exe`, `wget.exe`)
- **macOS**: Uses system tools from PATH (e.g., `7z`, `wget`, `curl`)
- **Linux**: Uses system tools from PATH (e.g., `7z`, `wget`, `curl`)

## Installation Guide

### Quick Setup (Homebrew)

Install all required dependencies at once:

```bash
# Install Homebrew if not already installed
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Install required tools
brew install p7zip wget sdl2

# Optional: Install SDL3 if available
brew install sdl3
```

### Verification

Verify all tools are installed and available:

```bash
# Check 7z
which 7z && 7z --help | head -n 1

# Check wget
which wget && wget --version | head -n 1

# Check curl
which curl && curl --version | head -n 1

# Check git
which git && git --version

# Check SDL2
ls -l /opt/homebrew/lib/libSDL2*.dylib || ls -l /usr/local/lib/libSDL2*.dylib

# Check SDL3 (optional)
ls -l /opt/homebrew/lib/libSDL3*.dylib || ls -l /usr/local/lib/libSDL3*.dylib
```

## SDL Framework Integration

### For EmulationStation Developers

When building EmulationStation for macOS:

1. SDL2 is provided by Homebrew as dynamic libraries (`.dylib`)
2. Link against SDL2 using CMake:
   ```cmake
   find_package(SDL2 REQUIRED)
   target_link_libraries(emulationstation SDL2::SDL2)
   ```
3. The SDL2 dylib will be found automatically via Homebrew's installation path

### Runtime Dependencies

EmulationStation on macOS expects SDL2 to be installed via Homebrew. When distributing RetroBat for macOS:

**Option 1: Homebrew Dependency (Recommended)**
- Require users to have Homebrew and SDL2 installed
- Document in installation instructions
- Lighter distribution package

**Option 2: Bundle SDL2 Framework**
- Include SDL2.framework in the app bundle
- Use `@rpath` for dynamic linking
- Larger distribution package but self-contained

## Architecture Notes

### Apple Silicon vs Intel

- **Apple Silicon (M1/M2/M3/M4)**: Tools installed to `/opt/homebrew/`
- **Intel x86_64**: Tools installed to `/usr/local/` (if supporting Intel)

Current RetroBat macOS port targets **Apple Silicon only** (ARM64).

### Dynamic Library Paths

macOS uses different dynamic library extensions:
- Windows: `.dll`
- macOS: `.dylib`
- Linux: `.so`

Ensure build scripts and emulator launchers check for the appropriate extension based on platform.

## Troubleshooting

### Tool Not Found

If RetroBuild reports a tool is missing:

```bash
# Install the missing tool
brew install p7zip wget

# Verify it's in your PATH
echo $PATH
which 7z wget curl
```

### SDL2 Not Found

If EmulationStation can't find SDL2:

```bash
# Install SDL2
brew install sdl2

# Verify installation
brew list sdl2
ls -l $(brew --prefix sdl2)/lib/
```

### Permission Issues

If you get permission errors:

```bash
# Fix Homebrew permissions
sudo chown -R $(whoami) $(brew --prefix)/*
```

## Additional Dependencies

For a complete RetroBat build environment, see the main `Brewfile` in the repository root, which includes:

- cmake (for building EmulationStation)
- boost (for EmulationStation)
- freeimage, freetype (for EmulationStation)
- eigen, glm (for EmulationStation)
- dotnet-sdk (for RetroBuild)

## References

- [Homebrew Documentation](https://docs.brew.sh/)
- [SDL2 Documentation](https://wiki.libsdl.org/)
- [p7zip Documentation](https://www.7-zip.org/)
- [RetroBat Documentation](https://wiki.retrobat.org/)
