# RetroBuild - Cross-Platform Build Tool for RetroBat

RetroBuild is a .NET 8 cross-platform build tool that downloads, configures, and packages RetroBat for distribution on Windows, macOS, and Linux.

## Overview

This is a complete migration from .NET Framework 4.7.2 to .NET 8.0, enabling cross-platform support for building RetroBat on macOS and Linux in addition to Windows.

## Features

- **Cross-Platform**: Runs on Windows, macOS (Apple Silicon/Intel), and Linux
- **Platform Detection**: Automatically detects the host platform and adjusts behavior accordingly
- **Path Handling**: Uses cross-platform path handling with `Path.Combine()` and `Path.DirectorySeparatorChar`
- **Tool Detection**: Finds system tools like 7-Zip, wget, and curl in PATH or at specified locations
- **Archive Creation**: Creates distributable ZIP archives with SHA256 checksums

## Prerequisites

### Windows
- .NET 8.0 SDK
- 7-Zip (7za.exe in `system/tools/`)
- wget and curl (in `system/tools/`)

### macOS
- .NET 8.0 SDK
- Homebrew packages:
  ```bash
  brew install p7zip wget
  ```
- curl (built-in on macOS)

### Linux
- .NET 8.0 SDK
- System packages:
  ```bash
  sudo apt install p7zip-full wget curl
  ```

## Building

```bash
cd src/RetroBuild
dotnet build
```

For release build:
```bash
dotnet build -c Release
```

## Usage

### Windows
```bash
cd src/RetroBuild
dotnet run
```

### macOS/Linux
```bash
cd src/RetroBuild
dotnet run
```

Or use the platform-specific configuration:
```bash
# Copy build-macos.ini to build.ini for macOS
cp ../../build-macos.ini ../../build.ini
dotnet run
```

## Configuration

The `build.ini` file controls what gets downloaded and configured:

```ini
[BuilderOptions]
retrobat_version=8.0.0.0
retroarch_version=1.22.2
branch=beta
architecture=osx-arm64  # or win64, linux-x64
get_batgui=0  # Windows only
get_batocera_ports=1
get_bios=1
get_decorations=1
get_default_theme=1
get_emulationstation=1
get_emulators=0
get_lrcores=1
get_retroarch=1
get_retrobat_binaries=1
get_system=1
get_wiimotegun=0  # Windows only
7za_path=7z  # macOS/Linux: expects 7z in PATH
wget_path=wget
curl_path=curl
# ... URLs for downloads ...
```

## Menu Options

1. **Download and configure** - Downloads all required packages and configures the build
2. **Create archive** - Creates a ZIP archive of the build directory
3. **Create installer** - (Windows only) Creates a Windows installer

## Platform-Specific Notes

### macOS
- Uses system commands (`7z`, `wget`, `curl`) from PATH via Homebrew
- Windows-only components (BatGui, WiimoteGun) are skipped
- Architecture is automatically detected (ARM64 for Apple Silicon, x64 for Intel)
- Installer creation is not available (use ZIP archive or create .dmg manually)

### Windows
- Uses bundled tools in `system/tools/`
- Can create Windows installer with option 3
- All features available

### Linux
- Similar to macOS, uses system commands from PATH
- All cross-platform features available

## Architecture

- **Program.cs** - Main entry point, menu system, and build orchestration
- **BuilderOptions.cs** - Configuration parsing and platform-specific defaults
- **Methods.cs** - Utility methods for downloading, extracting, and file operations
- **IniParser.cs** - Simple INI file parser
- **Logger.cs** - Logging to console and file
- **Installer.cs** - Windows installer creation (stub on other platforms)

## Cross-Platform Improvements

1. **Path Handling**: All paths use `Path.Combine()` and are normalized for the host platform
2. **Platform Detection**: Uses `RuntimeInformation.IsOSPlatform()` to detect Windows/macOS/Linux
3. **Tool Discovery**: Checks both absolute paths and system PATH for required tools
4. **Process Execution**: Uses cross-platform `Process.Start()` for running external commands
5. **Architecture Detection**: Automatically detects ARM64, x64, etc.

## Differences from Original

- Migrated from .NET Framework 4.7.2 to .NET 8.0
- Added full cross-platform support
- Improved path handling and normalization
- Added platform-specific tool detection
- Added helpful error messages for missing tools
- Maintains backward compatibility with Windows build process

## Future Improvements

- Replace `WebClient` with `HttpClient` (currently has obsolete warning)
- Add progress bars for downloads
- Add parallel download support
- Improve error handling and recovery
- Add unit tests

## License

Same as RetroBat main project.
