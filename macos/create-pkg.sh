#!/bin/bash
# Script to create macOS .pkg installer package for RetroBat

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

# Configuration
APP_NAME="RetroBat"
VERSION="${1:-8.0.0}"
BUILD_DIR="$PROJECT_ROOT/build"
APP_BUNDLE="$BUILD_DIR/RetroBat.app"
PKG_OUTPUT="$BUILD_DIR/RetroBat-${VERSION}-macOS-arm64.pkg"
PKG_IDENTIFIER="org.retrobat.RetroBat"
PKG_SCRIPTS="$PROJECT_ROOT/macos/pkg-scripts"
PKG_TEMP="/tmp/RetroBat-pkg"
PKG_ROOT="$PKG_TEMP/root"
PKG_COMPONENT="$PKG_TEMP/RetroBat.pkg"

echo "=========================================="
echo "Creating RetroBat PKG Installer"
echo "=========================================="
echo "Version: $VERSION"
echo "App Bundle: $APP_BUNDLE"
echo "Output: $PKG_OUTPUT"
echo ""

# Check if app bundle exists
if [ ! -d "$APP_BUNDLE" ]; then
    echo "Error: App bundle not found: $APP_BUNDLE"
    echo "Please build the app bundle first."
    exit 1
fi

# Check if pkgbuild and productbuild are available
if ! command -v pkgbuild &> /dev/null; then
    echo "Error: 'pkgbuild' command not found. This script must run on macOS."
    exit 1
fi

if ! command -v productbuild &> /dev/null; then
    echo "Error: 'productbuild' command not found. This script must run on macOS."
    exit 1
fi

# Clean up any existing package
echo "Cleaning up previous builds..."
rm -f "$PKG_OUTPUT"
rm -rf "$PKG_TEMP"

# Create package root directory structure
echo "Creating package structure..."
mkdir -p "$PKG_ROOT/Applications"

# Copy app bundle to package root
echo "Copying app bundle..."
cp -R "$APP_BUNDLE" "$PKG_ROOT/Applications/"

# Build component package
echo "Building component package..."
pkgbuild --root "$PKG_ROOT" \
         --identifier "$PKG_IDENTIFIER" \
         --version "$VERSION" \
         --install-location "/" \
         --scripts "$PKG_SCRIPTS" \
         "$PKG_COMPONENT"

# Create distribution.xml for product package
echo "Creating distribution definition..."
cat > "$PKG_TEMP/distribution.xml" << EOF
<?xml version="1.0" encoding="utf-8"?>
<installer-gui-script minSpecVersion="2">
    <title>RetroBat ${VERSION}</title>
    <organization>org.retrobat</organization>
    <domains enable_localSystem="true"/>
    <options customize="never" require-scripts="false" hostArchitectures="arm64"/>
    
    <!-- Define documents displayed at various steps -->
    <welcome file="welcome.html" mime-type="text/html"/>
    <readme file="readme.html" mime-type="text/html"/>
    <license file="license.txt" mime-type="text/plain"/>
    <conclusion file="conclusion.html" mime-type="text/html"/>
    
    <!-- Background image -->
    <background file="background.png" mime-type="image/png" alignment="bottomleft" scaling="proportional"/>
    
    <!-- Define the installation choices -->
    <choices-outline>
        <line choice="default">
            <line choice="org.retrobat.RetroBat"/>
        </line>
    </choices-outline>
    
    <choice id="default"/>
    <choice id="org.retrobat.RetroBat" visible="false">
        <pkg-ref id="org.retrobat.RetroBat"/>
    </choice>
    
    <pkg-ref id="org.retrobat.RetroBat" version="${VERSION}" onConclusion="none">
        RetroBat.pkg
    </pkg-ref>
</installer-gui-script>
EOF

# Create welcome message
cat > "$PKG_TEMP/welcome.html" << 'EOF'
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <style>
        body { font-family: -apple-system, BlinkMacSystemFont, sans-serif; margin: 20px; }
        h1 { color: #007AFF; }
        .warning { background-color: #FFF3CD; padding: 10px; border-radius: 5px; margin: 10px 0; }
    </style>
</head>
<body>
    <h1>Welcome to RetroBat</h1>
    <p>This installer will install RetroBat on your Mac.</p>
    
    <h2>What is RetroBat?</h2>
    <p>RetroBat is a comprehensive retro gaming frontend that brings together EmulationStation and RetroArch, allowing you to easily manage and play games from numerous gaming platforms.</p>
    
    <div class="warning">
        <strong>Requirements:</strong>
        <ul>
            <li>macOS 11.0 (Big Sur) or later</li>
            <li>Apple Silicon Mac (M1/M2/M3/M4)</li>
            <li>Homebrew with dependencies: <code>brew install sdl2 p7zip wget</code></li>
        </ul>
    </div>
    
    <p>Click Continue to proceed with the installation.</p>
</body>
</html>
EOF

# Create readme
cat > "$PKG_TEMP/readme.html" << 'EOF'
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <style>
        body { font-family: -apple-system, BlinkMacSystemFont, sans-serif; margin: 20px; }
        h2 { color: #007AFF; }
        code { background-color: #F5F5F5; padding: 2px 5px; border-radius: 3px; }
        pre { background-color: #F5F5F5; padding: 10px; border-radius: 5px; overflow-x: auto; }
    </style>
</head>
<body>
    <h2>Installation Information</h2>
    
    <h3>Installation Location</h3>
    <p>RetroBat will be installed to: <code>/Applications/RetroBat.app</code></p>
    
    <h3>First Launch</h3>
    <p>When you first launch RetroBat:</p>
    <ol>
        <li>Right-click the RetroBat app in Applications</li>
        <li>Select "Open" from the menu</li>
        <li>Click "Open" in the security dialog</li>
    </ol>
    
    <h3>Dependencies</h3>
    <p>Before running RetroBat, install required dependencies using Homebrew:</p>
    <pre>brew install sdl2 p7zip wget</pre>
    
    <h3>Data Location</h3>
    <p>RetroBat will create its data directory at:</p>
    <ul>
        <li><code>~/RetroBat</code> - Main data directory (ROMs, saves, etc.)</li>
        <li><code>~/Library/Application Support/RetroBat</code> - Configuration files</li>
    </ul>
    
    <h3>More Information</h3>
    <p>For documentation and support, visit: <a href="https://github.com/bayramog/retrobat-macos">https://github.com/bayramog/retrobat-macos</a></p>
</body>
</html>
EOF

# Create conclusion message
cat > "$PKG_TEMP/conclusion.html" << 'EOF'
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <style>
        body { font-family: -apple-system, BlinkMacSystemFont, sans-serif; margin: 20px; }
        h2 { color: #007AFF; }
        .success { background-color: #D4EDDA; padding: 10px; border-radius: 5px; margin: 10px 0; }
        code { background-color: #F5F5F5; padding: 2px 5px; border-radius: 3px; }
    </style>
</head>
<body>
    <div class="success">
        <h2>✓ Installation Complete!</h2>
        <p>RetroBat has been successfully installed.</p>
    </div>
    
    <h3>Next Steps</h3>
    <ol>
        <li>Open <strong>Applications</strong> folder</li>
        <li>Right-click <strong>RetroBat</strong> and select <strong>Open</strong></li>
        <li>Allow RetroBat to run in the security dialog</li>
        <li>Follow the first-time setup wizard</li>
    </ol>
    
    <h3>Dependencies</h3>
    <p>Don't forget to install required dependencies:</p>
    <p><code>brew install sdl2 p7zip wget</code></p>
    
    <h3>Documentation</h3>
    <p>Visit <a href="https://github.com/bayramog/retrobat-macos">github.com/bayramog/retrobat-macos</a> for guides and troubleshooting.</p>
    
    <p><strong>Enjoy your retro gaming experience!</strong></p>
</body>
</html>
EOF

# Copy license if it exists
if [ -f "$PROJECT_ROOT/license.txt" ]; then
    cp "$PROJECT_ROOT/license.txt" "$PKG_TEMP/"
else
    echo "MIT License - See repository for details" > "$PKG_TEMP/license.txt"
fi

# Copy background if it exists
if [ -f "$PROJECT_ROOT/macos/dmg-assets/background.png" ]; then
    cp "$PROJECT_ROOT/macos/dmg-assets/background.png" "$PKG_TEMP/"
fi

# Build final product package
echo "Building distribution package..."
productbuild --distribution "$PKG_TEMP/distribution.xml" \
             --resources "$PKG_TEMP" \
             --package-path "$PKG_TEMP" \
             "$PKG_OUTPUT"

# Clean up
echo "Cleaning up..."
rm -rf "$PKG_TEMP"

echo ""
echo "=========================================="
echo "✓ PKG Created Successfully!"
echo "=========================================="
echo "Output: $PKG_OUTPUT"
ls -lh "$PKG_OUTPUT"
echo ""
echo "To test the package:"
echo "  open $PKG_OUTPUT"
echo ""
echo "To sign the package (requires Developer ID):"
echo "  productsign --sign 'Developer ID Installer: Your Name' \\"
echo "              $PKG_OUTPUT \\"
echo "              ${PKG_OUTPUT%.pkg}-signed.pkg"
echo ""
