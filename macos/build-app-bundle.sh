#!/bin/bash
# Master script to build RetroBat app bundle from build output
# This script creates the proper app bundle structure

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

# Configuration
VERSION="${1:-8.0.0}"
BUILD_DIR="$PROJECT_ROOT/build"
APP_BUNDLE="$BUILD_DIR/RetroBat.app"
APP_CONTENTS="$APP_BUNDLE/Contents"
APP_MACOS="$APP_CONTENTS/MacOS"
APP_RESOURCES="$APP_CONTENTS/Resources"
APP_FRAMEWORKS="$APP_CONTENTS/Frameworks"

echo "=========================================="
echo "Building RetroBat App Bundle"
echo "=========================================="
echo "Version: $VERSION"
echo "Build Dir: $BUILD_DIR"
echo "App Bundle: $APP_BUNDLE"
echo ""

# Check if build directory exists
if [ ! -d "$BUILD_DIR" ]; then
    echo "Error: Build directory not found: $BUILD_DIR"
    echo "Please run RetroBuild first to create the build output"
    exit 1
fi

# Clean up any existing app bundle
if [ -d "$APP_BUNDLE" ]; then
    echo "Removing existing app bundle..."
    rm -rf "$APP_BUNDLE"
fi

# Create app bundle structure
echo "Creating app bundle structure..."
mkdir -p "$APP_MACOS"
mkdir -p "$APP_RESOURCES"
mkdir -p "$APP_FRAMEWORKS"

# Copy Info.plist
echo "Copying Info.plist..."
if [ -f "$PROJECT_ROOT/macos/app-bundle/Info.plist" ]; then
    # Update version in Info.plist
    cp "$PROJECT_ROOT/macos/app-bundle/Info.plist" "$APP_CONTENTS/"
    
    # Update version numbers if plutil is available
    if command -v plutil &> /dev/null; then
        plutil -replace CFBundleShortVersionString -string "$VERSION" "$APP_CONTENTS/Info.plist"
        plutil -replace CFBundleVersion -string "${VERSION}.0" "$APP_CONTENTS/Info.plist"
    fi
else
    echo "Error: Info.plist not found"
    exit 1
fi

# Copy entitlements
echo "Copying entitlements..."
if [ -f "$PROJECT_ROOT/macos/app-bundle/entitlements.plist" ]; then
    cp "$PROJECT_ROOT/macos/app-bundle/entitlements.plist" "$APP_CONTENTS/"
fi

# Copy app icon
echo "Copying app icon..."
if [ -f "$PROJECT_ROOT/macos/app-bundle/RetroBat.icns" ]; then
    cp "$PROJECT_ROOT/macos/app-bundle/RetroBat.icns" "$APP_RESOURCES/"
else
    echo "Warning: App icon not found. Run macos/create-icon.sh first"
fi

# Create launcher script
echo "Creating launcher script..."
cat > "$APP_MACOS/RetroBat" << 'LAUNCHER_EOF'
#!/bin/bash
# RetroBat launcher script

# Get the app bundle path
APP_BUNDLE="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
RESOURCES="$APP_BUNDLE/Contents/Resources"

# Change to resources directory
cd "$RESOURCES"

# Set up environment
export RETROBAT_ROOT="$RESOURCES"
export DYLD_FRAMEWORK_PATH="$APP_BUNDLE/Contents/Frameworks"

# Check for required dependencies
if ! command -v 7z &> /dev/null; then
    osascript -e 'display dialog "Required dependency missing: p7zip\n\nPlease install Homebrew dependencies:\nbrew install p7zip wget sdl2" buttons {"OK"} default button "OK" with icon stop with title "RetroBat"'
    exit 1
fi

if ! command -v wget &> /dev/null; then
    osascript -e 'display dialog "Required dependency missing: wget\n\nPlease install Homebrew dependencies:\nbrew install p7zip wget sdl2" buttons {"OK"} default button "OK" with icon stop with title "RetroBat"'
    exit 1
fi

# Check for SDL2
if [ ! -f "/opt/homebrew/lib/libSDL2.dylib" ] && [ ! -f "/usr/local/lib/libSDL2.dylib" ]; then
    osascript -e 'display dialog "Required dependency missing: SDL2\n\nPlease install Homebrew dependencies:\nbrew install p7zip wget sdl2" buttons {"OK"} default button "OK" with icon stop with title "RetroBat"'
    exit 1
fi

# Launch EmulationStation (if available)
if [ -f "$RESOURCES/emulationstation/emulationstation" ]; then
    exec "$RESOURCES/emulationstation/emulationstation"
else
    # First run - need to build/download
    if [ -f "$RESOURCES/RetroBuild" ]; then
        # Run RetroBuild to download and setup
        exec "$RESOURCES/RetroBuild"
    else
        osascript -e 'display dialog "RetroBat is not properly configured.\n\nPlease run RetroBuild first to download required components." buttons {"OK"} default button "OK" with icon stop with title "RetroBat"'
        exit 1
    fi
fi
LAUNCHER_EOF

chmod +x "$APP_MACOS/RetroBat"

# Copy build output to Resources
echo "Copying build contents to Resources..."

# Copy system directory
if [ -d "$BUILD_DIR/system" ]; then
    echo "  - system/"
    cp -R "$BUILD_DIR/system" "$APP_RESOURCES/"
fi

# Copy emulationstation (if available)
if [ -d "$BUILD_DIR/emulationstation" ]; then
    echo "  - emulationstation/"
    cp -R "$BUILD_DIR/emulationstation" "$APP_RESOURCES/"
fi

# Copy RetroArch (if available)
if [ -d "$BUILD_DIR/emulators/retroarch" ]; then
    echo "  - RetroArch/"
    mkdir -p "$APP_RESOURCES/emulators"
    cp -R "$BUILD_DIR/emulators/retroarch" "$APP_RESOURCES/emulators/"
fi

# Copy RetroBuild
if [ -f "$BUILD_DIR/../src/RetroBuild/bin/Release/net8.0/osx-arm64/publish/RetroBuild" ]; then
    echo "  - RetroBuild"
    cp "$BUILD_DIR/../src/RetroBuild/bin/Release/net8.0/osx-arm64/publish/RetroBuild" "$APP_RESOURCES/"
elif [ -f "$PROJECT_ROOT/RetroBuild.exe" ]; then
    echo "  - RetroBuild.exe (will need .NET runtime)"
    cp "$PROJECT_ROOT/RetroBuild.exe" "$APP_RESOURCES/"
fi

# Copy configuration files
echo "Copying configuration files..."
for config in retrobat.ini build-macos.ini license.txt; do
    if [ -f "$BUILD_DIR/$config" ] || [ -f "$PROJECT_ROOT/$config" ]; then
        echo "  - $config"
        [ -f "$BUILD_DIR/$config" ] && cp "$BUILD_DIR/$config" "$APP_RESOURCES/" || cp "$PROJECT_ROOT/$config" "$APP_RESOURCES/"
    fi
done

# Copy README
if [ -f "$PROJECT_ROOT/README.md" ]; then
    cp "$PROJECT_ROOT/README.md" "$APP_RESOURCES/"
fi

# Set proper permissions
echo "Setting permissions..."
chmod -R 755 "$APP_BUNDLE"
find "$APP_MACOS" -type f -exec chmod +x {} \;

echo ""
echo "✓ App Bundle Created Successfully!"
echo ""
echo "Location: $APP_BUNDLE"
echo "Size: $(du -sh "$APP_BUNDLE" | cut -f1)"
echo ""
echo "Next steps:"
echo "  1. Test the app: open $APP_BUNDLE"
echo "  2. Create icon: ./macos/create-icon.sh"
echo "  3. Create DMG: ./macos/create-dmg.sh $VERSION"
echo "  4. Create PKG: ./macos/create-pkg.sh $VERSION"
echo "  5. Sign: ./macos/sign.sh"
echo "  6. Notarize: ./macos/notarize.sh"
echo ""
