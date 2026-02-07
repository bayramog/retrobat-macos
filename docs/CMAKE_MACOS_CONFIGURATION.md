# CMake Configuration for macOS

This document describes the changes needed to EmulationStation's CMakeLists.txt to support macOS builds.

## Overview

The Batocera EmulationStation CMakeLists.txt needs modifications to:
1. Detect macOS platform
2. Set appropriate compiler flags
3. Link macOS system frameworks
4. Include MacOSApiSystem source files
5. Configure dependencies for macOS (Homebrew paths)

## Changes Required

### 1. Platform Detection (Add near top of CMakeLists.txt)

```cmake
# Detect macOS
if(APPLE)
    message(STATUS "=========================================")
    message(STATUS "Building EmulationStation for macOS")
    message(STATUS "=========================================")
    
    # Set RetroBat mode for macOS build
    set(RETROBAT ON CACHE BOOL "Enable RetroBat features" FORCE)
    
    # Use Desktop OpenGL (not OpenGL ES)
    set(GL ON CACHE BOOL "Use Desktop OpenGL" FORCE)
    set(GLES OFF CACHE BOOL "Disable OpenGL ES" FORCE)
    set(GLES2 OFF CACHE BOOL "Disable OpenGL ES 2" FORCE)
    
    # Disable Linux-specific features
    set(CEC OFF CACHE BOOL "Disable CEC support" FORCE)
    set(BCM OFF CACHE BOOL "Disable BCM host" FORCE)
    set(RPI OFF CACHE BOOL "Disable Raspberry Pi" FORCE)
    set(ENABLE_PULSE OFF CACHE BOOL "Disable PulseAudio" FORCE)
    
    # Architecture settings
    if(NOT CMAKE_OSX_ARCHITECTURES)
        set(CMAKE_OSX_ARCHITECTURES "arm64" CACHE STRING "Build for Apple Silicon")
    endif()
    
    if(NOT CMAKE_OSX_DEPLOYMENT_TARGET)
        set(CMAKE_OSX_DEPLOYMENT_TARGET "12.0" CACHE STRING "Minimum macOS version")
    endif()
    
    message(STATUS "Target Architecture: ${CMAKE_OSX_ARCHITECTURES}")
    message(STATUS "Minimum macOS Version: ${CMAKE_OSX_DEPLOYMENT_TARGET}")
endif()
```

### 2. Compiler Settings for macOS

```cmake
# After existing compiler settings, add:
if(APPLE)
    # C++ standard
    set(CMAKE_CXX_STANDARD 17)
    set(CMAKE_CXX_STANDARD_REQUIRED ON)
    set(CMAKE_CXX_EXTENSIONS OFF)
    
    # Compiler flags
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wall -Wextra")
    set(CMAKE_CXX_FLAGS_RELEASE "${CMAKE_CXX_FLAGS_RELEASE} -O3")
    
    # Suppress OpenGL deprecation warnings (OpenGL is deprecated but still functional)
    add_compile_definitions(GL_SILENCE_DEPRECATION)
    
    # macOS-specific definitions
    add_compile_definitions(__APPLE__)
    add_compile_definitions(RETROBAT)
endif()
```

### 3. Homebrew Dependencies Configuration

```cmake
if(APPLE)
    # Detect Homebrew installation
    if(CMAKE_OSX_ARCHITECTURES MATCHES "arm64")
        set(HOMEBREW_PREFIX "/opt/homebrew")
    else()
        set(HOMEBREW_PREFIX "/usr/local")
    endif()
    
    message(STATUS "Homebrew prefix: ${HOMEBREW_PREFIX}")
    
    # Add Homebrew to CMake prefix path
    list(APPEND CMAKE_PREFIX_PATH 
        "${HOMEBREW_PREFIX}"
        "${HOMEBREW_PREFIX}/opt/sdl2"
        "${HOMEBREW_PREFIX}/opt/boost"
        "${HOMEBREW_PREFIX}/opt/freetype"
        "${HOMEBREW_PREFIX}/opt/freeimage"
        "${HOMEBREW_PREFIX}/opt/curl"
    )
    
    # Set PKG_CONFIG_PATH for finding libraries
    set(ENV{PKG_CONFIG_PATH} "${HOMEBREW_PREFIX}/lib/pkgconfig:${HOMEBREW_PREFIX}/opt/libvlc/lib/pkgconfig")
endif()
```

### 4. macOS System Frameworks

```cmake
if(APPLE)
    # Find required macOS frameworks
    find_library(COCOA_LIBRARY Cocoa REQUIRED)
    find_library(IOKIT_LIBRARY IOKit REQUIRED)
    find_library(COREAUDIO_LIBRARY CoreAudio REQUIRED)
    find_library(OPENGL_LIBRARY OpenGL REQUIRED)
    find_library(COREFOUNDATION_LIBRARY CoreFoundation REQUIRED)
    find_library(SYSTEMCONFIGURATION_LIBRARY SystemConfiguration REQUIRED)
    
    message(STATUS "macOS Frameworks:")
    message(STATUS "  - Cocoa: ${COCOA_LIBRARY}")
    message(STATUS "  - IOKit: ${IOKIT_LIBRARY}")
    message(STATUS "  - CoreAudio: ${COREAUDIO_LIBRARY}")
    message(STATUS "  - OpenGL: ${OPENGL_LIBRARY}")
    
    # Group all framework libraries
    set(MACOS_FRAMEWORKS
        ${COCOA_LIBRARY}
        ${IOKIT_LIBRARY}
        ${COREAUDIO_LIBRARY}
        ${OPENGL_LIBRARY}
        ${COREFOUNDATION_LIBRARY}
        ${SYSTEMCONFIGURATION_LIBRARY}
    )
endif()
```

### 5. Source Files for macOS

In the es-app/CMakeLists.txt, add:

```cmake
# macOS-specific source files
if(APPLE)
    set(ES_SOURCES
        ${ES_SOURCES}
        ${CMAKE_CURRENT_SOURCE_DIR}/src/MacOSApiSystem.cpp
    )
    
    set(ES_HEADERS
        ${ES_HEADERS}
        ${CMAKE_CURRENT_SOURCE_DIR}/src/MacOSApiSystem.h
    )
    
    message(STATUS "Added macOS-specific sources")
endif()
```

### 6. Linking for macOS

At the end of CMakeLists.txt, modify the target_link_libraries section:

```cmake
if(APPLE)
    target_link_libraries(emulationstation ${MACOS_FRAMEWORKS})
    
    # Set RPATH for runtime library loading
    set_target_properties(emulationstation PROPERTIES
        INSTALL_RPATH "@executable_path/../Frameworks;${HOMEBREW_PREFIX}/lib"
        BUILD_WITH_INSTALL_RPATH TRUE
    )
endif()
```

### 7. App Bundle Support (Optional)

```cmake
if(APPLE)
    # Configure as macOS app bundle
    set_target_properties(emulationstation PROPERTIES
        MACOSX_BUNDLE TRUE
        MACOSX_BUNDLE_INFO_PLIST "${CMAKE_CURRENT_SOURCE_DIR}/resources/macos/Info.plist"
        MACOSX_BUNDLE_BUNDLE_NAME "EmulationStation"
        MACOSX_BUNDLE_GUI_IDENTIFIER "org.retrobat.emulationstation"
        MACOSX_BUNDLE_BUNDLE_VERSION "1.0"
        MACOSX_BUNDLE_SHORT_VERSION_STRING "1.0"
    )
    
    # Copy resources to app bundle
    set_source_files_properties(
        ${CMAKE_CURRENT_SOURCE_DIR}/resources
        PROPERTIES MACOSX_PACKAGE_LOCATION Resources
    )
endif()
```

## Complete Patch File

To apply these changes, create a file `cmake-macos.patch` with the following content:

```diff
--- a/CMakeLists.txt
+++ b/CMakeLists.txt
@@ -5,6 +5,48 @@ option(GLES2 "Set to ON if targeting OpenGL ES 2.0" ${GLES2})
 option(GL "Set to ON if targeting Desktop OpenGL" ${GL})
 option(RPI "Set to ON to enable the Raspberry PI video player (omxplayer)" ${RPI})
 option(CEC "CEC" ON)
+
+# macOS Platform Detection and Configuration
+if(APPLE)
+    message(STATUS "=========================================")
+    message(STATUS "Building EmulationStation for macOS")
+    message(STATUS "=========================================")
+    
+    # Force RetroBat mode
+    set(RETROBAT ON CACHE BOOL "Enable RetroBat features" FORCE)
+    
+    # Use Desktop OpenGL
+    set(GL ON CACHE BOOL "Use Desktop OpenGL" FORCE)
+    set(GLES OFF CACHE BOOL "Disable OpenGL ES" FORCE)
+    set(GLES2 OFF CACHE BOOL "Disable OpenGL ES 2" FORCE)
+    
+    # Disable Linux-specific features
+    set(CEC OFF CACHE BOOL "Disable CEC support" FORCE)
+    set(BCM OFF CACHE BOOL "Disable BCM host" FORCE)
+    set(RPI OFF CACHE BOOL "Disable Raspberry Pi" FORCE)
+    set(ENABLE_PULSE OFF CACHE BOOL "Disable PulseAudio" FORCE)
+    
+    # Architecture
+    if(NOT CMAKE_OSX_ARCHITECTURES)
+        set(CMAKE_OSX_ARCHITECTURES "arm64" CACHE STRING "Build for Apple Silicon")
+    endif()
+    
+    if(NOT CMAKE_OSX_DEPLOYMENT_TARGET)
+        set(CMAKE_OSX_DEPLOYMENT_TARGET "12.0" CACHE STRING "Minimum macOS version")
+    endif()
+    
+    # Homebrew paths
+    if(CMAKE_OSX_ARCHITECTURES MATCHES "arm64")
+        set(HOMEBREW_PREFIX "/opt/homebrew")
+    else()
+        set(HOMEBREW_PREFIX "/usr/local")
+    endif()
+    
+    list(APPEND CMAKE_PREFIX_PATH "${HOMEBREW_PREFIX}")
+    set(ENV{PKG_CONFIG_PATH} "${HOMEBREW_PREFIX}/lib/pkgconfig")
+    
+    message(STATUS "Homebrew prefix: ${HOMEBREW_PREFIX}")
+endif()
 
 option(BATOCERA "Set to ON to enable BATOCERA specific code" OFF)
 option(RETROBAT "Set to ON to enable RETROBAT specific code" OFF)
@@ -20,6 +62,16 @@ if(WIN32)
 
 	set(CMAKE_CXX_STANDARD 17)
 	set(CMAKE_CXX_STANDARD_REQUIRED ON)
+elseif(APPLE)
+    # macOS compiler settings
+    set(CMAKE_CXX_STANDARD 17)
+    set(CMAKE_CXX_STANDARD_REQUIRED ON)
+    set(CMAKE_CXX_EXTENSIONS OFF)
+    
+    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wall -Wextra")
+    
+    # Suppress OpenGL deprecation warnings
+    add_compile_definitions(GL_SILENCE_DEPRECATION)
 endif()
 
 # Win32 default platform & directory detection
```

## Usage

### Apply the patch manually:

Edit the main CMakeLists.txt file and add the sections above in the appropriate locations.

### Build with macOS configuration:

```bash
cd src/emulationstation
mkdir build
cd build

cmake .. \
  -DCMAKE_BUILD_TYPE=Release \
  -DRETROBAT=ON \
  -DGL=ON \
  -DCMAKE_OSX_ARCHITECTURES=arm64 \
  -DCMAKE_OSX_DEPLOYMENT_TARGET=12.0

make -j$(sysctl -n hw.ncpu)
```

## Testing the Configuration

After applying the changes, test the CMake configuration:

```bash
cd src/emulationstation
rm -rf build
mkdir build
cd build

# Configure
cmake .. -DRETROBAT=ON

# Check for errors in the output
# Look for:
# - "Building EmulationStation for macOS"
# - All frameworks found
# - No missing dependencies
```

## Troubleshooting

### If SDL2 not found:
```bash
export PKG_CONFIG_PATH="/opt/homebrew/lib/pkgconfig:$PKG_CONFIG_PATH"
```

### If VLC not found:
```bash
cmake .. -DVLC_INCLUDE_DIR=/opt/homebrew/opt/libvlc/include \
         -DVLC_LIBRARIES=/opt/homebrew/opt/libvlc/lib/libvlc.dylib
```

### If Boost not found:
```bash
cmake .. -DBOOST_ROOT=/opt/homebrew/opt/boost
```

## Verification

After building, verify the executable:

```bash
# Check architecture
file emulationstation
# Should show: Mach-O 64-bit executable arm64

# Check linked libraries
otool -L emulationstation
# Should show Homebrew libraries and macOS frameworks

# Test run
./emulationstation --version
```

## Next Steps

After successful CMake configuration:
1. Fix any remaining compilation errors
2. Test the executable
3. Create proper app bundle
4. Test with RetroBat configuration files
5. Verify theme rendering
6. Test controller input
7. Package for distribution

## References

- CMake Apple Platform: https://cmake.org/cmake/help/latest/manual/cmake-toolchains.7.html#cross-compiling-for-macos
- macOS Frameworks: https://developer.apple.com/documentation/
- Homebrew: https://docs.brew.sh/
