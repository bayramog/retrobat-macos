# Building EmulationStation for macOS

This guide explains how to build Batocera EmulationStation (RetroBat's base) for macOS.

## Overview

RetroBat uses a fork of Batocera's EmulationStation as its frontend. This document provides instructions for compiling EmulationStation on macOS with all required dependencies.

## Prerequisites

### Required Software

1. **Xcode Command Line Tools**
   ```bash
   xcode-select --install
   ```

2. **Homebrew**
   ```bash
   /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
   ```

3. **All Dependencies via Homebrew**
   ```bash
   brew install cmake sdl2 sdl2_mixer boost freeimage freetype rapidjson curl libvlc pugixml eigen glm
   ```

## Building EmulationStation

### Step 1: Clone Repository (if not already cloned)

The EmulationStation source is included as a git submodule:

```bash
cd /path/to/retrobat-macos
git submodule update --init --recursive
```

### Step 2: Create Build Directory

```bash
cd src/emulationstation
mkdir build
cd build
```

### Step 3: Configure with CMake

For macOS, we need to configure CMake with the following options:

```bash
cmake .. \
  -DCMAKE_BUILD_TYPE=Release \
  -DRETROBAT=ON \
  -DBATOCERA=OFF \
  -DGL=ON \
  -DGLES=OFF \
  -DGLES2=OFF \
  -DCEC=OFF \
  -DENABLE_PULSE=OFF \
  -DUSE_SYSTEM_PUGIXML=ON \
  -DCMAKE_OSX_ARCHITECTURES=arm64 \
  -DCMAKE_OSX_DEPLOYMENT_TARGET=12.0
```

#### CMake Options Explained

- `RETROBAT=ON`: Enables RetroBat-specific features
- `BATOCERA=OFF`: Disables Batocera-specific features
- `GL=ON`: Use OpenGL (native on macOS)
- `GLES=OFF`, `GLES2=OFF`: Disable OpenGL ES (not needed on macOS)
- `CEC=OFF`: Disable CEC (HDMI-CEC control, not typically used on macOS)
- `ENABLE_PULSE=OFF`: Disable PulseAudio (macOS uses CoreAudio)
- `USE_SYSTEM_PUGIXML=ON`: Use Homebrew's pugixml instead of bundled version
- `CMAKE_OSX_ARCHITECTURES=arm64`: Build for Apple Silicon
- `CMAKE_OSX_DEPLOYMENT_TARGET=12.0`: Target macOS 12 (Monterey) and later

### Step 4: Build

```bash
make -j$(sysctl -n hw.ncpu)
```

This will compile EmulationStation using all available CPU cores.

### Step 5: Install (Optional)

```bash
sudo make install
```

Or create an app bundle (see below).

## Creating a macOS App Bundle

EmulationStation can be packaged as a `.app` bundle for easier distribution:

### Option 1: Manual App Bundle Creation

```bash
mkdir -p EmulationStation.app/Contents/MacOS
mkdir -p EmulationStation.app/Contents/Resources
mkdir -p EmulationStation.app/Contents/Frameworks

# Copy executable
cp emulationstation EmulationStation.app/Contents/MacOS/

# Copy resources
cp -r ../resources EmulationStation.app/Contents/Resources/

# Create Info.plist
cat > EmulationStation.app/Contents/Info.plist << 'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>CFBundleDevelopmentRegion</key>
    <string>en</string>
    <key>CFBundleExecutable</key>
    <string>emulationstation</string>
    <key>CFBundleIdentifier</key>
    <string>org.retrobat.emulationstation</string>
    <key>CFBundleInfoDictionaryVersion</key>
    <string>6.0</string>
    <key>CFBundleName</key>
    <string>EmulationStation</string>
    <key>CFBundlePackageType</key>
    <string>APPL</string>
    <key>CFBundleShortVersionString</key>
    <string>1.0.0</string>
    <key>CFBundleVersion</key>
    <string>1</string>
    <key>LSMinimumSystemVersion</key>
    <string>12.0</string>
    <key>NSHighResolutionCapable</key>
    <true/>
    <key>NSPrincipalClass</key>
    <string>NSApplication</string>
</dict>
</plist>
EOF

# Copy dynamic libraries (if not using Homebrew-provided libs)
# This step may be needed for standalone distribution
```

### Option 2: Using CMake's Bundle Generation

Modify the CMakeLists.txt to include bundle generation (TODO: implement this).

## Dependencies Reference

### Core Dependencies

| Library | Purpose | Homebrew Package |
|---------|---------|------------------|
| SDL2 | Graphics, Input, Audio | `sdl2` |
| SDL2_mixer | Audio mixing | `sdl2_mixer` |
| Boost | C++ utilities | `boost` |
| FreeImage | Image loading | `freeimage` |
| FreeType | Font rendering | `freetype` |
| RapidJSON | JSON parsing | `rapidjson` |
| cURL | Network requests | `curl` |
| LibVLC | Video playback | `libvlc` |
| pugixml | XML parsing | `pugixml` |
| Eigen | Linear algebra | `eigen` |
| GLM | OpenGL mathematics | `glm` |

### System Frameworks (Built-in)

- **OpenGL**: For graphics rendering
- **CoreAudio**: For audio output
- **Foundation**: macOS core framework
- **AppKit**: macOS UI framework

## Known Issues and Workarounds

### Issue 1: SDL2 Joystick Support

**Problem**: SDL2 on macOS may have different joystick mappings than Windows.

**Workaround**: 
- Use the `gamecontrollerdb.txt` file from the `system/tools/` directory
- Test controller mappings and update as needed

### Issue 2: OpenGL Deprecation

**Problem**: Apple deprecated OpenGL in macOS 10.14 (Mojave).

**Current Solution**: 
- Continue using OpenGL (still functional as of macOS 14)
- OpenGL is not removed, just deprecated

**Future Solution**: 
- Port to Metal for better performance and future-proofing
- This is a Phase 5 optimization task

### Issue 3: VLC Library Paths

**Problem**: LibVLC may not be found automatically.

**Workaround**:
```bash
export PKG_CONFIG_PATH="/opt/homebrew/opt/libvlc/lib/pkgconfig:$PKG_CONFIG_PATH"
cmake .. -DVLC_INCLUDE_DIR=/opt/homebrew/opt/libvlc/include \
         -DVLC_LIBRARIES=/opt/homebrew/opt/libvlc/lib/libvlc.dylib
```

### Issue 4: File Paths

**Problem**: EmulationStation expects Unix paths (`/`) not Windows paths (`\`).

**Solution**: Already handled by Batocera codebase (Linux-native).

## Platform-Specific Code Patterns

When modifying EmulationStation for macOS-specific features:

### Detecting macOS

```cpp
#ifdef __APPLE__
    // macOS-specific code
    #include <TargetConditionals.h>
    #if TARGET_OS_MAC
        // macOS (not iOS)
    #endif
#endif
```

### File System Paths

```cpp
#include <filesystem>
namespace fs = std::filesystem;

// Cross-platform path handling
fs::path configPath = fs::path(getHomePath()) / ".emulationstation";
```

### Dynamic Library Loading

```cpp
#ifdef __APPLE__
    const char* libExtension = ".dylib";
#elif defined(_WIN32)
    const char* libExtension = ".dll";
#else
    const char* libExtension = ".so";
#endif
```

## Testing the Build

### Minimal Test

```bash
./emulationstation --version
```

### Full Test

```bash
# Create a minimal configuration
mkdir -p ~/.emulationstation
./emulationstation
```

### Controller Test

1. Connect a controller
2. Launch EmulationStation
3. Navigate to Input Configuration
4. Map all buttons

## Performance Optimization

### For Apple Silicon (M1/M2/M3/M4)

1. **Build for arm64**:
   ```bash
   -DCMAKE_OSX_ARCHITECTURES=arm64
   ```

2. **Enable optimization flags**:
   ```bash
   -DCMAKE_BUILD_TYPE=Release
   -DCMAKE_CXX_FLAGS="-O3 -march=native"
   ```

3. **Use Metal (future)**:
   - Replace OpenGL renderer with Metal
   - Significant performance improvements expected

### Memory Management

EmulationStation can be memory-intensive with themes. Consider:
- Using lower-resolution theme assets for testing
- Monitoring memory usage with Activity Monitor
- Optimizing image loading and caching

## Debugging

### Enable Debug Build

```bash
cmake .. -DCMAKE_BUILD_TYPE=Debug -DRETROBAT=ON
make
```

### Run with LLDB

```bash
lldb ./emulationstation
(lldb) run
```

### Common Debug Commands

```bash
# Check linked libraries
otool -L emulationstation

# Check architecture
lipo -info emulationstation

# Verify code signing
codesign -dv emulationstation
```

## Integration with RetroBat

Once EmulationStation is built:

1. **Copy to RetroBat directory**:
   ```bash
   cp emulationstation /path/to/retrobat/emulationstation/
   ```

2. **Copy required resources**:
   ```bash
   cp -r resources/* /path/to/retrobat/emulationstation/
   ```

3. **Test with RetroBat configuration**:
   ```bash
   cd /path/to/retrobat
   ./emulationstation/emulationstation
   ```

## Next Steps

After successfully building EmulationStation:

1. **Phase 3**: Port Windows-specific code to macOS
   - Replace any remaining Windows API calls
   - Test all features (themes, scraper, downloader)

2. **Phase 4**: Integration testing
   - Test with RetroBat themes
   - Verify emulator launching
   - Test configuration system

3. **Phase 5**: Optimization
   - Consider Metal port for better performance
   - Optimize for Apple Silicon
   - Polish UI for macOS conventions

## Resources

- **Batocera EmulationStation**: https://github.com/batocera-linux/batocera-emulationstation
- **SDL2 Documentation**: https://wiki.libsdl.org/SDL2/
- **OpenGL on macOS**: https://developer.apple.com/opengl/
- **CMake Documentation**: https://cmake.org/documentation/

## Troubleshooting

### Build Fails with Missing Headers

```bash
# Install missing dependencies
brew install <package-name>

# Update PKG_CONFIG_PATH
export PKG_CONFIG_PATH="/opt/homebrew/lib/pkgconfig:$PKG_CONFIG_PATH"
```

### Runtime Crashes

1. Check library paths with `otool -L`
2. Verify all dependencies are installed
3. Check for architecture mismatches (arm64 vs x86_64)
4. Review logs in `~/.emulationstation/es_log.txt`

### Performance Issues

1. Check Activity Monitor for CPU/GPU usage
2. Try a simpler theme
3. Reduce resolution or window size
4. Enable performance monitoring in EmulationStation settings

## Contributing

When making changes to EmulationStation for macOS:

1. Keep changes minimal and platform-specific
2. Use `#ifdef __APPLE__` for macOS-only code
3. Test on both Intel and Apple Silicon (if possible)
4. Document any new dependencies or build steps
5. Submit changes back to the community

## License

EmulationStation is licensed under the MIT License. See LICENSE.md in the EmulationStation source directory.
