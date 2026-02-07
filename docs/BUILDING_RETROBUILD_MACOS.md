# Building RetroBat on macOS

This guide explains how to build RetroBat distributions on macOS using the new cross-platform RetroBuild tool.

## Prerequisites

### Required Software

1. **.NET 8 SDK** - `brew install dotnet-sdk`
2. **Build Tools** - `brew install p7zip wget`

Note: `curl` and `git` are already built-in on macOS

## Quick Start

```bash
# 1. Copy macOS configuration
cp build-macos.ini build.ini

# 2. Build RetroBuild
cd src/RetroBuild && dotnet build -c Release && cd ../..

# 3. Run the build process
dotnet run --project src/RetroBuild/RetroBuild.csproj
```

## Build Output

The build creates:
- `build/` - Complete RetroBat directory structure
- `retrobat-v*.zip` - Distribution archive
- `retrobat-v*.zip.sha256.txt` - Checksum file

## Platform Differences

### Skipped on macOS
- BatGui (Windows-only)
- WiimoteGun (Windows-only)  
- Installer creation (option 3)

### macOS-Specific
- Uses `.dylib` cores instead of `.dll`
- Downloads RetroArch for macOS
- Uses system tools from Homebrew

## More Information

See `src/RetroBuild/README.md` for detailed documentation.
