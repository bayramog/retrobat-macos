#!/bin/bash
# Script to code sign RetroBat app bundle and installer packages
# Requires Apple Developer ID certificates

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

# Configuration
BUILD_DIR="$PROJECT_ROOT/build"
APP_BUNDLE="$BUILD_DIR/RetroBat.app"
ENTITLEMENTS="$PROJECT_ROOT/macos/app-bundle/entitlements.plist"

# Certificate identities (set via environment variables or command line)
APP_SIGNING_IDENTITY="${APP_SIGNING_IDENTITY:-Developer ID Application}"
INSTALLER_SIGNING_IDENTITY="${INSTALLER_SIGNING_IDENTITY:-Developer ID Installer}"

echo "=========================================="
echo "RetroBat Code Signing"
echo "=========================================="
echo ""

# Check if running on macOS
if [[ "$OSTYPE" != "darwin"* ]]; then
    echo "Error: Code signing must be performed on macOS"
    exit 1
fi

# Check if codesign is available
if ! command -v codesign &> /dev/null; then
    echo "Error: 'codesign' command not found"
    exit 1
fi

# Function to sign a binary/library
sign_binary() {
    local file="$1"
    local identifier="$2"
    
    echo "Signing: $file"
    codesign --force \
             --sign "$APP_SIGNING_IDENTITY" \
             --identifier "$identifier" \
             --entitlements "$ENTITLEMENTS" \
             --options runtime \
             --timestamp \
             --deep \
             "$file"
}

# Function to verify code signature
verify_signature() {
    local file="$1"
    echo "Verifying: $file"
    codesign --verify --deep --strict --verbose=2 "$file"
    echo "✓ Signature valid"
}

# Sign App Bundle
if [ -d "$APP_BUNDLE" ]; then
    echo "Signing app bundle..."
    echo "App: $APP_BUNDLE"
    echo "Identity: $APP_SIGNING_IDENTITY"
    echo "Entitlements: $ENTITLEMENTS"
    echo ""
    
    # Check if entitlements file exists
    if [ ! -f "$ENTITLEMENTS" ]; then
        echo "Error: Entitlements file not found: $ENTITLEMENTS"
        exit 1
    fi
    
    # Sign all frameworks, dylibs, and executables first (inside-out signing)
    echo "Signing frameworks and libraries..."
    
    # Sign .dylib files
    find "$APP_BUNDLE" -name "*.dylib" -print0 | while IFS= read -r -d '' dylib; do
        sign_binary "$dylib" "org.retrobat.RetroBat.$(basename "$dylib")"
    done
    
    # Sign .framework bundles
    find "$APP_BUNDLE/Contents/Frameworks" -name "*.framework" -print0 2>/dev/null | while IFS= read -r -d '' framework; do
        sign_binary "$framework" "org.retrobat.RetroBat.$(basename "$framework" .framework)"
    done
    
    # Sign executables in MacOS directory
    if [ -d "$APP_BUNDLE/Contents/MacOS" ]; then
        find "$APP_BUNDLE/Contents/MacOS" -type f -perm +111 -print0 | while IFS= read -r -d '' exe; do
            sign_binary "$exe" "org.retrobat.RetroBat.$(basename "$exe")"
        done
    fi
    
    # Finally sign the app bundle itself
    echo ""
    echo "Signing main app bundle..."
    codesign --force \
             --sign "$APP_SIGNING_IDENTITY" \
             --identifier "org.retrobat.RetroBat" \
             --entitlements "$ENTITLEMENTS" \
             --options runtime \
             --timestamp \
             "$APP_BUNDLE"
    
    echo ""
    verify_signature "$APP_BUNDLE"
    
    echo ""
    echo "✓ App bundle signed successfully"
else
    echo "Warning: App bundle not found: $APP_BUNDLE"
    echo "Skipping app signing"
fi

# Sign DMG (if exists)
DMG_FILES=("$BUILD_DIR"/*.dmg)
if [ -f "${DMG_FILES[0]}" ]; then
    echo ""
    echo "Signing DMG files..."
    for dmg in "${DMG_FILES[@]}"; do
        if [ -f "$dmg" ]; then
            echo "Signing: $dmg"
            codesign --force \
                     --sign "$APP_SIGNING_IDENTITY" \
                     --timestamp \
                     "$dmg"
            verify_signature "$dmg"
            echo "✓ DMG signed: $(basename "$dmg")"
        fi
    done
fi

# Sign PKG (if exists)
PKG_FILES=("$BUILD_DIR"/*.pkg)
if [ -f "${PKG_FILES[0]}" ]; then
    echo ""
    echo "Signing PKG files..."
    for pkg in "${PKG_FILES[@]}"; do
        if [ -f "$pkg" ]; then
            # Create signed version
            signed_pkg="${pkg%.pkg}-signed.pkg"
            echo "Signing: $pkg -> $signed_pkg"
            productsign --sign "$INSTALLER_SIGNING_IDENTITY" \
                       --timestamp \
                       "$pkg" \
                       "$signed_pkg"
            
            # Verify
            pkgutil --check-signature "$signed_pkg"
            echo "✓ PKG signed: $(basename "$signed_pkg")"
            
            # Replace original with signed version
            mv "$signed_pkg" "$pkg"
        fi
    done
fi

echo ""
echo "=========================================="
echo "✓ Code Signing Complete!"
echo "=========================================="
echo ""
echo "Signed files:"
[ -d "$APP_BUNDLE" ] && echo "  - App Bundle: $APP_BUNDLE"
[ -f "${DMG_FILES[0]}" ] && echo "  - DMG: $(basename "${DMG_FILES[0]}")"
[ -f "${PKG_FILES[0]}" ] && echo "  - PKG: $(basename "${PKG_FILES[0]}")"
echo ""
echo "Next step: Notarize with Apple"
echo "  Run: ./macos/notarize.sh"
echo ""
