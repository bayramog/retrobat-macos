#!/bin/bash
# Script to create macOS .dmg disk image installer for RetroBat

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

# Configuration
APP_NAME="RetroBat"
VERSION="${1:-8.0.0}"
BUILD_DIR="$PROJECT_ROOT/build"
APP_BUNDLE="$BUILD_DIR/RetroBat.app"
DMG_OUTPUT="$BUILD_DIR/RetroBat-${VERSION}-macOS-arm64.dmg"
DMG_TEMP="/tmp/RetroBat-dmg"
DMG_VOLUME_NAME="RetroBat ${VERSION}"
DMG_BACKGROUND="$PROJECT_ROOT/macos/dmg-assets/background.png"
DMG_WINDOW_WIDTH=600
DMG_WINDOW_HEIGHT=450
DMG_ICON_SIZE=128
DMG_TEXT_SIZE=12

echo "=========================================="
echo "Creating RetroBat DMG Installer"
echo "=========================================="
echo "Version: $VERSION"
echo "App Bundle: $APP_BUNDLE"
echo "Output: $DMG_OUTPUT"
echo ""

# Check if app bundle exists
if [ ! -d "$APP_BUNDLE" ]; then
    echo "Error: App bundle not found: $APP_BUNDLE"
    echo "Please build the app bundle first."
    exit 1
fi

# Check if hdiutil is available
if ! command -v hdiutil &> /dev/null; then
    echo "Error: 'hdiutil' command not found. This script must run on macOS."
    exit 1
fi

# Clean up any existing DMG
echo "Cleaning up previous builds..."
rm -f "$DMG_OUTPUT"
rm -rf "$DMG_TEMP"

# Create temporary DMG directory
echo "Creating temporary DMG structure..."
mkdir -p "$DMG_TEMP"

# Copy app bundle to temp directory
echo "Copying app bundle..."
cp -R "$APP_BUNDLE" "$DMG_TEMP/"

# Create Applications folder symlink
echo "Creating Applications folder symlink..."
ln -s /Applications "$DMG_TEMP/Applications"

# Create .background directory for custom background (if it exists)
if [ -f "$DMG_BACKGROUND" ]; then
    echo "Adding custom background..."
    mkdir -p "$DMG_TEMP/.background"
    cp "$DMG_BACKGROUND" "$DMG_TEMP/.background/background.png"
fi

# Create README file
echo "Creating README..."
cat > "$DMG_TEMP/README.txt" << 'EOF'
RetroBat for macOS Apple Silicon
=================================

INSTALLATION
------------
1. Drag the RetroBat.app icon to the Applications folder
2. Open Applications folder and right-click RetroBat.app
3. Select "Open" from the menu (required for first launch)
4. Click "Open" in the security dialog

REQUIREMENTS
------------
- macOS 11.0 (Big Sur) or later
- Apple Silicon (M1/M2/M3/M4)
- Homebrew with required dependencies:
  * brew install sdl2 p7zip wget

FIRST RUN
---------
On first launch, RetroBat will:
- Create necessary directories in ~/RetroBat
- Download EmulationStation and RetroArch
- Setup configuration files

For more information, visit:
https://github.com/bayramog/retrobat-macos

UNINSTALLATION
--------------
1. Delete RetroBat.app from Applications
2. Delete ~/RetroBat directory (optional, contains ROMs and saves)
3. Delete ~/Library/Application Support/RetroBat (optional)

LICENSE
-------
See license.txt in the app bundle for details.

Enjoy your retro gaming experience!
EOF

# Create initial DMG
echo "Creating initial DMG..."
hdiutil create -volname "$DMG_VOLUME_NAME" \
               -srcfolder "$DMG_TEMP" \
               -ov \
               -format UDRW \
               -fs HFS+ \
               "$DMG_OUTPUT.temp.dmg"

# Mount the DMG
echo "Mounting DMG..."
MOUNT_DIR=$(hdiutil attach -readwrite -noverify -noautoopen "$DMG_OUTPUT.temp.dmg" | grep Volumes | awk '{print $3}')

echo "Mounted at: $MOUNT_DIR"

# Set custom icon positions and window properties using AppleScript
echo "Configuring DMG appearance..."
cat > /tmp/dmg-setup.applescript << EOF
tell application "Finder"
    tell disk "$DMG_VOLUME_NAME"
        open
        set current view of container window to icon view
        set toolbar visible of container window to false
        set statusbar visible of container window to false
        set the bounds of container window to {100, 100, $(($DMG_WINDOW_WIDTH + 100)), $(($DMG_WINDOW_HEIGHT + 100))}
        set viewOptions to the icon view options of container window
        set arrangement of viewOptions to not arranged
        set icon size of viewOptions to $DMG_ICON_SIZE
        set text size of viewOptions to $DMG_TEXT_SIZE
        
EOF

if [ -f "$DMG_BACKGROUND" ]; then
    cat >> /tmp/dmg-setup.applescript << EOF
        set background picture of viewOptions to file ".background:background.png"
EOF
fi

cat >> /tmp/dmg-setup.applescript << EOF
        -- Position icons
        set position of item "RetroBat.app" of container window to {150, 150}
        set position of item "Applications" of container window to {450, 150}
        
        -- Hide README initially (user can find it if needed)
        -- set position of item "README.txt" of container window to {300, 350}
        
        close
        open
        update without registering applications
        delay 2
    end tell
end tell
EOF

# Run AppleScript (may fail in CI environment, that's ok)
if [ -n "$MOUNT_DIR" ]; then
    osascript /tmp/dmg-setup.applescript 2>/dev/null || echo "Warning: Could not set DMG appearance (AppleScript failed)"
fi

# Unmount
echo "Unmounting DMG..."
hdiutil detach "$MOUNT_DIR" -force || true
sleep 2

# Convert to compressed read-only DMG
echo "Compressing DMG..."
hdiutil convert "$DMG_OUTPUT.temp.dmg" \
                -format UDZO \
                -imagekey zlib-level=9 \
                -o "$DMG_OUTPUT"

# Clean up
echo "Cleaning up..."
rm -f "$DMG_OUTPUT.temp.dmg"
rm -rf "$DMG_TEMP"
rm -f /tmp/dmg-setup.applescript

echo ""
echo "=========================================="
echo "✓ DMG Created Successfully!"
echo "=========================================="
echo "Output: $DMG_OUTPUT"
ls -lh "$DMG_OUTPUT"
echo ""
echo "To test the DMG:"
echo "  open $DMG_OUTPUT"
echo ""
