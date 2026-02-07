# RetroBat macOS Packaging Guide

This guide explains how to create macOS installation packages (.dmg and .pkg) for RetroBat.

## Overview

RetroBat for macOS is distributed in two formats:
- **DMG (Disk Image)**: Drag-and-drop installation for easy setup
- **PKG (Package)**: Traditional installer with guided installation

Both formats include the complete RetroBat app bundle with proper code signing and notarization.

## Table of Contents

- [Prerequisites](#prerequisites)
- [App Bundle Structure](#app-bundle-structure)
- [Building Process](#building-process)
- [Creating Installers](#creating-installers)
- [Code Signing & Notarization](#code-signing--notarization)
- [Testing](#testing)
- [Distribution](#distribution)
- [Troubleshooting](#troubleshooting)

## Prerequisites

### System Requirements

- macOS 11.0 (Big Sur) or later
- Apple Silicon Mac (M1/M2/M3/M4)
- Xcode Command Line Tools: `xcode-select --install`

### Required Tools

```bash
# Install Homebrew if not already installed
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Install dependencies
brew install p7zip wget sdl2

# Install .NET 8 SDK
brew install dotnet-sdk
```

### Optional (for Code Signing)

- Apple Developer Account
- Developer ID Application certificate
- Developer ID Installer certificate
- App-specific password for notarization

## App Bundle Structure

RetroBat uses the standard macOS app bundle structure:

```
RetroBat.app/
├── Contents/
│   ├── Info.plist              # App metadata and configuration
│   ├── entitlements.plist      # Security entitlements
│   ├── MacOS/
│   │   └── RetroBat           # Launcher script
│   ├── Resources/
│   │   ├── RetroBat.icns      # App icon
│   │   ├── system/            # RetroBat system files
│   │   ├── emulationstation/  # EmulationStation files
│   │   ├── emulators/         # Emulators (RetroArch, etc.)
│   │   ├── RetroBuild         # Build/update tool
│   │   ├── retrobat.ini       # Configuration
│   │   └── README.md          # Documentation
│   └── Frameworks/            # Embedded frameworks (if any)
```

## Building Process

### Step 1: Build RetroBat Components

First, build the RetroBat distribution:

```bash
# Navigate to project root
cd /path/to/retrobat-macos

# Copy macOS build configuration
cp build-macos.ini build.ini

# Build with RetroBuild (if using .NET version)
dotnet run --project src/RetroBuild

# Or use the compiled version
./RetroBuild.exe
```

This creates a `build/` directory with all components.

### Step 2: Create App Icon

Generate the macOS app icon (.icns):

```bash
./macos/create-icon.sh
```

This converts `resources/logo_icon.png` to `macos/app-bundle/RetroBat.icns`.

### Step 3: Build App Bundle

Create the app bundle structure:

```bash
./macos/build-app-bundle.sh 8.0.0
```

This creates `build/RetroBat.app` with all necessary files.

### Step 4: Test App Bundle

Before creating installers, test the app bundle:

```bash
open build/RetroBat.app
```

Verify:
- App launches without errors
- Dependencies are detected correctly
- Configuration files are accessible

## Creating Installers

### DMG (Disk Image)

Create a DMG installer with drag-and-drop installation:

```bash
./macos/create-dmg.sh 8.0.0
```

Features:
- Custom background image (optional)
- Applications folder symlink
- Optimized window layout
- README included
- Compressed format

Output: `build/RetroBat-8.0.0-macOS-arm64.dmg`

#### DMG Customization

To customize the DMG appearance:

1. Create background image: `macos/dmg-assets/background.png` (600x450px recommended)
2. Edit icon positions in `macos/create-dmg.sh`
3. Adjust window size and layout parameters

### PKG (Package Installer)

Create a PKG installer with guided installation:

```bash
./macos/create-pkg.sh 8.0.0
```

Features:
- Guided installation wizard
- System requirements check
- Pre/post-install scripts
- HTML welcome and readme pages
- License agreement
- Automatic dependency detection

Output: `build/RetroBat-8.0.0-macOS-arm64.pkg`

#### PKG Scripts

The installer includes:

- **preinstall**: Checks system requirements, backs up existing installation
- **postinstall**: Sets permissions, creates user directories, removes quarantine

Edit these scripts in `macos/pkg-scripts/` if needed.

## Code Signing & Notarization

To distribute RetroBat without security warnings, you need to sign and notarize your packages.

### Prerequisites

1. **Obtain Developer ID Certificates**:
   - Developer ID Application (for app bundles and DMG)
   - Developer ID Installer (for PKG)
   - Available from [Apple Developer](https://developer.apple.com/account/resources/certificates/)

2. **Install Certificates**:
   - Download certificates from Apple Developer portal
   - Double-click to install in Keychain

3. **Create App-Specific Password**:
   - Go to [appleid.apple.com](https://appleid.apple.com)
   - Security → App-Specific Passwords → Generate Password
   - Save this password securely

### Signing

Sign your app bundle and installers:

```bash
# Set your certificate identities
export APP_SIGNING_IDENTITY="Developer ID Application: Your Name (TEAM_ID)"
export INSTALLER_SIGNING_IDENTITY="Developer ID Installer: Your Name (TEAM_ID)"

# Sign all components
./macos/sign.sh
```

This will:
1. Sign all dylibs and frameworks
2. Sign executables
3. Sign the app bundle with entitlements
4. Sign DMG files
5. Sign PKG files

### Notarization

Submit for Apple notarization:

```bash
# Set your Apple ID credentials
export APPLE_ID="your-email@example.com"
export APPLE_TEAM_ID="YOUR_TEAM_ID"
export APPLE_PASSWORD="app-specific-password"

# Notarize
./macos/notarize.sh
```

Notarization typically takes 5-15 minutes. The script will:
1. Upload files to Apple
2. Wait for notarization to complete
3. Staple notarization tickets
4. Verify the stapling

### Verify Signing

Check code signatures:

```bash
# Verify app bundle
codesign --verify --deep --strict --verbose=2 build/RetroBat.app

# Verify DMG
codesign --verify --verbose=2 build/RetroBat-8.0.0-macOS-arm64.dmg

# Verify PKG
pkgutil --check-signature build/RetroBat-8.0.0-macOS-arm64.pkg

# Check Gatekeeper approval
spctl --assess --verbose=4 --type execute build/RetroBat.app
spctl --assess --verbose=4 --type install build/RetroBat-8.0.0-macOS-arm64.pkg
```

## Testing

### Local Testing

1. **Test DMG**:
   ```bash
   open build/RetroBat-8.0.0-macOS-arm64.dmg
   # Drag RetroBat.app to Applications
   # Open from Applications folder
   ```

2. **Test PKG**:
   ```bash
   open build/RetroBat-8.0.0-macOS-arm64.pkg
   # Follow installation wizard
   # Launch from Applications
   ```

3. **Test Uninstallation**:
   - Delete `/Applications/RetroBat.app`
   - Delete `~/RetroBat` (optional)
   - Delete `~/Library/Application Support/RetroBat` (optional)

### Security Testing

Test Gatekeeper behavior:

```bash
# Test unsigned (should show security warning)
xattr -d com.apple.quarantine build/RetroBat.app
open build/RetroBat.app

# Test signed (should open without warning)
# After signing and notarization
open build/RetroBat.app
```

### Clean Install Testing

Test on a fresh macOS installation or VM:

1. Create fresh user account
2. Install only Homebrew and dependencies
3. Install RetroBat from DMG or PKG
4. Verify first-run experience
5. Test all major features

## Distribution

### GitHub Releases

1. Create a new release on GitHub
2. Upload both DMG and PKG files
3. Include checksums:

```bash
# Generate SHA256 checksums
shasum -a 256 build/RetroBat-8.0.0-macOS-arm64.dmg > build/RetroBat-8.0.0-macOS-arm64.dmg.sha256
shasum -a 256 build/RetroBat-8.0.0-macOS-arm64.pkg > build/RetroBat-8.0.0-macOS-arm64.pkg.sha256
```

4. Update release notes with:
   - Version number
   - New features
   - Bug fixes
   - Installation instructions
   - System requirements

### Release Checklist

- [ ] Version numbers updated in all files
- [ ] All components built successfully
- [ ] App bundle tested
- [ ] DMG created and tested
- [ ] PKG created and tested
- [ ] Code signing completed
- [ ] Notarization completed
- [ ] Checksums generated
- [ ] Release notes written
- [ ] Documentation updated

## Troubleshooting

### Common Issues

#### App Won't Open (Security Warning)

**Problem**: macOS shows "RetroBat cannot be opened because it is from an unidentified developer"

**Solution**:
1. Right-click the app and select "Open"
2. Click "Open" in the security dialog
3. For distribution: Sign and notarize the app

#### Missing Dependencies

**Problem**: App shows error about missing p7zip, wget, or SDL2

**Solution**:
```bash
brew install p7zip wget sdl2
```

#### Code Signing Failed

**Problem**: codesign reports errors

**Solutions**:
- Verify certificates are installed: `security find-identity -p codesigning -v`
- Check certificate expiration dates
- Ensure correct certificate identity strings
- Try signing individual components first

#### Notarization Failed

**Problem**: notarytool reports rejection

**Solutions**:
- Check notarization log: `xcrun notarytool log <submission-id>`
- Verify all binaries are properly signed
- Ensure hardened runtime is enabled
- Check entitlements are valid

#### DMG Won't Mount

**Problem**: Error mounting DMG

**Solutions**:
- Check DMG wasn't corrupted during creation
- Verify disk space available
- Try: `hdiutil verify build/RetroBat-8.0.0-macOS-arm64.dmg`
- Recreate DMG with lower compression

#### PKG Installation Fails

**Problem**: Installer shows error

**Solutions**:
- Check pre-install script for errors
- Verify file permissions in PKG
- Test scripts manually: `bash macos/pkg-scripts/preinstall`
- Check installer log: `/var/log/install.log`

### Debug Mode

Enable verbose output in scripts:

```bash
# Add to beginning of any script
set -x  # Print commands as they execute
```

### Getting Help

- Check script output for error messages
- Review system logs: Console.app
- Check installer logs: `/var/log/install.log`
- Verify file permissions and ownership
- Test on different macOS versions

## Advanced Topics

### Custom App Icon

To use a different icon:

1. Place new icon source in `resources/`
2. Update `macos/create-icon.sh` with new source path
3. Run icon creation script

### Bundle Embedded Frameworks

To include custom frameworks:

1. Copy frameworks to `build/RetroBat.app/Contents/Frameworks/`
2. Update Info.plist with framework references
3. Sign frameworks individually before signing app bundle

### Customize Installer UI

Edit the HTML files in PKG creation:
- `welcome.html` - Welcome screen
- `readme.html` - Installation information
- `conclusion.html` - Post-installation message

### Automated Building

Create a CI/CD pipeline:

```yaml
# Example GitHub Actions workflow
- name: Build App Bundle
  run: ./macos/build-app-bundle.sh $VERSION

- name: Create DMG
  run: ./macos/create-dmg.sh $VERSION

- name: Create PKG
  run: ./macos/create-pkg.sh $VERSION
```

## References

- [Apple Developer Documentation](https://developer.apple.com/documentation/)
- [Code Signing Guide](https://developer.apple.com/library/archive/documentation/Security/Conceptual/CodeSigningGuide/)
- [Notarization Guide](https://developer.apple.com/documentation/security/notarizing_macos_software_before_distribution)
- [App Bundle Programming Guide](https://developer.apple.com/library/archive/documentation/CoreFoundation/Conceptual/CFBundles/)
- [PKG Building Guide](https://developer.apple.com/library/archive/documentation/DeveloperTools/Reference/DistributionDefinitionRef/)

## License

RetroBat is open source. See [license.txt](../license.txt) for details.

---

**Last Updated**: 2024-02-07  
**Version**: 1.0  
**Author**: RetroBat Team
