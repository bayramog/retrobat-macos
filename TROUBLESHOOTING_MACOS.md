# 🔧 RetroBat for macOS - Troubleshooting Guide

Solutions to common issues when running RetroBat on macOS.

## 📋 Table of Contents

- [Installation Issues](#-installation-issues)
- [Launch Issues](#-launch-issues)
- [Performance Problems](#-performance-problems)
- [Controller Issues](#-controller-issues)
- [Emulator-Specific Problems](#-emulator-specific-problems)
- [Game Loading Issues](#-game-loading-issues)
- [Audio/Video Issues](#-audiovideo-issues)
- [Save State Problems](#-save-state-problems)
- [Crash Debugging](#-crash-debugging)
- [System-Specific Issues](#-system-specific-issues)

---

## 🚧 Installation Issues

### "RetroBat.app is damaged and can't be opened"

**Cause**: macOS Gatekeeper blocking unsigned/unnotarized apps.

**Solution**:
```bash
# Remove quarantine attribute
xattr -dr com.apple.quarantine /Applications/RetroBat.app

# Alternative: Right-click → Open (first time only)
```

**If still blocked**:
1. Open **System Preferences** → **Security & Privacy**
2. Click **General** tab
3. Click **Open Anyway** next to RetroBat warning
4. Confirm by clicking **Open**

### "Cannot install RetroBat - requires macOS 12 or later"

**Solution**:
1. Check your macOS version:
   ```bash
   sw_vers
   ```
2. If below 12.0, upgrade macOS:
   - Apple menu → **System Preferences** → **Software Update**
3. If you have an Intel Mac, this version is not supported - requires Apple Silicon

### "Installation failed - not enough disk space"

**Solution**:
1. Check available space:
   ```bash
   df -h ~
   ```
2. Free up space:
   - Remove large unused files
   - Empty Trash
   - Remove old Time Machine snapshots: `tmutil listlocalsnapshots /`
3. RetroBat needs at least 20 GB free space

### Homebrew Dependencies Not Installing

**Problem**: `brew install` commands fail or hang.

**Solution**:
```bash
# Update Homebrew first
brew update

# If update fails, reinstall Command Line Tools
sudo rm -rf /Library/Developer/CommandLineTools
xcode-select --install

# Clean Homebrew cache
brew cleanup

# Retry installation
brew install p7zip wget sdl2 dotnet-sdk

# Check for issues
brew doctor
```

### ".NET SDK not found" Error

**Problem**: RetroBuild or EmulatorLauncher won't run.

**Solution**:
```bash
# Check .NET installation
dotnet --version

# If not found, install via Homebrew
brew install --cask dotnet-sdk

# Or download from Microsoft
# https://dotnet.microsoft.com/download/dotnet/8.0

# Verify installation
dotnet --info

# Add to PATH if needed
export PATH="$PATH:/usr/local/share/dotnet"
```

---

## 🚀 Launch Issues

### RetroBat Won't Launch (App Bounces and Stops)

**Cause 1**: Missing dependencies

**Solution**:
```bash
# Verify all dependencies installed
./verify-tools.sh

# Install missing dependencies
brew bundle
```

**Cause 2**: Corrupted preferences

**Solution**:
```bash
# Backup and reset preferences
mv ~/.emulationstation ~/.emulationstation.backup
mv ~/Library/Application\ Support/RetroBat ~/Library/Application\ Support/RetroBat.backup

# Relaunch RetroBat
```

**Cause 3**: Permissions issue

**Solution**:
```bash
# Fix permissions
chmod +x /Applications/RetroBat.app/Contents/MacOS/*
sudo xattr -cr /Applications/RetroBat.app
```

### EmulationStation Shows Black Screen

**Solution 1**: Check logs
```bash
# View EmulationStation log
cat ~/.emulationstation/es_log.txt

# Check for OpenGL/SDL errors
```

**Solution 2**: Reset video settings
```bash
# Edit config file
nano ~/.emulationstation/es_settings.cfg

# Change or add:
<string name="VideoMode" value="1920x1080" />

# Or delete file to reset all settings
rm ~/.emulationstation/es_settings.cfg
```

**Solution 3**: SDL library issue
```bash
# Reinstall SDL2
brew reinstall sdl2

# Check SDL version
sdl2-config --version
```

### "Cannot connect to display" Error

**Cause**: Running via SSH or without GUI session.

**Solution**: RetroBat requires a GUI session. Launch from Terminal.app on the Mac itself, not via SSH.

---

## ⚡ Performance Problems

### Games Running Slowly / Low FPS

**General Solutions**:

1. **Check Activity Monitor**:
   ```bash
   # Open Activity Monitor
   open -a "Activity Monitor"
   ```
   - Look for high CPU/GPU usage by other apps
   - Close unnecessary applications

2. **Reduce Visual Effects**:
   - In EmulationStation: Start → UI Settings → Transition Style → Instant
   - Disable game videos
   - Use simpler themes

3. **Optimize RetroArch Settings**:
   - Settings → Video → Threaded Video: ON
   - Settings → Video → Hard GPU Sync: OFF
   - Settings → Video → Max Swapchain Images: 2
   - Settings → Latency → Latency: 1 frame

4. **Close Background Apps**:
   ```bash
   # See what's using CPU
   top -o cpu
   
   # Kill unnecessary processes
   killall -9 ProcessName
   ```

### Specific Performance Issues by System

**Nintendo 64 (N64)**:
```
# In RetroArch with Mupen64Plus core
Quick Menu → Options:
- Graphics Plugin: mupen64plus-video-rice (faster)
- RSP Plugin: HLE
- Framebuffer Emulation: Disable
- Multisampling: 0
```

**GameCube/Wii (Dolphin)**:
- Graphics → Enhancements → Set resolution to 1x Native
- Graphics → Hacks → Skip EFB Access from CPU: ON
- Graphics → Hacks → Ignore Format Changes: ON
- Config → General → Enable Dual Core: ON
- Config → General → Enable Cheats: OFF

**PlayStation 2 (PCSX2)**:
- Graphics → Renderer: Vulkan (fastest)
- Graphics → Internal Resolution: Native
- System → EE Cycle Rate: -1 or -2
- System → VU Cycle Stealing: 1
- Graphics → Hardware Fixes → Half Pixel Offset: Normal (Vertex)

**PSP (PPSSPP)**:
- Graphics → Backend: Vulkan
- Graphics → Rendering Resolution: 1x PSP
- Graphics → Frameskip: OFF
- System → Fast Memory: ON
- System → I/O on thread: ON

### Temperature/Thermal Throttling

**Check Temperature**:
```bash
# Install temperature monitor
brew install osx-cpu-temp

# Monitor temperature
osx-cpu-temp

# Continuous monitoring
watch -n 2 osx-cpu-temp
```

**Solutions**:
- Ensure good ventilation
- Use laptop cooling pad
- Clean dust from vents
- Consider TG Pro app for fan control
- Lower graphics settings in demanding games

### High CPU Usage When Idle

**Cause**: Video scraping or background processes.

**Solution**:
1. Start → UI Settings → Video Screensaver: Disable
2. Start → UI Settings → Power Saver Mode: Enable
3. Disable video previews in game lists
4. Use static themes instead of animated ones

---

## 🎮 Controller Issues

### Controller Not Detected

**Solution 1**: Check USB connection
```bash
# List USB devices
ioreg -p IOUSB | grep -i game

# Check if controller appears
system_profiler SPUSBDataType | grep -i controller
```

**Solution 2**: Bluetooth pairing
1. Open **System Preferences** → **Bluetooth**
2. Put controller in pairing mode:
   - **PS4/PS5**: Hold Share + PS button until light flashes
   - **Xbox**: Hold pairing button (top of controller)
   - **Switch Pro**: Hold sync button (top)
3. Click **Connect** in Bluetooth preferences
4. Wait for pairing to complete

**Solution 3**: Reset controller config
```bash
# Backup current config
cp ~/.emulationstation/es_input.cfg ~/.emulationstation/es_input.cfg.backup

# Delete config to reset
rm ~/.emulationstation/es_input.cfg

# Restart EmulationStation
```

**Solution 4**: Install controller driver (if needed)
```bash
# For some controllers, you may need additional drivers
# Install via Homebrew if available
brew tap homebrew/cask-drivers
brew install --cask controller-driver-name
```

### Controller Buttons Mapped Incorrectly

**Solution 1**: Reconfigure in EmulationStation
1. Start → Controllers → Configure Input
2. Hold any button on controller to start
3. Follow on-screen prompts
4. Press each button as requested

**Solution 2**: Manual configuration
```bash
# Edit input config
nano ~/.emulationstation/es_input.cfg

# Find your controller by name
# Adjust button mappings as needed
```

**Solution 3**: Per-emulator configuration
- Each emulator may need separate controller setup
- Configure within the emulator itself
- For RetroArch: Hotkey + X → Settings → Input

### Analog Stick Drift or Dead Zone Issues

**Solution 1**: Adjust dead zone
1. In RetroArch: Settings → Input → Analog Deadzone
2. Increase to 0.15-0.20 if experiencing drift

**Solution 2**: Calibrate controller
```bash
# Some controllers support calibration
# Check manufacturer's tools or apps
```

**Solution 3**: Clean controller
- Use compressed air around analog sticks
- Use electrical contact cleaner
- Replace analog stick modules if needed

### Controller Disconnects Randomly

**Bluetooth Issues**:
1. **Reset Bluetooth**:
   ```bash
   sudo killall -HUP bluetoothd
   ```

2. **Remove and re-pair**:
   - System Preferences → Bluetooth
   - Click X next to controller
   - Re-pair from scratch

3. **Check for interference**:
   - Move away from WiFi router
   - Remove other Bluetooth devices
   - Try USB connection instead

**USB Issues**:
- Try different USB port
- Use USB 2.0 port instead of 3.0 (sometimes more stable)
- Replace USB cable
- Try USB hub with external power

### Hotkeys Not Working

**Solution**:
1. **Verify hotkey button configured**:
   - In EmulationStation config, ensure "Hotkey Enable" is set
   - Usually set to Select button

2. **Check RetroArch hotkeys**:
   - Settings → Input → Hotkeys
   - Verify hotkey combinations
   - Reset to defaults if needed

3. **Per-core override conflict**:
   ```bash
   # Remove per-game/per-core overrides
   rm -rf ~/.config/retroarch/config/*/*.cfg
   ```

---

## 🎯 Emulator-Specific Problems

### RetroArch: "Failed to load content"

**Causes & Solutions**:

1. **Missing BIOS**:
   - Check required BIOS: Quick Menu → Information → Core Information
   - Place BIOS in `~/RetroBat/bios/`

2. **Wrong core**:
   - Try different core: Start → Game Settings → Select alternate core

3. **Corrupted ROM**:
   - Verify ROM file integrity
   - Try re-downloading ROM
   - Check file extension matches core

4. **Core not installed**:
   ```bash
   # In RetroArch
   Main Menu → Online Updater → Core Updater
   # Download the needed core
   ```

### Dolphin: "Invalid or Corrupt File"

**For GameCube/Wii ISOs**:

1. **Check file integrity**:
   ```bash
   # Verify ISO not corrupted
   md5 /path/to/game.iso
   ```

2. **Convert format**:
   ```bash
   # Install Dolphin CLI tools
   brew install dolphin-emu
   
   # Convert to RVZ (recommended format)
   dolphintool convert -f rvz -i game.iso -o game.rvz
   ```

3. **Check region compatibility**:
   - Ensure BIOS matches game region
   - Try different region ROM

### PCSX2: Black Screen or Freezing

**Solutions**:

1. **Update BIOS files**:
   - Place in `~/RetroBat/bios/`
   - Files needed: `ps2-0200a-20040614.bin` (USA), `ps2-0220a-20050620.bin` (Europe)

2. **Graphics settings**:
   - Switch renderer: Vulkan ↔ Metal
   - Enable/disable "Large Framebuffer"
   - Try software renderer (slow but compatible)

3. **Check logs**:
   ```bash
   # View PCSX2 logs
   cat ~/Library/Application\ Support/PCSX2/logs/emuLog.txt
   ```

### PPSSPP: "Rendering Issues" or Glitches

**Solutions**:

1. **Change backend**:
   - Graphics → Backend: Try Vulkan, OpenGL, or Metal
   
2. **Rendering mode**:
   - Graphics → Mode: Buffered Rendering
   - Disable frameskipping
   
3. **Compatibility settings**:
   - System → I/O on thread: Toggle ON/OFF
   - System → Fast Memory: Toggle

### Citra/Lime3DS: Slow or Won't Boot

**Solutions**:

1. **Update to Lime3DS** (Citra fork):
   ```bash
   brew install --cask lime3ds
   ```

2. **Required files**:
   - Place 3DS system files in `~/RetroBat/bios/3ds/`
   - Boot9.bin, Boot11.bin, otp.bin, movable.sed

3. **Graphics settings**:
   - Emulation → Configure → Graphics
   - API: Vulkan (fastest)
   - Use Disk Shader Cache: ON
   - Async Shader Compilation: ON

### MAME: "ROM Not Found" Errors

**Solutions**:

1. **Check ROM set version**:
   - MAME version must match ROM set version
   - Check MAME version: In game list, look at emulator version
   
2. **Parent/Clone ROMs**:
   - Clone ROMs need parent ROM in same folder
   - Example: `mspacman.zip` needs `pacman.zip`

3. **BIOS ROMs**:
   - Many games need `neogeo.zip`, `cpzn1.zip`, etc.
   - Place in same folder as game ROMs

4. **Verify ROM**:
   ```bash
   # Check ROM in MAME
   /Applications/MAME.app/Contents/MacOS/mame -verifyroms romname
   ```

---

## 📀 Game Loading Issues

### "Could not find BIOS" Error

**Solution**:
1. Identify required BIOS for system
2. Download BIOS files (legally from your own console)
3. Place in `~/RetroBat/bios/`
4. Verify filenames exactly match requirements
5. Check BIOS status: Start → Information → BIOS Check

**Common BIOS Files**:
```bash
~/RetroBat/bios/
├── scph5501.bin          # PS1 USA
├── ps2-0200a-20040614.bin # PS2 USA
├── dc_boot.bin           # Dreamcast
├── saturn_bios.bin       # Saturn
├── gba_bios.bin          # Game Boy Advance
├── bios7.bin             # Nintendo DS
└── bios9.bin             # Nintendo DS
```

### ROM Not Showing in Game List

**Solutions**:

1. **Check file extension**:
   - Ensure extension matches supported formats
   - Example: SNES uses `.sfc`, `.smc`, not `.rom`

2. **Refresh game list**:
   - Start → Game Collection Settings → Update Game List

3. **Check file location**:
   - Must be in correct folder: `~/RetroBat/roms/[system]/`
   - Check folder name matches system name

4. **Hidden files**:
   ```bash
   # Show hidden files
   defaults write com.apple.finder AppleShowAllFiles TRUE
   killall Finder
   ```

5. **Permissions**:
   ```bash
   # Fix permissions
   chmod -R 755 ~/RetroBat/roms/
   ```

### Multi-Disc Games Not Working

**Solution 1**: Use M3U playlist
```bash
# Create .m3u file
cd ~/RetroBat/roms/psx/
cat > "Final Fantasy VII.m3u" << EOF
Final Fantasy VII (Disc 1).chd
Final Fantasy VII (Disc 2).chd
Final Fantasy VII (Disc 3).chd
EOF
```

**Solution 2**: Disc swapping in-game
1. Open RetroArch menu (Hotkey + X)
2. Quick Menu → Disk Control
3. Eject disk
4. Cycle to next disk
5. Insert disk

---

## 🎵 Audio/Video Issues

### No Audio or Crackling Sound

**Solutions**:

1. **Check system volume**:
   - Ensure volume not muted
   - Check in menu bar

2. **RetroArch audio settings**:
   ```
   Settings → Audio:
   - Audio Device: Default
   - Driver: coreaudio
   - Latency: 64-128ms
   - Max Timing Skew: 0.05
   ```

3. **Buffer size**:
   - Increase audio latency if crackling
   - Settings → Audio → Audio Latency: 128-256ms

4. **Sample rate**:
   - Settings → Audio → Output Sample Rate: 48000 Hz

5. **Reset audio driver**:
   ```bash
   # Restart CoreAudio
   sudo killall coreaudiod
   ```

### Video Stuttering or Screen Tearing

**Solutions**:

1. **V-Sync settings**:
   ```
   RetroArch:
   Settings → Video → Vertical Refresh Rate: ON
   Settings → Video → Threaded Video: ON
   ```

2. **Disable compositor**:
   - Settings → Video → GPU Hard Sync: OFF (try both on/off)

3. **Frame delay**:
   - Settings → Video → Frame Delay: 0 (adjust 0-15)

4. **Reduce resolution**:
   - Lower output resolution
   - Disable shaders
   - Disable integer scaling

### Graphics Glitches or Artifacts

**Solutions**:

1. **Try different video driver**:
   - Settings → Drivers → Video: Try Metal, OpenGL, or Vulkan

2. **Disable enhancements**:
   - Turn off shaders
   - Disable anti-aliasing
   - Use native resolution

3. **Update graphics drivers** (macOS updates)

4. **Check for overheating** (see Performance section)

---

## 💾 Save State Problems

### Save States Not Working

**Solutions**:

1. **Check save state location**:
   ```bash
   ls -la ~/RetroBat/saves/
   ```

2. **Permissions**:
   ```bash
   chmod -R 755 ~/RetroBat/saves/
   ```

3. **Disk space**:
   ```bash
   df -h ~/RetroBat/
   ```

4. **Core compatibility**:
   - Not all cores support save states
   - Try saving from RetroArch menu instead of hotkey

### Save States Load Incorrectly

**Causes**:
- Core version mismatch
- ROM version changed
- Corrupted save state

**Solutions**:

1. **Use in-game saves instead** (more reliable)

2. **Update core to same version**:
   - RetroArch → Online Updater → Update Core

3. **Delete corrupted states**:
   ```bash
   rm ~/RetroBat/saves/[system]/[game]/*.state*
   ```

### Can't Find Save Files

**Solution**:
```bash
# Find all save files
find ~/RetroBat -name "*.srm"
find ~/RetroBat -name "*.sav"

# Common locations:
~/RetroBat/saves/[system]/
~/.config/retroarch/saves/
~/Library/Application Support/[Emulator]/saves/
```

---

## 💥 Crash Debugging

### EmulationStation Crashes on Launch

**Solution 1**: Check crash logs
```bash
# View crash log
cat ~/Library/Logs/DiagnosticReports/RetroBat*.crash

# Or use Console app
open -a Console
```

**Solution 2**: Run from Terminal to see errors
```bash
# Launch from terminal
/Applications/RetroBat.app/Contents/MacOS/RetroBat

# Watch for error messages
```

**Solution 3**: Safe mode
```bash
# Reset all settings
rm -rf ~/.emulationstation
rm -rf ~/Library/Application\ Support/RetroBat

# Restart RetroBat
```

### Game/Emulator Crashes

**Solution 1**: Check emulator logs
```bash
# RetroArch log
cat ~/.config/retroarch/retroarch.log

# Dolphin log  
cat ~/Library/Application\ Support/Dolphin/Logs/

# PCSX2 log
cat ~/Library/Application\ Support/PCSX2/logs/
```

**Solution 2**: Test emulator standalone
```bash
# Launch emulator directly (outside RetroBat)
open -a "Dolphin"
open -a "RetroArch"

# If it works standalone, issue is with RetroBat launcher
```

**Solution 3**: Compatibility settings
- Try different emulator
- Update to latest emulator version
- Check if game is known to have issues

### Kernel Panic / System Crash

**Rare but serious**:

1. **Update macOS**: System Preferences → Software Update
2. **Check for hardware issues**: Apple Diagnostics (hold D during boot)
3. **Reset SMC/PRAM**:
   ```bash
   # For Apple Silicon, just restart
   # System manages these automatically
   ```
4. **Report to Apple and RetroBat developers**

---

## 🖥️ System-Specific Issues

### macOS Ventura (13.x) Issues

**"App is Damaged" More Aggressive**:
- Use `xattr -cr` instead of just `xattr -dr`
- Check **System Settings** → **Privacy & Security** → **Allow apps from**

**Metal API Compatibility**:
- Some older cores may have issues
- Use OpenGL renderer as fallback

### macOS Sonoma (14.x) Issues

**Game Mode Conflicts**:
- Disable Game Mode for RetroBat: Right-click app → Get Info → Disable Game Mode
- Or keep enabled for better performance

**Permission Prompts**:
- Grant all requested permissions
- Check: System Settings → Privacy & Security

### M1/M2/M3/M4 Specific Issues

**Rosetta Not Available**:
- This version doesn't need Rosetta (native ARM64)
- If Rosetta is mentioned in errors, something's wrong with build

**Memory Pressure**:
```bash
# Check memory usage
memory_pressure

# Close apps if memory is high
```

**Thermal Management**:
- MacBook Air (fanless): May throttle under heavy load
- Use external cooling or reduce graphics settings

### External Storage Issues

**Games on External Drive**:

1. **Format**: Use APFS or exFAT, not NTFS
2. **Connection**: Use USB 3.0+ for best performance
3. **Permissions**:
   ```bash
   # Fix external drive permissions
   sudo chmod -R 755 /Volumes/ExternalDrive/RetroBat/
   ```

**Symbolic Links** (Advanced):
```bash
# Move ROMs to external drive
mv ~/RetroBat/roms /Volumes/ExternalDrive/RetroBat-ROMs

# Create symlink
ln -s /Volumes/ExternalDrive/RetroBat-ROMs ~/RetroBat/roms
```

---

## 📞 Getting Additional Help

If none of these solutions work:

### Collect Debug Information

```bash
# System info
system_profiler SPSoftwareDataType SPHardwareDataType

# RetroBat version
cat /Applications/RetroBat.app/Contents/Info.plist | grep -A 1 CFBundleVersion

# Check dependencies
brew list --versions

# RetroArch version
/Applications/RetroArch.app/Contents/MacOS/RetroArch --version
```

### Report Issues

1. **GitHub Issues**: [Create an issue](https://github.com/bayramog/retrobat-macos/issues)
   - Include system info
   - Attach relevant logs
   - Describe steps to reproduce

2. **Discord**: [Join RetroBat Discord](https://discord.gg/GVcPNxwzuT)
   - #macos-support channel
   - Share debug info
   - Ask for help from community

3. **Forum**: [RetroBat Forum](https://social.retrobat.org/forum)
   - Post detailed issue description
   - Include logs and screenshots

### Log Locations Reference

```
EmulationStation:
~/.emulationstation/es_log.txt

RetroArch:
~/.config/retroarch/retroarch.log

Dolphin:
~/Library/Application Support/Dolphin/Logs/

PCSX2:
~/Library/Application Support/PCSX2/logs/

System Crash Logs:
~/Library/Logs/DiagnosticReports/

Console Output:
/Applications/Utilities/Console.app
```

---

## 🔍 Quick Diagnostic Checklist

Before asking for help, try this checklist:

- [ ] macOS version 12+ and Apple Silicon?
- [ ] All Homebrew dependencies installed?
- [ ] `.NET SDK` installed and working?
- [ ] App quarantine attribute removed?
- [ ] Sufficient disk space (20+ GB)?
- [ ] ROMs in correct folders?
- [ ] Required BIOS files present?
- [ ] Controller properly configured?
- [ ] Tried different emulator/core?
- [ ] Checked logs for errors?
- [ ] Tested on different game?
- [ ] Restarted Mac?
- [ ] Latest RetroBat version?

---

**Still stuck?** Check [MACOS_FAQ.md](MACOS_FAQ.md) for more answers or ask the community!
