# Controller Testing Guide for macOS

This document provides comprehensive testing procedures for game controllers on RetroBat macOS.

## Testing Overview

### Test Levels

1. **System Level**: macOS controller detection
2. **SDL3 Level**: SDL3 controller recognition and input
3. **EmulationStation Level**: Frontend controller integration
4. **RetroArch Level**: Emulator controller functionality
5. **Standalone Emulator Level**: Individual emulator support

## Prerequisites

### Required Tools

```bash
# Install SDL3 and testing utilities
brew install sdl3

# Verify installation
which sdl3-config
sdl3-config --version
```

### Test Utilities

1. **SDL3 testcontroller**: Built-in SDL3 controller test
2. **macOS System Settings**: Native controller view
3. **EmulationStation**: Frontend testing
4. **RetroArch**: Emulator core testing

## Test Procedure by Controller Type

### Xbox Series X/S Controller

#### USB Connection Test

**Setup:**
1. Connect controller via USB-C cable
2. Wait 2-3 seconds for detection

**macOS System Test:**
```bash
# Check USB device detection
system_profiler SPUSBDataType | grep -A 10 "Xbox"
```

Expected output: Xbox Wireless Controller listed

**SDL3 Test:**
```bash
# Run SDL3 controller test
testcontroller
```

**Checklist:**
- [ ] Controller detected and listed
- [ ] D-Pad: Up, Down, Left, Right
- [ ] A button (b0)
- [ ] B button (b1)
- [ ] X button (b3)
- [ ] Y button (b4)
- [ ] View/Back button (b10)
- [ ] Menu/Start button (b11)
- [ ] Xbox/Guide button (b12)
- [ ] LB shoulder button (b6)
- [ ] RB shoulder button (b7)
- [ ] LT trigger (a5) - Full range 0.0 to 1.0
- [ ] RT trigger (a4) - Full range 0.0 to 1.0
- [ ] Left stick X axis (a0) - Range -1.0 to +1.0
- [ ] Left stick Y axis (a1) - Range -1.0 to +1.0
- [ ] Left stick button (b13)
- [ ] Right stick X axis (a2) - Range -1.0 to +1.0
- [ ] Right stick Y axis (a3) - Range -1.0 to +1.0
- [ ] Right stick button (b14)
- [ ] Share button (b15, if available)
- [ ] No drift in neutral position
- [ ] Rumble/vibration (if supported)

#### Bluetooth Connection Test

**Setup:**
1. Put controller in pairing mode (hold pairing button)
2. Connect via System Settings → Bluetooth
3. Verify connection (Xbox button should be lit)

**macOS Bluetooth Test:**
```bash
# Check Bluetooth devices
system_profiler SPBluetoothDataType | grep -A 10 "Xbox"
```

Expected output: Xbox Wireless Controller paired and connected

**Repeat SDL3 Test checklist above**

**Additional Bluetooth Tests:**
- [ ] Reconnection after sleep
- [ ] Reconnection after turning off/on
- [ ] Signal strength adequate (< 2m distance)
- [ ] No input lag noticeable
- [ ] Battery level reported (if supported)

### PlayStation 5 DualSense Controller

#### USB Connection Test

**Setup:**
1. Connect controller via USB-C cable
2. Wait 2-3 seconds for detection

**macOS System Test:**
```bash
# Check USB device detection
system_profiler SPUSBDataType | grep -A 10 "DualSense"
```

**SDL3 Test Checklist:**
- [ ] Controller detected and listed
- [ ] D-Pad: Up, Down, Left, Right
- [ ] Cross/X button (b1)
- [ ] Circle button (b2)
- [ ] Square button (b0)
- [ ] Triangle button (b3)
- [ ] Share/Create button (b8)
- [ ] Options button (b9)
- [ ] PS button (b12)
- [ ] L1 shoulder button (b4)
- [ ] R1 shoulder button (b5)
- [ ] L2 trigger (a3) - Full range 0.0 to 1.0
- [ ] R2 trigger (a4) - Full range 0.0 to 1.0
- [ ] Left stick X axis (a0)
- [ ] Left stick Y axis (a1)
- [ ] Left stick button (b10)
- [ ] Right stick X axis (a2)
- [ ] Right stick Y axis (a5)
- [ ] Right stick button (b11)
- [ ] Touchpad button (b13)
- [ ] Mute button (b14, if supported)
- [ ] No drift in neutral position
- [ ] Rumble/haptic feedback

#### Bluetooth Connection Test

**Setup:**
1. Put controller in pairing mode (PS + Create buttons)
2. Connect via System Settings → Bluetooth
3. Verify light bar is solid color

**Repeat SDL3 Test checklist above**

**Additional Tests:**
- [ ] LED color changes
- [ ] Speaker output (if supported)
- [ ] Motion controls (basic detection)

### Nintendo Switch Pro Controller

#### USB Connection Test

**Setup:**
1. Connect controller via USB-C cable
2. Wait 2-3 seconds for detection

**SDL3 Test Checklist:**
- [ ] Controller detected and listed
- [ ] D-Pad: Up, Down, Left, Right
- [ ] B button (bottom, b0)
- [ ] A button (right, b1)
- [ ] Y button (left, b2)
- [ ] X button (top, b3)
- [ ] Minus (-) button (b8)
- [ ] Plus (+) button (b9)
- [ ] Home button (b12)
- [ ] L shoulder button (b4)
- [ ] R shoulder button (b5)
- [ ] ZL trigger (b6)
- [ ] ZR trigger (b7)
- [ ] Left stick X axis (a0)
- [ ] Left stick Y axis (a1)
- [ ] Left stick button (b10)
- [ ] Right stick X axis (a2)
- [ ] Right stick Y axis (a3)
- [ ] Right stick button (b11)
- [ ] Capture button (if detected)
- [ ] No drift in neutral position
- [ ] HD Rumble

#### Bluetooth Connection Test

**Setup:**
1. Put controller in pairing mode (hold sync button)
2. Connect via System Settings → Bluetooth
3. Verify player LED 1 is lit

**Repeat SDL3 Test checklist above**

**Additional Tests:**
- [ ] Player LED changes
- [ ] Gyro/motion controls (basic detection)

### 8BitDo Controllers

#### General Test Procedure

Different 8BitDo models may have different modes. Test in X-input mode (usually Mode 1).

**Connection Modes:**
- Mode 1 (X-input): Start + X (usually)
- Mode 2 (D-input): Start + Y (usually)
- Mode 3 (Switch): Start + A (usually)
- Mode 4 (macOS): Start + B (usually)

**Use macOS Mode (Mode 4) for best compatibility**

**SDL3 Test Checklist:**
- [ ] Controller detected in correct mode
- [ ] All digital buttons respond
- [ ] All analog inputs work correctly
- [ ] Mode switching works
- [ ] Pairing button functions
- [ ] Star/home button works
- [ ] Rumble (if supported)

### Generic USB Controllers

**Basic Functionality Test:**
- [ ] Controller detected by macOS
- [ ] SDL3 recognizes controller
- [ ] Minimum buttons work: A, B, Start, Select, D-Pad
- [ ] Analog sticks work (if present)
- [ ] Configuration can be saved

## EmulationStation Testing

### Initial Configuration Test

1. Launch EmulationStation with controller connected
2. Configuration wizard should appear automatically

**Test Checklist:**
- [ ] Controller detected on startup
- [ ] Configuration wizard appears
- [ ] All prompted buttons can be mapped
- [ ] "Hold button to skip" works for unavailable inputs
- [ ] Configuration is saved after completion
- [ ] Controller works immediately after configuration

### Navigation Test

**Menu Navigation:**
- [ ] Up/Down/Left/Right navigation works
- [ ] A button selects items
- [ ] B button goes back
- [ ] Start button opens menu
- [ ] Shoulder buttons scroll pages
- [ ] Analog stick can navigate (as alternative to D-pad)

**Quick Actions:**
- [ ] Select+Start: Shutdown menu
- [ ] Select+X: Random game selection
- [ ] Select+Y: Favorite toggle

### Game Launch Test

- [ ] Can navigate to and select a game
- [ ] Game launches successfully
- [ ] Controller input works in game
- [ ] Can exit game with hotkey (Select+Start)
- [ ] Returns to EmulationStation correctly

## RetroArch Testing

### Core Controller Test

Test with different emulator cores to verify compatibility.

#### SNES Core Test (snes9x_libretro)

1. Load a SNES game
2. Test all controller inputs:

**Checklist:**
- [ ] D-Pad navigation works
- [ ] A/B buttons work
- [ ] X/Y buttons work
- [ ] L/R shoulder buttons work
- [ ] Start/Select buttons work
- [ ] Hotkey combos work (Select+Start to exit)
- [ ] Menu access (Select+X)

#### PlayStation Core Test (pcsx_rearmed)

**Checklist:**
- [ ] All digital buttons work
- [ ] Analog sticks work (DualShock games)
- [ ] L2/R2 triggers work properly
- [ ] Analog button works (if present)
- [ ] Rumble works (if game supports it)

#### N64 Core Test (mupen64plus_next)

**Checklist:**
- [ ] Analog stick works properly
- [ ] C buttons mapped correctly
- [ ] Z trigger works
- [ ] L/R triggers work
- [ ] Memory pak detection (if applicable)

### Hotkey Test

**Essential Hotkeys:**
- [ ] Select+Start: Exit game
- [ ] Select+R1: Save state
- [ ] Select+L1: Load state
- [ ] Select+R2: Next save slot
- [ ] Select+L2: Previous save slot
- [ ] Select+A: RetroArch menu toggle
- [ ] Select+Right: Fast forward
- [ ] Select+Left: Rewind (if enabled)

## Standalone Emulator Testing

### PPSSPP (PSP Emulator)

1. Launch PPSSPP
2. Navigate to Settings → Controls
3. Verify controller is detected

**Test Checklist:**
- [ ] Controller shown in control settings
- [ ] Can map all PSP buttons
- [ ] Analog stick works
- [ ] In-game controls work correctly

### Dolphin (GameCube/Wii Emulator)

1. Launch Dolphin
2. Navigate to Controllers → Configure
3. Select controller

**Test Checklist:**
- [ ] Controller detected
- [ ] GC controller mode works
- [ ] Analog triggers work properly
- [ ] C-stick works
- [ ] Rumble works

## Stress Testing

### Rapid Input Test

Test button response under rapid presses:

1. Rapidly press each button 20 times
2. Verify all inputs registered
3. Check for missed inputs or double-inputs

**Checklist:**
- [ ] All buttons respond to rapid input
- [ ] No missed inputs
- [ ] No ghost/phantom inputs
- [ ] No input lag

### Simultaneous Input Test

Test multiple inputs at once:

1. Press multiple buttons simultaneously
2. Move both analog sticks while pressing buttons
3. Use all triggers and buttons together

**Checklist:**
- [ ] All simultaneous inputs registered
- [ ] No input blocking
- [ ] No interference between inputs

### Extended Session Test

Test controller reliability over time:

1. Play a game for 30+ minutes continuously
2. Monitor for issues

**Checklist:**
- [ ] No connection drops
- [ ] No input lag development
- [ ] No battery drain issues (wireless)
- [ ] No overheating
- [ ] Consistent performance

## Disconnection/Reconnection Testing

### Graceful Disconnection

1. While in EmulationStation, disconnect controller
2. Observe behavior

**Expected:**
- [ ] EmulationStation detects disconnection
- [ ] No crash or freeze
- [ ] Can still use keyboard as fallback

### Reconnection

1. Reconnect same controller
2. Verify functionality

**Expected:**
- [ ] Controller automatically recognized
- [ ] Previous configuration restored
- [ ] Works immediately without reconfiguration

### Controller Swap

1. Disconnect Controller A
2. Connect Controller B (different model)
3. Observe behavior

**Expected:**
- [ ] EmulationStation detects new controller
- [ ] Configuration prompt appears (if not previously configured)
- [ ] Both controllers can be configured separately

## Battery Life Testing (Wireless Controllers)

### Battery Monitor Test

For wireless controllers with battery indicators:

**Test Procedure:**
1. Note starting battery level
2. Use controller continuously for 4 hours
3. Monitor battery level

**Checklist:**
- [ ] Battery level reported accurately
- [ ] Low battery warning appears
- [ ] Controller performance not affected by low battery
- [ ] Graceful shutdown on empty battery

## Performance Metrics

### Acceptable Standards

- **Input Lag**: < 10ms (unnoticeable)
- **Polling Rate**: ≥ 125 Hz (8ms)
- **Analog Precision**: ± 1% accuracy
- **Dead Zone**: < 10% of full range
- **Button Response**: 100% reliability

### Measurement Tools

```bash
# Monitor controller events in real-time
log stream --predicate 'eventMessage contains "controller"' --level debug

# Check USB polling rate (USB controllers only)
ioreg -l -w 0 | grep -i "polling"
```

## Test Results Template

Use this template to document test results:

```markdown
## Controller: [Model Name]
**Connection Type**: [USB/Bluetooth]
**Date**: [YYYY-MM-DD]
**macOS Version**: [e.g., 14.2]
**SDL3 Version**: [e.g., 3.1.2]

### Detection
- [ ] macOS System: PASS/FAIL
- [ ] SDL3: PASS/FAIL
- [ ] EmulationStation: PASS/FAIL
- [ ] RetroArch: PASS/FAIL

### Buttons
- [ ] All digital buttons: PASS/FAIL
- [ ] Analog sticks: PASS/FAIL
- [ ] Triggers: PASS/FAIL
- [ ] Special buttons: PASS/FAIL

### Features
- [ ] Rumble: PASS/FAIL/N/A
- [ ] LED: PASS/FAIL/N/A
- [ ] Motion: PASS/FAIL/N/A
- [ ] Battery indicator: PASS/FAIL/N/A

### Performance
- Input lag: [measurement]
- Polling rate: [measurement]
- Analog precision: [measurement]

### Issues Found
[List any issues]

### Overall Rating
[Excellent/Good/Fair/Poor]
```

## Automated Testing Script

Save this as `test-controller-macos.sh`:

```bash
#!/bin/bash

echo "RetroBat macOS Controller Test"
echo "================================"
echo ""

# Check SDL3 installation
if ! command -v sdl3-config &> /dev/null; then
    echo "❌ SDL3 not found. Install with: brew install sdl3"
    exit 1
fi

echo "✓ SDL3 installed: $(sdl3-config --version)"
echo ""

# Check for connected USB controllers
echo "USB Controllers:"
system_profiler SPUSBDataType | grep -E "(Xbox|PlayStation|Nintendo|Controller)" || echo "  None detected"
echo ""

# Check for Bluetooth controllers
echo "Bluetooth Controllers:"
system_profiler SPBluetoothDataType | grep -E "(Xbox|PlayStation|Nintendo|Controller)" || echo "  None detected"
echo ""

# Check gamecontrollerdb.txt
if [ -f "system/tools/macos/gamecontrollerdb.txt" ]; then
    MAPPING_COUNT=$(wc -l < system/tools/macos/gamecontrollerdb.txt | tr -d ' ')
    echo "✓ gamecontrollerdb.txt found ($MAPPING_COUNT mappings)"
else
    echo "❌ gamecontrollerdb.txt not found at system/tools/macos/"
fi
echo ""

echo "To test controller input, run: testcontroller"
echo "To view detailed controller info, open: System Settings → Game Controllers"
```

## See Also

- [Controller Configuration Guide](CONTROLLER_CONFIGURATION_MACOS.md)
- [Controller Troubleshooting Guide](CONTROLLER_TROUBLESHOOTING_MACOS.md)
- [Known Issues](CONTROLLER_KNOWN_ISSUES_MACOS.md)
