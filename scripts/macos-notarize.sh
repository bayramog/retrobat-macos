#!/bin/bash
# RetroBat macOS Notarization Script
# This script submits an app/dmg for Apple notarization and staples the ticket

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
Usage: $0 [OPTIONS] <file_path>

Submit a macOS application or DMG for Apple notarization.

Arguments:
  <file_path>    Path to .app bundle, .dmg, .pkg, or .zip to notarize

Options:
  -p, --profile <name>         Keychain profile name (recommended)
  -a, --apple-id <email>       Apple ID email
  -t, --team-id <id>           Apple Developer Team ID
  -w, --password <password>    App-specific password
  -s, --skip-staple            Skip stapling notarization ticket
  -v, --verbose                Show detailed output
  -h, --help                   Show this help message

Authentication Methods (in order of preference):
  1. Keychain Profile (--profile or NOTARIZATION_PROFILE env var)
     Create with: xcrun notarytool store-credentials <profile_name>
  
  2. Environment Variables:
     - NOTARIZATION_PROFILE
     - APPLE_DEVELOPER_ID (Apple ID email)
     - APPLE_TEAM_ID (Team ID)
     - APPLE_APP_SPECIFIC_PASSWORD (App-specific password)
  
  3. Command line options (--apple-id, --team-id, --password)

Examples:
  # Using keychain profile (recommended)
  $0 --profile retrobat-notarization RetroBat.dmg
  
  # Using environment variables
  export NOTARIZATION_PROFILE="retrobat-notarization"
  $0 RetroBat.dmg
  
  # Using command line options
  $0 --apple-id you@email.com --team-id TEAM123 --password xxxx-xxxx-xxxx-xxxx RetroBat.dmg
  
  # Skip stapling (for ZIP files)
  $0 --profile retrobat-notarization --skip-staple RetroBat.zip

For more information, see: docs/CODESIGNING_MACOS.md
EOF
    exit 1
}

# Parse command line arguments
KEYCHAIN_PROFILE=""
APPLE_ID=""
TEAM_ID=""
APP_PASSWORD=""
SKIP_STAPLE=false
VERBOSE=false
FILE_PATH=""

while [[ $# -gt 0 ]]; do
    case $1 in
        -p|--profile)
            KEYCHAIN_PROFILE="$2"
            shift 2
            ;;
        -a|--apple-id)
            APPLE_ID="$2"
            shift 2
            ;;
        -t|--team-id)
            TEAM_ID="$2"
            shift 2
            ;;
        -w|--password)
            APP_PASSWORD="$2"
            shift 2
            ;;
        -s|--skip-staple)
            SKIP_STAPLE=true
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
            FILE_PATH="$1"
            shift
            ;;
    esac
done

# Validate file path
if [ -z "$FILE_PATH" ]; then
    print_error "No file path specified"
    usage
fi

if [ ! -e "$FILE_PATH" ]; then
    print_error "File not found: $FILE_PATH"
    exit 1
fi

# Resolve to absolute path
if [ -d "$FILE_PATH" ]; then
    FILE_PATH="$(cd "$FILE_PATH" && pwd)"
else
    FILE_PATH="$(cd "$(dirname "$FILE_PATH")" && pwd)/$(basename "$FILE_PATH")"
fi

# Check for notarytool
if ! command_exists xcrun; then
    print_error "xcrun not found. Install Xcode Command Line Tools."
    exit 1
fi

# Determine authentication method
USE_KEYCHAIN_PROFILE=false

if [ -n "$KEYCHAIN_PROFILE" ]; then
    USE_KEYCHAIN_PROFILE=true
elif [ -n "$NOTARIZATION_PROFILE" ]; then
    KEYCHAIN_PROFILE="$NOTARIZATION_PROFILE"
    USE_KEYCHAIN_PROFILE=true
elif [ -z "$APPLE_ID" ] || [ -z "$TEAM_ID" ] || [ -z "$APP_PASSWORD" ]; then
    # Try environment variables
    if [ -n "$APPLE_DEVELOPER_ID" ] && [ -n "$APPLE_TEAM_ID" ] && [ -n "$APPLE_APP_SPECIFIC_PASSWORD" ]; then
        APPLE_ID="$APPLE_DEVELOPER_ID"
        TEAM_ID="$APPLE_TEAM_ID"
        APP_PASSWORD="$APPLE_APP_SPECIFIC_PASSWORD"
    else
        print_error "Incomplete authentication credentials"
        print_info "Provide either:"
        print_info "  - Keychain profile (--profile or NOTARIZATION_PROFILE)"
        print_info "  - Apple ID, Team ID, and App Password (--apple-id, --team-id, --password)"
        print_info "  - Environment variables (APPLE_DEVELOPER_ID, APPLE_TEAM_ID, APPLE_APP_SPECIFIC_PASSWORD)"
        exit 1
    fi
fi

# Start notarization process
print_info "=========================================="
print_info "RetroBat macOS Notarization"
print_info "=========================================="
print_info "File: $(basename "$FILE_PATH")"
if [ "$USE_KEYCHAIN_PROFILE" = true ]; then
    print_info "Authentication: Keychain Profile ($KEYCHAIN_PROFILE)"
else
    print_info "Authentication: Apple ID ($APPLE_ID)"
fi
print_info "=========================================="
echo ""

# Step 1: Verify the file is signed
print_info "Step 1: Verifying code signature..."
if codesign --verify --verbose "$FILE_PATH" 2>&1; then
    print_success "File is properly signed"
else
    print_error "File is not signed or signature is invalid"
    print_info "Sign the file first with: ./scripts/macos-sign.sh"
    exit 1
fi
echo ""

# Step 2: Submit for notarization
print_info "Step 2: Submitting for notarization..."
print_info "This may take several minutes..."

SUBMISSION_OUTPUT=""
if [ "$USE_KEYCHAIN_PROFILE" = true ]; then
    print_info "Using keychain profile: $KEYCHAIN_PROFILE"
    SUBMISSION_OUTPUT=$(xcrun notarytool submit "$FILE_PATH" \
        --keychain-profile "$KEYCHAIN_PROFILE" \
        --wait 2>&1)
else
    print_info "Using Apple ID: $APPLE_ID"
    SUBMISSION_OUTPUT=$(xcrun notarytool submit "$FILE_PATH" \
        --apple-id "$APPLE_ID" \
        --team-id "$TEAM_ID" \
        --password "$APP_PASSWORD" \
        --wait 2>&1)
fi

echo "$SUBMISSION_OUTPUT"

# Extract submission ID
SUBMISSION_ID=$(echo "$SUBMISSION_OUTPUT" | grep -o "id: [a-zA-Z0-9-]*" | head -1 | cut -d' ' -f2)

if [ -z "$SUBMISSION_ID" ]; then
    print_error "Failed to get submission ID"
    print_info "Output was:"
    echo "$SUBMISSION_OUTPUT"
    exit 1
fi

print_info "Submission ID: $SUBMISSION_ID"
echo ""

# Step 3: Check result
print_info "Step 3: Checking notarization result..."

if echo "$SUBMISSION_OUTPUT" | grep -q "status: Accepted"; then
    print_success "Notarization succeeded! ✅"
    NOTARIZATION_SUCCESS=true
elif echo "$SUBMISSION_OUTPUT" | grep -q "status: Invalid"; then
    print_error "Notarization failed! ❌"
    NOTARIZATION_SUCCESS=false
elif echo "$SUBMISSION_OUTPUT" | grep -q "status: In Progress"; then
    print_warning "Notarization still in progress..."
    print_info "Check status with: xcrun notarytool info $SUBMISSION_ID"
    exit 0
else
    print_warning "Unable to determine notarization status"
    NOTARIZATION_SUCCESS=false
fi

# If failed, get the log
if [ "$NOTARIZATION_SUCCESS" = false ]; then
    echo ""
    print_error "Notarization was rejected by Apple"
    print_info "Fetching detailed log..."
    
    LOG_FILE="/tmp/notarization-log-${SUBMISSION_ID}.json"
    
    if [ "$USE_KEYCHAIN_PROFILE" = true ]; then
        xcrun notarytool log "$SUBMISSION_ID" \
            --keychain-profile "$KEYCHAIN_PROFILE" \
            "$LOG_FILE" 2>&1 || true
    else
        xcrun notarytool log "$SUBMISSION_ID" \
            --apple-id "$APPLE_ID" \
            --team-id "$TEAM_ID" \
            --password "$APP_PASSWORD" \
            "$LOG_FILE" 2>&1 || true
    fi
    
    if [ -f "$LOG_FILE" ]; then
        print_info "Log saved to: $LOG_FILE"
        echo ""
        print_info "Log contents:"
        cat "$LOG_FILE"
        echo ""
        
        # Try to extract common issues
        if grep -q "unsigned" "$LOG_FILE"; then
            print_error "Issue: Unsigned binaries detected"
            print_info "Fix: Sign all binaries with ./scripts/macos-sign.sh"
        fi
        
        if grep -q "hardened runtime" "$LOG_FILE"; then
            print_error "Issue: Hardened runtime missing"
            print_info "Fix: Use --options runtime when signing"
        fi
        
        if grep -q "timestamp" "$LOG_FILE"; then
            print_error "Issue: Secure timestamp missing"
            print_info "Fix: Use --timestamp when signing"
        fi
    fi
    
    exit 1
fi

echo ""

# Step 4: Staple the notarization ticket
if [ "$SKIP_STAPLE" = true ]; then
    print_warning "Skipping stapling (--skip-staple specified)"
    print_info "Note: Without stapling, users will need internet to verify notarization"
else
    print_info "Step 4: Stapling notarization ticket..."
    
    # Check if file can be stapled (DMG, app, pkg)
    FILE_EXT="${FILE_PATH##*.}"
    if [[ "$FILE_EXT" != "dmg" && "$FILE_EXT" != "app" && "$FILE_EXT" != "pkg" ]]; then
        print_warning "File type .$FILE_EXT cannot be stapled"
        print_info "Stapling is only supported for .app, .dmg, and .pkg files"
    else
        if xcrun stapler staple "$FILE_PATH" 2>&1; then
            print_success "Notarization ticket stapled successfully"
            
            # Verify stapling
            if xcrun stapler validate "$FILE_PATH" 2>&1; then
                print_success "Stapled ticket verified"
            else
                print_warning "Could not verify stapled ticket"
            fi
        else
            print_error "Failed to staple notarization ticket"
            print_info "The file is notarized but requires internet for verification"
        fi
    fi
fi

echo ""
print_info "=========================================="
print_success "Notarization process completed!"
print_info "=========================================="
echo ""

# Final verification
print_info "Final verification:"
if [ -d "$FILE_PATH" ] && [[ "$FILE_PATH" == *.app ]]; then
    # App bundle
    print_info "Running Gatekeeper assessment..."
    if spctl --assess --type execute -vv "$FILE_PATH" 2>&1; then
        print_success "Gatekeeper: PASSED ✅"
    else
        print_warning "Gatekeeper assessment returned warnings (may be normal)"
    fi
elif [ -f "$FILE_PATH" ] && [[ "$FILE_PATH" == *.dmg ]]; then
    # DMG file
    print_info "DMG notarization complete"
    print_success "Users can now download and install without security warnings"
elif [ -f "$FILE_PATH" ] && [[ "$FILE_PATH" == *.pkg ]]; then
    # PKG file
    print_info "PKG notarization complete"
    print_success "Users can now install without security warnings"
fi

echo ""
print_info "Next steps:"
print_info "  1. Test on a clean Mac (or with quarantine): xattr -w com.apple.quarantine ... '$FILE_PATH'"
print_info "  2. Distribute to users via download"
print_info "  3. Users should see no security warnings when opening"
echo ""
print_info "Notarization details:"
print_info "  Submission ID: $SUBMISSION_ID"
if [ "$USE_KEYCHAIN_PROFILE" = true ]; then
    print_info "  View history: xcrun notarytool history --keychain-profile $KEYCHAIN_PROFILE"
    print_info "  View info: xcrun notarytool info $SUBMISSION_ID --keychain-profile $KEYCHAIN_PROFILE"
else
    print_info "  View history: xcrun notarytool history --apple-id $APPLE_ID --team-id $TEAM_ID"
    print_info "  View info: xcrun notarytool info $SUBMISSION_ID --apple-id $APPLE_ID --team-id $TEAM_ID"
fi
echo ""
print_success "All done! 🎉"
