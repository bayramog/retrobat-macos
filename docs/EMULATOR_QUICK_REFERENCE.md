# macOS Emulator Quick Reference

Quick reference guide for the most commonly used emulators on macOS.

## Installation Quick Start

```bash
# Install core emulators automatically
./scripts/download-macos-emulators.sh --core

# Or install all emulators
./scripts/download-macos-emulators.sh --all
```

## Top 10 Essential Emulators

### 1. RetroArch (Multi-System)
- **Download**: https://www.retroarch.com/
- **Systems**: NES, SNES, Genesis, PS1, N64, GBA, and 50+ more
- **Path**: `/Applications/RetroArch.app`
- **BIOS**: `~/Library/Application Support/RetroArch/system/`
- **Notes**: Primary multi-system frontend, install cores through UI

### 2. Dolphin (GameCube/Wii)
- **Download**: https://dolphin-emu.org/
- **Systems**: GameCube, Wii
- **Path**: `/Applications/Dolphin.app`
- **BIOS**: Not required (optional DSP ROM)
- **Notes**: Native Metal support, excellent performance

### 3. PCSX2 (PlayStation 2)
- **Download**: https://pcsx2.net/
- **Systems**: PlayStation 2
- **Path**: `/Applications/PCSX2.app`
- **BIOS**: Required (PS2 BIOS in settings)
- **Notes**: Use nightly builds for best Apple Silicon support

### 4. PPSSPP (PSP)
- **Download**: https://www.ppsspp.org/
- **Systems**: PlayStation Portable
- **Path**: `/Applications/PPSSPP.app`
- **BIOS**: Not required
- **Notes**: Excellent upscaling, texture pack support

### 5. DuckStation (PS1)
- **Download**: https://github.com/stenzek/duckstation
- **Systems**: PlayStation 1
- **Path**: `/Applications/DuckStation.app`
- **BIOS**: Required (PS1 BIOS in settings)
- **Notes**: Best PS1 emulator for macOS

### 6. Ryujinx (Switch)
- **Download**: https://ryujinx.org/
- **Systems**: Nintendo Switch
- **Path**: `/Applications/Ryujinx.app`
- **BIOS**: Required (Switch firmware + keys)
- **Notes**: Best Switch emulator for macOS, native ARM64

### 7. Lime3DS (3DS)
- **Download**: https://github.com/Lime3DS/Lime3DS
- **Systems**: Nintendo 3DS
- **Path**: `/Applications/Lime3DS.app`
- **BIOS**: Required (3DS system files)
- **Notes**: Citra fork, better macOS support

### 8. melonDS (Nintendo DS)
- **Download**: https://melonds.kuribo64.net/
- **Systems**: Nintendo DS
- **Path**: `/Applications/melonDS.app`
- **BIOS**: Required (DS BIOS files)
- **Notes**: Most accurate DS emulator

### 9. mGBA (Game Boy Advance)
- **Download**: https://mgba.io/
- **Systems**: GBA, Game Boy, Game Boy Color
- **Path**: `/Applications/mGBA.app`
- **BIOS**: Optional (works without)
- **Notes**: Fast and accurate

### 10. MAME (Arcade)
- **Download**: https://www.mamedev.org/
- **Systems**: Arcade machines
- **Path**: `/Applications/MAME.app`
- **BIOS**: Varies by game
- **Notes**: Native ARM64 build available

## Quick Command Reference

### Launch Emulators
```bash
# RetroArch
open /Applications/RetroArch.app

# Dolphin
open /Applications/Dolphin.app

# PCSX2
open /Applications/PCSX2.app

# With a specific ROM
open -a RetroArch ~/ROMs/game.sfc
```

### Remove Quarantine (if blocked)
```bash
# Remove quarantine from specific app
xattr -cr /Applications/RetroArch.app

# Remove quarantine from all emulators
find /Applications -name "*.app" -maxdepth 1 -exec xattr -cr {} \;
```

### Check Architecture
```bash
# Check if emulator is ARM64 native
file /Applications/RetroArch.app/Contents/MacOS/RetroArch

# Expected output: "Mach-O 64-bit executable arm64"
```

### Install via Homebrew
```bash
# Install emulators via Homebrew
brew install --cask retroarch
brew install --cask dolphin
brew install --cask ppsspp

# Install command-line emulators
brew install mame
brew install dosbox-x
```

## BIOS Files Location

### RetroArch
```
~/Library/Application Support/RetroArch/system/
```

Common BIOS files:
- PS1: `scph5500.bin`, `scph5501.bin`, `scph5502.bin`
- PS2: `ps2-0200a-20040614.bin` (and others)
- GBA: `gba_bios.bin`
- DS: `bios7.bin`, `bios9.bin`, `firmware.bin`

### PCSX2
```
~/Library/Application Support/PCSX2/bios/
```

### DuckStation
```
~/Library/Application Support/DuckStation/bios/
```

### melonDS
```
~/Library/Application Support/melonDS/bios/
```

### Ryujinx
```
~/Library/Application Support/Ryujinx/system/
```
Requires: `prod.keys`, firmware files

## Common Issues and Solutions

### Issue: "App cannot be opened because the developer cannot be verified"
**Solution**:
```bash
xattr -cr /Applications/[App].app
```
Or: System Settings > Privacy & Security > Allow app

### Issue: Emulator runs slowly on Apple Silicon
**Solution**:
- Check if using Rosetta (Intel) version
- Download ARM64-native version
- Enable Metal renderer if available
- Close background applications

### Issue: Controller not detected
**Solution**:
- Check System Settings > Privacy & Security > Input Monitoring
- Grant permission to emulator
- Use native controller support (not third-party drivers)

### Issue: Save states not working
**Solution**:
```bash
# Give Full Disk Access
# System Settings > Privacy & Security > Full Disk Access
# Add emulator to the list
```

### Issue: Audio crackling
**Solution**:
- Increase audio buffer size in emulator settings
- Check audio sample rate matches system (usually 48000 Hz)
- Close other audio applications

## Controller Setup

### Recommended Controllers
- **PlayStation DualSense** - Excellent native support
- **PlayStation DualShock 4** - Great support
- **Xbox Series X/S Controller** - Good support
- **Nintendo Switch Pro Controller** - Good support

### Bluetooth Pairing
1. Hold pair button on controller
2. Open System Settings > Bluetooth
3. Select controller from list
4. Configure in emulator settings

### USB Connection
- Most controllers work plug-and-play via USB
- Better input latency than Bluetooth
- No battery concerns

## Performance Tips

### Optimize for Apple Silicon
1. Use Metal renderer when available
2. Enable threaded rendering
3. Disable unnecessary enhancements
4. Use native resolution for older systems
5. Enable frame skipping if needed

### macOS-Specific Settings
- **Allow in Background**: System Settings > General > Login Items
- **Prevent Sleep**: Use `caffeinate` command or third-party app
- **High Performance Mode**: For MacBook Pro models

### Monitor Performance
```bash
# Watch CPU usage
top -pid $(pgrep RetroArch)

# Monitor temperature
sudo powermetrics --samplers smc
```

## Updating Emulators

### Manual Updates
1. Download latest version from official website
2. Replace app in `/Applications`
3. Settings are usually preserved

### Homebrew Updates
```bash
# Update all casks
brew upgrade --cask

# Update specific emulator
brew upgrade --cask retroarch
```

### RetroArch Core Updates
1. Open RetroArch
2. Online Updater > Update Cores
3. Select cores to update

## Backup Configuration

### Important Directories to Backup
```bash
# RetroArch
~/Library/Application Support/RetroArch/

# Save states and saves
~/Library/Application Support/RetroArch/states/
~/Library/Application Support/RetroArch/saves/

# Other emulators
~/Library/Application Support/[Emulator]/
```

### Quick Backup Script
```bash
#!/bin/bash
# backup-emulator-configs.sh
BACKUP_DIR="$HOME/Documents/Emulator-Backups/$(date +%Y%m%d)"
mkdir -p "$BACKUP_DIR"

# Backup RetroArch
cp -R "$HOME/Library/Application Support/RetroArch" "$BACKUP_DIR/"

# Backup other emulators
for emu in PCSX2 Dolphin DuckStation PPSSPP; do
    if [ -d "$HOME/Library/Application Support/$emu" ]; then
        cp -R "$HOME/Library/Application Support/$emu" "$BACKUP_DIR/"
    fi
done

echo "Backup saved to: $BACKUP_DIR"
```

## See Also

- [MACOS_EMULATOR_COMPATIBILITY.md](MACOS_EMULATOR_COMPATIBILITY.md) - Complete compatibility matrix
- [scripts/download-macos-emulators.sh](scripts/download-macos-emulators.sh) - Automated download script
- [system/configgen/emulator_paths_macos.conf](system/configgen/emulator_paths_macos.conf) - Path mappings

## Support Resources

- **RetroBat Discord**: [Join for support]
- **RetroArch Forums**: https://forums.libretro.com/
- **Dolphin Wiki**: https://wiki.dolphin-emu.org/
- **PCSX2 Wiki**: https://wiki.pcsx2.net/

---

**Last Updated**: February 7, 2026  
**For**: RetroBat macOS Port
