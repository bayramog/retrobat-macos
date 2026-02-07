# DMG Assets

This directory contains assets for customizing the DMG installer appearance.

## Background Image

### Creating a Custom Background

The DMG installer can use a custom background image to enhance the visual appearance.

**Recommended Specifications**:
- **Dimensions**: 600x450 pixels (or 1200x900 for Retina)
- **Format**: PNG with transparency or solid background
- **File name**: `background.png`

### Design Guidelines

The background should include:
- RetroBat branding/logo
- Visual instructions (drag icon to Applications)
- Clean, professional appearance
- Good contrast for icon visibility

### Layout Reference

With default window size (600x450):
- **RetroBat.app icon**: Position at ~150, 150
- **Applications folder**: Position at ~450, 150
- **Central area**: Instructions/branding
- **Bottom area**: Additional information

### Creating from Existing Assets

To create a background from RetroBat assets:

```bash
# Use ImageMagick or GIMP to create a 600x450 background
# Example with ImageMagick:
convert -size 600x450 xc:white \
        ../system/resources/retrobat_logo_v7.png -geometry 300x100+150+20 -composite \
        -pointsize 16 -fill black \
        -annotate +150+350 "Drag RetroBat to Applications folder to install" \
        background.png
```

### Using Without Background

If no background.png is present, the DMG will use:
- System default white background
- Standard icon arrangement
- Basic appearance (still fully functional)

## Other Assets

Future assets may include:
- Volume icon (.icns)
- License agreement (HTML/RTF)
- Installer graphics

## Testing Background

After creating background.png:

```bash
# Recreate DMG with new background
cd ..
./create-dmg.sh 8.0.0

# Test appearance
open ../build/RetroBat-8.0.0-macOS-arm64.dmg
```

## Examples

### Minimal Background

Simple white background with instructions:
- Clean and professional
- Good for first release
- Easy to create

### Branded Background

Full branded design:
- RetroBat logo and colors
- Visual guides (arrows, etc.)
- Marketing elements
- Requires graphic design work

## Tools

Recommended tools for creating backgrounds:
- **GIMP**: Free, open-source image editor
- **Adobe Photoshop**: Professional option
- **Sketch/Figma**: For modern UI design
- **ImageMagick**: Command-line image manipulation

## References

- [DMG Canvas](https://www.araelium.com/dmgcanvas) - DMG design tool (commercial)
- [create-dmg](https://github.com/create-dmg/create-dmg) - Open-source alternative
- [Apple HIG](https://developer.apple.com/design/human-interface-guidelines/) - Design guidelines
