#!/bin/bash
# Complete workflow for building and packaging RetroBat for macOS
# This script runs all steps in sequence

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

# Configuration
VERSION="${1:-8.0.0}"
SKIP_BUILD="${SKIP_BUILD:-false}"
SKIP_ICON="${SKIP_ICON:-false}"
SIGN="${SIGN:-false}"
NOTARIZE="${NOTARIZE:-false}"

echo "=========================================="
echo "RetroBat macOS Complete Build Workflow"
echo "=========================================="
echo "Version: $VERSION"
echo "Options:"
echo "  SKIP_BUILD: $SKIP_BUILD"
echo "  SKIP_ICON: $SKIP_ICON"
echo "  SIGN: $SIGN"
echo "  NOTARIZE: $NOTARIZE"
echo ""

# Check if running on macOS
if [[ "$OSTYPE" != "darwin"* ]]; then
    echo "Error: This script must run on macOS"
    exit 1
fi

# Check dependencies
echo "Checking dependencies..."
MISSING_DEPS=()

for required_cmd in 7z wget dotnet; do
    if ! command -v $required_cmd &> /dev/null; then
        MISSING_DEPS+=("$required_cmd")
    fi
done

if [ ${#MISSING_DEPS[@]} -gt 0 ]; then
    echo "Error: Missing dependencies: ${MISSING_DEPS[*]}"
    echo "Install them with: brew install ${MISSING_DEPS[*]}"
    exit 1
fi

echo "✓ All dependencies found"
echo ""

# Step 1: Build RetroBat (optional)
if [ "$SKIP_BUILD" != "true" ]; then
    echo "=========================================="
    echo "Step 1: Building RetroBat"
    echo "=========================================="
    echo ""
    
    cd "$PROJECT_ROOT"
    
    # Check if build.ini exists
    if [ ! -f build.ini ]; then
        echo "Creating build.ini from build-macos.ini..."
        cp build-macos.ini build.ini
    fi
    
    # Build with RetroBuild
    if [ -f "src/RetroBuild/RetroBuild.csproj" ]; then
        echo "Building with .NET..."
        dotnet build src/RetroBuild/RetroBuild.csproj -c Release
        dotnet run --project src/RetroBuild/RetroBuild.csproj -c Release
    elif [ -f "RetroBuild.exe" ]; then
        echo "Running RetroBuild.exe..."
        dotnet RetroBuild.exe
    else
        echo "Error: RetroBuild not found"
        exit 1
    fi
    
    echo ""
    echo "✓ Build complete"
    echo ""
else
    echo "Skipping RetroBat build (SKIP_BUILD=true)"
    echo ""
fi

# Step 2: Create app icon
if [ "$SKIP_ICON" != "true" ]; then
    echo "=========================================="
    echo "Step 2: Creating App Icon"
    echo "=========================================="
    echo ""
    
    cd "$SCRIPT_DIR"
    
    if [ -f "$PROJECT_ROOT/macos/app-bundle/RetroBat.icns" ]; then
        echo "App icon already exists, skipping..."
    else
        ./create-icon.sh
    fi
    
    echo ""
    echo "✓ Icon ready"
    echo ""
else
    echo "Skipping icon creation (SKIP_ICON=true)"
    echo ""
fi

# Step 3: Build app bundle
echo "=========================================="
echo "Step 3: Building App Bundle"
echo "=========================================="
echo ""

cd "$SCRIPT_DIR"
./build-app-bundle.sh "$VERSION"

echo ""

# Step 4: Create DMG
echo "=========================================="
echo "Step 4: Creating DMG Installer"
echo "=========================================="
echo ""

./create-dmg.sh "$VERSION"

echo ""

# Step 5: Create PKG
echo "=========================================="
echo "Step 5: Creating PKG Installer"
echo "=========================================="
echo ""

./create-pkg.sh "$VERSION"

echo ""

# Step 6: Code signing (optional)
if [ "$SIGN" = "true" ]; then
    echo "=========================================="
    echo "Step 6: Code Signing"
    echo "=========================================="
    echo ""
    
    if [ -z "$APP_SIGNING_IDENTITY" ] || [ -z "$INSTALLER_SIGNING_IDENTITY" ]; then
        echo "Warning: Signing identities not set"
        echo "Set APP_SIGNING_IDENTITY and INSTALLER_SIGNING_IDENTITY environment variables"
        echo "Skipping code signing..."
    else
        ./sign.sh
    fi
    
    echo ""
else
    echo "Skipping code signing (SIGN=false)"
    echo ""
fi

# Step 7: Notarization (optional)
if [ "$NOTARIZE" = "true" ]; then
    echo "=========================================="
    echo "Step 7: Notarization"
    echo "=========================================="
    echo ""
    
    if [ -z "$APPLE_ID" ] || [ -z "$APPLE_TEAM_ID" ] || [ -z "$APPLE_PASSWORD" ]; then
        echo "Warning: Apple credentials not set"
        echo "Set APPLE_ID, APPLE_TEAM_ID, and APPLE_PASSWORD environment variables"
        echo "Skipping notarization..."
    else
        ./notarize.sh
    fi
    
    echo ""
else
    echo "Skipping notarization (NOTARIZE=false)"
    echo ""
fi

# Generate checksums
echo "=========================================="
echo "Step 8: Generating Checksums"
echo "=========================================="
echo ""

cd "$PROJECT_ROOT/build"

for file in RetroBat-${VERSION}-macOS-arm64.{dmg,pkg}; do
    if [ -f "$file" ]; then
        echo "Generating checksum for $file..."
        shasum -a 256 "$file" > "${file}.sha256"
        cat "${file}.sha256"
    fi
done

echo ""

# Summary
echo "=========================================="
echo "✓ Build Workflow Complete!"
echo "=========================================="
echo ""
echo "Output files in build/:"
ls -lh "$PROJECT_ROOT/build" | grep -E "(\.app|\.dmg|\.pkg|\.sha256)" || echo "No output files found"
echo ""

if [ "$SIGN" != "true" ]; then
    echo "Note: Packages are not signed. To sign them:"
    echo "  export APP_SIGNING_IDENTITY='Developer ID Application: Your Name'"
    echo "  export INSTALLER_SIGNING_IDENTITY='Developer ID Installer: Your Name'"
    echo "  SIGN=true ./macos/build-all.sh $VERSION"
    echo ""
fi

if [ "$NOTARIZE" != "true" ] && [ "$SIGN" = "true" ]; then
    echo "Note: Packages are not notarized. To notarize them:"
    echo "  export APPLE_ID='your-email@example.com'"
    echo "  export APPLE_TEAM_ID='YOUR_TEAM_ID'"
    echo "  export APPLE_PASSWORD='app-specific-password'"
    echo "  NOTARIZE=true ./macos/build-all.sh $VERSION"
    echo ""
fi

echo "Next steps:"
echo "  1. Test the app: open build/RetroBat.app"
echo "  2. Test DMG: open build/RetroBat-${VERSION}-macOS-arm64.dmg"
echo "  3. Test PKG: open build/RetroBat-${VERSION}-macOS-arm64.pkg"
echo ""
echo "For distribution:"
echo "  1. Upload to GitHub Releases"
echo "  2. Include .sha256 checksum files"
echo "  3. Update release notes"
echo ""
