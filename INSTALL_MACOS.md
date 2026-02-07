# 🍎 RetroBat for macOS - Installation Guide

This guide will walk you through installing RetroBat on your macOS system.

## 📋 Table of Contents

- [System Requirements](#-system-requirements)
- [Prerequisites](#-prerequisites)
- [Installation Methods](#-installation-methods)
- [First-Time Setup](#-first-time-setup)
- [ROM Organization](#-rom-organization)
- [BIOS Files](#-bios-files)
- [Next Steps](#-next-steps)

---

## 💻 System Requirements

### Minimum Requirements

| Component | Requirement |
|-----------|-------------|
| **Operating System** | macOS 12 (Monterey) or later |
| **Processor** | Apple Silicon (M1, M2, M3, M4) - ARM64 only |
| **Memory** | 8 GB RAM minimum, 16 GB recommended |
| **Storage** | 20 GB free space minimum (more recommended for games) |
| **Graphics** | Apple GPU with Metal support (built into all Apple Silicon chips) |
| **Internet** | Required for initial setup and emulator downloads |

### Recommended Configuration

- **macOS 13 (Ventura)** or later for best compatibility
- **16 GB RAM** or more for modern emulators (PS3, Switch, Wii U)
- **SSD storage** for better game loading performance
- **100+ GB free space** for game libraries and emulator cores

> **⚠️ Important**: Intel-based Macs (x86_64) are **not supported**. This version is optimized exclusively for Apple Silicon.

---

## 🔧 Prerequisites

Before installing RetroBat, you need to install the following dependencies:

### 1. Install Homebrew (if not already installed)

Homebrew is the package manager for macOS. Open **Terminal** and run:

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

Follow the on-screen instructions to complete the installation.

### 2. Install Xcode Command Line Tools

These tools provide essential development utilities:

```bash
xcode-select --install
```

A dialog will appear. Click **Install** and wait for the download to complete.

### 3. Install Required Dependencies

Install all necessary dependencies using Homebrew:

```bash
# Core utilities
brew install p7zip wget curl git

# SDL libraries (required for EmulationStation)
brew install sdl2

# .NET Runtime (required for RetroBat tools)
brew install --cask dotnet-sdk
```

### 4. Verify Installation

To verify all dependencies are installed correctly, run:

```bash
# Check Homebrew
brew --version

# Check p7zip
7z

# Check wget
wget --version

# Check .NET
dotnet --version
```

---

## 📦 Installation Methods

RetroBat for macOS can be installed in two ways:

### Method 1: DMG Installer (Recommended for Most Users)

This is the easiest method for end users.

1. **Download the latest release**:
   - Visit the [Releases page](https://github.com/bayramog/retrobat-macos/releases)
   - Download the latest `RetroBat-macOS-vX.X.X.dmg` file

2. **Mount the DMG**:
   - Double-click the downloaded `.dmg` file
   - A new window will open showing the RetroBat application

3. **Install RetroBat**:
   - Drag the **RetroBat.app** icon to the **Applications** folder
   - Wait for the copy to complete

4. **Remove Quarantine (First Launch)**:
   ```bash
   # Run this command in Terminal to allow the app to open
   xattr -dr com.apple.quarantine /Applications/RetroBat.app
   ```

5. **Launch RetroBat**:
   - Open **Finder** → **Applications**
   - Double-click **RetroBat**
   - If macOS asks for permission, click **Open**

### Method 2: PKG Installer

Alternative installation method using a standard macOS installer package.

1. **Download the PKG installer**:
   - Visit the [Releases page](https://github.com/bayramog/retrobat-macos/releases)
   - Download `RetroBat-macOS-vX.X.X.pkg`

2. **Run the installer**:
   - Double-click the `.pkg` file
   - Follow the installation wizard
   - Enter your administrator password when prompted

3. **Launch RetroBat**:
   - The installer will place RetroBat in `/Applications`
   - Open from **Launchpad** or **Finder**

### Method 3: Build from Source (Developers)

For developers who want to build RetroBat from source code:

1. **Clone the repository**:
   ```bash
   git clone https://github.com/bayramog/retrobat-macos.git
   cd retrobat-macos
   ```

2. **Install all dependencies**:
   ```bash
   brew bundle
   ```

3. **Build RetroBat**:
   ```bash
   # Build RetroBuild tool
   cd src/RetroBuild
   dotnet build -c Release
   
   # Build EmulatorLauncher
   cd ../EmulatorLauncher.Core
   dotnet build -c Release
   ```

4. **Run the build script**:
   ```bash
   cd ../..
   ./build-macos.sh
   ```

For complete build instructions, see [INSTALL.md](INSTALL.md).

---

## 🎮 First-Time Setup

After installing RetroBat, follow these steps to complete the setup:

### 1. Launch RetroBat

- Open RetroBat from **Applications** folder
- The first launch may take longer as it initializes the configuration

### 2. Initial Configuration Wizard

On first launch, RetroBat will:

1. **Create User Directories**:
   - `~/RetroBat/` - Main user directory
   - `~/RetroBat/roms/` - Game ROM files
   - `~/RetroBat/saves/` - Save states and save files
   - `~/RetroBat/screenshots/` - Screenshots
   - `~/Library/Application Support/RetroBat/` - Configuration files

2. **Download EmulationStation** (if not bundled):
   - EmulationStation is the frontend interface
   - This may take a few minutes depending on your connection

3. **Configure Basic Settings**:
   - Language selection
   - Screen resolution
   - Input device detection

### 3. Configure Controllers

1. **Connect your controller**:
   - USB controllers: Simply plug in
   - Bluetooth controllers: Pair through **System Preferences** → **Bluetooth**

2. **Configure in EmulationStation**:
   - Press any button on your controller
   - Follow the on-screen prompts to map buttons
   - Map at least: D-pad, A/B buttons, Start, Select

3. **Supported controllers**:
   - PlayStation 4/5 DualShock/DualSense
   - Xbox One/Series controllers
   - Nintendo Switch Pro Controller
   - 8BitDo controllers
   - Generic USB/Bluetooth controllers

For detailed controller configuration, see [MACOS_USER_GUIDE.md](MACOS_USER_GUIDE.md#controller-configuration).

### 4. Install Emulators (Optional)

RetroBat can automatically download and install emulators:

1. Open EmulationStation
2. Press **Start** → **Updates & Downloads**
3. Select **Download Emulators**
4. Choose emulators for systems you want to play
5. Wait for downloads to complete

Alternatively, install emulators manually:
- Download from official sources
- Place in `/Applications` directory
- RetroBat will auto-detect them

Common emulators:
- **RetroArch** - Multi-system emulator (NES, SNES, Genesis, PS1, etc.)
- **Dolphin** - GameCube & Wii
- **PCSX2** - PlayStation 2
- **PPSSPP** - PlayStation Portable
- **Citra/Lime3DS** - Nintendo 3DS

For a complete list, see [MACOS_EMULATOR_COMPATIBILITY.md](docs/MACOS_EMULATOR_COMPATIBILITY.md).

---

## 📂 ROM Organization

Proper ROM organization ensures RetroBat can find and launch your games.

### Directory Structure

RetroBat expects ROMs in the following structure:

```
~/RetroBat/roms/
├── nes/              # Nintendo Entertainment System
├── snes/             # Super Nintendo
├── n64/              # Nintendo 64
├── gamecube/         # Nintendo GameCube
├── wii/              # Nintendo Wii
├── gb/               # Game Boy
├── gba/              # Game Boy Advance
├── nds/              # Nintendo DS
├── 3ds/              # Nintendo 3DS
├── genesis/          # Sega Genesis/Mega Drive
├── dreamcast/        # Sega Dreamcast
├── saturn/           # Sega Saturn
├── psx/              # PlayStation 1
├── ps2/              # PlayStation 2
├── psp/              # PlayStation Portable
├── arcade/           # Arcade (MAME/FBNeo)
├── mame/             # MAME ROMs
└── [other systems]/
```

### Adding ROMs

1. **Locate your ROM files**:
   - Legal backups of games you own
   - Homebrew games
   - Public domain games

2. **Copy ROMs to the appropriate folder**:
   ```bash
   # Example: Adding SNES games
   cp /path/to/your/games/*.smc ~/RetroBat/roms/snes/
   ```

3. **Supported formats vary by system**:
   - **NES**: `.nes`, `.unf`, `.zip`
   - **SNES**: `.smc`, `.sfc`, `.zip`
   - **N64**: `.z64`, `.n64`, `.v64`
   - **PS1**: `.cue`, `.bin`, `.chd`, `.pbp`
   - **PS2**: `.iso`, `.cso`, `.chd`
   - **GameCube/Wii**: `.iso`, `.wbfs`, `.rvz`, `.gcm`

4. **Refresh game list**:
   - In EmulationStation, press **Start**
   - Select **Game Collection Settings**
   - Choose **Update Game List**

### ROM Naming Conventions

For best compatibility:
- Use descriptive names: `Super Mario World (USA).smc`
- Avoid special characters: `< > : " / \ | ? *`
- Keep region tags: `(USA)`, `(Europe)`, `(Japan)`
- Use No-Intro or Redump naming conventions when possible

### Multi-Disc Games

For games with multiple discs (PS1, PS2, Dreamcast):

**Method 1: M3U Playlist**
```
# Create a file: Final Fantasy VII.m3u
Final Fantasy VII (Disc 1).chd
Final Fantasy VII (Disc 2).chd
Final Fantasy VII (Disc 3).chd
```

**Method 2: CHD Format**
- Convert multi-disc games to CHD format
- Reduces file size and improves loading

---

## 🔧 BIOS Files

Many emulators require BIOS files to function properly.

### BIOS Directory

Place BIOS files in:
```
~/RetroBat/bios/
```

Or in the application bundle:
```
/Applications/RetroBat.app/Contents/Resources/bios/
```

### Required BIOS Files by System

| System | Files Needed | Notes |
|--------|-------------|-------|
| **PlayStation 1** | `scph5501.bin`, `scph5502.bin`, `scph7001.bin` | USA/Europe/Japan BIOS |
| **PlayStation 2** | `ps2-0200a-20040614.bin`, `ps2-0220a-20050620.bin` | USA/Europe BIOS |
| **Sega Saturn** | `saturn_bios.bin`, `mpr-17933.bin` | Japan/USA BIOS |
| **Sega Dreamcast** | `dc_boot.bin`, `dc_flash.bin` | Required for boot |
| **GameBoy Advance** | `gba_bios.bin` | Optional but recommended |
| **Nintendo DS** | `bios7.bin`, `bios9.bin`, `firmware.bin` | Required for some games |
| **Neo Geo** | `neogeo.zip` | Contains all required files |
| **Arcade (MAME)** | Various | Depends on ROM set version |

### Verifying BIOS Files

1. **Check BIOS status in EmulationStation**:
   - Press **Start** → **Information**
   - Select **BIOS Check**
   - View missing files

2. **Check file checksums**:
   ```bash
   # Example: PS1 BIOS verification
   md5 ~/RetroBat/bios/scph5501.bin
   # Should match: 490f666e1afb15b7362b406ed1cea246
   ```

3. **RetroArch BIOS check**:
   - Open RetroArch from EmulationStation
   - Go to **Main Menu** → **Online Updater**
   - Select **System Files Status**

### Obtaining BIOS Files

> **⚠️ Legal Notice**: BIOS files are copyrighted material. You should only use BIOS files from systems you legally own.

- Extract from your own consoles using homebrew tools
- Purchase from legitimate sources
- Check community homebrew archives for public domain alternatives

**Do NOT share or distribute BIOS files**. This violates copyright law.

---

## 🎯 Next Steps

Now that RetroBat is installed, you can:

1. **📚 Read the User Guide**: [MACOS_USER_GUIDE.md](MACOS_USER_GUIDE.md)
   - Learn EmulationStation navigation
   - Configure advanced settings
   - Customize themes and appearance

2. **🎮 Add Your Games**: 
   - Copy ROMs to `~/RetroBat/roms/[system]/`
   - Add required BIOS files
   - Refresh the game list

3. **⚙️ Configure Controllers**:
   - Map buttons for each emulator
   - Set up hotkeys
   - Configure analog sensitivity

4. **🎨 Customize Your Experience**:
   - Download themes
   - Configure scraper for game artwork
   - Set up game collections

5. **❓ Get Help if Needed**: [TROUBLESHOOTING_MACOS.md](TROUBLESHOOTING_MACOS.md)
   - Common installation issues
   - Performance optimization
   - Emulator-specific problems

---

## 🆘 Getting Help

If you encounter issues during installation:

1. **Check the FAQ**: [MACOS_FAQ.md](MACOS_FAQ.md)
2. **Review Troubleshooting Guide**: [TROUBLESHOOTING_MACOS.md](TROUBLESHOOTING_MACOS.md)
3. **GitHub Issues**: [Report a bug](https://github.com/bayramog/retrobat-macos/issues)
4. **Discord**: Join the [RetroBat Discord](https://discord.gg/GVcPNxwzuT)
5. **Forums**: Visit the [RetroBat Forum](https://social.retrobat.org/forum)

---

## 📄 License & Legal

RetroBat is free and open-source software (LGPL v3). It should not be used for commercial purposes.

**Important**:
- RetroBat does not include copyrighted games or BIOS files
- You must own the games and systems you emulate
- Downloading ROMs for games you don't own is illegal
- See [LICENSE](license.txt) for full terms

---

**Ready to play?** Continue to [MACOS_USER_GUIDE.md](MACOS_USER_GUIDE.md) →
