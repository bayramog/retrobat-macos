#!/bin/bash
# RetroBat macOS Code Signing Script
# This script signs all binaries, frameworks, and the app bundle for distribution

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

# Function to print colored output
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

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to display usage
usage() {
    cat << EOF
Usage: $0 [OPTIONS] <app_bundle_path>

Sign a macOS application bundle for distribution.

Arguments:
  <app_bundle_path>    Path to the .app bundle to sign (e.g., RetroBat.app)

Options:
  -i, --identity <identity>    Signing identity (certificate name)
  -e, --entitlements <file>    Path to entitlements.plist file
  -d, --dry-run                Show what would be signed without actually signing
  -v, --verbose                Show detailed output
  -h, --help                   Show this help message

Environment Variables:
  SIGNING_IDENTITY_APP         Default signing identity if not specified with -i
  
Examples:
  # Sign with environment variable
  export SIGNING_IDENTITY_APP="Developer ID Application: Your Name (TEAM_ID)"
  $0 RetroBat.app
  
  # Sign with custom identity and entitlements
  $0 -i "Developer ID Application: Your Name" -e entitlements.plist RetroBat.app
  
  # Dry run to see what would be signed
  $0 --dry-run RetroBat.app

For more information, see: docs/CODESIGNING_MACOS.md
EOF
    exit 1
}

# Parse command line arguments
SIGNING_IDENTITY=""
ENTITLEMENTS_FILE=""
DRY_RUN=false
VERBOSE=false
APP_BUNDLE=""

while [[ $# -gt 0 ]]; do
    case $1 in
        -i|--identity)
            SIGNING_IDENTITY="$2"
            shift 2
            ;;
        -e|--entitlements)
            ENTITLEMENTS_FILE="$2"
            shift 2
            ;;
        -d|--dry-run)
            DRY_RUN=true
            shift
            ;;
        -v|--verbose)
            VERBOSE=true
            shift
            ;;
        -h|--help)
            usage
            ;;
        -*)
            print_error "Unknown option: $1"
            usage
            ;;
        *)
            APP_BUNDLE="$1"
            shift
            ;;
    esac
done

# Validate app bundle path
if [ -z "$APP_BUNDLE" ]; then
    print_error "No app bundle path specified"
    usage
fi

if [ ! -d "$APP_BUNDLE" ]; then
    print_error "App bundle not found: $APP_BUNDLE"
    exit 1
fi

# Resolve to absolute path
APP_BUNDLE="$(cd "$(dirname "$APP_BUNDLE")" && pwd)/$(basename "$APP_BUNDLE")"

# Get signing identity
if [ -z "$SIGNING_IDENTITY" ]; then
    if [ -n "$SIGNING_IDENTITY_APP" ]; then
        SIGNING_IDENTITY="$SIGNING_IDENTITY_APP"
    else
        print_error "No signing identity specified"
        print_info "Set SIGNING_IDENTITY_APP environment variable or use -i option"
        print_info "Run: security find-identity -v -p codesigning"
        exit 1
    fi
fi

# Check if signing identity exists
print_info "Checking for signing identity: $SIGNING_IDENTITY"
if ! security find-identity -v -p codesigning | grep -q "$SIGNING_IDENTITY"; then
    print_error "Signing identity not found in keychain"
    print_info "Available identities:"
    security find-identity -v -p codesigning
    exit 1
fi

print_success "Found signing identity"

# Set default entitlements file if not specified
if [ -z "$ENTITLEMENTS_FILE" ]; then
    DEFAULT_ENTITLEMENTS="$REPO_ROOT/entitlements.plist"
    if [ -f "$DEFAULT_ENTITLEMENTS" ]; then
        ENTITLEMENTS_FILE="$DEFAULT_ENTITLEMENTS"
        print_info "Using default entitlements: $ENTITLEMENTS_FILE"
    else
        print_warning "No entitlements file found (will sign without entitlements)"
    fi
elif [ ! -f "$ENTITLEMENTS_FILE" ]; then
    print_error "Entitlements file not found: $ENTITLEMENTS_FILE"
    exit 1
fi

# Function to sign a file or bundle
sign_item() {
    local item="$1"
    local options="$2"
    
    if [ "$DRY_RUN" = true ]; then
        echo "[DRY RUN] Would sign: $item"
        return 0
    fi
    
    local sign_cmd="codesign --force --sign \"$SIGNING_IDENTITY\" --options runtime --timestamp $options \"$item\""
    
    if [ "$VERBOSE" = true ]; then
        print_info "Signing: $item"
        eval $sign_cmd
    else
        eval $sign_cmd 2>&1 | grep -v "replacing existing signature" || true
    fi
    
    # Verify signature
    if ! codesign --verify --strict "$item" 2>/dev/null; then
        print_error "Failed to verify signature for: $item"
        return 1
    fi
}

# Start signing process
print_info "=========================================="
print_info "RetroBat macOS Code Signing"
print_info "=========================================="
print_info "App Bundle: $APP_BUNDLE"
print_info "Identity: $SIGNING_IDENTITY"
if [ -n "$ENTITLEMENTS_FILE" ]; then
    print_info "Entitlements: $ENTITLEMENTS_FILE"
fi
if [ "$DRY_RUN" = true ]; then
    print_warning "DRY RUN MODE - No actual signing will be performed"
fi
print_info "=========================================="
echo ""

# Step 1: Sign all dynamic libraries (.dylib files)
print_info "Step 1: Signing dynamic libraries (.dylib files)..."
dylib_count=0
while IFS= read -r -d '' dylib; do
    if [ "$VERBOSE" = true ]; then
        print_info "  Signing: $(basename "$dylib")"
    fi
    sign_item "$dylib" ""
    ((dylib_count++))
done < <(find "$APP_BUNDLE" -name "*.dylib" -print0)

if [ $dylib_count -eq 0 ]; then
    print_warning "  No .dylib files found"
else
    print_success "  Signed $dylib_count dynamic libraries"
fi
echo ""

# Step 2: Sign all executable binaries
print_info "Step 2: Signing executable binaries..."
binary_count=0
while IFS= read -r -d '' binary; do
    # Skip .dylib files (already signed) and directories
    if [[ "$binary" == *.dylib ]] || [ -d "$binary" ]; then
        continue
    fi
    
    # Skip if it's the main executable (will be signed with the bundle)
    if [[ "$binary" == "$APP_BUNDLE/Contents/MacOS/"* ]]; then
        continue
    fi
    
    # Check if file is actually executable
    if file "$binary" | grep -q "executable\|shared library"; then
        if [ "$VERBOSE" = true ]; then
            print_info "  Signing: ${binary#$APP_BUNDLE/}"
        fi
        sign_item "$binary" ""
        ((binary_count++))
    fi
done < <(find "$APP_BUNDLE" -type f -perm +111 -print0)

if [ $binary_count -eq 0 ]; then
    print_warning "  No executable binaries found"
else
    print_success "  Signed $binary_count executable binaries"
fi
echo ""

# Step 3: Sign frameworks
print_info "Step 3: Signing frameworks..."
framework_count=0
while IFS= read -r -d '' framework; do
    if [ "$VERBOSE" = true ]; then
        print_info "  Signing: $(basename "$framework")"
    fi
    sign_item "$framework" ""
    ((framework_count++))
done < <(find "$APP_BUNDLE" -name "*.framework" -print0)

if [ $framework_count -eq 0 ]; then
    print_warning "  No frameworks found"
else
    print_success "  Signed $framework_count frameworks"
fi
echo ""

# Step 4: Sign nested app bundles (e.g., RetroArch.app)
print_info "Step 4: Signing nested application bundles..."
nested_app_count=0
while IFS= read -r -d '' nested_app; do
    # Skip the main app bundle itself
    if [ "$nested_app" = "$APP_BUNDLE" ]; then
        continue
    fi
    
    if [ "$VERBOSE" = true ]; then
        print_info "  Signing: $(basename "$nested_app")"
    fi
    
    # Sign nested apps deeply (they are complete bundles)
    if [ "$DRY_RUN" = false ]; then
        codesign --force --deep --sign "$SIGNING_IDENTITY" \
            --options runtime --timestamp "$nested_app"
        
        if ! codesign --verify --deep --strict "$nested_app" 2>/dev/null; then
            print_error "Failed to verify signature for: $nested_app"
            exit 1
        fi
    else
        echo "[DRY RUN] Would sign nested app: $nested_app"
    fi
    
    ((nested_app_count++))
done < <(find "$APP_BUNDLE" -name "*.app" -print0)

if [ $nested_app_count -eq 0 ]; then
    print_warning "  No nested application bundles found"
else
    print_success "  Signed $nested_app_count nested application bundles"
fi
echo ""

# Step 5: Sign the main app bundle
print_info "Step 5: Signing main app bundle..."

if [ "$DRY_RUN" = false ]; then
    if [ -n "$ENTITLEMENTS_FILE" ]; then
        codesign --force --sign "$SIGNING_IDENTITY" \
            --entitlements "$ENTITLEMENTS_FILE" \
            --options runtime --timestamp \
            "$APP_BUNDLE"
    else
        codesign --force --sign "$SIGNING_IDENTITY" \
            --options runtime --timestamp \
            "$APP_BUNDLE"
    fi
    
    print_success "Signed main app bundle"
else
    echo "[DRY RUN] Would sign main app bundle with entitlements"
fi
echo ""

# Step 6: Verify all signatures
print_info "Step 6: Verifying signatures..."

if [ "$DRY_RUN" = false ]; then
    if codesign --verify --deep --strict --verbose=2 "$APP_BUNDLE" 2>&1; then
        print_success "All signatures verified successfully"
    else
        print_error "Signature verification failed"
        exit 1
    fi
    
    # Display signature information
    if [ "$VERBOSE" = true ]; then
        echo ""
        print_info "Signature details:"
        codesign --display --verbose=4 "$APP_BUNDLE"
    fi
else
    echo "[DRY RUN] Would verify all signatures"
fi

echo ""
print_info "=========================================="
print_success "Code signing completed successfully!"
print_info "=========================================="
echo ""
print_info "Summary:"
print_info "  - Dynamic libraries: $dylib_count"
print_info "  - Executable binaries: $binary_count"
print_info "  - Frameworks: $framework_count"
print_info "  - Nested apps: $nested_app_count"
print_info "  - Main bundle: $(basename "$APP_BUNDLE")"
echo ""

if [ "$DRY_RUN" = false ]; then
    print_info "Next steps:"
    print_info "  1. Create DMG: hdiutil create -volname 'RetroBat' -srcfolder '$APP_BUNDLE' -ov -format UDZO RetroBat.dmg"
    print_info "  2. Sign DMG: codesign --force --sign \"$SIGNING_IDENTITY\" --timestamp RetroBat.dmg"
    print_info "  3. Notarize: ./scripts/macos-notarize.sh RetroBat.dmg"
    print_info "  4. Test: spctl --assess --type execute -vv '$APP_BUNDLE'"
    echo ""
    print_info "See docs/CODESIGNING_MACOS.md for detailed instructions"
fi
