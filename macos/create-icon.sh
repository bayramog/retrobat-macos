#!/bin/bash
# Script to create macOS app icon (.icns) from PNG source

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

# Source image (PNG with high resolution)
SOURCE_PNG="$PROJECT_ROOT/resources/logo_icon.png"
OUTPUT_ICNS="$PROJECT_ROOT/macos/app-bundle/RetroBat.icns"

# Temporary directory for iconset
ICONSET_DIR="/tmp/RetroBat.iconset"

echo "Creating macOS app icon (.icns)..."
echo "Source: $SOURCE_PNG"
echo "Output: $OUTPUT_ICNS"

# Check if source image exists
if [ ! -f "$SOURCE_PNG" ]; then
    echo "Error: Source image not found: $SOURCE_PNG"
    exit 1
fi

# Check if sips and iconutil are available (macOS built-in tools)
if ! command -v sips &> /dev/null; then
    echo "Error: 'sips' command not found. This script must run on macOS."
    exit 1
fi

if ! command -v iconutil &> /dev/null; then
    echo "Error: 'iconutil' command not found. This script must run on macOS."
    exit 1
fi

# Create temporary iconset directory
rm -rf "$ICONSET_DIR"
mkdir -p "$ICONSET_DIR"

# Generate all required icon sizes
# macOS requires specific icon sizes for .icns format
echo "Generating icon sizes..."

# 16x16
sips -z 16 16 "$SOURCE_PNG" --out "$ICONSET_DIR/icon_16x16.png" > /dev/null
sips -z 32 32 "$SOURCE_PNG" --out "$ICONSET_DIR/icon_16x16@2x.png" > /dev/null

# 32x32
sips -z 32 32 "$SOURCE_PNG" --out "$ICONSET_DIR/icon_32x32.png" > /dev/null
sips -z 64 64 "$SOURCE_PNG" --out "$ICONSET_DIR/icon_32x32@2x.png" > /dev/null

# 128x128
sips -z 128 128 "$SOURCE_PNG" --out "$ICONSET_DIR/icon_128x128.png" > /dev/null
sips -z 256 256 "$SOURCE_PNG" --out "$ICONSET_DIR/icon_128x128@2x.png" > /dev/null

# 256x256
sips -z 256 256 "$SOURCE_PNG" --out "$ICONSET_DIR/icon_256x256.png" > /dev/null
sips -z 512 512 "$SOURCE_PNG" --out "$ICONSET_DIR/icon_256x256@2x.png" > /dev/null

# 512x512
sips -z 512 512 "$SOURCE_PNG" --out "$ICONSET_DIR/icon_512x512.png" > /dev/null
sips -z 1024 1024 "$SOURCE_PNG" --out "$ICONSET_DIR/icon_512x512@2x.png" > /dev/null

echo "Converting iconset to .icns..."
iconutil -c icns "$ICONSET_DIR" -o "$OUTPUT_ICNS"

# Clean up
rm -rf "$ICONSET_DIR"

echo "✓ Successfully created: $OUTPUT_ICNS"
ls -lh "$OUTPUT_ICNS"
