#!/bin/bash
# ==============================================================================
# RetroBat macOS Automated Build Script
# ==============================================================================
# This script automates the entire macOS build process for RetroBat:
# - Dependency checking
# - .NET project building
# - Resource downloading
# - File organization
# - DMG/PKG creation
# - Build verification
#
# Usage: ./build-macos.sh [options]
# Options:
#   --skip-deps       Skip dependency checking
#   --skip-build      Skip RetroBuild compilation
#   --skip-download   Skip resource downloading
#   --skip-package    Skip DMG/PKG creation
#   --clean           Clean build directory before starting
#   --help            Show this help message
# ==============================================================================

set -e  # Exit on error

# ==============================================================================
# Configuration
# ==============================================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BUILD_DIR="$SCRIPT_DIR/build"
OUTPUT_DIR="$SCRIPT_DIR/output"
SRC_DIR="$SCRIPT_DIR/src/RetroBuild"
CONFIG_FILE="$SCRIPT_DIR/build.ini"
MACOS_CONFIG_FILE="$SCRIPT_DIR/build-macos.ini"
LOG_FILE="$SCRIPT_DIR/build-macos.log"

# Version info (read from build.ini or defaults)
VERSION="8.0.0.0"
ARCH="osx-arm64"

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Parse command line arguments
SKIP_DEPS=false
SKIP_BUILD=false
SKIP_DOWNLOAD=false
SKIP_PACKAGE=false
CLEAN_BUILD=false

# ==============================================================================
# Helper Functions
# ==============================================================================

log() {
    echo -e "${BLUE}[$(date +'%Y-%m-%d %H:%M:%S')]${NC} $*" | tee -a "$LOG_FILE"
}

success() {
    echo -e "${GREEN}✓${NC} $*" | tee -a "$LOG_FILE"
}

error() {
    echo -e "${RED}✗${NC} $*" | tee -a "$LOG_FILE"
}

warning() {
    echo -e "${YELLOW}⚠${NC} $*" | tee -a "$LOG_FILE"
}

section() {
    echo "" | tee -a "$LOG_FILE"
    echo "==============================================================================" | tee -a "$LOG_FILE"
    echo "$*" | tee -a "$LOG_FILE"
    echo "==============================================================================" | tee -a "$LOG_FILE"
}

check_command() {
    local cmd=$1
    local package=$2
    
    if command -v "$cmd" > /dev/null 2>&1; then
        success "$cmd is installed ($(which "$cmd"))"
        return 0
    else
        error "$cmd is NOT installed"
        if [ -n "$package" ]; then
            echo "  Install with: brew install $package"
        fi
        return 1
    fi
}

show_help() {
    cat << EOF
RetroBat macOS Automated Build Script

Usage: $0 [options]

Options:
    --skip-deps       Skip dependency checking
    --skip-build      Skip RetroBuild compilation
    --skip-download   Skip resource downloading
    --skip-package    Skip DMG/PKG creation
    --clean           Clean build directory before starting
    --help            Show this help message

Examples:
    # Full build from scratch
    $0

    # Build without creating packages
    $0 --skip-package

    # Clean build (removes previous build)
    $0 --clean

Environment Variables:
    RETROBAT_VERSION  Override version number
    SIGNING_IDENTITY  Code signing identity (optional)
    NOTARIZE_PROFILE  Notarization profile (optional)

EOF
    exit 0
}

# ==============================================================================
# Parse Arguments
# ==============================================================================

while [[ $# -gt 0 ]]; do
    case $1 in
        --skip-deps)
            SKIP_DEPS=true
            shift
            ;;
        --skip-build)
            SKIP_BUILD=true
            shift
            ;;
        --skip-download)
            SKIP_DOWNLOAD=true
            shift
            ;;
        --skip-package)
            SKIP_PACKAGE=true
            shift
            ;;
        --clean)
            CLEAN_BUILD=true
            shift
            ;;
        --help|-h)
            show_help
            ;;
        *)
            error "Unknown option: $1"
            show_help
            ;;
    esac
done

# ==============================================================================
# Main Build Process
# ==============================================================================

section "RetroBat macOS Build Starting"
log "Build directory: $BUILD_DIR"
log "Output directory: $OUTPUT_DIR"
log "Log file: $LOG_FILE"

# Initialize log file
echo "RetroBat macOS Build Log - $(date)" > "$LOG_FILE"

# ==============================================================================
# Step 1: Dependency Checking
# ==============================================================================

if [ "$SKIP_DEPS" = false ]; then
    section "Step 1: Checking Dependencies"
    
    MISSING_DEPS=false
    
    # Check required tools
    check_command "dotnet" "dotnet-sdk" || MISSING_DEPS=true
    check_command "7z" "p7zip" || MISSING_DEPS=true
    check_command "wget" "wget" || MISSING_DEPS=true
    check_command "curl" "" || MISSING_DEPS=true
    check_command "git" "" || MISSING_DEPS=true
    
    # Check optional packaging tools
    check_command "hdiutil" "" || warning "hdiutil not found (built-in on macOS)"
    check_command "create-dmg" "create-dmg" || warning "create-dmg not found (optional for custom DMG)"
    
    if [ "$MISSING_DEPS" = true ]; then
        error "Missing required dependencies"
        log "Install with: brew bundle"
        exit 1
    fi
    
    # Check .NET version
    DOTNET_VERSION=$(dotnet --version)
    log "Using .NET version: $DOTNET_VERSION"
    
    # Verify major version is 8 or higher
    DOTNET_MAJOR=$(echo "$DOTNET_VERSION" | cut -d. -f1)
    if [ "$DOTNET_MAJOR" -lt 8 ]; then
        error ".NET 8.0 or higher is required (found $DOTNET_VERSION)"
        exit 1
    fi
    
    success "All dependencies satisfied"
else
    warning "Skipping dependency check"
fi

# ==============================================================================
# Step 2: Clean Build Directory (Optional)
# ==============================================================================

if [ "$CLEAN_BUILD" = true ]; then
    section "Step 2: Cleaning Build Directory"
    
    if [ -d "$BUILD_DIR" ]; then
        log "Removing existing build directory..."
        rm -rf "$BUILD_DIR"
        success "Build directory cleaned"
    fi
    
    if [ -d "$OUTPUT_DIR" ]; then
        log "Removing existing output directory..."
        rm -rf "$OUTPUT_DIR"
        success "Output directory cleaned"
    fi
fi

# ==============================================================================
# Step 3: Build Configuration
# ==============================================================================

section "Step 3: Preparing Build Configuration"

# Ensure we have a build.ini
if [ ! -f "$CONFIG_FILE" ]; then
    if [ -f "$MACOS_CONFIG_FILE" ]; then
        log "Copying build-macos.ini to build.ini..."
        cp "$MACOS_CONFIG_FILE" "$CONFIG_FILE"
        success "Configuration file prepared"
    else
        error "Neither build.ini nor build-macos.ini found"
        exit 1
    fi
else
    log "Using existing build.ini"
fi

# Read version from config if available
if grep -q "retrobat_version=" "$CONFIG_FILE" 2>/dev/null; then
    VERSION=$(grep "retrobat_version=" "$CONFIG_FILE" | cut -d= -f2)
    log "Version from config: $VERSION"
fi

# Override with environment variable if set
if [ -n "$RETROBAT_VERSION" ]; then
    VERSION="$RETROBAT_VERSION"
    log "Version overridden: $VERSION"
fi

# ==============================================================================
# Step 4: Build RetroBuild
# ==============================================================================

if [ "$SKIP_BUILD" = false ]; then
    section "Step 4: Building RetroBuild"
    
    if [ ! -d "$SRC_DIR" ]; then
        error "RetroBuild source directory not found: $SRC_DIR"
        exit 1
    fi
    
    log "Building RetroBuild in Release mode..."
    cd "$SRC_DIR"
    
    if dotnet build -c Release 2>&1 | tee -a "$LOG_FILE"; then
        success "RetroBuild compiled successfully"
    else
        error "RetroBuild compilation failed"
        exit 1
    fi
    
    cd "$SCRIPT_DIR"
else
    warning "Skipping RetroBuild compilation"
fi

# ==============================================================================
# Step 5: Download and Configure Resources
# ==============================================================================

if [ "$SKIP_DOWNLOAD" = false ]; then
    section "Step 5: Downloading Resources"
    
    log "Running RetroBuild to download and configure resources..."
    log "This may take several minutes depending on your internet connection..."
    
    cd "$SCRIPT_DIR"
    
    # Run RetroBuild with option 1 (Download and configure)
    if echo "1" | dotnet run --project "$SRC_DIR/RetroBuild.csproj" 2>&1 | tee -a "$LOG_FILE"; then
        success "Resources downloaded and configured"
    else
        error "Resource download failed"
        exit 1
    fi
else
    warning "Skipping resource download"
fi

# ==============================================================================
# Step 6: File Organization
# ==============================================================================

section "Step 6: Organizing Build Files"

if [ ! -d "$BUILD_DIR" ]; then
    error "Build directory not found: $BUILD_DIR"
    error "Resource download may have failed"
    exit 1
fi

log "Verifying build structure..."

# Check for critical directories
CRITICAL_DIRS=(
    "$BUILD_DIR/system"
    "$BUILD_DIR/emulators"
)

for dir in "${CRITICAL_DIRS[@]}"; do
    if [ -d "$dir" ]; then
        success "Found: $(basename "$dir")"
    else
        warning "Missing: $(basename "$dir")"
    fi
done

# Count files in build
FILE_COUNT=$(find "$BUILD_DIR" -type f | wc -l)
DIR_COUNT=$(find "$BUILD_DIR" -type d | wc -l)
log "Build contains: $FILE_COUNT files in $DIR_COUNT directories"

success "Build structure verified"

# ==============================================================================
# Step 7: Code Signing Integration (Placeholder)
# ==============================================================================

section "Step 7: Code Signing"

if [ -n "$SIGNING_IDENTITY" ]; then
    warning "Code signing requested but not yet implemented"
    log "Signing identity: $SIGNING_IDENTITY"
    log "This feature will be implemented in a future version"
    # TODO: Implement signing
    # - Sign all executables and libraries
    # - Sign app bundles
    # - Sign with entitlements
else
    log "No signing identity specified (SIGNING_IDENTITY not set)"
    log "Builds will be unsigned"
fi

# ==============================================================================
# Step 8: Create Packages
# ==============================================================================

if [ "$SKIP_PACKAGE" = false ]; then
    section "Step 8: Creating Distribution Packages"
    
    # Create output directory
    mkdir -p "$OUTPUT_DIR"
    
    # --- Create ZIP Archive ---
    log "Creating ZIP archive..."
    ARCHIVE_NAME="retrobat-macos-v${VERSION}-${ARCH}.zip"
    ARCHIVE_PATH="$OUTPUT_DIR/$ARCHIVE_NAME"
    
    cd "$SCRIPT_DIR"
    if 7z a -tzip "$ARCHIVE_PATH" ./build/* 2>&1 | tee -a "$LOG_FILE"; then
        success "ZIP archive created: $ARCHIVE_NAME"
        
        # Create checksum
        CHECKSUM_FILE="${ARCHIVE_PATH}.sha256"
        if command -v shasum > /dev/null 2>&1; then
            cd "$OUTPUT_DIR"
            shasum -a 256 "$ARCHIVE_NAME" > "$(basename $CHECKSUM_FILE)"
            success "Checksum created: $(basename $CHECKSUM_FILE)"
            cd "$SCRIPT_DIR"
        fi
    else
        error "ZIP archive creation failed"
    fi
    
    # --- Create DMG (macOS Disk Image) ---
    log "Creating DMG disk image..."
    DMG_NAME="RetroBat-macOS-v${VERSION}.dmg"
    DMG_PATH="$OUTPUT_DIR/$DMG_NAME"
    
    if command -v hdiutil > /dev/null 2>&1; then
        # Create a temporary directory for DMG contents
        DMG_TEMP="$OUTPUT_DIR/dmg_temp"
        mkdir -p "$DMG_TEMP"
        
        # Copy build to temp location with a nice name
        cp -R "$BUILD_DIR" "$DMG_TEMP/RetroBat"
        
        # Create DMG
        if hdiutil create -volname "RetroBat macOS" \
                         -srcfolder "$DMG_TEMP" \
                         -ov -format UDZO \
                         "$DMG_PATH" 2>&1 | tee -a "$LOG_FILE"; then
            success "DMG created: $DMG_NAME"
            
            # Cleanup temp
            rm -rf "$DMG_TEMP"
        else
            error "DMG creation failed"
            rm -rf "$DMG_TEMP"
        fi
    else
        warning "hdiutil not found, skipping DMG creation"
    fi
    
    # --- Create PKG (macOS Installer Package) - Placeholder ---
    log "PKG creation not yet implemented"
    warning "PKG installer will be added in a future version"
    # TODO: Implement PKG creation
    # - Create package structure
    # - Add installer scripts
    # - Sign package
    
else
    warning "Skipping package creation"
fi

# ==============================================================================
# Step 9: Build Verification
# ==============================================================================

section "Step 9: Build Verification"

# Verify build directory
if [ -d "$BUILD_DIR" ]; then
    success "Build directory exists"
    
    # Calculate build size
    if command -v du > /dev/null 2>&1; then
        BUILD_SIZE=$(du -sh "$BUILD_DIR" | cut -f1)
        log "Build size: $BUILD_SIZE"
    fi
else
    error "Build directory missing!"
    exit 1
fi

# Verify archives
if [ "$SKIP_PACKAGE" = false ]; then
    if [ -f "$ARCHIVE_PATH" ]; then
        success "ZIP archive verified"
        ARCHIVE_SIZE=$(du -sh "$ARCHIVE_PATH" | cut -f1)
        log "Archive size: $ARCHIVE_SIZE"
    else
        error "ZIP archive missing!"
    fi
    
    if [ -f "$DMG_PATH" ]; then
        success "DMG image verified"
        DMG_SIZE=$(du -sh "$DMG_PATH" | cut -f1)
        log "DMG size: $DMG_SIZE"
    else
        warning "DMG image not created"
    fi
fi

# ==============================================================================
# Build Complete
# ==============================================================================

section "Build Complete!"

log "Build artifacts:"
if [ -d "$BUILD_DIR" ]; then
    log "  - Build directory: $BUILD_DIR"
fi
if [ -f "$ARCHIVE_PATH" ]; then
    log "  - ZIP archive: $ARCHIVE_PATH"
fi
if [ -f "$DMG_PATH" ]; then
    log "  - DMG image: $DMG_PATH"
fi

log ""
log "Next steps:"
log "  1. Test the build by extracting and running RetroBat"
log "  2. Verify all components are present"
log "  3. Test emulator launching"

if [ -z "$SIGNING_IDENTITY" ]; then
    log ""
    warning "Build is unsigned!"
    log "  For distribution, sign with:"
    log "    SIGNING_IDENTITY=\"Developer ID\" ./build-macos.sh"
fi

log ""
success "Build log saved to: $LOG_FILE"
success "All done! 🎮"
