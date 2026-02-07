#!/bin/bash
#
# RetroBat macOS Build Environment Verification Script
# This script checks if all required tools and dependencies are installed
#
# Usage: ./verify-macos-setup.sh
#

set -e  # Exit on error

echo "========================================"
echo "RetroBat macOS Build Environment Check"
echo "========================================"
echo ""

# Color codes for better readability
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Counters
TOTAL_CHECKS=0
PASSED_CHECKS=0
FAILED_CHECKS=0
WARNING_CHECKS=0

# Check if a command exists
check_command() {
    local cmd=$1
    local version_flag=$2
    local required=$3  # "required" or "optional"
    
    TOTAL_CHECKS=$((TOTAL_CHECKS + 1))
    
    if command -v "$cmd" &> /dev/null; then
        echo -e "${GREEN}✓${NC} $cmd is installed"
        if [ ! -z "$version_flag" ]; then
            local version=$($cmd $version_flag 2>&1 | head -n 1)
            echo "  Version: $version"
        fi
        PASSED_CHECKS=$((PASSED_CHECKS + 1))
        return 0
    else
        if [ "$required" = "required" ]; then
            echo -e "${RED}✗${NC} $cmd is NOT installed (REQUIRED)"
            FAILED_CHECKS=$((FAILED_CHECKS + 1))
        else
            echo -e "${YELLOW}⚠${NC} $cmd is NOT installed (optional)"
            WARNING_CHECKS=$((WARNING_CHECKS + 1))
        fi
        return 1
    fi
}

# Check if a Homebrew package is installed
check_brew_package() {
    local package=$1
    local required=$2  # "required" or "optional"
    
    TOTAL_CHECKS=$((TOTAL_CHECKS + 1))
    
    if brew list "$package" &> /dev/null 2>&1; then
        echo -e "${GREEN}✓${NC} $package is installed (Homebrew)"
        local version=$(brew list --versions "$package" 2>/dev/null)
        if [ ! -z "$version" ]; then
            echo "  $version"
        fi
        PASSED_CHECKS=$((PASSED_CHECKS + 1))
        return 0
    else
        if [ "$required" = "required" ]; then
            echo -e "${RED}✗${NC} $package is NOT installed (REQUIRED)"
            echo "  Install with: brew install $package"
            FAILED_CHECKS=$((FAILED_CHECKS + 1))
        else
            echo -e "${YELLOW}⚠${NC} $package is NOT installed (optional)"
            echo "  Install with: brew install $package"
            WARNING_CHECKS=$((WARNING_CHECKS + 1))
        fi
        return 1
    fi
}

# Check if a directory or file exists
check_exists() {
    local path=$1
    local description=$2
    local required=$3
    
    TOTAL_CHECKS=$((TOTAL_CHECKS + 1))
    
    if [ -e "$path" ]; then
        echo -e "${GREEN}✓${NC} $description exists"
        echo "  Path: $path"
        PASSED_CHECKS=$((PASSED_CHECKS + 1))
        return 0
    else
        if [ "$required" = "required" ]; then
            echo -e "${RED}✗${NC} $description NOT found (REQUIRED)"
            FAILED_CHECKS=$((FAILED_CHECKS + 1))
        else
            echo -e "${YELLOW}⚠${NC} $description NOT found (optional)"
            WARNING_CHECKS=$((WARNING_CHECKS + 1))
        fi
        return 1
    fi
}

echo -e "${BLUE}1. System Information${NC}"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "   OS: $(sw_vers -productName) $(sw_vers -productVersion)"
echo "   Build: $(sw_vers -buildVersion)"
echo "   Architecture: $(uname -m)"
echo "   Hostname: $(hostname)"
echo ""

# Check if running on Apple Silicon
if [ "$(uname -m)" != "arm64" ]; then
    echo -e "${YELLOW}⚠ WARNING:${NC} This script is optimized for Apple Silicon (arm64)."
    echo "  You are running on: $(uname -m)"
    echo ""
fi

echo -e "${BLUE}2. Development Tools${NC}"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
check_command "xcode-select" "-p" "required"
check_command "gcc" "--version" "required"
check_command "clang" "--version" "required"
check_command "git" "--version" "required"
echo ""

echo -e "${BLUE}3. Package Manager${NC}"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
check_command "brew" "--version" "required"

if command -v brew &> /dev/null; then
    echo "  Homebrew prefix: $(brew --prefix)"
    
    # Check if Homebrew is up to date
    echo "  Checking for updates..."
    if brew update > /dev/null 2>&1; then
        echo -e "  ${GREEN}Homebrew is up to date${NC}"
    else
        echo -e "  ${YELLOW}Warning: Could not check for Homebrew updates${NC}"
    fi
fi
echo ""

echo -e "${BLUE}4. .NET SDK${NC}"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
check_command "dotnet" "--version" "required"

if command -v dotnet &> /dev/null; then
    echo "  Installed SDKs:"
    dotnet --list-sdks | sed 's/^/    /'
    
    echo "  Installed Runtimes:"
    dotnet --list-runtimes | sed 's/^/    /'
    
    # Check for .NET 6+ or .NET 8+
    DOTNET_VERSION=$(dotnet --version)
    MAJOR_VERSION=$(echo $DOTNET_VERSION | cut -d. -f1)
    
    if [ "$MAJOR_VERSION" -ge 6 ]; then
        echo -e "  ${GREEN}✓ .NET version is compatible (6.0+ required)${NC}"
    else
        echo -e "  ${RED}✗ .NET version is too old (6.0+ required, found $DOTNET_VERSION)${NC}"
        FAILED_CHECKS=$((FAILED_CHECKS + 1))
    fi
fi
echo ""

echo -e "${BLUE}5. Required Command-Line Tools${NC}"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
check_command "7z" "--help" "required"
check_command "wget" "--version" "required"
check_command "curl" "--version" "required"
check_command "cmake" "--version" "required"
check_command "make" "--version" "required"
check_command "pkg-config" "--version" "required"
echo ""

echo -e "${BLUE}6. Required Libraries (Homebrew)${NC}"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
check_brew_package "sdl2" "required"
check_brew_package "boost" "required"
check_brew_package "freeimage" "required"
check_brew_package "freetype" "required"
check_brew_package "eigen" "required"
echo ""

echo -e "${BLUE}7. Optional Libraries${NC}"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
check_brew_package "sdl3" "optional"
check_brew_package "libpng" "optional"
check_brew_package "jpeg" "optional"
echo ""

echo -e "${BLUE}8. Development IDEs${NC}"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

IDE_FOUND=false

if [ -d "/Applications/Visual Studio Code.app" ]; then
    echo -e "${GREEN}✓${NC} Visual Studio Code is installed"
    if command -v code &> /dev/null; then
        echo "  CLI tool 'code' is available"
    else
        echo -e "  ${YELLOW}⚠${NC} CLI tool 'code' not in PATH"
        echo "  Install from: Code > Shell Command > Install 'code' command in PATH"
    fi
    IDE_FOUND=true
fi

if [ -d "/Applications/Rider.app" ]; then
    echo -e "${GREEN}✓${NC} JetBrains Rider is installed"
    IDE_FOUND=true
fi

if [ -d "/Applications/Visual Studio.app" ]; then
    echo -e "${YELLOW}⚠${NC} Visual Studio for Mac is installed"
    echo "  Note: VS for Mac is being discontinued. Consider VS Code or Rider."
    IDE_FOUND=true
fi

if [ "$IDE_FOUND" = false ]; then
    echo -e "${YELLOW}⚠${NC} No supported IDE found"
    echo "  Recommended: Visual Studio Code or JetBrains Rider"
    echo "  Install VS Code: brew install --cask visual-studio-code"
    WARNING_CHECKS=$((WARNING_CHECKS + 1))
fi
echo ""

echo -e "${BLUE}9. Repository Status${NC}"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# Check if we're in a git repository
if git rev-parse --git-dir > /dev/null 2>&1; then
    echo -e "${GREEN}✓${NC} Running inside a git repository"
    echo "  Repository: $(git remote get-url origin 2>/dev/null || echo 'No remote configured')"
    echo "  Current branch: $(git branch --show-current)"
    echo "  Latest commit: $(git log -1 --oneline)"
    PASSED_CHECKS=$((PASSED_CHECKS + 1))
else
    echo -e "${YELLOW}⚠${NC} Not running inside a git repository"
    echo "  This is okay if running the script standalone"
    WARNING_CHECKS=$((WARNING_CHECKS + 1))
fi
echo ""

echo -e "${BLUE}10. Disk Space${NC}"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
AVAILABLE_SPACE=$(df -h . | tail -1 | awk '{print $4}')
echo "  Available space: $AVAILABLE_SPACE"

# Parse available space (crude check)
SPACE_GB=$(df -g . | tail -1 | awk '{print $4}')
if [ "$SPACE_GB" -lt 20 ]; then
    echo -e "  ${YELLOW}⚠ WARNING:${NC} Less than 20GB free. Consider freeing up space."
    WARNING_CHECKS=$((WARNING_CHECKS + 1))
else
    echo -e "  ${GREEN}✓${NC} Sufficient disk space available"
    PASSED_CHECKS=$((PASSED_CHECKS + 1))
fi
echo ""

echo "========================================"
echo -e "${BLUE}Summary${NC}"
echo "========================================"
echo ""
echo "Total Checks: $TOTAL_CHECKS"
echo -e "${GREEN}Passed: $PASSED_CHECKS${NC}"
echo -e "${RED}Failed: $FAILED_CHECKS${NC}"
echo -e "${YELLOW}Warnings: $WARNING_CHECKS${NC}"
echo ""

if [ $FAILED_CHECKS -eq 0 ]; then
    echo -e "${GREEN}✓ All required components are installed!${NC}"
    echo ""
    echo "Next steps:"
    echo "  1. Read BUILDING_MACOS.md for detailed build instructions"
    echo "  2. Clone emulatorLauncher repository"
    echo "  3. Build the project with: dotnet build"
    echo ""
    exit 0
else
    echo -e "${RED}✗ Some required components are missing.${NC}"
    echo ""
    echo "Please install missing components:"
    echo "  • Review the sections above marked with ✗"
    echo "  • See BUILDING_MACOS.md for installation instructions"
    echo "  • Run 'brew bundle' to install Homebrew dependencies"
    echo ""
    exit 1
fi
