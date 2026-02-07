# Building RetroBat on macOS

This guide explains how to build RetroBat distributions on macOS using the new cross-platform RetroBuild tool.

## Prerequisites

### Required Software

1. **.NET 8 SDK** - `brew install dotnet-sdk`
2. **Build Tools** - `brew install p7zip wget`

Note: `curl` and `git` are already built-in on macOS

### Verify Installation

Run the verification script to check all dependencies:

```bash
./verify-tools.sh
```

This will check:
- Core build tools (7z, wget, curl, git, dotnet)
- SDL libraries (SDL2, SDL3)
- Tool functionality (extraction, downloads)
- RetroBuild compilation

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

## Code Signing and Notarization

For distribution outside the Mac App Store, the built application must be signed and notarized. See:

- **[docs/CODESIGNING_MACOS.md](CODESIGNING_MACOS.md)** - Complete code signing and notarization guide
- **scripts/macos-sign.sh** - Automated signing script
- **scripts/macos-notarize.sh** - Automated notarization script

Quick signing workflow:
```bash
# 1. Build the app
dotnet run --project src/RetroBuild/RetroBuild.csproj

# 2. Create app bundle structure (TBD - manual for now)
# Create RetroBat.app with proper bundle structure

# 3. Sign the app
export SIGNING_IDENTITY_APP="Developer ID Application: Your Name (TEAM_ID)"
./scripts/macos-sign.sh build/RetroBat.app

# 4. Create and sign DMG
hdiutil create -volname "RetroBat" -srcfolder build/RetroBat.app -ov -format UDZO RetroBat.dmg
codesign --force --sign "$SIGNING_IDENTITY_APP" --timestamp RetroBat.dmg

# 5. Notarize
./scripts/macos-notarize.sh RetroBat.dmg
```

**Note**: Apple Developer account ($99/year) and Developer ID certificates are required.

## More Information

See `src/RetroBuild/README.md` for detailed documentation.
