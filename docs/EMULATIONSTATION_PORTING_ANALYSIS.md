# EmulationStation macOS Porting Analysis

This document provides a detailed analysis of the work required to port Batocera EmulationStation to macOS for RetroBat.

## Executive Summary

The porting effort is **moderate** in complexity. Batocera EmulationStation is already cross-platform (Linux-native), so most of the code is portable. The main areas requiring work are:

1. **Windows-specific API layer** (Win32ApiSystem.cpp/h) - ~1200 lines
2. **Platform detection** - scattered throughout codebase
3. **Build system** - CMake configuration
4. **Dependencies** - All available via Homebrew

**Good news**: 
- No DirectX dependencies found in core rendering code
- Already uses SDL2 for graphics/input
- Already uses OpenGL (not DirectX)
- File system code is mostly portable

## Source Code Structure

```
src/emulationstation/
├── CMakeLists.txt           # Main build configuration
├── es-app/                  # Application layer
│   └── src/
│       ├── Win32ApiSystem.cpp  # 1176 lines - NEEDS PORTING
│       ├── Win32ApiSystem.h    # Platform-specific API
│       ├── ApiSystem.h         # Base API interface
│       └── guis/               # GUI components with some WIN32 ifdefs
├── es-core/                 # Core engine
│   └── src/
│       ├── Window.cpp          # Main window management
│       ├── InputManager.cpp    # Controller input
│       ├── AudioManager.cpp    # Audio system
│       ├── Paths.cpp           # File path handling
│       └── renderers/          # OpenGL renderer
└── external/                # Third-party libraries
```

## Platform-Specific Code Analysis

### 1. Win32ApiSystem (High Priority)

**Location**: `es-app/src/Win32ApiSystem.cpp` (1176 lines)

This is the main Windows-specific implementation. It needs a macOS equivalent (`MacOSApiSystem.cpp`).

**Functions to implement**:

| Function | Purpose | macOS Equivalent |
|----------|---------|------------------|
| `getSystemInformations()` | Get OS info | `sysctl`, `uname` |
| `getAvailableStorageDevices()` | List drives | `getfsstat`, `statfs` |
| `getFreeSpaceGB()` | Disk space | `statvfs` |
| `getVideoModes()` | Display resolutions | `CGDisplay` APIs |
| `updateSystem()` | System updates | Custom implementation |
| `executeScript()` | Run shell scripts | `popen`, `system` |
| `launchKodi()` | Launch external app | `open` command |
| `suspend()` | System sleep | `pmset` command |
| `getBatoceraBezelsList()` | Manage bezels | File system operations |

**Implementation Strategy**:
1. Create `MacOSApiSystem.cpp` and `MacOSApiSystem.h`
2. Implement each function using macOS APIs
3. Use conditional compilation: `#if defined(__APPLE__)`

### 2. Platform Detection Patterns

Found in multiple files:

```cpp
// Current patterns
#if WIN32
    // Windows-specific code
#else
    // Linux/Unix code (usually compatible with macOS)
#endif
```

**Update to**:

```cpp
#if defined(_WIN32)
    // Windows-specific code
#elif defined(__APPLE__)
    // macOS-specific code
#else
    // Linux code
#endif
```

**Files with platform detection** (not exhaustive):

- `es-app/src/guis/GuiMenu.cpp` - ~30 occurrences
- `es-app/src/guis/GuiControllersSettings.cpp`
- `es-app/src/guis/GuiImageViewer.cpp`
- `es-app/src/NetworkThread.cpp`
- `es-app/src/MetaData.cpp`

### 3. File Path Handling

**Location**: `es-core/src/Paths.cpp`

Already uses cross-platform file system operations. Most code should work as-is on macOS.

**Potential issues**:
- Windows uses `\` backslashes, macOS/Linux use `/` forward slashes
- Solution: Already handled by using standard C++ `<filesystem>` or Boost filesystem

**Action**: Test and verify, likely no changes needed.

### 4. Rendering System

**Location**: `es-core/src/renderers/`

**Good news**: 
- Already uses **OpenGL**, not DirectX
- SDL2 handles the windowing and OpenGL context creation
- No rendering code changes needed

**Renderer files**:
- `Renderer_GL21.cpp` - OpenGL 2.1 renderer (desktop)
- `Renderer_GLES.cpp` - OpenGL ES renderer (embedded/Raspberry Pi)

**For macOS**: Use GL21 renderer (Desktop OpenGL)

**Future optimization**: Consider adding Metal renderer for better Apple Silicon performance.

### 5. Input System

**Location**: `es-core/src/InputManager.cpp`

Already uses **SDL2** for input, which is cross-platform.

**Action**: Test controllers, should work out of the box.

### 6. Audio System

**Location**: `es-core/src/AudioManager.cpp`, `VolumeControl.cpp`

Uses SDL2_mixer for audio playback.

**VolumeControl** may have platform-specific code:
- Windows: Uses Windows Volume APIs
- Linux: Uses ALSA
- macOS: Needs CoreAudio implementation

**Action**: 
1. Check `VolumeControl.cpp` for WIN32 ifdefs
2. Add macOS implementation using CoreAudio or SDL2's volume control

### 7. Text-to-Speech

**Location**: `es-core/src/TextToSpeech.cpp`

Likely has platform-specific implementations.

**macOS solution**: Use `NSSpeechSynthesizer` or `say` command

### 8. Network/HTTP

**Location**: `es-core/src/HttpReq.cpp`

Uses cURL, which is cross-platform and available via Homebrew.

**Action**: No changes needed.

## Build System Analysis

### CMakeLists.txt Configuration

**Current options**:
```cmake
option(GLES "Set to ON if targeting Embedded OpenGL" ${GLES})
option(GL "Set to ON if targeting Desktop OpenGL" ${GL})
option(BATOCERA "Set to ON to enable BATOCERA specific code" OFF)
option(RETROBAT "Set to ON to enable RETROBAT specific code" OFF)
```

**For macOS, we need**:
```cmake
-DRETROBAT=ON
-DGL=ON              # Use Desktop OpenGL
-DGLES=OFF
-DGLES2=OFF
-DCEC=OFF            # Disable CEC
-DENABLE_PULSE=OFF   # Disable PulseAudio
```

**Detect macOS in CMake**:
```cmake
if(APPLE)
    set(CMAKE_OSX_ARCHITECTURES "arm64" CACHE STRING "Build architectures for Mac OS X" FORCE)
    set(CMAKE_OSX_DEPLOYMENT_TARGET "12.0" CACHE STRING "Minimum OS X deployment version" FORCE)
    
    # Find macOS frameworks
    find_library(COCOA_LIBRARY Cocoa)
    find_library(IOKIT_LIBRARY IOKit)
    find_library(COREAUDIO_LIBRARY CoreAudio)
    
    # Add to link libraries
    target_link_libraries(emulationstation ${COCOA_LIBRARY} ${IOKIT_LIBRARY} ${COREAUDIO_LIBRARY})
endif()
```

## Dependencies Analysis

All dependencies are available via Homebrew:

| Dependency | Purpose | Homebrew Package | Status |
|------------|---------|------------------|--------|
| SDL2 | Graphics, Input, Audio | `sdl2` | ✅ Available |
| SDL2_mixer | Audio mixing | `sdl2_mixer` | ✅ Available |
| Boost | C++ utilities | `boost` | ✅ Available |
| FreeImage | Image loading | `freeimage` | ✅ Available |
| FreeType | Font rendering | `freetype` | ✅ Available |
| RapidJSON | JSON parsing | `rapidjson` | ✅ Available |
| cURL | HTTP requests | `curl` | ✅ Built-in + Homebrew |
| LibVLC | Video playback | `libvlc` | ✅ Available |
| pugixml | XML parsing | `pugixml` | ✅ Available |
| Eigen | Linear algebra | `eigen` | ✅ Available |
| GLM | OpenGL math | `glm` | ✅ Available |

**System Frameworks** (built-in):
- OpenGL.framework
- CoreAudio.framework
- Cocoa.framework
- IOKit.framework

## Estimated Effort

### Phase 1: Setup (Completed)
- ✅ Add as git submodule
- ✅ Create build documentation
- ✅ Create build script
- ✅ Analyze codebase

### Phase 2: Core Implementation (3-5 days)

**Task**: Create MacOSApiSystem

**Effort breakdown**:
- Create MacOSApiSystem.cpp/h: 1 day
- Implement system info functions: 1 day
- Implement file system functions: 0.5 day
- Implement process/script execution: 0.5 day
- Implement display/video functions: 1 day
- Testing and debugging: 1-2 days

**Lines of code estimate**: ~800-1000 lines (similar to Win32ApiSystem)

### Phase 3: Platform-Specific Fixes (2-3 days)

- Update platform detection ifdefs: 1 day
- Implement VolumeControl for macOS: 0.5 day
- Fix any path handling issues: 0.5 day
- Test and fix compilation errors: 1 day

### Phase 4: Build System (1-2 days)

- Update CMakeLists.txt for macOS: 0.5 day
- Configure dependencies: 0.5 day
- Test build process: 0.5 day
- Create app bundle: 0.5 day

### Phase 5: Testing & Integration (3-5 days)

- Basic functionality testing: 1 day
- Controller input testing: 0.5 day
- Theme rendering testing: 1 day
- Scraper testing: 0.5 day
- Integration with RetroBat: 1 day
- Bug fixes: 1-2 days

**Total Estimated Time**: 9-15 days (1.5-3 weeks)

## Risk Assessment

### Low Risk ✅

1. **Rendering**: Already uses OpenGL + SDL2
2. **Input**: Already uses SDL2
3. **Audio**: SDL2_mixer is cross-platform
4. **Networking**: cURL is cross-platform
5. **Dependencies**: All available via Homebrew

### Medium Risk ⚠️

1. **VolumeControl**: Needs macOS-specific implementation
2. **Platform ifdefs**: Scattered throughout code, need systematic update
3. **Text-to-Speech**: Needs macOS implementation (non-critical)
4. **System functions**: Some Win32ApiSystem functions may be complex

### High Risk ⛔

None identified. The codebase is well-structured and already cross-platform.

## Implementation Plan

### Step 1: Create MacOSApiSystem

**Priority**: High
**Dependencies**: None

Create new files:
- `es-app/src/MacOSApiSystem.cpp`
- `es-app/src/MacOSApiSystem.h`

Implement using macOS APIs:
- `<sys/sysctl.h>` for system info
- `<sys/statvfs.h>` for disk space
- `<ApplicationServices/ApplicationServices.h>` for display info
- `<IOKit/IOKitLib.h>` for hardware info
- `popen()` for script execution

### Step 2: Update CMakeLists.txt

**Priority**: High
**Dependencies**: Step 1

Add macOS-specific configuration:
```cmake
if(APPLE)
    # Platform detection
    add_compile_definitions(__APPLE__ RETROBAT)
    
    # Architecture
    set(CMAKE_OSX_ARCHITECTURES "arm64")
    set(CMAKE_OSX_DEPLOYMENT_TARGET "12.0")
    
    # Frameworks
    find_library(COCOA_LIBRARY Cocoa REQUIRED)
    find_library(IOKIT_LIBRARY IOKit REQUIRED)
    find_library(COREAUDIO_LIBRARY CoreAudio REQUIRED)
    find_library(OPENGL_LIBRARY OpenGL REQUIRED)
    
    # Source files
    set(ES_SOURCES ${ES_SOURCES} es-app/src/MacOSApiSystem.cpp)
    
    # Link
    target_link_libraries(emulationstation 
        ${COCOA_LIBRARY} 
        ${IOKIT_LIBRARY} 
        ${COREAUDIO_LIBRARY}
        ${OPENGL_LIBRARY}
    )
endif()
```

### Step 3: Update Platform Ifdefs

**Priority**: Medium
**Dependencies**: Step 1, 2

Search and replace pattern:
```bash
# Find all WIN32 ifdefs
grep -r "#if WIN32\|#ifdef WIN32" --include="*.cpp" --include="*.h"

# Update to:
#if defined(_WIN32)
    // Windows code
#elif defined(__APPLE__)
    // macOS code
#else
    // Linux code
#endif
```

**Files to update** (prioritized):
1. `es-app/src/guis/GuiMenu.cpp` (~30 instances)
2. `es-app/src/guis/GuiControllersSettings.cpp`
3. `es-app/src/guis/GuiImageViewer.cpp`
4. `es-app/src/NetworkThread.cpp`
5. `es-core/src/VolumeControl.cpp`

### Step 4: Implement VolumeControl

**Priority**: Medium
**Dependencies**: Step 2

Add macOS volume control in `VolumeControl.cpp`:
```cpp
#ifdef __APPLE__
#include <CoreAudio/CoreAudio.h>

// Implement getVolume(), setVolume()
#endif
```

### Step 5: Test Build

**Priority**: High
**Dependencies**: Steps 1-4

```bash
cd src/emulationstation/build
cmake .. -DRETROBAT=ON -DGL=ON -DGLES=OFF
make -j$(sysctl -n hw.ncpu)
```

Fix compilation errors iteratively.

### Step 6: Runtime Testing

**Priority**: High
**Dependencies**: Step 5

Test checklist:
- [ ] Application launches
- [ ] Window displays correctly
- [ ] Theme renders properly
- [ ] Controller input works
- [ ] Audio playback works
- [ ] Volume control works
- [ ] Network requests work (scraper)
- [ ] Can navigate menus
- [ ] Can launch games/emulators
- [ ] Configuration persists

### Step 7: Integration

**Priority**: High
**Dependencies**: Step 6

Integrate with RetroBat:
1. Copy built binary to RetroBat directory
2. Test with RetroBat configuration files
3. Test theme compatibility
4. Test emulator launching
5. Document any differences from Windows version

## Code Examples

### MacOSApiSystem Implementation Template

```cpp
// MacOSApiSystem.h
#ifdef __APPLE__
#pragma once

#include "ApiSystem.h"

class MacOSApiSystem : public ApiSystem
{
public:
    MacOSApiSystem();
    virtual ~MacOSApiSystem();
    
    // System information
    std::vector<std::string> getSystemInformations() override;
    
    // Storage
    std::vector<std::string> getAvailableStorageDevices() override;
    unsigned long getFreeSpaceGB(std::string mountpoint) override;
    std::string getFreeSpaceUserInfo() override;
    std::string getFreeSpaceSystemInfo() override;
    
    // Video
    std::vector<std::string> getVideoModes(const std::string output = "") override;
    
    // Script execution
    bool executeScript(const std::string command) override;
    std::pair<std::string, int> executeScript(const std::string command, 
        const std::function<void(const std::string)>& func) override;
    
    // Network
    bool ping() override;
    
    // Applications
    bool launchKodi(Window *window) override;
    
    // System control
    bool canSuspend();
    void suspend() override;
    
protected:
    std::vector<std::string> executeEnumerationScript(const std::string command) override;
};

#endif // __APPLE__
```

### CMake macOS Detection

```cmake
# Detect macOS
if(APPLE)
    message(STATUS "Building for macOS")
    
    # Set RetroBat mode
    set(RETROBAT ON CACHE BOOL "Enable RetroBat features" FORCE)
    
    # Use Desktop OpenGL
    set(GL ON CACHE BOOL "Use Desktop OpenGL" FORCE)
    set(GLES OFF CACHE BOOL "Don't use OpenGL ES" FORCE)
    set(GLES2 OFF CACHE BOOL "Don't use OpenGL ES 2" FORCE)
    
    # Disable Linux-specific features
    set(CEC OFF CACHE BOOL "Disable CEC" FORCE)
    set(ENABLE_PULSE OFF CACHE BOOL "Disable PulseAudio" FORCE)
    
    # Architecture
    set(CMAKE_OSX_ARCHITECTURES "arm64" CACHE STRING "Build for Apple Silicon")
    set(CMAKE_OSX_DEPLOYMENT_TARGET "12.0" CACHE STRING "Target macOS 12+")
    
    # Add macOS source files
    list(APPEND ES_SOURCES 
        ${CMAKE_CURRENT_SOURCE_DIR}/es-app/src/MacOSApiSystem.cpp
    )
    
    # Find required frameworks
    find_library(COCOA_LIBRARY Cocoa REQUIRED)
    find_library(IOKIT_LIBRARY IOKit REQUIRED)
    find_library(COREAUDIO_LIBRARY CoreAudio REQUIRED)
    find_library(OPENGL_LIBRARY OpenGL REQUIRED)
    find_library(APPKIT_LIBRARY AppKit REQUIRED)
    
    # Add frameworks to link
    list(APPEND PLATFORM_LIBRARIES
        ${COCOA_LIBRARY}
        ${IOKIT_LIBRARY}
        ${COREAUDIO_LIBRARY}
        ${OPENGL_LIBRARY}
        ${APPKIT_LIBRARY}
    )
    
    message(STATUS "macOS frameworks: ${PLATFORM_LIBRARIES}")
endif()
```

## Next Steps

1. **Immediate**: Create MacOSApiSystem.cpp/h skeleton
2. **Immediate**: Update CMakeLists.txt for macOS
3. **Short-term**: Implement core MacOSApiSystem functions
4. **Short-term**: Fix platform ifdefs
5. **Medium-term**: Full testing and bug fixes
6. **Long-term**: Optimization for Apple Silicon (Metal)

## References

- **Batocera EmulationStation**: https://github.com/batocera-linux/batocera-emulationstation
- **SDL2 API**: https://wiki.libsdl.org/SDL2/
- **macOS System APIs**: https://developer.apple.com/documentation/
- **CMake for macOS**: https://cmake.org/cmake/help/latest/manual/cmake-toolchains.7.html#cross-compiling-for-macos

## Conclusion

Porting Batocera EmulationStation to macOS is **feasible** and **moderate** in complexity:

✅ **Pros**:
- Already cross-platform (Linux base)
- Uses OpenGL + SDL2 (no DirectX)
- All dependencies available
- Well-structured code

⚠️ **Challenges**:
- Win32ApiSystem needs reimplementation (~1000 lines)
- Platform ifdefs scattered throughout code
- Some macOS-specific APIs needed

**Timeline**: 2-3 weeks for full port
**Risk**: Low to Medium
**Recommendation**: Proceed with porting
