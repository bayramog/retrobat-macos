# Code Signing and Notarization for macOS

This guide covers the complete process for signing and notarizing RetroBat for macOS distribution outside the Mac App Store.

## Overview

Apple requires all software distributed outside the Mac App Store to be signed with a Developer ID and notarized by Apple. This ensures users can run your app without security warnings and that it passes Gatekeeper verification.

### What Gets Signed

For RetroBat on macOS, you need to sign:
1. **Individual binaries** - All executable files (.dylib, binaries in emulators)
2. **Frameworks** - Any bundled frameworks (e.g., SDL, boost libraries)
3. **Emulator applications** - RetroArch.app and any other .app bundles
4. **Main app bundle** - The complete RetroBat.app structure
5. **Installer** - The .pkg or .dmg distribution file

### Requirements

#### Apple Developer Account
- **Individual or Organization account** ($99/year)
- Enrollment at: https://developer.apple.com/programs/

#### Certificates Required
- **Developer ID Application** - For signing applications and binaries
- **Developer ID Installer** - For signing .pkg installers (if using)

#### Tools Required
- Xcode Command Line Tools: `xcode-select --install`
- App-specific password for notarization
- Active Apple Developer subscription

## Step 1: Obtain Apple Developer ID

### 1.1 Enroll in Apple Developer Program

1. Visit https://developer.apple.com/programs/
2. Sign in with your Apple ID
3. Complete enrollment process
4. Pay annual fee ($99 USD)
5. Wait for approval (typically 24-48 hours)

### 1.2 Verify Enrollment

```bash
# Check your team ID and account status
xcrun notarytool history --apple-id "your@email.com" --team-id YOUR_TEAM_ID
```

## Step 2: Generate Developer ID Certificates

### 2.1 Create Certificate Signing Request (CSR)

1. Open **Keychain Access** (Applications > Utilities)
2. Menu: **Keychain Access > Certificate Assistant > Request a Certificate from a Certificate Authority**
3. Enter your email address and name
4. Select **"Saved to disk"**
5. Click **Continue** and save the CSR file

### 2.2 Generate Certificates in Developer Portal

1. Visit https://developer.apple.com/account/resources/certificates/list
2. Click the **"+"** button to add a new certificate

#### For Developer ID Application Certificate:
- Select **"Developer ID Application"**
- Upload your CSR file
- Download the certificate (.cer file)
- Double-click to install in Keychain

#### For Developer ID Installer Certificate (if creating .pkg):
- Select **"Developer ID Installer"**
- Upload your CSR file
- Download the certificate (.cer file)
- Double-click to install in Keychain

### 2.3 Verify Certificate Installation

```bash
# List all Developer ID certificates
security find-identity -v -p codesigning

# Should show entries like:
# 1) XXXXXXXX "Developer ID Application: Your Name (TEAM_ID)"
# 2) YYYYYYYY "Developer ID Installer: Your Name (TEAM_ID)"
```

## Step 3: Configure Signing in Build Process

### 3.1 Set Environment Variables

Create a file `~/.retrobat-signing` with your signing configuration:

```bash
# Apple Developer credentials
export APPLE_DEVELOPER_ID="your@email.com"
export APPLE_TEAM_ID="YOUR_TEAM_ID"

# Certificate identities (from security find-identity)
export SIGNING_IDENTITY_APP="Developer ID Application: Your Name (TEAM_ID)"
export SIGNING_IDENTITY_INSTALLER="Developer ID Installer: Your Name (TEAM_ID)"

# App-specific password for notarization
# Generate at: https://appleid.apple.com/account/manage
export APPLE_APP_SPECIFIC_PASSWORD="xxxx-xxxx-xxxx-xxxx"

# Notarization keychain profile (recommended)
export NOTARIZATION_PROFILE="retrobat-notarization"
```

Source this file before building:
```bash
source ~/.retrobat-signing
```

### 3.2 Create Notarization Keychain Profile (Recommended)

This stores your credentials securely in Keychain instead of using environment variables:

```bash
xcrun notarytool store-credentials "retrobat-notarization" \
  --apple-id "your@email.com" \
  --team-id "YOUR_TEAM_ID" \
  --password "xxxx-xxxx-xxxx-xxxx"
```

## Step 4: Sign Binaries and Frameworks

### 4.1 Sign All Binaries First

Sign from the inside out - start with individual binaries, then frameworks, then apps, then the main bundle.

```bash
# Sign all .dylib files
find RetroBat.app -name "*.dylib" -exec codesign --force --sign "$SIGNING_IDENTITY_APP" \
  --options runtime --timestamp {} \;

# Sign all executable binaries
find RetroBat.app -type f -perm +111 -exec codesign --force --sign "$SIGNING_IDENTITY_APP" \
  --options runtime --timestamp {} \;
```

### 4.2 Signing Options Explained

- `--force`: Overwrite existing signatures
- `--sign`: Certificate identity to use
- `--options runtime`: Enable hardened runtime (required for notarization)
- `--timestamp`: Add secure timestamp (required for notarization)
- `--deep`: Sign nested code (use cautiously, prefer signing items individually)
- `--verify`: Verify signature after signing
- `--verbose`: Show detailed output

### 4.3 Sign Frameworks

```bash
# Sign each framework individually
for framework in RetroBat.app/Contents/Frameworks/*.framework; do
  codesign --force --sign "$SIGNING_IDENTITY_APP" \
    --options runtime --timestamp "$framework"
done
```

## Step 5: Sign Nested Applications

### 5.1 Sign Emulator Applications

RetroArch and other emulators that are .app bundles must be signed before signing the main RetroBat.app:

```bash
# Example: Sign RetroArch.app
codesign --force --deep --sign "$SIGNING_IDENTITY_APP" \
  --options runtime --timestamp \
  RetroBat.app/Contents/Resources/RetroArch.app

# Verify the signature
codesign --verify --deep --strict --verbose=2 \
  RetroBat.app/Contents/Resources/RetroArch.app
```

## Step 6: Sign Main App Bundle

### 6.1 Create Entitlements File

Create `entitlements.plist` with required entitlements:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <!-- Allow JIT compilation (for emulators) -->
    <key>com.apple.security.cs.allow-jit</key>
    <true/>
    
    <!-- Allow unsigned executable memory (for dynamic code) -->
    <key>com.apple.security.cs.allow-unsigned-executable-memory</key>
    <true/>
    
    <!-- Disable library validation (for loading plugins) -->
    <key>com.apple.security.cs.disable-library-validation</key>
    <true/>
    
    <!-- Allow DYLD environment variables (if needed) -->
    <key>com.apple.security.cs.allow-dyld-environment-variables</key>
    <true/>
</dict>
</plist>
```

**Note**: These entitlements are necessary for emulators but may trigger additional Apple review. Use only what's needed.

### 6.2 Sign the Main Bundle

```bash
# Sign with entitlements
codesign --force --sign "$SIGNING_IDENTITY_APP" \
  --entitlements entitlements.plist \
  --options runtime --timestamp \
  RetroBat.app

# Verify the signature
codesign --verify --deep --strict --verbose=2 RetroBat.app
```

### 6.3 Verify All Signatures

```bash
# Check all signatures recursively
codesign --verify --deep --strict --verbose=4 RetroBat.app

# Display signature information
codesign --display --verbose=4 RetroBat.app

# Check for any unsigned code
find RetroBat.app -type f -perm +111 | while read file; do
  if ! codesign --verify "$file" 2>/dev/null; then
    echo "Unsigned: $file"
  fi
done
```

## Step 7: Create Distribution Package

### 7.1 Create DMG (Disk Image)

```bash
# Create a DMG for distribution
hdiutil create -volname "RetroBat" -srcfolder RetroBat.app \
  -ov -format UDZO RetroBat-8.0.0-macos.dmg

# Sign the DMG
codesign --force --sign "$SIGNING_IDENTITY_APP" \
  --timestamp RetroBat-8.0.0-macos.dmg

# Verify DMG signature
codesign --verify --verbose RetroBat-8.0.0-macos.dmg
```

### 7.2 Create ZIP Archive (Alternative)

```bash
# Create ZIP for notarization
ditto -c -k --keepParent RetroBat.app RetroBat-8.0.0-macos.zip
```

## Step 8: Submit for Notarization

### 8.1 Using Notarytool (Recommended - Xcode 13+)

```bash
# Submit for notarization using keychain profile
xcrun notarytool submit RetroBat-8.0.0-macos.dmg \
  --keychain-profile "retrobat-notarization" \
  --wait

# Or with credentials directly
xcrun notarytool submit RetroBat-8.0.0-macos.dmg \
  --apple-id "your@email.com" \
  --team-id "YOUR_TEAM_ID" \
  --password "xxxx-xxxx-xxxx-xxxx" \
  --wait
```

### 8.2 Check Notarization Status

```bash
# Get submission ID from previous command, or:
xcrun notarytool history --keychain-profile "retrobat-notarization"

# Check specific submission
xcrun notarytool info SUBMISSION_ID --keychain-profile "retrobat-notarization"

# Get detailed log if it failed
xcrun notarytool log SUBMISSION_ID --keychain-profile "retrobat-notarization"
```

### 8.3 Understanding Notarization Results

- **Accepted**: Your app passed notarization ✅
- **Invalid**: There are issues that need fixing ❌
- **In Progress**: Still being processed ⏳

Common rejection reasons:
- Unsigned binaries or libraries
- Missing hardened runtime
- Invalid entitlements
- Malware detected

## Step 9: Staple Notarization Ticket

After notarization succeeds, staple the ticket to your app/DMG:

```bash
# Staple to DMG
xcrun stapler staple RetroBat-8.0.0-macos.dmg

# Verify stapling
xcrun stapler validate RetroBat-8.0.0-macos.dmg

# Or staple to app bundle (if distributing directly)
xcrun stapler staple RetroBat.app
xcrun stapler validate RetroBat.app
```

**What is stapling?**
Stapling attaches the notarization ticket to your app/DMG, allowing it to be verified offline. This is important for users without internet access.

## Step 10: Test on Clean Mac

### 10.1 Test with Gatekeeper

```bash
# Remove quarantine attribute (simulates download)
xattr -rc RetroBat.app

# Set quarantine attribute (simulates download)
xattr -w com.apple.quarantine "0001;$(date +%s);Safari;0A0A0A0A-0B0B-0C0C-0D0D-0E0E0E0E0E0E" RetroBat.app

# Test if Gatekeeper allows it
spctl --assess --type execute -vv RetroBat.app

# Should output: "accepted" and "source=Notarized Developer ID"
```

### 10.2 Test on Fresh System

1. Copy the DMG to a clean Mac (or VM)
2. Double-click to open
3. Drag to Applications
4. Try to open the app
5. Should open **without** security warnings

### 10.3 Expected Behavior

✅ **Success**:
- App opens immediately
- No security dialogs
- No "unverified developer" warnings

❌ **Failure**:
- "Cannot be opened because it is from an unidentified developer"
- "damaged and can't be opened"
- Security warnings

## Step 11: Automation Scripts

The repository includes helper scripts:

### 11.1 Sign Script

```bash
./scripts/macos-sign.sh RetroBat.app
```

This script:
- Checks for signing identity
- Signs all binaries, frameworks, and nested apps
- Signs the main bundle
- Verifies all signatures

### 11.2 Notarize Script

```bash
./scripts/macos-notarize.sh RetroBat-8.0.0-macos.dmg
```

This script:
- Submits for notarization
- Polls for completion
- Downloads log on failure
- Staples ticket on success
- Verifies stapling

### 11.3 Complete Build and Sign

```bash
# Build RetroBat
dotnet run --project src/RetroBuild/RetroBuild.csproj

# Create app bundle structure (manual or script)
# ... create RetroBat.app ...

# Sign everything
./scripts/macos-sign.sh build/RetroBat.app

# Create DMG
hdiutil create -volname "RetroBat" -srcfolder build/RetroBat.app \
  -ov -format UDZO RetroBat-8.0.0-macos.dmg

# Sign DMG
codesign --force --sign "$SIGNING_IDENTITY_APP" \
  --timestamp RetroBat-8.0.0-macos.dmg

# Notarize
./scripts/macos-notarize.sh RetroBat-8.0.0-macos.dmg

# Test
spctl --assess --type execute -vv RetroBat-8.0.0-macos.dmg
```

## Step 12: CI/CD Integration

### 12.1 GitHub Actions

For automated signing in GitHub Actions:

```yaml
name: Build and Sign macOS

on:
  push:
    tags:
      - 'v*'

jobs:
  build-macos:
    runs-on: macos-latest
    steps:
      - uses: actions/checkout@v3
      
      - name: Setup .NET
        uses: actions/setup-dotnet@v3
        with:
          dotnet-version: '8.0.x'
      
      - name: Import Certificates
        env:
          CERTIFICATE_BASE64: ${{ secrets.MACOS_CERTIFICATE }}
          CERTIFICATE_PASSWORD: ${{ secrets.MACOS_CERT_PASSWORD }}
        run: |
          # Create temporary keychain
          security create-keychain -p "$KEYCHAIN_PASSWORD" build.keychain
          security default-keychain -s build.keychain
          security unlock-keychain -p "$KEYCHAIN_PASSWORD" build.keychain
          
          # Import certificate
          echo "$CERTIFICATE_BASE64" | base64 --decode > certificate.p12
          security import certificate.p12 -k build.keychain -P "$CERTIFICATE_PASSWORD" -T /usr/bin/codesign
          security set-key-partition-list -S apple-tool:,apple:,codesign: -s -k "$KEYCHAIN_PASSWORD" build.keychain
          
          rm certificate.p12
      
      - name: Build RetroBat
        run: |
          dotnet build src/RetroBuild/RetroBuild.csproj -c Release
          dotnet run --project src/RetroBuild/RetroBuild.csproj
      
      - name: Sign Application
        env:
          SIGNING_IDENTITY: ${{ secrets.SIGNING_IDENTITY }}
        run: |
          ./scripts/macos-sign.sh build/RetroBat.app
      
      - name: Create DMG
        run: |
          hdiutil create -volname "RetroBat" -srcfolder build/RetroBat.app \
            -ov -format UDZO RetroBat-macos.dmg
          codesign --force --sign "$SIGNING_IDENTITY" --timestamp RetroBat-macos.dmg
      
      - name: Notarize
        env:
          APPLE_ID: ${{ secrets.APPLE_ID }}
          APPLE_TEAM_ID: ${{ secrets.APPLE_TEAM_ID }}
          APPLE_APP_PASSWORD: ${{ secrets.APPLE_APP_PASSWORD }}
        run: |
          ./scripts/macos-notarize.sh RetroBat-macos.dmg
      
      - name: Upload Release Asset
        uses: actions/upload-artifact@v3
        with:
          name: RetroBat-macOS
          path: RetroBat-macos.dmg
```

### 12.2 Required GitHub Secrets

Set these in repository settings > Secrets:

- `MACOS_CERTIFICATE` - Base64-encoded .p12 certificate
- `MACOS_CERT_PASSWORD` - Certificate password
- `SIGNING_IDENTITY` - Full certificate name
- `APPLE_ID` - Apple Developer email
- `APPLE_TEAM_ID` - Team ID
- `APPLE_APP_PASSWORD` - App-specific password

### 12.3 Export Certificate for CI

```bash
# Export from Keychain
security find-identity -v -p codesigning

# Export certificate with private key
security export -k login.keychain -t identities -f pkcs12 \
  -o certificate.p12 -P "YourPassword"

# Convert to base64 for GitHub Secrets
base64 -i certificate.p12 -o certificate.base64.txt

# Copy contents of certificate.base64.txt to MACOS_CERTIFICATE secret
```

## Troubleshooting

### Issue: "No identity found"

**Solution**:
```bash
# Verify certificate installation
security find-identity -v -p codesigning

# If not found, re-download from developer.apple.com and double-click to install
```

### Issue: "errSecInternalComponent"

**Solution**:
```bash
# Unlock keychain
security unlock-keychain ~/Library/Keychains/login.keychain-db

# Or set partition list
security set-key-partition-list -S apple-tool:,apple: -s -k PASSWORD login.keychain-db
```

### Issue: Notarization fails with "Invalid signature"

**Solution**:
- Ensure all binaries are signed
- Use `--options runtime` on all signatures
- Add `--timestamp` to all signatures
- Sign from inside out (binaries → frameworks → apps → bundle)

### Issue: App says "damaged and can't be opened"

**Solution**:
```bash
# Remove quarantine attribute
xattr -rc /Applications/RetroBat.app

# Or user can run:
xattr -d com.apple.quarantine /Applications/RetroBat.app
```

### Issue: "The executable requests the com.apple.security.cs.allow-jit entitlement"

**Solution**:
- JIT is required for emulators but may trigger review
- Ensure entitlement is in entitlements.plist
- Consider alternatives if possible (AOT compilation)

### Issue: Notarization takes too long

**Solution**:
- Use `--wait` flag to wait for completion
- Typical time: 2-10 minutes
- Check status with `notarytool history`
- Large apps (>1GB) may take 30+ minutes

## Best Practices

1. **Test early and often**: Don't wait until release to try signing
2. **Automate**: Use scripts to ensure consistency
3. **Keep certificates secure**: Never commit to git
4. **Monitor expiration**: Certificates expire after 5 years
5. **Use keychain profiles**: Safer than environment variables
6. **Staple immediately**: Don't forget this step
7. **Test on clean systems**: VMs or clean partitions
8. **Document your process**: Keep notes on your specific setup
9. **Keep Xcode updated**: Apple updates signing requirements
10. **Archive signed builds**: Keep copies of notarized releases

## Resources

### Official Apple Documentation
- [Notarizing macOS Software](https://developer.apple.com/documentation/security/notarizing_macos_software_before_distribution)
- [Code Signing Guide](https://developer.apple.com/library/archive/documentation/Security/Conceptual/CodeSigningGuide/)
- [Hardened Runtime](https://developer.apple.com/documentation/security/hardened_runtime)
- [Entitlements](https://developer.apple.com/documentation/bundleresources/entitlements)

### Apple Developer Portal
- [Certificates Portal](https://developer.apple.com/account/resources/certificates/list)
- [App-Specific Passwords](https://appleid.apple.com/account/manage)
- [Program Enrollment](https://developer.apple.com/programs/)

### Command Line Tools
- `man codesign` - Code signing documentation
- `man spctl` - Gatekeeper assessment
- `man notarytool` - Notarization tool
- `man stapler` - Stapling tool

### Community Resources
- [Signing Scripts Examples](https://github.com/topics/macos-codesigning)
- [Stack Overflow: macOS Code Signing](https://stackoverflow.com/questions/tagged/code-signing+macos)

## Summary

Code signing and notarization are essential for distributing RetroBat on macOS. The process involves:

1. ✅ Obtaining Apple Developer ID and certificates
2. ✅ Signing all binaries, frameworks, and nested applications
3. ✅ Signing the main application bundle with entitlements
4. ✅ Creating a signed DMG or ZIP distribution
5. ✅ Submitting for notarization with Apple
6. ✅ Stapling the notarization ticket
7. ✅ Testing with Gatekeeper on a clean Mac
8. ✅ Automating the process for CI/CD

Following this guide ensures RetroBat launches without security warnings and provides users with a smooth installation experience.
