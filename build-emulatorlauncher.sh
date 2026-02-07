#!/bin/bash
# Build script for EmulatorLauncher.Core on macOS

set -e

echo "====================================="
echo "EmulatorLauncher.Core Build Script"
echo "====================================="
echo ""

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check for .NET SDK
if ! command -v dotnet &> /dev/null; then
    echo -e "${RED}ERROR: .NET SDK not found${NC}"
    echo "Please install .NET 8 SDK:"
    echo "  https://dotnet.microsoft.com/download"
    exit 1
fi

echo -e "${GREEN}✓${NC} .NET SDK found: $(dotnet --version)"
echo ""

# Navigate to project directory
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PROJECT_DIR="$SCRIPT_DIR/src/EmulatorLauncher.Core"

if [ ! -d "$PROJECT_DIR" ]; then
    echo -e "${RED}ERROR: Project directory not found: $PROJECT_DIR${NC}"
    exit 1
fi

cd "$PROJECT_DIR"

# Parse command line arguments
BUILD_CONFIG="Debug"
RUNTIME=""
PUBLISH=false

while [[ $# -gt 0 ]]; do
    case $1 in
        -c|--configuration)
            BUILD_CONFIG="$2"
            shift 2
            ;;
        -r|--runtime)
            RUNTIME="$2"
            shift 2
            ;;
        -p|--publish)
            PUBLISH=true
            shift
            ;;
        -h|--help)
            echo "Usage: $0 [options]"
            echo ""
            echo "Options:"
            echo "  -c, --configuration <Debug|Release>  Build configuration (default: Debug)"
            echo "  -r, --runtime <rid>                  Runtime identifier (e.g., osx-arm64)"
            echo "  -p, --publish                        Publish single-file executable"
            echo "  -h, --help                           Show this help message"
            echo ""
            echo "Examples:"
            echo "  $0                                   # Debug build"
            echo "  $0 -c Release                        # Release build"
            echo "  $0 -c Release -r osx-arm64 -p        # Publish for macOS ARM64"
            exit 0
            ;;
        *)
            echo -e "${RED}Unknown option: $1${NC}"
            echo "Use --help for usage information"
            exit 1
            ;;
    esac
done

# Build or publish
if [ "$PUBLISH" = true ]; then
    if [ -z "$RUNTIME" ]; then
        RUNTIME="osx-arm64"
        echo -e "${YELLOW}No runtime specified, using default: $RUNTIME${NC}"
        echo ""
    fi
    
    echo "Publishing EmulatorLauncher.Core..."
    echo "  Configuration: $BUILD_CONFIG"
    echo "  Runtime: $RUNTIME"
    echo ""
    
    dotnet publish \
        -c "$BUILD_CONFIG" \
        -r "$RUNTIME" \
        --self-contained false \
        -p:PublishSingleFile=true \
        -p:IncludeNativeLibrariesForSelfExtract=true
    
    if [ $? -eq 0 ]; then
        echo ""
        echo -e "${GREEN}✓ Publish succeeded${NC}"
        OUTPUT_DIR="$PROJECT_DIR/bin/$BUILD_CONFIG/net8.0/$RUNTIME/publish"
        echo ""
        echo "Output: $OUTPUT_DIR"
        echo ""
        ls -lh "$OUTPUT_DIR/emulatorLauncher"
    else
        echo -e "${RED}✗ Publish failed${NC}"
        exit 1
    fi
else
    echo "Building EmulatorLauncher.Core..."
    echo "  Configuration: $BUILD_CONFIG"
    if [ -n "$RUNTIME" ]; then
        echo "  Runtime: $RUNTIME"
    fi
    echo ""
    
    if [ -n "$RUNTIME" ]; then
        dotnet build -c "$BUILD_CONFIG" -r "$RUNTIME"
    else
        dotnet build -c "$BUILD_CONFIG"
    fi
    
    if [ $? -eq 0 ]; then
        echo ""
        echo -e "${GREEN}✓ Build succeeded${NC}"
        OUTPUT_DIR="$PROJECT_DIR/bin/$BUILD_CONFIG/net8.0"
        if [ -n "$RUNTIME" ]; then
            OUTPUT_DIR="$OUTPUT_DIR/$RUNTIME"
        fi
        echo ""
        echo "Output: $OUTPUT_DIR"
    else
        echo -e "${RED}✗ Build failed${NC}"
        exit 1
    fi
fi

echo ""
echo "====================================="
echo "Build Complete!"
echo "====================================="
