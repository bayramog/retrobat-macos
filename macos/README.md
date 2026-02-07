# macOS Packaging Scripts

This directory contains scripts and resources for creating macOS installation packages for RetroBat.

## Directory Structure

```
macos/
├── app-bundle/              # App bundle templates
│   ├── Info.plist          # App metadata
│   ├── entitlements.plist  # Security entitlements
│   └── RetroBat.icns       # App icon (generated)
├── dmg-assets/             # DMG customization assets
│   └── background.png      # DMG background (optional)
├── pkg-scripts/            # PKG installer scripts
│   ├── preinstall         # Pre-installation checks
│   └── postinstall        # Post-installation setup
├── build-app-bundle.sh    # Create app bundle structure
├── create-icon.sh         # Generate .icns from PNG
├── create-dmg.sh          # Build DMG installer
├── create-pkg.sh          # Build PKG installer
├── sign.sh                # Code sign all components
├── notarize.sh            # Notarize with Apple
├── PACKAGING_MACOS.md     # Complete packaging guide
└── README.md              # This file
```

## Quick Start

### 1. Build RetroBat

```bash
# From project root
cp build-macos.ini build.ini
./RetroBuild.exe  # or use dotnet run --project src/RetroBuild
```

### 2. Create App Icon

```bash
cd macos
./create-icon.sh
```

### 3. Build App Bundle

```bash
./build-app-bundle.sh 8.0.0
```

### 4. Create Installers

```bash
# Create DMG
./create-dmg.sh 8.0.0

# Create PKG
./create-pkg.sh 8.0.0
```

### 5. Sign & Notarize (Optional)

```bash
# Set credentials
export APP_SIGNING_IDENTITY="Developer ID Application: Your Name"
export INSTALLER_SIGNING_IDENTITY="Developer ID Installer: Your Name"
export APPLE_ID="your-email@example.com"
export APPLE_TEAM_ID="YOUR_TEAM_ID"
export APPLE_PASSWORD="app-specific-password"

# Sign
./sign.sh

# Notarize
./notarize.sh
```

## Scripts Reference

### build-app-bundle.sh

Creates the macOS app bundle structure from build output.

**Usage**: `./build-app-bundle.sh [VERSION]`

**Input**: `../build/` directory with RetroBat components  
**Output**: `../build/RetroBat.app`

**What it does**:
- Creates standard app bundle structure
- Copies Info.plist and entitlements
- Installs app icon
- Creates launcher script
- Copies all resources and executables
- Sets proper permissions

### create-icon.sh

Generates macOS app icon (.icns) from PNG source.

**Usage**: `./create-icon.sh`

**Input**: `../resources/logo_icon.png`  
**Output**: `app-bundle/RetroBat.icns`

**Requirements**: macOS with `sips` and `iconutil` (built-in)

**What it does**:
- Generates all required icon sizes (16x16 to 1024x1024)
- Creates @2x retina versions
- Converts to .icns format

### create-dmg.sh

Creates a DMG disk image installer.

**Usage**: `./create-dmg.sh [VERSION]`

**Input**: `../build/RetroBat.app`  
**Output**: `../build/RetroBat-VERSION-macOS-arm64.dmg`

**What it does**:
- Creates drag-and-drop disk image
- Adds Applications folder symlink
- Includes README
- Configures window appearance
- Adds custom background (if available)
- Compresses to optimal size

**Customization**: Edit script to change:
- Window size and position
- Icon positions
- Background image
- Volume name

### create-pkg.sh

Creates a PKG installer package.

**Usage**: `./create-pkg.sh [VERSION]`

**Input**: `../build/RetroBat.app`  
**Output**: `../build/RetroBat-VERSION-macOS-arm64.pkg`

**What it does**:
- Creates traditional installer package
- Runs pre-install checks
- Installs to /Applications
- Runs post-install setup
- Includes welcome/readme/conclusion pages
- Embeds license

**Customization**: Edit files in `pkg-scripts/` and HTML templates in script

### sign.sh

Code signs app bundle and installers.

**Usage**: `./sign.sh`

**Requirements**:
- Developer ID Application certificate
- Developer ID Installer certificate
- Environment variables:
  - `APP_SIGNING_IDENTITY`
  - `INSTALLER_SIGNING_IDENTITY`

**What it does**:
- Signs all dylibs and frameworks
- Signs all executables
- Signs app bundle with entitlements
- Signs DMG files
- Signs PKG files
- Verifies all signatures

### notarize.sh

Notarizes signed packages with Apple.

**Usage**: `./notarize.sh`

**Requirements**:
- Signed packages
- Apple Developer account
- Environment variables:
  - `APPLE_ID`
  - `APPLE_TEAM_ID`
  - `APPLE_PASSWORD` (app-specific password)

**What it does**:
- Submits packages to Apple
- Waits for notarization
- Staples notarization tickets
- Verifies stapling

**Duration**: 5-15 minutes per package

## File Templates

### Info.plist

Defines app metadata:
- Bundle identifier: `org.retrobat.RetroBat`
- Version numbers
- Minimum macOS version: 11.0
- Architecture: arm64 (Apple Silicon)
- Privacy permissions
- File associations

### entitlements.plist

Security entitlements required for RetroBat:
- `com.apple.security.cs.allow-jit` - JIT compilation for emulators
- `com.apple.security.cs.allow-unsigned-executable-memory` - Dynamic recompilation
- `com.apple.security.cs.disable-library-validation` - Load emulator cores
- Network, file, device access permissions

### Pre-install Script

Checks before installation:
- macOS version ≥ 11.0
- Architecture = arm64
- Backs up existing installation
- Checks for Homebrew dependencies

### Post-install Script

Setup after installation:
- Sets correct ownership and permissions
- Creates user data directories
- Removes quarantine attribute
- Updates Launch Services database

## Output Files

After running all scripts, you'll have:

```
build/
├── RetroBat.app                                  # App bundle
├── RetroBat-8.0.0-macOS-arm64.dmg               # Disk image
├── RetroBat-8.0.0-macOS-arm64.dmg.sha256        # DMG checksum
├── RetroBat-8.0.0-macOS-arm64.pkg               # Installer package
└── RetroBat-8.0.0-macOS-arm64.pkg.sha256        # PKG checksum
```

## Testing

### Test App Bundle

```bash
open ../build/RetroBat.app
```

### Test DMG

```bash
open ../build/RetroBat-8.0.0-macOS-arm64.dmg
# Drag to Applications
# Open from Applications
```

### Test PKG

```bash
open ../build/RetroBat-8.0.0-macOS-arm64.pkg
# Follow installation wizard
```

### Verify Signatures

```bash
# App bundle
codesign --verify --deep --strict --verbose=2 ../build/RetroBat.app

# DMG
codesign --verify --verbose=2 ../build/RetroBat-8.0.0-macOS-arm64.dmg

# PKG
pkgutil --check-signature ../build/RetroBat-8.0.0-macOS-arm64.pkg

# Gatekeeper
spctl --assess --verbose=4 --type execute ../build/RetroBat.app
spctl --assess --verbose=4 --type install ../build/RetroBat-8.0.0-macOS-arm64.pkg
```

## Troubleshooting

### App Won't Open

```bash
# Remove quarantine (testing only)
xattr -dr com.apple.quarantine ../build/RetroBat.app
```

### Missing Dependencies

```bash
brew install p7zip wget sdl2
```

### Code Signing Issues

```bash
# List available identities
security find-identity -p codesigning -v

# Check certificate validity
security find-certificate -c "Developer ID Application" -p
```

### Notarization Failed

```bash
# Check notarization status
xcrun notarytool history --apple-id $APPLE_ID --team-id $APPLE_TEAM_ID --password $APPLE_PASSWORD

# Get detailed log
xcrun notarytool log <submission-id> --apple-id $APPLE_ID --team-id $APPLE_TEAM_ID --password $APPLE_PASSWORD
```

## Requirements

### System

- macOS 11.0 or later
- Apple Silicon Mac (M1/M2/M3/M4)
- Xcode Command Line Tools

### Dependencies

```bash
brew install p7zip wget sdl2 dotnet-sdk
```

### For Code Signing

- Apple Developer Account
- Developer ID certificates
- App-specific password

## Documentation

For complete documentation, see:
- [PACKAGING_MACOS.md](PACKAGING_MACOS.md) - Comprehensive packaging guide
- [../docs/BUILDING_RETROBUILD_MACOS.md](../docs/BUILDING_RETROBUILD_MACOS.md) - Build guide

## Support

- Issues: [GitHub Issues](https://github.com/bayramog/retrobat-macos/issues)
- Documentation: [GitHub Wiki](https://github.com/bayramog/retrobat-macos/wiki)

## License

See [../license.txt](../license.txt)
