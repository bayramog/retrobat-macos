#!/bin/bash
# build-emulationstation-macos.sh
# 
# Build EmulationStation for macOS
# This script automates the build process for Batocera EmulationStation on macOS

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Helper functions
print_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Get script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
ES_SOURCE_DIR="$REPO_ROOT/src/emulationstation"
BUILD_DIR="$ES_SOURCE_DIR/build"

print_info "RetroBat EmulationStation Build Script for macOS"
print_info "=================================================="
echo ""

# Check if EmulationStation source exists
if [ ! -d "$ES_SOURCE_DIR" ]; then
    print_error "EmulationStation source not found at: $ES_SOURCE_DIR"
    print_info "Initializing submodules..."
    cd "$REPO_ROOT"
    git submodule update --init --recursive
    
    if [ ! -d "$ES_SOURCE_DIR" ]; then
        print_error "Failed to initialize EmulationStation submodule"
        exit 1
    fi
fi

# Check for required tools
print_info "Checking for required tools..."

if ! command -v cmake &> /dev/null; then
    print_error "CMake not found. Install with: brew install cmake"
    exit 1
fi
print_success "CMake found: $(cmake --version | head -1)"

if ! command -v brew &> /dev/null; then
    print_error "Homebrew not found. Install from: https://brew.sh"
    exit 1
fi
print_success "Homebrew found"

# Check for required dependencies
print_info "Checking for required Homebrew dependencies..."

REQUIRED_DEPS=(
    "sdl2"
    "sdl2_mixer"
    "boost"
    "freeimage"
    "freetype"
    "rapidjson"
    "curl"
    "pugixml"
    "eigen"
    "glm"
)

MISSING_DEPS=()

for dep in "${REQUIRED_DEPS[@]}"; do
    if brew list "$dep" &> /dev/null; then
        print_success "$dep is installed"
    else
        print_warning "$dep is NOT installed"
        MISSING_DEPS+=("$dep")
    fi
done

# Check for VLC (optional but recommended)
if brew list "libvlc" &> /dev/null; then
    print_success "libvlc is installed (video playback enabled)"
    VLC_ENABLED="ON"
else
    print_warning "libvlc is NOT installed (video playback will be disabled)"
    VLC_ENABLED="OFF"
fi

# Offer to install missing dependencies
if [ ${#MISSING_DEPS[@]} -gt 0 ]; then
    echo ""
    print_warning "Missing dependencies: ${MISSING_DEPS[*]}"
    read -p "Install missing dependencies now? (y/n) " -n 1 -r
    echo ""
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        print_info "Installing dependencies..."
        brew install "${MISSING_DEPS[@]}"
        print_success "Dependencies installed"
    else
        print_error "Cannot build without required dependencies"
        exit 1
    fi
fi

# Detect architecture
ARCH=$(uname -m)
if [ "$ARCH" = "arm64" ]; then
    print_info "Building for Apple Silicon (arm64)"
    CMAKE_OSX_ARCH="arm64"
    HOMEBREW_PREFIX="/opt/homebrew"
elif [ "$ARCH" = "x86_64" ]; then
    print_info "Building for Intel (x86_64)"
    CMAKE_OSX_ARCH="x86_64"
    HOMEBREW_PREFIX="/usr/local"
else
    print_error "Unknown architecture: $ARCH"
    exit 1
fi

# Parse command line arguments
BUILD_TYPE="Release"
CLEAN_BUILD=false
CREATE_BUNDLE=false
INSTALL=false

while [[ $# -gt 0 ]]; do
    case $1 in
        --debug)
            BUILD_TYPE="Debug"
            shift
            ;;
        --clean)
            CLEAN_BUILD=true
            shift
            ;;
        --bundle)
            CREATE_BUNDLE=true
            shift
            ;;
        --install)
            INSTALL=true
            shift
            ;;
        --help)
            echo "Usage: $0 [OPTIONS]"
            echo ""
            echo "Options:"
            echo "  --debug     Build in Debug mode (default: Release)"
            echo "  --clean     Clean build directory before building"
            echo "  --bundle    Create macOS app bundle after building"
            echo "  --install   Install to /usr/local (requires sudo)"
            echo "  --help      Show this help message"
            exit 0
            ;;
        *)
            print_error "Unknown option: $1"
            echo "Use --help for usage information"
            exit 1
            ;;
    esac
done

print_info "Build configuration:"
echo "  - Build type: $BUILD_TYPE"
echo "  - Architecture: $CMAKE_OSX_ARCH"
echo "  - Source directory: $ES_SOURCE_DIR"
echo "  - Build directory: $BUILD_DIR"
echo ""

# Clean build directory if requested
if [ "$CLEAN_BUILD" = true ] && [ -d "$BUILD_DIR" ]; then
    print_info "Cleaning build directory..."
    rm -rf "$BUILD_DIR"
    print_success "Build directory cleaned"
fi

# Create build directory
mkdir -p "$BUILD_DIR"
cd "$BUILD_DIR"

# Configure with CMake
print_info "Configuring with CMake..."

CMAKE_ARGS=(
    "-DCMAKE_BUILD_TYPE=$BUILD_TYPE"
    "-DRETROBAT=ON"
    "-DBATOCERA=OFF"
    "-DGL=ON"
    "-DGLES=OFF"
    "-DGLES2=OFF"
    "-DCEC=OFF"
    "-DENABLE_PULSE=OFF"
    "-DUSE_SYSTEM_PUGIXML=ON"
    "-DCMAKE_OSX_ARCHITECTURES=$CMAKE_OSX_ARCH"
    "-DCMAKE_OSX_DEPLOYMENT_TARGET=12.0"
    "-DCMAKE_PREFIX_PATH=$HOMEBREW_PREFIX"
)

# Add VLC if available
if [ "$VLC_ENABLED" = "ON" ] && [ -d "$HOMEBREW_PREFIX/opt/libvlc" ]; then
    CMAKE_ARGS+=(
        "-DVLC_INCLUDE_DIR=$HOMEBREW_PREFIX/opt/libvlc/include"
        "-DVLC_LIBRARIES=$HOMEBREW_PREFIX/opt/libvlc/lib/libvlc.dylib"
        "-DVLC_VERSION=3.0.0"
    )
fi

cmake "${CMAKE_ARGS[@]}" ..

if [ $? -ne 0 ]; then
    print_error "CMake configuration failed"
    exit 1
fi

print_success "CMake configuration complete"

# Build
print_info "Building EmulationStation..."
NUM_CORES=$(sysctl -n hw.ncpu)
print_info "Using $NUM_CORES cores for parallel build"

make -j"$NUM_CORES"

if [ $? -ne 0 ]; then
    print_error "Build failed"
    exit 1
fi

print_success "Build complete!"

# Check if executable was created
if [ -f "emulationstation" ]; then
    print_success "EmulationStation executable created: $BUILD_DIR/emulationstation"
    
    # Show file info
    print_info "Executable information:"
    file emulationstation
    otool -L emulationstation | head -10
else
    print_error "EmulationStation executable not found"
    exit 1
fi

# Create app bundle if requested
if [ "$CREATE_BUNDLE" = true ]; then
    print_info "Creating macOS app bundle..."
    
    BUNDLE_DIR="$BUILD_DIR/EmulationStation.app"
    rm -rf "$BUNDLE_DIR"
    
    mkdir -p "$BUNDLE_DIR/Contents/MacOS"
    mkdir -p "$BUNDLE_DIR/Contents/Resources"
    
    # Copy executable
    cp emulationstation "$BUNDLE_DIR/Contents/MacOS/"
    
    # Copy resources
    if [ -d "$ES_SOURCE_DIR/resources" ]; then
        cp -r "$ES_SOURCE_DIR/resources" "$BUNDLE_DIR/Contents/Resources/"
    fi
    
    # Create Info.plist
    cat > "$BUNDLE_DIR/Contents/Info.plist" << 'EOF'
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
    
    print_success "App bundle created: $BUNDLE_DIR"
fi

# Install if requested
if [ "$INSTALL" = true ]; then
    print_info "Installing EmulationStation..."
    sudo make install
    print_success "EmulationStation installed to /usr/local"
fi

echo ""
print_success "=========================================="
print_success "EmulationStation build complete!"
print_success "=========================================="
echo ""
print_info "Executable location: $BUILD_DIR/emulationstation"

if [ "$CREATE_BUNDLE" = true ]; then
    print_info "App bundle location: $BUILD_DIR/EmulationStation.app"
fi

echo ""
print_info "To run EmulationStation:"
echo "  cd $BUILD_DIR"
echo "  ./emulationstation"
echo ""
print_info "For more information, see: docs/BUILDING_EMULATIONSTATION_MACOS.md"
