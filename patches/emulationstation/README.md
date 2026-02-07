# EmulationStation macOS Patches

This directory contains patches and new files for porting Batocera EmulationStation to macOS.

## Overview

Since we cannot directly commit to the upstream batocera-emulationstation repository, these files are maintained as patches that need to be applied to the EmulationStation source tree.

## Files

### MacOSApiSystem Implementation

1. **MacOSApiSystem.h** - Header file for macOS-specific API implementation
2. **MacOSApiSystem.cpp** - Implementation of macOS-specific system functions

These files should be copied to: `src/emulationstation/es-app/src/`

## Applying the Patches

### Automatic Application

Use the provided build script which handles patch application:

```bash
./scripts/build-emulationstation-macos.sh
```

### Manual Application

1. **Copy source files**:
   ```bash
   cp patches/emulationstation/MacOSApiSystem.h src/emulationstation/es-app/src/
   cp patches/emulationstation/MacOSApiSystem.cpp src/emulationstation/es-app/src/
   ```

2. **Apply CMake changes**:
   Follow the instructions in `docs/CMAKE_MACOS_CONFIGURATION.md` to update the CMakeLists.txt files.

3. **Build**:
   ```bash
   cd src/emulationstation
   mkdir build && cd build
   cmake .. -DRETROBAT=ON -DGL=ON
   make -j$(sysctl -n hw.ncpu)
   ```

## CMake Integration

After copying the files, you need to update the CMakeLists.txt to include them in the build.

### In src/emulationstation/es-app/CMakeLists.txt:

Find the section that lists source files and add:

```cmake
# macOS-specific sources
if(APPLE)
    list(APPEND ES_SOURCES
        ${CMAKE_CURRENT_SOURCE_DIR}/src/MacOSApiSystem.cpp
    )
    list(APPEND ES_HEADERS
        ${CMAKE_CURRENT_SOURCE_DIR}/src/MacOSApiSystem.h
    )
endif()
```

### In src/emulationstation/CMakeLists.txt:

Add the macOS platform detection and configuration as documented in `docs/CMAKE_MACOS_CONFIGURATION.md`.

## Verification

After applying patches, verify they're correctly integrated:

```bash
cd src/emulationstation/build

# Check if files are recognized
cmake .. -DRETROBAT=ON -DGL=ON 2>&1 | grep -i macos

# Verify compilation includes MacOSApiSystem
make VERBOSE=1 2>&1 | grep MacOSApiSystem
```

## Platform Detection

The MacOSApiSystem files use `#ifdef __APPLE__` to ensure they're only compiled on macOS. They won't interfere with Windows or Linux builds.

## ApiSystem Factory Pattern

In the EmulationStation source, you'll need to update the ApiSystem factory to instantiate MacOSApiSystem on macOS.

### In es-app/src/ApiSystem.cpp:

Find the `getInstance()` method and update it:

```cpp
ApiSystem* ApiSystem::getInstance()
{
    static ApiSystem* instance = nullptr;
    
    if (instance == nullptr)
    {
#if WIN32
        instance = new Win32ApiSystem();
#elif __APPLE__
        instance = new MacOSApiSystem();
#else
        instance = new ApiSystem();
#endif
    }
    
    return instance;
}
```

Don't forget to include the header:

```cpp
#ifdef __APPLE__
#include "MacOSApiSystem.h"
#endif
```

## Features Implemented

### ✅ System Information
- OS version detection
- CPU information
- Memory information  
- Architecture detection (Apple Silicon vs Intel)
- Hostname

### ✅ Storage Management
- List mounted volumes
- Free space calculation
- Device enumeration

### ✅ Network Functions
- IP address detection
- Connectivity testing (ping)

### ✅ Process Management
- Script execution
- Command output capture
- Callback support for progress updates

### ✅ Display Management
- Video mode enumeration (basic)

### ✅ Power Management
- System suspend/sleep

### ✅ File Operations
- 7-Zip command configuration

### ⚠️ Partial/Stub Implementations
- Bezel management (file operations work, but not fully tested)
- System updates (macOS uses App Store)
- Bluetooth management (stub - not implemented)
- Kodi launching (basic - uses 'open -a')

## Testing

After building, test the implementation:

```bash
cd src/emulationstation/build

# Basic launch test
./emulationstation

# Check system information
./emulationstation --help

# View logs
tail -f ~/.emulationstation/es_log.txt
```

## Known Limitations

1. **Bluetooth**: Not fully implemented - macOS Bluetooth APIs are complex
2. **System Updates**: Stub implementation - RetroBat updates would need custom implementation
3. **Video Modes**: Returns common resolutions, not actual display capabilities (TODO)
4. **Bezel System**: File operations work but RetroBat-specific features may need adjustment

## Future Improvements

1. **Video Mode Detection**: Use CGDisplay APIs to enumerate actual display modes
2. **Volume Control**: Implement native CoreAudio volume control
3. **Bluetooth**: Implement using IOBluetooth framework
4. **Text-to-Speech**: Implement using NSSpeechSynthesizer
5. **Metal Renderer**: Add Metal rendering backend for better Apple Silicon performance

## Contributing

When updating these patches:

1. Make changes to the files in `patches/emulationstation/`
2. Test the changes by copying to `src/emulationstation/`
3. Document any new dependencies or build requirements
4. Update this README with new features or changes
5. Commit the updated patches

## References

- EmulationStation source: https://github.com/batocera-linux/batocera-emulationstation
- macOS System APIs: https://developer.apple.com/documentation/
- Build documentation: `docs/BUILDING_EMULATIONSTATION_MACOS.md`
- CMake configuration: `docs/CMAKE_MACOS_CONFIGURATION.md`
- Porting analysis: `docs/EMULATIONSTATION_PORTING_ANALYSIS.md`
