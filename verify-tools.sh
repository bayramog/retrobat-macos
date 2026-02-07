#!/bin/bash
# Verification script for macOS tool replacement
# This script verifies that all required tools are available and functional

echo "=========================================="
echo "RetroBat macOS Tool Verification Script"
echo "=========================================="
echo ""

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

SUCCESS=0
WARNINGS=0
FAILURES=0

check_tool() {
    local tool=$1
    local package=$2
    
    if command -v "$tool" > /dev/null 2>&1; then
        echo -e "${GREEN}✓${NC} $tool is installed"
        echo "  Location: $(which $tool)"
        SUCCESS=$((SUCCESS + 1))
        return 0
    else
        echo -e "${RED}✗${NC} $tool is NOT installed"
        if [ -n "$package" ]; then
            echo "  Install with: brew install $package"
        fi
        FAILURES=$((FAILURES + 1))
        return 1
    fi
}

check_library() {
    local lib=$1
    local package=$2
    local paths=(
        "/opt/homebrew/lib/$lib"
        "/usr/local/lib/$lib"
    )
    
    local found=false
    for path in "${paths[@]}"; do
        if [ -f "$path" ] || ls "$path"* > /dev/null 2>&1; then
            echo -e "${GREEN}✓${NC} $lib is installed"
            echo "  Location: $path"
            SUCCESS=$((SUCCESS + 1))
            found=true
            break
        fi
    done
    
    if [ "$found" = false ]; then
        echo -e "${YELLOW}⚠${NC} $lib not found (optional)"
        echo "  Install with: brew install $package"
        WARNINGS=$((WARNINGS + 1))
        return 1
    fi
    return 0
}

echo "1. Checking Core Build Tools"
echo "------------------------------"
check_tool "7z" "p7zip"
check_tool "wget" "wget"
check_tool "curl" ""
check_tool "git" ""
check_tool "dotnet" "dotnet-sdk"
echo ""

echo "2. Checking SDL Libraries"
echo "------------------------------"
check_library "libSDL2.dylib" "sdl2"
check_library "libSDL3.dylib" "sdl3"
echo ""

echo "3. Testing Tool Functionality"
echo "------------------------------"

# Test 7z
if command -v 7z > /dev/null 2>&1; then
    if 7z --help > /dev/null 2>&1; then
        echo -e "${GREEN}✓${NC} 7z works correctly"
        SUCCESS=$((SUCCESS + 1))
    else
        echo -e "${RED}✗${NC} 7z failed functionality test"
        FAILURES=$((FAILURES + 1))
    fi
fi

# Test wget
if command -v wget > /dev/null 2>&1; then
    if wget --version > /dev/null 2>&1; then
        echo -e "${GREEN}✓${NC} wget works correctly"
        SUCCESS=$((SUCCESS + 1))
    else
        echo -e "${RED}✗${NC} wget failed functionality test"
        FAILURES=$((FAILURES + 1))
    fi
fi

# Test curl
if command -v curl > /dev/null 2>&1; then
    if curl --version > /dev/null 2>&1; then
        echo -e "${GREEN}✓${NC} curl works correctly"
        SUCCESS=$((SUCCESS + 1))
    else
        echo -e "${RED}✗${NC} curl failed functionality test"
        FAILURES=$((FAILURES + 1))
    fi
fi

# Test dotnet
if command -v dotnet > /dev/null 2>&1; then
    if dotnet --version > /dev/null 2>&1; then
        echo -e "${GREEN}✓${NC} dotnet works correctly"
        echo "  Version: $(dotnet --version)"
        SUCCESS=$((SUCCESS + 1))
    else
        echo -e "${RED}✗${NC} dotnet failed functionality test"
        FAILURES=$((FAILURES + 1))
    fi
fi

echo ""
echo "4. Testing Archive Extraction"
echo "------------------------------"

if command -v 7z > /dev/null 2>&1; then
    # Create test archive
    TEST_DIR="/tmp/retrobat-7z-test"
    mkdir -p "$TEST_DIR/input"
    echo "Test content" > "$TEST_DIR/input/test.txt"
    
    # Save current directory
    ORIGINAL_DIR="$(pwd)"
    
    # Create archive
    cd "$TEST_DIR/input"
    if 7z a "$TEST_DIR/test.zip" test.txt > /dev/null 2>&1; then
        # Extract archive
        mkdir -p "$TEST_DIR/output"
        if 7z x "$TEST_DIR/test.zip" -o"$TEST_DIR/output" -y > /dev/null 2>&1; then
            if [ -f "$TEST_DIR/output/test.txt" ]; then
                echo -e "${GREEN}✓${NC} Archive extraction works correctly"
                SUCCESS=$((SUCCESS + 1))
            else
                echo -e "${RED}✗${NC} Archive extraction failed: file not found"
                FAILURES=$((FAILURES + 1))
            fi
        else
            echo -e "${RED}✗${NC} Archive extraction failed: 7z x command failed"
            FAILURES=$((FAILURES + 1))
        fi
    else
        echo -e "${RED}✗${NC} Archive creation failed"
        FAILURES=$((FAILURES + 1))
    fi
    
    # Return to original directory
    cd "$ORIGINAL_DIR"
    
    # Cleanup
    rm -rf "$TEST_DIR"
else
    echo -e "${YELLOW}⚠${NC} Skipping extraction test (7z not found)"
    WARNINGS=$((WARNINGS + 1))
fi

echo ""
echo "5. Checking RetroBuild"
echo "------------------------------"

# Try to find the repository root
REPO_ROOT=""
if [ -d "src/RetroBuild" ]; then
    REPO_ROOT="."
elif [ -d "../src/RetroBuild" ]; then
    REPO_ROOT=".."
fi

if [ -n "$REPO_ROOT" ]; then
    RETROBUILD_DIR="$REPO_ROOT/src/RetroBuild"
    echo "  Building RetroBuild..."
    BUILD_OUTPUT=$(dotnet build "$RETROBUILD_DIR/RetroBuild.csproj" -c Release 2>&1)
    BUILD_EXIT_CODE=$?
    
    if [ $BUILD_EXIT_CODE -eq 0 ]; then
        echo -e "${GREEN}✓${NC} RetroBuild builds successfully"
        SUCCESS=$((SUCCESS + 1))
        
        # Check if build-macos.ini exists
        if [ -f "$REPO_ROOT/build-macos.ini" ]; then
            echo -e "${GREEN}✓${NC} build-macos.ini exists"
            SUCCESS=$((SUCCESS + 1))
        else
            echo -e "${RED}✗${NC} build-macos.ini not found"
            FAILURES=$((FAILURES + 1))
        fi
    else
        echo -e "${RED}✗${NC} RetroBuild build failed (exit code: $BUILD_EXIT_CODE)"
        FAILURES=$((FAILURES + 1))
    fi
else
    echo -e "${YELLOW}⚠${NC} RetroBuild directory not found (run from repository root)"
    WARNINGS=$((WARNINGS + 1))
fi

echo ""
echo "=========================================="
echo "Verification Summary"
echo "=========================================="
echo -e "${GREEN}✓ Successes: $SUCCESS${NC}"
echo -e "${YELLOW}⚠ Warnings:  $WARNINGS${NC}"
echo -e "${RED}✗ Failures:  $FAILURES${NC}"
echo ""

if [ $FAILURES -eq 0 ]; then
    echo -e "${GREEN}All critical checks passed!${NC}"
    echo ""
    echo "Next steps:"
    echo "1. Copy build-macos.ini to build.ini: cp build-macos.ini build.ini"
    echo "2. Run RetroBuild: dotnet run --project src/RetroBuild/RetroBuild.csproj"
    exit 0
else
    echo -e "${RED}Some checks failed. Please install missing dependencies.${NC}"
    echo ""
    echo "Install all dependencies at once:"
    echo "  brew bundle"
    echo ""
    echo "Or install individually:"
    echo "  brew install p7zip wget sdl2 dotnet-sdk"
    exit 1
fi
