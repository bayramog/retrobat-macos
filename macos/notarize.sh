#!/bin/bash
# Script to notarize RetroBat with Apple
# Requires Apple Developer account and app-specific password

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
BUILD_DIR="$PROJECT_ROOT/build"

# Configuration (set via environment variables)
APPLE_ID="${APPLE_ID:-}"
APPLE_TEAM_ID="${APPLE_TEAM_ID:-}"
APPLE_PASSWORD="${APPLE_PASSWORD:-}"  # App-specific password

echo "=========================================="
echo "RetroBat Notarization"
echo "=========================================="
echo ""

# Check if running on macOS
if [[ "$OSTYPE" != "darwin"* ]]; then
    echo "Error: Notarization must be performed on macOS"
    exit 1
fi

# Check if xcrun is available
if ! command -v xcrun &> /dev/null; then
    echo "Error: 'xcrun' command not found. Install Xcode Command Line Tools."
    exit 1
fi

# Check if credentials are provided
if [ -z "$APPLE_ID" ] || [ -z "$APPLE_TEAM_ID" ] || [ -z "$APPLE_PASSWORD" ]; then
    echo "Error: Apple credentials not provided"
    echo ""
    echo "Set the following environment variables:"
    echo "  export APPLE_ID='your-apple-id@example.com'"
    echo "  export APPLE_TEAM_ID='YOUR_TEAM_ID'"
    echo "  export APPLE_PASSWORD='app-specific-password'"
    echo ""
    echo "To create an app-specific password:"
    echo "  1. Go to appleid.apple.com"
    echo "  2. Sign in with your Apple ID"
    echo "  3. Go to Security section"
    echo "  4. Click 'Generate Password' under App-Specific Passwords"
    echo ""
    exit 1
fi

# Function to notarize a file
notarize_file() {
    local file="$1"
    local filename=$(basename "$file")
    
    echo "Notarizing: $filename"
    echo "This may take several minutes..."
    echo ""
    
    # Submit for notarization
    echo "Uploading to Apple..."
    xcrun notarytool submit "$file" \
        --apple-id "$APPLE_ID" \
        --team-id "$APPLE_TEAM_ID" \
        --password "$APPLE_PASSWORD" \
        --wait
    
    # Check status
    if [ $? -eq 0 ]; then
        echo "✓ Notarization successful: $filename"
        
        # Staple the notarization ticket (for offline verification)
        # Note: Stapling works for app bundles, DMGs, and PKGs
        if [[ "$file" == *.app ]] || [[ "$file" == *.dmg ]] || [[ "$file" == *.pkg ]]; then
            echo "Stapling notarization ticket..."
            xcrun stapler staple "$file"
            
            # Verify stapling
            xcrun stapler validate "$file"
            echo "✓ Notarization ticket stapled"
        fi
        
        return 0
    else
        echo "✗ Notarization failed: $filename"
        return 1
    fi
}

# Notarize DMG files
echo "Looking for DMG files to notarize..."
DMG_FILES=("$BUILD_DIR"/*.dmg)
if [ -f "${DMG_FILES[0]}" ]; then
    for dmg in "${DMG_FILES[@]}"; do
        if [ -f "$dmg" ]; then
            echo ""
            notarize_file "$dmg"
        fi
    done
else
    echo "No DMG files found"
fi

# Notarize PKG files
echo ""
echo "Looking for PKG files to notarize..."
PKG_FILES=("$BUILD_DIR"/*.pkg)
if [ -f "${PKG_FILES[0]}" ]; then
    for pkg in "${PKG_FILES[@]}"; do
        if [ -f "$pkg" ]; then
            echo ""
            notarize_file "$pkg"
        fi
    done
else
    echo "No PKG files found"
fi

# Notarize app bundle (create a zip first)
APP_BUNDLE="$BUILD_DIR/RetroBat.app"
if [ -d "$APP_BUNDLE" ]; then
    echo ""
    echo "Notarizing app bundle..."
    APP_ZIP="$BUILD_DIR/RetroBat.app.zip"
    
    # Create zip for notarization
    echo "Creating zip archive..."
    ditto -c -k --keepParent "$APP_BUNDLE" "$APP_ZIP"
    
    notarize_file "$APP_ZIP"
    
    # Clean up zip
    rm -f "$APP_ZIP"
fi

echo ""
echo "=========================================="
echo "✓ Notarization Complete!"
echo "=========================================="
echo ""
echo "Your files are now notarized and can be distributed."
echo ""
echo "Users will be able to:"
echo "  - Open the app without security warnings"
echo "  - Install DMG/PKG without Gatekeeper issues"
echo ""
echo "To verify notarization:"
echo "  spctl --assess --verbose=4 --type execute RetroBat.app"
echo "  spctl --assess --verbose=4 --type install RetroBat.pkg"
echo ""
