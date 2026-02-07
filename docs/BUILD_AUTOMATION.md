# RetroBat macOS Build Automation

This document describes the automated build system for creating RetroBat macOS releases.

## Overview

The build automation system consists of:

1. **`build-macos.sh`** - Main build script that automates the entire build process
2. **`.github/workflows/build-macos.yml`** - CI/CD workflow for automated builds on GitHub Actions
3. **Configuration files** - `build-macos.ini` for macOS-specific build settings

## Quick Start

### Local Build

```bash
# Full automated build
./build-macos.sh

# Clean build (removes previous build artifacts)
./build-macos.sh --clean

# Build without creating packages (faster for testing)
./build-macos.sh --skip-package

# Skip dependency check (if you know they're installed)
./build-macos.sh --skip-deps
```

### CI/CD Build

The build runs automatically on:
- Push to `main` or `develop` branches
- Pull requests to `main` or `develop`
- Git tags starting with `v` (e.g., `v8.0.0.0`)
- Manual trigger via GitHub Actions UI

## Build Script (build-macos.sh)

### Features

The build script performs the following steps:

1. **Dependency Checking** - Verifies all required tools are installed
2. **Build Configuration** - Prepares `build.ini` from `build-macos.ini`
3. **RetroBuild Compilation** - Builds the RetroBuild tool in Release mode
4. **Resource Downloading** - Downloads RetroArch, cores, themes, etc.
5. **File Organization** - Organizes files into proper directory structure
6. **Code Signing** - Integration point for signing (to be implemented)
7. **Package Creation** - Creates ZIP and DMG distributions
8. **Build Verification** - Verifies all artifacts were created successfully

### Command-Line Options

```bash
./build-macos.sh [options]

Options:
  --skip-deps       Skip dependency checking
  --skip-build      Skip RetroBuild compilation
  --skip-download   Skip resource downloading
  --skip-package    Skip DMG/PKG creation
  --clean           Clean build directory before starting
  --help            Show help message
```

### Examples

```bash
# Full build with clean start
./build-macos.sh --clean

# Quick rebuild (skip downloads)
./build-macos.sh --skip-download

# Build only, no packaging (for development)
./build-macos.sh --skip-package

# Skip everything except packaging (if build exists)
./build-macos.sh --skip-deps --skip-build --skip-download
```

### Environment Variables

The build script supports the following environment variables:

| Variable | Description | Default |
|----------|-------------|---------|
| `RETROBAT_VERSION` | Override version number | From build.ini |
| `SIGNING_IDENTITY` | Code signing identity | None (unsigned) |
| `NOTARIZE_PROFILE` | Notarization profile | None |

Examples:

```bash
# Build with custom version
RETROBAT_VERSION="8.1.0.0-beta" ./build-macos.sh

# Build with signing
SIGNING_IDENTITY="Developer ID Application: Your Name" ./build-macos.sh

# Build with signing and notarization
SIGNING_IDENTITY="Developer ID Application: Your Name" \
NOTARIZE_PROFILE="retrobat-notary" \
./build-macos.sh
```

### Output

The build script creates:

- **`build/`** - Complete RetroBat directory structure
- **`output/`** - Distribution packages
  - `retrobat-macos-v*.zip` - Portable ZIP archive
  - `retrobat-macos-v*.dmg` - macOS disk image
  - `*.sha256` - Checksum files
- **`build-macos.log`** - Detailed build log

## GitHub Actions Workflow

### Workflow File

`.github/workflows/build-macos.yml`

### Triggers

The workflow runs on:

1. **Push to main/develop** - Automated builds for continuous integration
2. **Pull requests** - Test builds to verify changes
3. **Tags (v*)** - Release builds with automatic GitHub release creation
4. **Manual dispatch** - On-demand builds via GitHub UI

### Workflow Inputs

When manually triggered, you can set:

- `skip_package` - Skip package creation for faster test builds

### Workflow Steps

1. **Checkout** - Clone repository with submodules
2. **Setup .NET** - Install .NET 8.0 SDK
3. **Install Dependencies** - Install Homebrew packages
4. **Verify Tools** - Check all tools are working
5. **Run Build Script** - Execute `build-macos.sh`
6. **Verify Artifacts** - Check build outputs
7. **Upload Artifacts** - Store build results
8. **Create Release** - For tagged versions, create GitHub release

### Artifacts

The workflow uploads artifacts:

1. **Build artifacts** - Complete build directory (30 days retention)
2. **Release packages** - ZIP and DMG files (90 days retention)

### Release Creation

For git tags starting with `v`:

- Automatically creates a draft GitHub release
- Attaches DMG and ZIP files
- Includes SHA256 checksums
- Generates release notes template
- Marks as prerelease for alpha/beta/rc tags

## Dependencies

### Required Tools

The following tools must be installed:

| Tool | Homebrew Package | Purpose |
|------|-----------------|---------|
| .NET 8 SDK | `dotnet-sdk` | Build RetroBuild |
| 7-Zip | `p7zip` | Archive creation/extraction |
| wget | `wget` | File downloads |
| curl | Built-in | File downloads |
| git | Built-in | Version control |

### Optional Tools

| Tool | Homebrew Package | Purpose |
|------|-----------------|---------|
| create-dmg | `create-dmg` | Enhanced DMG creation |

### Installation

```bash
# Install all dependencies
brew bundle

# Or install individually
brew install dotnet-sdk p7zip wget create-dmg
```

### Verification

Verify all dependencies are installed:

```bash
./verify-tools.sh
```

## Build Configuration

### build-macos.ini

The `build-macos.ini` file contains macOS-specific configuration:

```ini
[BuilderOptions]
retrobat_version=8.0.0.0
retroarch_version=1.22.2
branch=beta
architecture=osx-arm64
get_batgui=0              # Windows only
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
get_wiimotegun=0          # Windows only
7za_path=7z               # System tool
wget_path=wget            # System tool
curl_path=curl            # System tool
```

### Key Differences from Windows

- `architecture=osx-arm64` - Apple Silicon binaries
- `get_batgui=0` - Windows-only component disabled
- `get_wiimotegun=0` - Windows-only component disabled
- System tools use Homebrew paths (`7z`, `wget`, `curl`)

## Code Signing and Notarization

### Current Status

Code signing and notarization are **not yet implemented** but the integration points exist in the build script.

### Future Implementation

When implemented, signing will work as follows:

```bash
# Set signing identity
export SIGNING_IDENTITY="Developer ID Application: Your Name (TEAMID)"

# Set notarization profile (configured in Keychain)
export NOTARIZE_PROFILE="retrobat-notary"

# Run build with signing
./build-macos.sh
```

### Requirements (Future)

For code signing and notarization, you'll need:

1. **Apple Developer Account** ($99/year)
2. **Developer ID Application Certificate** - For signing apps
3. **Developer ID Installer Certificate** - For signing PKG files
4. **App-Specific Password** - For notarization
5. **Notarization Profile** - Stored in Keychain

### Documentation (Future)

When implemented, see:
- `docs/CODESIGNING_MACOS.md` - Code signing guide
- `scripts/macos-sign.sh` - Signing script
- `scripts/macos-notarize.sh` - Notarization script

## Package Formats

### ZIP Archive

**File**: `retrobat-macos-v{version}-osx-arm64.zip`

- Portable format
- Can be extracted anywhere
- No installation required
- Includes all files from `build/` directory

**Usage**:
```bash
unzip retrobat-macos-v8.0.0.0-osx-arm64.zip
cd build
./emulationstation
```

### DMG Disk Image

**File**: `RetroBat-macOS-v{version}.dmg`

- Standard macOS distribution format
- Provides drag-and-drop installation
- Better user experience than ZIP
- Can be easily opened on any Mac

**Usage**:
1. Double-click DMG file
2. Drag RetroBat to Applications or desired location
3. Eject DMG
4. Run RetroBat

### PKG Installer (Future)

**Status**: Not yet implemented

**Planned Features**:
- Standard macOS installer package
- System-wide or user installation
- Can include install/uninstall scripts
- Required for Mac App Store distribution

## Troubleshooting

### Build Fails: Missing Dependencies

**Error**: Tool not found (7z, wget, dotnet, etc.)

**Solution**:
```bash
# Install all dependencies
brew bundle

# Or verify what's missing
./verify-tools.sh
```

### Build Fails: .NET Version Too Old

**Error**: .NET 8.0 or higher required

**Solution**:
```bash
# Update .NET SDK
brew upgrade dotnet-sdk

# Verify version
dotnet --version
```

### Build Fails: Download Errors

**Error**: Failed to download resources

**Solution**:
1. Check internet connection
2. Verify URLs in `build-macos.ini`
3. Try running with increased verbosity:
   ```bash
   ./build-macos.sh 2>&1 | tee debug.log
   ```

### Build Fails: Out of Disk Space

**Error**: No space left on device

**Solution**:
1. Clean previous builds:
   ```bash
   ./build-macos.sh --clean
   ```
2. Remove old artifacts:
   ```bash
   rm -rf output/ build/
   ```
3. Ensure at least 10GB free space

### DMG Creation Fails

**Error**: hdiutil failed

**Solution**:
1. Ensure build directory exists and is valid
2. Check available disk space
3. Try creating DMG manually:
   ```bash
   hdiutil create -volname "RetroBat" -srcfolder build -ov -format UDZO output/RetroBat.dmg
   ```

### CI/CD Workflow Fails

**Error**: Workflow run failed

**Solution**:
1. Check the Actions tab for detailed logs
2. Look for specific error messages
3. Verify workflow syntax:
   ```bash
   # Install act for local testing
   brew install act
   
   # Test workflow locally
   act -l
   ```

## Best Practices

### Local Development

1. **Use --skip-package for faster iteration**:
   ```bash
   ./build-macos.sh --skip-package
   ```

2. **Only download once**:
   ```bash
   # First build
   ./build-macos.sh
   
   # Subsequent builds
   ./build-macos.sh --skip-download
   ```

3. **Clean builds for testing**:
   ```bash
   ./build-macos.sh --clean
   ```

### CI/CD

1. **Test with pull requests** before merging
2. **Use draft releases** for testing release process
3. **Tag releases properly**:
   ```bash
   git tag -a v8.0.0.0 -m "Release 8.0.0.0"
   git push origin v8.0.0.0
   ```

### Release Process

1. Update version in `build-macos.ini`
2. Create and test build locally
3. Commit changes
4. Create git tag:
   ```bash
   git tag -a v8.0.0.0 -m "Release 8.0.0.0"
   ```
5. Push with tags:
   ```bash
   git push origin main --tags
   ```
6. Wait for CI to build and create draft release
7. Review and publish release on GitHub

## Advanced Usage

### Custom Build Location

```bash
# Build in a different directory
BUILD_DIR=/path/to/custom/build ./build-macos.sh
```

### Parallel Builds

The build script is designed to be run once at a time. For parallel builds:

```bash
# Use separate directories
BUILD_DIR=build1 ./build-macos.sh &
BUILD_DIR=build2 ./build-macos.sh &
wait
```

### Debug Mode

```bash
# Enable bash debug mode
bash -x ./build-macos.sh 2>&1 | tee debug.log
```

### Testing Individual Steps

```bash
# Just check dependencies
./build-macos.sh --skip-build --skip-download --skip-package

# Just build RetroBuild
./build-macos.sh --skip-deps --skip-download --skip-package

# Just create packages
./build-macos.sh --skip-deps --skip-build --skip-download
```

## Performance

### Build Times

Typical build times on GitHub Actions (macos-14):

- **Checkout and setup**: ~2 minutes
- **RetroBuild compilation**: ~1 minute
- **Resource downloading**: ~10-30 minutes (depends on internet)
- **Package creation**: ~2-5 minutes
- **Total**: ~15-40 minutes

### Optimizations

1. **Use --skip-download** for development builds
2. **Use --skip-package** for faster testing
3. **Cache Homebrew dependencies** in CI (future improvement)
4. **Parallel downloads** in RetroBuild (future improvement)

## Contributing

### Adding New Features

1. Update `build-macos.sh` with new functionality
2. Update this documentation
3. Test locally before submitting PR
4. Update workflow if needed

### Testing Changes

```bash
# Test build script changes
./build-macos.sh --clean

# Test workflow changes locally
act -j build-macos
```

### Documentation Updates

Keep the following in sync:
- This file (`docs/BUILD_AUTOMATION.md`)
- Build script help text (`./build-macos.sh --help`)
- README.md sections on building
- Workflow file comments

## Future Enhancements

### Planned Features

- [ ] Code signing integration
- [ ] Notarization support
- [ ] PKG installer creation
- [ ] Incremental builds
- [ ] Build caching
- [ ] Parallel downloads
- [ ] Progress bars
- [ ] Build statistics
- [ ] Automated testing
- [ ] Multi-architecture support (Intel + Apple Silicon universal binaries)

### Ideas for Improvement

- Split large downloads into resumable chunks
- Add retry logic for failed downloads
- Implement build artifacts cache
- Add build time tracking and reports
- Create separate test workflow
- Add deployment to hosting service

## Support

### Getting Help

- **Issues**: Report problems at https://github.com/bayramog/retrobat-macos/issues
- **Discussions**: Ask questions in GitHub Discussions
- **Documentation**: Check `docs/` directory for more guides

### Useful Links

- [RetroBat Official](https://www.retrobat.org/)
- [Building on macOS](BUILDING_RETROBUILD_MACOS.md)
- [GitHub Actions Documentation](https://docs.github.com/en/actions)

---

Last updated: 2026-02-07
