# Controller Troubleshooting Guide for macOS

This guide provides solutions for common controller problems on RetroBat macOS.

## Quick Troubleshooting Checklist

Before diving into specific issues, try these quick fixes:

- [ ] Reconnect the controller (unplug/replug or forget/re-pair)
- [ ] Restart RetroBat/EmulationStation
- [ ] Update macOS to the latest version
- [ ] Check SDL2 and SDL3 installation: `brew list sdl2 sdl3`
- [ ] Test controller with SDL utility: `testcontroller`
- [ ] Check System Settings → Game Controllers
- [ ] Try USB connection if using Bluetooth
- [ ] Check controller battery level
- [ ] Restart your Mac

## Controller Not Detected

### Symptoms
- Controller doesn't appear in EmulationStation
- No response from button presses
- Not listed in System Settings → Game Controllers

### Diagnosis

**Step 1: Verify Physical Connection**

For USB:
```bash
# Check if USB device is detected
system_profiler SPUSBDataType | grep -A 10 -i "controller\|gamepad\|xbox\|playstation\|nintendo"
```

For Bluetooth:
```bash
# Check if Bluetooth device is paired
system_profiler SPBluetoothDataType | grep -A 10 -i "controller\|gamepad\|xbox\|playstation\|nintendo"
```

**Step 2: Test SDL Detection**

```bash
# Run SDL test utility
testcontroller

# If not found, install SDL3
brew install sdl3
```

### Solutions

#### Solution 1: Basic Reconnection

**For USB:**
1. Unplug the controller
2. Wait 5 seconds
3. Plug back in
4. Wait 10 seconds for detection

**For Bluetooth:**
1. Open System Settings → Bluetooth
2. Click (i) next to controller name
3. Click "Forget This Device"
4. Put controller in pairing mode
5. Connect again

#### Solution 2: Reset Bluetooth Module

```bash
# Reset Bluetooth (requires admin password)
sudo pkill bluetoothd
```

Then:
1. Turn Bluetooth off in System Settings
2. Wait 10 seconds
3. Turn Bluetooth back on
4. Re-pair controller

#### Solution 3: Reset SMC and NVRAM

**Intel Macs:**
1. Shut down Mac
2. Reset SMC (varies by model, check Apple Support)
3. Restart Mac
4. Reset NVRAM: Hold Cmd+Option+P+R during boot

**Apple Silicon Macs:**
1. Shut down Mac
2. Wait 30 seconds
3. Press and hold power button until startup options appear
4. Release, then shut down and restart normally

#### Solution 4: Check USB Power

If using USB hub:
- Try connecting directly to Mac USB port
- Ensure hub is powered (if using powered hub)
- Some USB-C hubs may not provide enough power

#### Solution 5: Update Controller Firmware

For Xbox controllers:
- Requires Windows PC or Xbox console
- Use Xbox Accessories app to update firmware

For PlayStation controllers:
- Requires PlayStation console
- Update via system software update

For 8BitDo controllers:
- Download firmware updater from 8BitDo website
- Requires Windows PC or web updater

## Controller Detected But Not Working

### Symptoms
- Controller appears in system but buttons don't work
- Some buttons work, others don't
- Analog sticks not responding

### Diagnosis

**Test with SDL:**
```bash
testcontroller
```

- If buttons respond here but not in RetroBat → Configuration issue
- If buttons don't respond anywhere → Hardware or driver issue

### Solutions

#### Solution 1: Reconfigure Controller

**In EmulationStation:**
1. Navigate to Main Menu → Controllers
2. Select "Configure Input"
3. Hold any button on the controller to start
4. Follow prompts to map all buttons
5. Test in games

**In RetroArch:**
1. Main Menu → Settings → Input
2. Port 1 Controls
3. Set All Controls
4. Map each button
5. Save configuration

#### Solution 2: Check Controller Mode

**For 8BitDo controllers:**
- Try switching modes:
  - Start + B: macOS mode (recommended)
  - Start + X: X-input mode
  - Start + Y: D-input mode
  - Start + A: Switch mode

**For controllers with multiple modes:**
- Consult manual for mode switching
- Try different modes to find compatible one

#### Solution 3: Verify gamecontrollerdb.txt

```bash
# Check if mapping exists for your controller
cd ~/RetroBat  # or your RetroBat directory
grep -i "your_controller_name" system/tools/macos/gamecontrollerdb.txt
```

If not found, you may need to add a custom mapping (see [Custom Mapping](#creating-custom-controller-mappings)).

#### Solution 4: Permission Issues

```bash
# Check RetroBat has necessary permissions
# System Settings → Privacy & Security → Input Monitoring
# Ensure EmulationStation/RetroArch have access
```

## Buttons Mapped Incorrectly

### Symptoms
- A button does B action
- Swapped buttons (A/B, X/Y, etc.)
- Incorrect layout

### Solutions

#### Solution 1: Reconfigure in EmulationStation

1. Main Menu → Controllers → Configure Input
2. Carefully map each button according to prompts
3. Don't skip buttons - hold a button to skip if truly not available

#### Solution 2: Reconfigure in RetroArch

1. Settings → Input → Port 1 Controls → Set All Controls
2. Map buttons according to prompts
3. Settings → Configuration → Save Current Configuration

#### Solution 3: Edit Configuration File

**EmulationStation config:**
```bash
# Edit es_input.cfg
nano ~/.emulationstation/es_input.cfg
```

Find your controller's `<inputConfig>` section and verify button indices.

**RetroArch config:**
```bash
# Edit retroarch.cfg
nano ~/.config/retroarch/retroarch.cfg
```

Look for `input_player1_` settings.

#### Solution 4: Nintendo vs Xbox Layout

For Nintendo controllers, remember:
- A (right) = B in Xbox terms
- B (bottom) = A in Xbox terms
- X (top) = Y in Xbox terms
- Y (left) = X in Xbox terms

Enable "Nintendo button layout" in RetroArch if available.

## Analog Stick Problems

### Symptoms
- Sticks don't respond
- Stick drift (movement when not touched)
- Inverted axes
- Limited range

### Solutions

#### Solution 1: Calibrate Analog Sticks

**macOS System Calibration:**
1. System Settings → Game Controllers
2. Select your controller
3. Click "Calibrate"
4. Follow on-screen instructions

**RetroArch Calibration:**
```
Settings → Input → Port 1 Controls
- Analog Deadzone: 0.15 (default) - Increase if drift
- Analog Sensitivity: 1.00 (default)
```

#### Solution 2: Adjust Dead Zone

In RetroArch:
1. Settings → Input → Analog Deadzone
2. Increase value to 0.20-0.30 if experiencing drift
3. Test in game

#### Solution 3: Invert Axes

If stick is inverted:
1. RetroArch: Settings → Input → Port 1 Controls
2. Find "Analog Y Axis-"
3. Toggle invert setting

#### Solution 4: Clean Controller

Physical cleaning:
1. Turn off controller
2. Use compressed air around analog sticks
3. Gently rotate sticks 360° several times
4. Let settle for 5 minutes before testing

## Trigger Problems

### Symptoms
- Triggers not detected
- Triggers detected as buttons not axes
- Limited range (0-50% instead of 0-100%)

### Solutions

#### Solution 1: Verify Trigger Mode

Some controllers have analog/digital trigger modes:
- Check controller manual for mode switch
- Xbox Elite: Use Xbox Accessories app (Windows)
- 8BitDo: Check firmware settings

#### Solution 2: Configure as Analog in RetroArch

```
Settings → Input → Port 1 Controls
- Find L2/R2 entries
- Set to analog axis, not button
- Test range with analog display
```

#### Solution 3: Check gamecontrollerdb.txt Mapping

Triggers should be mapped as axes (a#) not buttons (b#):
```
lefttrigger:a5,righttrigger:a4,platform:Mac OS X,
```

## Bluetooth Connection Problems

### Symptoms
- Frequent disconnections
- High input lag
- Pairing fails
- Can't find controller in Bluetooth settings

### Solutions

#### Solution 1: Improve Bluetooth Connection

1. **Reduce Distance**: Keep controller within 2 meters of Mac
2. **Remove Obstacles**: Clear line of sight between controller and Mac
3. **Reduce Interference**:
   - Move away from Wi-Fi routers
   - Disable other Bluetooth devices
   - Turn off 2.4GHz Wi-Fi (test only)

#### Solution 2: Reset Bluetooth

```bash
# Method 1: Restart Bluetooth daemon
sudo pkill bluetoothd

# Method 2: Reset Bluetooth module
# Hold Shift+Option and click Bluetooth icon in menu bar
# Select "Reset the Bluetooth module"
```

#### Solution 3: Forget and Re-pair

1. System Settings → Bluetooth
2. Find controller
3. Click (i) → Forget Device
4. Restart Mac
5. Put controller in pairing mode
6. Re-pair from fresh

#### Solution 4: Update macOS

Bluetooth improvements in newer macOS versions:
```bash
# Check for updates
softwareupdate -l

# Install updates
softwareupdate -i -a
```

#### Solution 5: Use USB Cable

If Bluetooth issues persist:
- Use USB-C cable for Xbox/PlayStation/Nintendo controllers
- More reliable connection
- Lower latency
- Charges controller while playing

## Input Lag Issues

### Symptoms
- Noticeable delay between button press and action
- Worse on Bluetooth than USB
- Inconsistent response times

### Solutions

#### Solution 1: Switch to USB

- Use wired connection for best latency
- Bluetooth typically adds 5-20ms latency
- USB provides ~1-3ms latency

#### Solution 2: Reduce Bluetooth Interference

1. Close other Bluetooth applications
2. Disconnect unused Bluetooth devices
3. Disable Bluetooth on nearby devices
4. Move away from 2.4GHz sources

#### Solution 3: Optimize RetroArch

```
Settings → Video
- V-Sync: Off (for lower latency)
- Hard GPU Sync: On
- Hard GPU Sync Frames: 0

Settings → Latency
- Run-Ahead: Enable (if CPU allows)
- Run-Ahead Frames: 1-2
```

#### Solution 4: Reduce Video Settings

Lower graphics settings to reduce overall system lag:
- Lower resolution in RetroArch
- Disable shader effects
- Reduce frame smoothing

#### Solution 5: Close Background Apps

Free up system resources:
```bash
# Check CPU usage
top -o cpu

# Close unnecessary apps via Activity Monitor
```

## Rumble Not Working

### Symptoms
- No vibration feedback
- Weak vibration
- Vibration works in some games but not others

### Solutions

#### Solution 1: Enable Rumble in RetroArch

```
Settings → Input → Rumble: On
Settings → Input → Port 1 Controls
- Device Index: Verify correct controller selected
```

#### Solution 2: Check Game/Core Support

- Not all games support rumble
- Not all libretro cores support rumble
- Test with known rumble game (e.g., Super Mario 64, Star Fox 64)

#### Solution 3: Check Controller Battery

- Wireless controllers may disable rumble at low battery
- Charge controller and test again

#### Solution 4: Verify USB Power

- Some USB hubs don't provide enough power for rumble
- Connect directly to Mac USB port
- Use powered USB hub if necessary

## Multiple Controllers Not Working

### Symptoms
- Only first controller works
- Players 2-4 not detected
- Controllers interfering with each other

### Solutions

#### Solution 1: Configure Each Controller

1. Connect all controllers
2. EmulationStation: Main Menu → Controllers
3. Configure Input for each controller separately
4. Hold button on each controller when prompted

#### Solution 2: Verify Controller Order

```bash
# Test all controllers
testcontroller

# Shows all detected controllers with IDs
```

Controllers are assigned in order of connection.

#### Solution 3: Reconfigure in RetroArch

For multiplayer games:
1. Settings → Input → Port 1 Controls (Player 1)
2. Settings → Input → Port 2 Controls (Player 2)
3. Configure each port separately

#### Solution 4: Mix USB and Bluetooth

If multiple Bluetooth controllers interfere:
- Use USB for Player 1
- Bluetooth for Players 2-4
- Reduces Bluetooth bandwidth issues

## Controller Works in EmulationStation But Not in Game

### Symptoms
- Can navigate EmulationStation menus
- Game doesn't respond to controller
- Some games work, others don't

### Solutions

#### Solution 1: Check EmulatorLauncher Config

```bash
# Verify emulator controller support
# Check logs in:
~/RetroBat/logs/
```

#### Solution 2: Configure in Standalone Emulator

For standalone emulators (not RetroArch):
- Launch emulator directly
- Configure controller in emulator's settings
- Different emulators have different controller systems

#### Solution 3: Use RetroArch for Consistency

- When possible, use RetroArch cores
- More consistent controller support across systems
- Unified configuration

## Creating Custom Controller Mappings

If your controller isn't in gamecontrollerdb.txt:

### Step 1: Find Controller GUID

```bash
# Run testcontroller
testcontroller

# Note the GUID (long hexadecimal string)
# Example: 030000005e040000130b000009050000
```

### Step 2: Map Buttons

Using testcontroller, press each button and note the mapping:
- Buttons: b0, b1, b2, etc.
- Axes: a0, a1, a2, etc.
- Hat/D-pad: h0.1, h0.2, h0.4, h0.8

### Step 3: Create Mapping String

Format:
```
GUID,Controller Name,button_mappings,platform:Mac OS X,
```

Example:
```
030000005e040000130b000009050000,Xbox Series Controller,a:b0,b:b1,x:b3,y:b4,back:b10,start:b11,guide:b12,leftshoulder:b6,rightshoulder:b7,leftstick:b13,rightstick:b14,dpup:h0.1,dpdown:h0.4,dpleft:h0.8,dpright:h0.2,leftx:a0,lefty:a1,rightx:a2,righty:a3,lefttrigger:a5,righttrigger:a4,platform:Mac OS X,
```

### Step 4: Add to gamecontrollerdb.txt

```bash
# Edit the file
nano system/tools/macos/gamecontrollerdb.txt

# Add your mapping at the end
# Save and test
```

## Advanced Troubleshooting

### Check SDL Library

```bash
# Verify SDL2 installation
sdl2-config --version
ls -l /opt/homebrew/lib/libSDL2*

# Verify SDL3 installation
sdl3-config --version
ls -l /opt/homebrew/lib/libSDL3*

# Reinstall if needed
brew reinstall sdl2 sdl3
```

### Check System Logs

```bash
# Monitor system logs for controller events
log stream --predicate 'eventMessage contains "gamecontroller"' --level debug

# Or check console app
# Applications → Utilities → Console
# Filter: "controller" or "HID"
```

### Reset All Controller Configurations

```bash
# Backup first!
cp ~/.emulationstation/es_input.cfg ~/.emulationstation/es_input.cfg.backup
cp ~/.config/retroarch/retroarch.cfg ~/.config/retroarch/retroarch.cfg.backup

# Remove configurations
rm ~/.emulationstation/es_input.cfg
rm ~/.config/retroarch/autoconfig/*

# Restart and reconfigure from scratch
```

## Getting Help

If you're still experiencing issues:

1. **Check Documentation**:
   - [Controller Configuration Guide](CONTROLLER_CONFIGURATION_MACOS.md)
   - [Known Issues](CONTROLLER_KNOWN_ISSUES_MACOS.md)
   - [Controller Testing Guide](CONTROLLER_TESTING_MACOS.md)

2. **Run Diagnostic Script**:
   ```bash
   ./scripts/test-controller-macos.sh
   ```

3. **Gather Information**:
   - Controller model and connection type
   - macOS version: `sw_vers`
   - SDL version: `sdl3-config --version`
   - Test results from `testcontroller`
   - Error messages from logs

4. **Report Issue**:
   - Check existing GitHub issues
   - Create new issue with diagnostic information
   - Include steps to reproduce

## See Also

- [Controller Configuration Guide](CONTROLLER_CONFIGURATION_MACOS.md)
- [Controller Testing Guide](CONTROLLER_TESTING_MACOS.md)
- [Known Issues](CONTROLLER_KNOWN_ISSUES_MACOS.md)
- [SDL3 Documentation](https://wiki.libsdl.org/SDL3)
