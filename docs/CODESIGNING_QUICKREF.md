# Code Signing Quick Reference

Quick reference guide for signing and notarizing RetroBat on macOS.

## Prerequisites Checklist

- [ ] Apple Developer account ($99/year)
- [ ] Developer ID Application certificate installed
- [ ] Developer ID Installer certificate installed (for .pkg)
- [ ] App-specific password generated
- [ ] Notarization keychain profile created

## Quick Setup

### 1. Create Keychain Profile (One-time)

```bash
xcrun notarytool store-credentials "retrobat-notarization" \
  --apple-id "your@email.com" \
  --team-id "YOUR_TEAM_ID" \
  --password "xxxx-xxxx-xxxx-xxxx"
```

### 2. Set Environment Variables

Add to `~/.zshrc` or `~/.bash_profile`:

```bash
export SIGNING_IDENTITY_APP="Developer ID Application: Your Name (TEAM_ID)"
export NOTARIZATION_PROFILE="retrobat-notarization"
```

## Complete Build and Sign Workflow

```bash
# 1. Build RetroBat
cp build-macos.ini build.ini
dotnet run --project src/RetroBuild/RetroBuild.csproj

# 2. Create app bundle structure (manual for now)
# TODO: Create RetroBat.app with proper bundle structure

# 3. Sign the app
./scripts/macos-sign.sh build/RetroBat.app

# 4. Create DMG
hdiutil create -volname "RetroBat" -srcfolder build/RetroBat.app \
  -ov -format UDZO RetroBat-8.0.0-macos.dmg

# 5. Sign DMG
codesign --force --sign "$SIGNING_IDENTITY_APP" \
  --timestamp RetroBat-8.0.0-macos.dmg

# 6. Notarize
./scripts/macos-notarize.sh RetroBat-8.0.0-macos.dmg

# 7. Verify
spctl --assess --type execute -vv RetroBat-8.0.0-macos.dmg
```

## Common Commands

### Check Signing Identity
```bash
security find-identity -v -p codesigning
```

### Verify Signature
```bash
codesign --verify --deep --strict --verbose=2 RetroBat.app
```

### Check Gatekeeper
```bash
spctl --assess --type execute -vv RetroBat.app
```

### View Notarization History
```bash
xcrun notarytool history --keychain-profile retrobat-notarization
```

### Get Notarization Log
```bash
xcrun notarytool log SUBMISSION_ID --keychain-profile retrobat-notarization
```

## Script Options

### macos-sign.sh

```bash
# Basic usage
./scripts/macos-sign.sh RetroBat.app

# With custom identity
./scripts/macos-sign.sh -i "Developer ID Application: Name" RetroBat.app

# Dry run
./scripts/macos-sign.sh --dry-run RetroBat.app

# Verbose output
./scripts/macos-sign.sh --verbose RetroBat.app

# Custom entitlements
./scripts/macos-sign.sh -e custom-entitlements.plist RetroBat.app
```

### macos-notarize.sh

```bash
# With keychain profile
./scripts/macos-notarize.sh --profile retrobat-notarization RetroBat.dmg

# With environment variable
export NOTARIZATION_PROFILE="retrobat-notarization"
./scripts/macos-notarize.sh RetroBat.dmg

# With credentials
./scripts/macos-notarize.sh \
  --apple-id "your@email.com" \
  --team-id "TEAM_ID" \
  --password "xxxx-xxxx-xxxx-xxxx" \
  RetroBat.dmg

# Skip stapling (for ZIP files)
./scripts/macos-notarize.sh --skip-staple RetroBat.zip

# Verbose output
./scripts/macos-notarize.sh --verbose RetroBat.dmg
```

## Troubleshooting

### "No identity found"
```bash
# Re-download certificate from developer.apple.com
# Double-click to install in Keychain
security find-identity -v -p codesigning
```

### "errSecInternalComponent"
```bash
security unlock-keychain ~/Library/Keychains/login.keychain-db
```

### "App is damaged"
```bash
# Remove quarantine attribute
xattr -rc /Applications/RetroBat.app
```

### Notarization fails
```bash
# Get detailed log
xcrun notarytool log SUBMISSION_ID --keychain-profile retrobat-notarization

# Common issues:
# - Unsigned binaries: Sign all with scripts/macos-sign.sh
# - Missing hardened runtime: Use --options runtime
# - Missing timestamp: Use --timestamp
```

## Resources

- **Full Documentation**: [docs/CODESIGNING_MACOS.md](docs/CODESIGNING_MACOS.md)
- **Apple Developer**: https://developer.apple.com/account
- **Notarization Docs**: https://developer.apple.com/documentation/security/notarizing_macos_software_before_distribution
- **Code Signing Guide**: https://developer.apple.com/library/archive/documentation/Security/Conceptual/CodeSigningGuide/

## Notes

- Certificates expire after 5 years - renew before expiration
- App-specific passwords can be revoked and regenerated at appleid.apple.com
- Keychain profiles are stored securely in macOS Keychain
- Always test on a clean Mac before distributing
- Notarization typically takes 2-10 minutes
- Keep signed builds archived for reference
