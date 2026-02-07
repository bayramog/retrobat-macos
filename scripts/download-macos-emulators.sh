#!/bin/bash
################################################################################
# RetroBat macOS Emulator Download Script
# 
# This script downloads and installs the top priority emulators for macOS.
# It handles DMG/ZIP extraction and places emulators in standard locations.
#
# Usage: ./download-macos-emulators.sh [options]
#
# Options:
#   --all           Download all top 20 emulators
#   --core          Download only core emulators (RetroArch, Dolphin, PCSX2)
#   --list          List available emulators
#   --help          Show this help message
#
# Requirements:
#   - macOS 12+ (Monterey or later)
#   - Apple Silicon (M1/M2/M3/M4)
#   - Homebrew (for 7z, wget, curl)
#   - Internet connection
#
################################################################################

set -e  # Exit on error

# Color output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Directories
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOWNLOAD_DIR="${DOWNLOAD_DIR:-/tmp/retrobat-emulators}"
INSTALL_DIR="${INSTALL_DIR:-/Applications}"
TEMP_DIR="${DOWNLOAD_DIR}/temp"

# Create directories
mkdir -p "$DOWNLOAD_DIR"
mkdir -p "$TEMP_DIR"

# Logging
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if running on macOS
check_macos() {
    if [[ "$OSTYPE" != "darwin"* ]]; then
        log_error "This script must be run on macOS"
        exit 1
    fi
}

# Check if running on Apple Silicon
check_apple_silicon() {
    ARCH=$(uname -m)
    if [[ "$ARCH" != "arm64" ]]; then
        log_warning "This script is optimized for Apple Silicon (ARM64)"
        log_warning "You are running on $ARCH architecture"
        log_warning "Some emulators may not perform optimally"
    fi
}

# Check for required tools
check_dependencies() {
    local missing_deps=()
    
    for cmd in wget curl 7z; do
        if ! command -v $cmd &> /dev/null; then
            missing_deps+=($cmd)
        fi
    done
    
    if [ ${#missing_deps[@]} -gt 0 ]; then
        log_error "Missing required dependencies: ${missing_deps[*]}"
        log_info "Install with: brew install ${missing_deps[*]}"
        exit 1
    fi
}

# Download file with progress
download_file() {
    local url="$1"
    local output="$2"
    local filename=$(basename "$output")
    
    log_info "Downloading $filename..."
    
    if command -v wget &> /dev/null; then
        wget --progress=bar:force -O "$output" "$url" 2>&1 | \
            grep -o "[0-9]*%" | while read percent; do
                printf "\rProgress: $percent"
            done
        echo ""
    else
        curl -L -# -o "$output" "$url"
    fi
    
    if [ $? -eq 0 ]; then
        log_success "Downloaded $filename"
        return 0
    else
        log_error "Failed to download $filename"
        return 1
    fi
}

# Extract DMG file
extract_dmg() {
    local dmg_file="$1"
    local app_name="$2"
    local dest_dir="$3"
    
    log_info "Mounting $dmg_file..."
    
    # Mount the DMG
    local mount_point=$(hdiutil attach "$dmg_file" | grep "/Volumes/" | sed 's/.*\/Volumes/\/Volumes/')
    
    if [ -z "$mount_point" ]; then
        log_error "Failed to mount DMG"
        return 1
    fi
    
    # Find the .app bundle
    local app_path=$(find "$mount_point" -maxdepth 2 -name "*.app" -type d | head -n 1)
    
    if [ -z "$app_path" ]; then
        log_error "No .app bundle found in DMG"
        hdiutil detach "$mount_point" &> /dev/null
        return 1
    fi
    
    # Copy the app
    log_info "Installing $(basename "$app_path")..."
    cp -R "$app_path" "$dest_dir/"
    
    # Unmount
    hdiutil detach "$mount_point" &> /dev/null
    
    log_success "Installed $(basename "$app_path") to $dest_dir"
    return 0
}

# Extract ZIP file
extract_zip() {
    local zip_file="$1"
    local dest_dir="$2"
    
    log_info "Extracting $zip_file..."
    
    # Create temp extraction directory
    local extract_dir="${TEMP_DIR}/extract_$$"
    mkdir -p "$extract_dir"
    
    # Extract
    unzip -q "$zip_file" -d "$extract_dir"
    
    # Find .app bundle
    local app_path=$(find "$extract_dir" -maxdepth 3 -name "*.app" -type d | head -n 1)
    
    if [ -n "$app_path" ]; then
        log_info "Installing $(basename "$app_path")..."
        cp -R "$app_path" "$dest_dir/"
        rm -rf "$extract_dir"
        log_success "Installed $(basename "$app_path") to $dest_dir"
        return 0
    else
        log_warning "No .app bundle found in ZIP"
        rm -rf "$extract_dir"
        return 1
    fi
}

# Remove quarantine attribute
remove_quarantine() {
    local app_path="$1"
    
    if [ -d "$app_path" ]; then
        log_info "Removing quarantine attribute from $(basename "$app_path")..."
        xattr -cr "$app_path" 2>/dev/null || true
    fi
}

# Install emulator
install_emulator() {
    local name="$1"
    local url="$2"
    local file_type="$3"  # dmg, zip, or tar.gz
    
    local filename="${name}.${file_type}"
    local download_path="${DOWNLOAD_DIR}/${filename}"
    local app_name="${name}.app"
    local install_path="${INSTALL_DIR}/${app_name}"
    
    # Check if already installed
    if [ -d "$install_path" ]; then
        log_info "$name is already installed at $install_path"
        read -p "Do you want to reinstall? (y/N): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            return 0
        fi
        rm -rf "$install_path"
    fi
    
    # Download
    if [ ! -f "$download_path" ]; then
        download_file "$url" "$download_path" || return 1
    else
        log_info "Using cached download: $filename"
    fi
    
    # Extract and install
    case "$file_type" in
        dmg)
            extract_dmg "$download_path" "$name" "$INSTALL_DIR" || return 1
            ;;
        zip)
            extract_zip "$download_path" "$INSTALL_DIR" || return 1
            ;;
        *)
            log_error "Unsupported file type: $file_type"
            return 1
            ;;
    esac
    
    # Remove quarantine
    if [ -d "$install_path" ]; then
        remove_quarantine "$install_path"
    fi
    
    return 0
}

# Emulator definitions
# Format: "name|url|file_type"
declare -A EMULATORS

# Core emulators (Priority 1)
EMULATORS[retroarch]="RetroArch|https://buildbot.libretro.com/stable/1.19.1/apple/osx/arm64/RetroArch.dmg|dmg"
EMULATORS[dolphin]="Dolphin|https://dl.dolphin-emu.org/builds/dolphin-master-latest.dmg|dmg"
EMULATORS[pcsx2]="PCSX2|https://github.com/PCSX2/pcsx2/releases/latest/download/pcsx2-macos-Qt.dmg|dmg"

# High priority emulators (Priority 2)
EMULATORS[ppsspp]="PPSSPP|https://www.ppsspp.org/files/1_17_1/PPSSPPSDL-macOS-v1.17.1.zip|zip"
EMULATORS[duckstation]="DuckStation|https://github.com/stenzek/duckstation/releases/latest/download/duckstation-mac-release.zip|zip"
EMULATORS[melonds]="melonDS|https://github.com/melonDS-emu/melonDS/releases/latest/download/melonDS-macOS.dmg|dmg"
EMULATORS[mgba]="mGBA|https://github.com/mgba-emu/mgba/releases/latest/download/mGBA-mac.dmg|dmg"
EMULATORS[snes9x]="Snes9x|https://github.com/snes9xgit/snes9x/releases/latest/download/Snes9x-macOS.zip|zip"

# Additional emulators (Priority 3)
EMULATORS[rpcs3]="RPCS3|https://github.com/RPCS3/rpcs3-binaries-mac/releases/latest/download/rpcs3-macos.dmg|dmg"
EMULATORS[ryujinx]="Ryujinx|https://github.com/Ryujinx/release-channel-master/releases/latest/download/ryujinx-macos.zip|zip"
EMULATORS[lime3ds]="Lime3DS|https://github.com/Lime3DS/Lime3DS/releases/latest/download/Lime3DS-macOS-arm64.zip|zip"
EMULATORS[scummvm]="ScummVM|https://www.scummvm.org/frs/scummvm/2.8.1/scummvm-2.8.1-macosx.dmg|dmg"
EMULATORS[xemu]="xemu|https://github.com/xemu-project/xemu/releases/latest/download/xemu-macos.zip|zip"
EMULATORS[dosbox-x]="DOSBox-X|https://github.com/joncampbell123/dosbox-x/releases/latest/download/dosbox-x-macosx-arm64.zip|zip"
EMULATORS[ares]="ares|https://github.com/ares-emulator/ares/releases/latest/download/ares-macos.zip|zip"
EMULATORS[hatari]="Hatari|https://download.tuxfamily.org/hatari/builds/macos/Hatari-arm64.dmg|dmg"
EMULATORS[stella]="Stella|https://github.com/stella-emu/stella/releases/latest/download/Stella-macOS.dmg|dmg"

# Core emulators list
CORE_EMULATORS=("retroarch" "dolphin" "pcsx2")

# All emulators list (ordered by priority)
ALL_EMULATORS=("retroarch" "dolphin" "pcsx2" "ppsspp" "duckstation" "melonds" 
               "mgba" "snes9x" "rpcs3" "ryujinx" "lime3ds" "scummvm" "xemu" 
               "dosbox-x" "ares" "hatari" "stella")

# List available emulators
list_emulators() {
    echo ""
    echo "Available Emulators:"
    echo "===================="
    echo ""
    echo "Core Emulators (Essential):"
    for emu in "${CORE_EMULATORS[@]}"; do
        IFS='|' read -r name url type <<< "${EMULATORS[$emu]}"
        printf "  %-15s - %s\n" "$name" "Multi-system / GameCube/Wii / PS2"
    done
    echo ""
    echo "High Priority Emulators:"
    printf "  %-15s - %s\n" "PPSSPP" "PSP"
    printf "  %-15s - %s\n" "DuckStation" "PlayStation 1"
    printf "  %-15s - %s\n" "melonDS" "Nintendo DS"
    printf "  %-15s - %s\n" "mGBA" "Game Boy Advance"
    printf "  %-15s - %s\n" "Snes9x" "Super Nintendo"
    echo ""
    echo "Additional Emulators:"
    printf "  %-15s - %s\n" "RPCS3" "PlayStation 3 (Experimental)"
    printf "  %-15s - %s\n" "Ryujinx" "Nintendo Switch"
    printf "  %-15s - %s\n" "Lime3DS" "Nintendo 3DS"
    printf "  %-15s - %s\n" "ScummVM" "Adventure Games"
    printf "  %-15s - %s\n" "xemu" "Original Xbox"
    printf "  %-15s - %s\n" "DOSBox-X" "DOS"
    printf "  %-15s - %s\n" "ares" "Multi-system"
    printf "  %-15s - %s\n" "Hatari" "Atari ST"
    printf "  %-15s - %s\n" "Stella" "Atari 2600"
    echo ""
}

# Show help
show_help() {
    cat << EOF
RetroBat macOS Emulator Download Script

Usage: $0 [options]

Options:
    --all           Download all top emulators
    --core          Download only core emulators (RetroArch, Dolphin, PCSX2)
    --list          List available emulators
    --help          Show this help message

Examples:
    $0 --core       # Install essential emulators
    $0 --all        # Install all emulators
    $0 --list       # Show available emulators

Environment Variables:
    DOWNLOAD_DIR    Directory for downloads (default: /tmp/retrobat-emulators)
    INSTALL_DIR     Installation directory (default: /Applications)

Requirements:
    - macOS 12+ (Monterey or later)
    - Apple Silicon (M1/M2/M3/M4) recommended
    - Homebrew packages: wget, curl, p7zip

EOF
}

# Main installation function
main() {
    local mode="${1:-interactive}"
    
    check_macos
    check_apple_silicon
    check_dependencies
    
    case "$mode" in
        --list)
            list_emulators
            exit 0
            ;;
        --help)
            show_help
            exit 0
            ;;
        --core)
            log_info "Installing core emulators..."
            local emulators_to_install=("${CORE_EMULATORS[@]}")
            ;;
        --all)
            log_info "Installing all emulators..."
            local emulators_to_install=("${ALL_EMULATORS[@]}")
            ;;
        *)
            show_help
            exit 1
            ;;
    esac
    
    log_info "Download directory: $DOWNLOAD_DIR"
    log_info "Installation directory: $INSTALL_DIR"
    echo ""
    
    local success_count=0
    local fail_count=0
    local failed_emulators=()
    
    for emu_key in "${emulators_to_install[@]}"; do
        IFS='|' read -r name url file_type <<< "${EMULATORS[$emu_key]}"
        
        echo ""
        log_info "========================================"
        log_info "Installing: $name"
        log_info "========================================"
        
        if install_emulator "$name" "$url" "$file_type"; then
            ((success_count++))
        else
            ((fail_count++))
            failed_emulators+=("$name")
        fi
    done
    
    # Summary
    echo ""
    echo "========================================"
    log_success "Installation Complete!"
    echo "========================================"
    log_info "Successfully installed: $success_count"
    if [ $fail_count -gt 0 ]; then
        log_warning "Failed installations: $fail_count"
        log_warning "Failed emulators: ${failed_emulators[*]}"
    fi
    echo ""
    log_info "Emulators installed to: $INSTALL_DIR"
    log_info "Downloads cached in: $DOWNLOAD_DIR"
    echo ""
    log_info "Next steps:"
    log_info "1. Check System Settings > Privacy & Security for any blocked apps"
    log_info "2. Configure emulators with BIOS files if needed"
    log_info "3. See MACOS_EMULATOR_COMPATIBILITY.md for configuration details"
    echo ""
}

# Run main function
main "$@"
