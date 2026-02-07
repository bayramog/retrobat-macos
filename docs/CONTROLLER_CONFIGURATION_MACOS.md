# Controller Configuration Guide for macOS

This guide explains how to configure controllers for RetroBat on macOS using SDL3.

## Overview

RetroBat on macOS uses SDL3 for controller support, providing a unified interface for various gaming controllers. The system automatically detects and configures most popular controllers out of the box.

## Supported Controllers

### Fully Tested Controllers

#### Xbox Controllers
- **Xbox Series X/S Controller**
  - USB: Full support with all buttons, analog sticks, triggers
  - Bluetooth: Full support with all features
  - Rumble: Supported
  
- **Xbox One Controller**
  - USB: Full support
  - Bluetooth: Full support
  - Rumble: Supported

- **Xbox 360 Controller**
  - USB: Full support (wired controller)
  - Wireless: Requires Xbox 360 Wireless Receiver
  - Rumble: Supported

- **Xbox Elite Controller Series 2**
  - USB and Bluetooth: Full support
  - Paddle buttons: Supported
  - Profile switching: Supported

#### PlayStation Controllers
- **PlayStation 5 DualSense**
  - USB: Full support with all buttons, touchpad, triggers
  - Bluetooth: Full support
  - Haptic feedback: Basic rumble support
  - Adaptive triggers: Not currently supported
  - LED: Limited support

- **PlayStation 4 DualShock 4**
  - USB: Full support with touchpad
  - Bluetooth: Full support
  - Rumble: Supported
  - LED: Limited support

#### Nintendo Controllers
- **Nintendo Switch Pro Controller**
  - USB: Full support
  - Bluetooth: Full support
  - HD Rumble: Basic rumble support
  - NFC: Not supported

#### Third-Party Controllers
- **8BitDo Controllers**
  - 8BitDo Pro 2: Full support
  - 8BitDo SN30 Pro+: Full support
  - 8BitDo Lite 2: Full support
  - 8BitDo M30: Full support
  - Other 8BitDo models: Generally supported

## Controller Connection

### USB Connection

1. Connect your controller to your Mac via USB cable
2. macOS will automatically detect the controller
3. Launch RetroBat - the controller should be recognized automatically
4. If not detected, check System Settings → Game Controllers

### Bluetooth Connection

#### Xbox Controllers
1. Put the controller in pairing mode:
   - Press and hold the **pairing button** (small button on top near USB-C port)
   - Wait for the Xbox button to flash rapidly
2. On your Mac:
   - Open System Settings → Bluetooth
   - Look for "Xbox Wireless Controller"
   - Click "Connect"
3. Once connected, the Xbox button will stay lit
4. Launch RetroBat to verify controller is detected

#### PlayStation Controllers
1. Put the controller in pairing mode:
   - Press and hold **PS button + Share button** (PS4) or **PS button + Create button** (PS5)
   - Wait for the light bar to flash
2. On your Mac:
   - Open System Settings → Bluetooth
   - Look for "DUALSHOCK 4" or "DualSense Wireless Controller"
   - Click "Connect"
3. Once connected, the light bar will change to solid color
4. Launch RetroBat to verify controller is detected

#### Nintendo Switch Pro Controller
1. Put the controller in pairing mode:
   - Press and hold the **sync button** (small button on top between L and R)
   - Wait for the player LEDs to flash
2. On your Mac:
   - Open System Settings → Bluetooth
   - Look for "Pro Controller"
   - Click "Connect"
3. Once connected, player LED 1 will be lit
4. Launch RetroBat to verify controller is detected

## Controller Configuration in EmulationStation

### Initial Setup

When you first launch EmulationStation with a controller connected:

1. EmulationStation will prompt you to configure the controller
2. Follow the on-screen instructions to map each button
3. Button mapping sequence:
   - D-Pad Up, Down, Left, Right
   - Start, Select
   - A, B, X, Y
   - L shoulder, R shoulder
   - L trigger, R trigger (if available)
   - L analog stick (Up, Down, Left, Right)
   - R analog stick (Up, Down, Left, Right)
   - L stick button, R stick button (if available)
   - Hotkey button (usually Select/Share)

### Recommended Button Mappings

#### Xbox Layout
- A: Confirm/Select
- B: Back/Cancel
- X: Special function
- Y: Special function
- Start: Pause menu
- Back/View: Back
- Guide/Xbox: EmulationStation menu
- LB/RB: Page navigation
- LT/RT: Quick selection
- Left Stick: Navigation
- Right Stick: Additional navigation

#### PlayStation Layout
- Cross (X): Confirm/Select
- Circle: Back/Cancel
- Square: Special function
- Triangle: Special function
- Options: Pause menu
- Share/Create: Back
- PS: EmulationStation menu
- L1/R1: Page navigation
- L2/R2: Quick selection
- Left Stick: Navigation
- Right Stick: Additional navigation

#### Nintendo Layout
- B (bottom): Confirm/Select
- A (right): Back/Cancel
- Y (left): Special function
- X (top): Special function
- Plus (+): Pause menu
- Minus (-): Back
- Home: EmulationStation menu
- L/R: Page navigation
- ZL/ZR: Quick selection
- Left Stick: Navigation
- Right Stick: Additional navigation

## Controller Configuration in RetroArch

RetroArch uses its own controller configuration system that works alongside SDL3.

### Auto-Configuration

RetroArch automatically detects and configures most controllers using the gamecontrollerdb.txt file. The macOS-specific mapping file is located at:

```
system/tools/macos/gamecontrollerdb.txt
```

### Manual Configuration

If you need to manually configure a controller in RetroArch:

1. Launch RetroArch
2. Navigate to Settings → Input → Port 1 Controls
3. Select "Set All Controls"
4. Follow the prompts to map each button
5. Save the configuration

### RetroArch Hotkeys

Default hotkey configuration for macOS:

- **Select/Share + Start**: Exit emulator
- **Select/Share + R1**: Save state
- **Select/Share + L1**: Load state
- **Select/Share + R2**: Increase save slot
- **Select/Share + L2**: Decrease save slot
- **Select/Share + Up**: Volume up
- **Select/Share + Down**: Volume down
- **Select/Share + Right**: Fast forward
- **Select/Share + Left**: Rewind (if enabled)
- **Select/Share + A/X**: RetroArch menu toggle

## Multiple Controllers

RetroBat supports up to 4 controllers simultaneously for multiplayer gaming.

### Configuration

1. Connect all controllers (USB or Bluetooth)
2. Launch EmulationStation
3. Configure each controller individually:
   - Hold a button on Controller 1 → Configure
   - Hold a button on Controller 2 → Configure
   - Repeat for all controllers

### Controller Order

Controllers are assigned in the order they are detected:
- First connected = Player 1
- Second connected = Player 2
- Third connected = Player 3
- Fourth connected = Player 4

To change controller order:
1. Disconnect all controllers
2. Reconnect in desired order
3. Or use EmulationStation menu → Controllers → Configure Input

## Advanced Configuration

### Custom Controller Profiles

You can create custom controller profiles by editing:
```
system/tools/macos/gamecontrollerdb.txt
```

Add a new line with your controller's GUID and button mappings:
```
GUID,Controller Name,a:b0,b:b1,...,platform:Mac OS X,
```

### Testing Controller Input

Use the SDL3 test utility to verify button mappings:

```bash
# Install SDL3 via Homebrew
brew install sdl3

# Run the controller test utility
/opt/homebrew/bin/testcontroller
```

This utility shows:
- Connected controllers
- Button presses
- Analog stick positions
- Trigger values
- Real-time input visualization

### Controller Calibration

If your controller's analog sticks drift or triggers don't respond correctly:

1. **macOS System Calibration**:
   - System Settings → Game Controllers
   - Select your controller
   - Click "Calibrate"

2. **RetroArch Calibration**:
   - Settings → Input → Port 1 Controls
   - Adjust analog deadzone (default: 0.15)
   - Adjust analog sensitivity (default: 1.0)

### Persistent Configuration

Controller configurations are saved in:
```
~/.emulationstation/es_input.cfg          # EmulationStation
~/.config/retroarch/retroarch.cfg         # RetroArch
~/RetroBat/emulators/retroarch/config/    # RetroArch per-system configs
```

## Troubleshooting

For controller issues, see:
- [Controller Testing Guide](CONTROLLER_TESTING_MACOS.md)
- [Controller Troubleshooting Guide](CONTROLLER_TROUBLESHOOTING_MACOS.md)
- [Known Issues](CONTROLLER_KNOWN_ISSUES_MACOS.md)

## References

- [SDL3 Game Controller API](https://wiki.libsdl.org/SDL3/CategoryGamepad)
- [SDL_GameControllerDB GitHub](https://github.com/mdqinc/SDL_GameControllerDB)
- [RetroArch Controller Configuration](https://docs.libretro.com/guides/input-and-controls/)
- [EmulationStation Controller Guide](https://retropie.org.uk/docs/First-Installation/#configuring-controllers)
