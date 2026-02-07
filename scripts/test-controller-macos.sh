#!/bin/bash
# RetroBat macOS Controller Testing Script
# This script checks controller detection and SDL3 setup

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}╔════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║  RetroBat macOS Controller Test Suite     ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════╝${NC}"
echo ""

# Function to print status
print_status() {
    if [ $1 -eq 0 ]; then
        echo -e "${GREEN}✓${NC} $2"
    else
        echo -e "${RED}✗${NC} $2"
    fi
}

# Function to print info
print_info() {
    echo -e "${BLUE}ℹ${NC} $1"
}

# Function to print warning
print_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

# Check if running on macOS
if [[ "$OSTYPE" != "darwin"* ]]; then
    echo -e "${RED}Error: This script must be run on macOS${NC}"
    exit 1
fi

print_info "macOS Version: $(sw_vers -productVersion)"
echo ""

# Test 1: Check SDL3 Installation
echo -e "${BLUE}[1/6] Checking SDL3 Installation...${NC}"
if command -v sdl3-config &> /dev/null; then
    SDL_VERSION=$(sdl3-config --version)
    print_status 0 "SDL3 installed: v$SDL_VERSION"
else
    print_status 1 "SDL3 not installed"
    print_warning "Install SDL3 with: brew install sdl3"
    SDL3_MISSING=1
fi
echo ""

# Test 2: Check SDL2 Installation (for EmulationStation)
echo -e "${BLUE}[2/6] Checking SDL2 Installation...${NC}"
if command -v sdl2-config &> /dev/null; then
    SDL2_VERSION=$(sdl2-config --version)
    print_status 0 "SDL2 installed: v$SDL2_VERSION"
else
    print_status 1 "SDL2 not installed"
    print_warning "Install SDL2 with: brew install sdl2"
    SDL2_MISSING=1
fi
echo ""

# Test 3: Check for gamecontrollerdb.txt
echo -e "${BLUE}[3/6] Checking gamecontrollerdb.txt...${NC}"
if [ -f "system/tools/macos/gamecontrollerdb.txt" ]; then
    MAPPING_COUNT=$(grep -c "platform:Mac OS X" system/tools/macos/gamecontrollerdb.txt || echo "0")
    print_status 0 "gamecontrollerdb.txt found with $MAPPING_COUNT macOS mappings"
else
    print_status 1 "gamecontrollerdb.txt not found at system/tools/macos/"
fi
echo ""

# Test 4: Check USB Controllers
echo -e "${BLUE}[4/6] Detecting USB Controllers...${NC}"
USB_CONTROLLERS=$(system_profiler SPUSBDataType 2>/dev/null | grep -E "(Xbox|PlayStation|DualSense|DualShock|Nintendo|Controller|Gamepad)" | sed 's/^[ \t]*//' || echo "")

if [ -n "$USB_CONTROLLERS" ]; then
    print_status 0 "USB controllers detected:"
    echo "$USB_CONTROLLERS" | while IFS= read -r line; do
        echo "  • $line"
    done
else
    print_warning "No USB controllers detected"
fi
echo ""

# Test 5: Check Bluetooth Controllers
echo -e "${BLUE}[5/6] Detecting Bluetooth Controllers...${NC}"
BT_CONTROLLERS=$(system_profiler SPBluetoothDataType 2>/dev/null | grep -E -B 2 "(Xbox|PlayStation|DualSense|DualShock|Nintendo|Controller|Gamepad)" | grep -E "(Name:|Connected:)" | sed 's/^[ \t]*//' || echo "")

if [ -n "$BT_CONTROLLERS" ]; then
    print_status 0 "Bluetooth controllers detected:"
    echo "$BT_CONTROLLERS" | while IFS= read -r line; do
        echo "  • $line"
    done
else
    print_warning "No Bluetooth controllers detected"
fi
echo ""

# Test 6: Check for test utilities
echo -e "${BLUE}[6/6] Checking Test Utilities...${NC}"

# Check for SDL testcontroller
if [ -z "$SDL3_MISSING" ]; then
    if [ -f "/opt/homebrew/bin/testcontroller" ]; then
        print_status 0 "testcontroller utility available"
        TEST_CONTROLLER="/opt/homebrew/bin/testcontroller"
    elif [ -f "/usr/local/bin/testcontroller" ]; then
        print_status 0 "testcontroller utility available"
        TEST_CONTROLLER="/usr/local/bin/testcontroller"
    else
        print_warning "testcontroller utility not found"
    fi
else
    print_status 1 "testcontroller not available (SDL3 not installed)"
fi
echo ""

# Summary
echo -e "${BLUE}╔════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║  Test Summary                              ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════╝${NC}"
echo ""

ISSUES=0

if [ -n "$SDL3_MISSING" ]; then
    echo -e "${RED}⚠ SDL3 is not installed${NC}"
    echo "  Install with: brew install sdl3"
    ISSUES=$((ISSUES + 1))
fi

if [ -n "$SDL2_MISSING" ]; then
    echo -e "${RED}⚠ SDL2 is not installed${NC}"
    echo "  Install with: brew install sdl2"
    ISSUES=$((ISSUES + 1))
fi

if [ -z "$USB_CONTROLLERS" ] && [ -z "$BT_CONTROLLERS" ]; then
    echo -e "${YELLOW}⚠ No controllers detected${NC}"
    echo "  Connect a controller via USB or Bluetooth to test"
    ISSUES=$((ISSUES + 1))
fi

if [ $ISSUES -eq 0 ]; then
    echo -e "${GREEN}✓ All checks passed!${NC}"
else
    echo -e "${YELLOW}⚠ $ISSUES issue(s) found${NC}"
fi
echo ""

# Next steps
echo -e "${BLUE}Next Steps:${NC}"
echo ""

if [ -n "$TEST_CONTROLLER" ]; then
    echo "1. Test controller input:"
    echo "   $TEST_CONTROLLER"
    echo ""
fi

echo "2. View detailed controller info:"
echo "   System Settings → Game Controllers"
echo ""

echo "3. Configure controllers in EmulationStation:"
echo "   Launch EmulationStation and follow the configuration wizard"
echo ""

echo "4. Test in RetroArch:"
echo "   Settings → Input → Port 1 Controls"
echo ""

echo -e "${BLUE}Documentation:${NC}"
echo "• Configuration Guide: docs/CONTROLLER_CONFIGURATION_MACOS.md"
echo "• Testing Guide: docs/CONTROLLER_TESTING_MACOS.md"
echo "• Troubleshooting: docs/CONTROLLER_TROUBLESHOOTING_MACOS.md"
echo "• Known Issues: docs/CONTROLLER_KNOWN_ISSUES_MACOS.md"
echo ""

exit 0
