# 🎮 RetroBat for macOS - User Guide

Complete guide to using RetroBat on macOS, from navigation to advanced customization.

## 📋 Table of Contents

- [EmulationStation Interface](#-emulationstation-interface)
- [Navigation](#-navigation)
- [Adding Games](#-adding-games)
- [Playing Games](#-playing-games)
- [Controller Configuration](#-controller-configuration)
- [Emulator Settings](#-emulator-settings)
- [Themes and Customization](#-themes-and-customization)
- [Game Scraping](#-game-scraping)
- [Save States](#-save-states)
- [Advanced Features](#-advanced-features)

---

## 🖥️ EmulationStation Interface

EmulationStation is the frontend that provides a unified interface for all your games and emulators.

### Main Screen Components

When you launch RetroBat, you'll see:

1. **System Carousel**: Horizontal list of game systems (NES, SNES, PlayStation, etc.)
2. **System Logo**: Large icon representing the current system
3. **Game List**: Vertical list of games for the selected system
4. **Game Metadata**: Information about the selected game (description, release date, genre)
5. **System Info**: Shows number of games, favorites, last played
6. **Background**: Themed wallpaper or video

### Status Bar

At the bottom of the screen:
- **Battery indicator** (for laptops)
- **Time and date**
- **Help prompts** showing available controls
- **System information**

---

## 🕹️ Navigation

### Basic Navigation

| Action | Keyboard | Controller |
|--------|----------|------------|
| **Move Up/Down** | Arrow Keys | D-Pad / Left Stick |
| **Move Left/Right** | Left/Right Arrows | D-Pad / Left Stick |
| **Select** | Enter | A Button |
| **Back** | Escape | B Button |
| **Menu** | F1 or S | Start Button |
| **Search** | F3 | Select + Y |
| **Favorites** | F | Y Button |
| **Random Game** | F2 | Select + A |

### System Navigation

1. **Browse Systems**:
   - Use **Left/Right** arrows to switch between systems
   - Only systems with games will be shown
   - Press **Select + Left/Right** to jump to first/last system

2. **Browse Games**:
   - Use **Up/Down** arrows to scroll through game list
   - Press **Page Up/Down** for faster scrolling
   - Use **Letter Jump**: Press a letter key to jump to games starting with that letter

3. **Quick Access**:
   - Press **Start** for main menu
   - Press **Select + Start** to restart EmulationStation
   - Press **Select + F4** to quit EmulationStation

### Main Menu Options

Press **Start** to access:

- **Scraper** - Download game metadata and artwork
- **Game Collection Settings** - Configure how games are displayed
- **Updates & Downloads** - Download emulators, themes, and updates
- **Game Settings** - Per-system or per-game configuration
- **Controllers** - Configure input devices
- **UI Settings** - Customize appearance and behavior
- **Sound Settings** - Audio configuration
- **Network Settings** - Configure WiFi and services
- **Information** - System info and BIOS check
- **Quit** - Exit options

---

## 📥 Adding Games

### Step-by-Step Guide

1. **Prepare Your ROM Files**:
   - Ensure files are in supported formats
   - Name files clearly (use No-Intro/Redump naming if possible)
   - Keep multi-disc games together

2. **Copy Files to ROM Directory**:
   ```bash
   # Example: Adding NES games
   cp ~/Downloads/*.nes ~/RetroBat/roms/nes/
   
   # Example: Adding PS1 games
   cp ~/Downloads/FinalFantasyVII/*.cue ~/RetroBat/roms/psx/
   cp ~/Downloads/FinalFantasyVII/*.bin ~/RetroBat/roms/psx/
   ```

3. **Update Game List**:
   - Press **Start** in EmulationStation
   - Select **Game Collection Settings**
   - Choose **Update Game List**
   - Wait for the scan to complete

4. **Verify Games Appear**:
   - Navigate to the system
   - Games should now be visible in the list
   - If games don't appear, check file extensions and system folder

### Supported File Formats by System

| System | Supported Formats |
|--------|-------------------|
| **NES** | .nes, .unf, .zip, .7z |
| **SNES** | .smc, .sfc, .fig, .swc, .zip, .7z |
| **Nintendo 64** | .z64, .n64, .v64, .zip, .7z |
| **GameCube** | .iso, .gcm, .gcz, .rvz, .ciso |
| **Wii** | .iso, .wbfs, .rvz, .wad |
| **Game Boy** | .gb, .gbc, .zip, .7z |
| **Game Boy Advance** | .gba, .zip, .7z |
| **Nintendo DS** | .nds, .zip, .7z |
| **Nintendo 3DS** | .3ds, .3dsx, .cia, .cci |
| **Genesis/Mega Drive** | .md, .smd, .gen, .bin, .zip |
| **Dreamcast** | .cdi, .gdi, .chd |
| **Saturn** | .cue, .bin, .mdf, .chd |
| **PlayStation** | .cue, .bin, .img, .pbp, .chd |
| **PlayStation 2** | .iso, .bin, .chd, .cso |
| **PSP** | .iso, .cso, .pbp |
| **Arcade (MAME)** | .zip (must match MAME version) |

### Multi-Disc Games

**Using M3U Playlists** (Recommended):

Create a `.m3u` file listing all discs:

```
# File: Metal Gear Solid.m3u
Metal Gear Solid (Disc 1).chd
Metal Gear Solid (Disc 2).chd
```

Place the `.m3u` file in the ROM folder with the disc images. EmulationStation will show the `.m3u` as a single game entry.

**Disc Swapping During Gameplay**:
- Open RetroArch menu (Hotkey + X)
- Navigate to **Disk Control**
- Eject current disc
- Select next disc
- Close disc tray

---

## 🎲 Playing Games

### Launching a Game

1. Navigate to the game in the list
2. Press **A** (or Enter) to launch
3. The game will start with the appropriate emulator
4. Wait for the emulator to load (first launch may take longer)

### In-Game Controls

Default RetroArch hotkeys (when using RetroArch cores):

| Function | Default Combo |
|----------|---------------|
| **Open Menu** | Hotkey + X |
| **Save State** | Hotkey + R1 |
| **Load State** | Hotkey + L1 |
| **State Slot +** | Hotkey + D-Pad Right |
| **State Slot -** | Hotkey + D-Pad Left |
| **Fast Forward** | Hotkey + R2 |
| **Rewind** | Hotkey + L2 |
| **Screenshot** | Hotkey + Triangle |
| **Reset Game** | Hotkey + Start |
| **Exit Game** | Hotkey + Select |

> **Note**: "Hotkey" is typically the **Select** button on most controllers.

### Exiting Games

- **RetroArch**: Hotkey + Select (or ESC on keyboard)
- **Standalone Emulators**: Usually ESC or Command+Q
- **Forced Exit**: Command+Option+Escape (macOS force quit)

---

## 🎮 Controller Configuration

### Initial Controller Setup

1. **Connect Your Controller**:
   - **USB**: Plug in the controller
   - **Bluetooth**: Pair through System Preferences → Bluetooth

2. **Configure in EmulationStation**:
   - EmulationStation will detect the controller automatically
   - Press any button when prompted
   - Map all requested inputs:
     - D-Pad (Up, Down, Left, Right)
     - Face Buttons (A, B, X, Y)
     - Shoulder Buttons (L1, R1, L2, R2)
     - Analog Sticks (if available)
     - Start and Select
     - Hotkey button (usually Select)

3. **Test Configuration**:
   - Navigate through EmulationStation
   - Ensure all buttons work as expected

### Supported Controllers

**Highly Compatible**:
- PlayStation 4 DualShock 4
- PlayStation 5 DualSense
- Xbox One Controller
- Xbox Series X|S Controller
- Nintendo Switch Pro Controller
- 8BitDo Controllers (SN30 Pro+, Pro 2, etc.)

**Good Compatibility**:
- Generic USB controllers
- Logitech F310/F710
- Steam Controller
- Most HID-compliant controllers

### Per-Emulator Controller Configuration

Different emulators may need specific controller setups:

1. **RetroArch Cores**:
   - Press **Start** → **Game Settings**
   - Select system → **Advanced**
   - Choose **RetroArch Configuration**
   - Map controllers in RetroArch menu

2. **Standalone Emulators**:
   - Launch a game with that emulator
   - Access emulator's native settings (varies by emulator)
   - Configure controls within the emulator

### Controller Troubleshooting

**Controller Not Detected**:
```bash
# Check if controller is recognized
ioreg -p IOUSB | grep -i game

# For Bluetooth controllers
system_profiler SPBluetoothDataType
```

**Buttons Not Working Correctly**:
- Reconfigure in EmulationStation: Start → Controllers → Configure Input
- Check for firmware updates for your controller
- Try a different USB port

**Analog Stick Drift**:
- Adjust deadzone: Start → Game Settings → Controllers → Deadzone
- Clean the controller or replace analog modules

---

## ⚙️ Emulator Settings

### Global Emulator Settings

Configure default behavior for all emulators:

1. Press **Start** → **Game Settings**
2. Select **Global** or **System-Specific** settings
3. Available options:
   - **Video Mode**: Resolution and aspect ratio
   - **Smooth Games**: Enable filtering/anti-aliasing
   - **Shaders**: Apply CRT, scanline, or other visual effects
   - **Integer Scale**: Pixel-perfect scaling
   - **Bezels**: Add decorative borders
   - **Rewind**: Enable rewind functionality
   - **Auto Save/Load**: Automatic save state management

### Per-System Settings

Customize settings for specific systems:

1. Navigate to a system (e.g., SNES)
2. Press **Start** → **Game Settings**
3. Select **This System** or select the system name
4. Configure:
   - **Emulator**: Choose preferred emulator
   - **Core**: Select emulator core (for RetroArch)
   - **Video settings**: System-specific visual options
   - **Audio settings**: Volume, latency
   - **Aspect ratio**: 4:3, 16:9, original, etc.

### Per-Game Settings

Override settings for individual games:

1. Select a game
2. Press **Start** → **Game Settings**
3. Select **This Game**
4. Configure game-specific options
5. Settings are saved per-game

### RetroArch Advanced Configuration

For RetroArch cores, you can access advanced settings:

1. Launch a game using RetroArch
2. Press **Hotkey + X** to open RetroArch menu
3. Navigate to:
   - **Quick Menu → Options**: Core-specific options
   - **Settings → Video**: Advanced video settings
   - **Settings → Audio**: Audio latency and driver
   - **Settings → Input**: Controller remapping
   - **Settings → Latency**: Reduce input lag

4. **Save Configuration**:
   - Quick Menu → Overrides → Save Game Override
   - Quick Menu → Overrides → Save Core Override
   - Configuration File → Save Current Configuration

### Popular Emulator Settings

**Dolphin (GameCube/Wii)**:
- Graphics: Enable "Compile Shaders Before Starting"
- Audio: Set backend to "Cubeb" for best compatibility
- GameCube: Enable progressive scan
- Wii: Configure Wii Remote via Controllers menu

**PCSX2 (PlayStation 2)**:
- Graphics: Use "Vulkan" renderer for best performance
- System: Set "EE Cycle Rate" to -1 for speed boost (if needed)
- Audio: Enable "Synchronization Mode"

**PPSSPP (PSP)**:
- Graphics: Enable "Buffered Rendering"
- System: Set CPU Clock to 333 MHz (default)
- Display: Enable "Display Stretched" for fullscreen

---

## 🎨 Themes and Customization

### Installing Themes

1. **Browse Available Themes**:
   - Press **Start** → **Updates & Downloads**
   - Select **Theme Downloader**
   - Browse available themes

2. **Install a Theme**:
   - Select theme from the list
   - Press **A** to download and install
   - Wait for installation to complete

3. **Apply Theme**:
   - Press **Start** → **UI Settings**
   - Select **Theme Set**
   - Choose installed theme
   - Restart EmulationStation to apply

### Popular Themes

- **Carbon** - Clean, modern design (default)
- **ES Theme Carbon** - Enhanced Carbon variant
- **Art Book** - Magazine/book style layout
- **Magazinemadness** - Retro gaming magazine aesthetic
- **NSO Menu Interpreted** - Nintendo Switch Online style
- **Pixel** - Retro pixel art theme
- **Switch Dual** - Nintendo Switch inspired

### Manual Theme Installation

Download themes from [EmulationStation Themes](https://github.com/topics/emulationstation-theme):

```bash
# Download theme to themes directory
cd ~/.emulationstation/themes/
git clone https://github.com/user/theme-name.git

# Or extract downloaded theme
unzip theme-name.zip -d ~/.emulationstation/themes/
```

### Customizing the UI

**UI Settings** (Start → UI Settings):

- **Theme Set**: Choose theme
- **Transition Style**: Slide, fade, instant
- **UI Mode**: Basic, Kiosk, Full
- **Random System**: Enable/disable random system selection
- **Carousel Transitions**: Instant or animated
- **Quick System Select**: Show/hide system menu
- **On-Screen Help**: Show button help text

**Game List View Options**:
- **Automatic**: Let theme decide
- **Detailed**: Shows game details, image, description
- **Video**: Shows gameplay videos (if available)
- **Basic**: Simple list view
- **Grid**: Thumbnail grid view

### Customizing Game Lists

**Game Collection Settings** (Start → Game Collection Settings):

- **Sort Games By**: Name, rating, release date, etc.
- **Filter**: Hide games by various criteria
- **Custom Collections**: Create themed collections
  - Favorites
  - Last Played
  - Genre-based (Action, RPG, Puzzle, etc.)
  - Custom tags

**Creating Custom Collections**:
1. Start → Game Collection Settings → Create New Custom Collection
2. Name your collection (e.g., "Multiplayer", "Completed", "Top 10")
3. Press **Y** on games to add them to the collection
4. Access from the main system carousel

---

## 📦 Game Scraping

Scraping downloads game metadata, box art, screenshots, and videos.

### Using the Built-in Scraper

1. **Access Scraper**:
   - Press **Start** → **Scraper**

2. **Choose Scraper Source**:
   - **ScreenScraper**: Most comprehensive (requires free account)
   - **TheGamesDB**: Good alternative, no account needed
   - **ArcadeDB**: Best for arcade games

3. **Configure Scraper Options**:
   - **Image Source**: Box art, screenshot, marquee, etc.
   - **Download Videos**: Enable to get gameplay videos
   - **Download Ratings**: Get community ratings
   - **Scrape These Systems**: Select which systems to scrape
   - **Scrape These Games**: All games or filter specific games

4. **Start Scraping**:
   - Select **Start**
   - Scraper will process each game
   - Large collections may take a while

5. **Review Results**:
   - Scraped data appears in game list
   - Images and videos are downloaded to:
     ```
     ~/.emulationstation/downloaded_images/
     ~/.emulationstation/downloaded_videos/
     ```

### Manual Scraping

For individual games that fail automatic scraping:

1. Select game in list
2. Press **Start** → **Scraper**
3. Select **Scrape This Game**
4. Choose from results if multiple matches
5. Confirm download

### ScreenScraper Account (Recommended)

1. Create free account at [screenscraper.fr](https://www.screenscraper.fr)
2. In EmulationStation:
   - Start → Scraper → Scraper Settings
   - Enter username and password
3. Benefits:
   - Higher scraping limits
   - Faster speeds
   - More accurate results
   - Support the service

### Editing Game Metadata Manually

1. Select a game
2. Press **Start** → **Edit This Game's Metadata**
3. Edit:
   - Name
   - Description
   - Release Date
   - Developer/Publisher
   - Genre
   - Players (1-4+)
   - Rating
   - Image/Video paths
4. Save changes

---

## 💾 Save States

Save states let you save and load your exact position in a game.

### Creating Save States

**During Gameplay** (RetroArch):
1. Press **Hotkey + R1** to save state
2. Current state slot is saved
3. On-screen notification confirms save

**Through RetroArch Menu**:
1. Press **Hotkey + X** to open menu
2. Navigate to **Quick Menu → Save State**
3. Choose **Save State** or select slot first

### Loading Save States

**During Gameplay** (RetroArch):
1. Press **Hotkey + L1** to load state
2. Game loads from current slot

**Through RetroArch Menu**:
1. Open RetroArch menu (Hotkey + X)
2. Quick Menu → Load State
3. Select slot to load

### Managing State Slots

- **Switch Slot**: Hotkey + D-Pad Left/Right
- **10 slots available** per game (0-9)
- States are saved per-game and per-core

**Save State Locations**:
```
~/RetroBat/saves/[system]/[emulator]/
```

### Auto Save/Load

Enable automatic save states:

1. Press **Start** → **Game Settings**
2. Select system or global settings
3. Enable **Auto Save/Load State**
4. Game automatically saves when exiting
5. Game automatically loads last state when launching

### Backup Save States

Regularly backup your saves:

```bash
# Backup all saves
cp -r ~/RetroBat/saves/ ~/RetroBat/saves_backup_$(date +%Y%m%d)/

# Backup specific system
cp -r ~/RetroBat/saves/snes/ ~/Backups/snes_saves/
```

---

## 🚀 Advanced Features

### NetPlay (Online Multiplayer)

Play retro games online with friends using RetroArch NetPlay:

1. **Enable NetPlay**:
   - Launch game in RetroArch
   - Hotkey + X → Quick Menu → NetPlay
   - Enable NetPlay

2. **Host a Game**:
   - NetPlay → Start Hosting
   - Share your IP address with friends
   - Friends can connect to your session

3. **Join a Game**:
   - NetPlay → Connect to NetPlay Host
   - Enter host's IP address
   - Press Connect

**Requirements**:
- Both players need same game ROM
- Same RetroArch core version
- Stable internet connection (low latency preferred)

### Shaders and Visual Effects

Apply CRT, scanline, and other visual effects:

1. **Access Shaders** (In RetroArch):
   - Hotkey + X → Quick Menu → Shaders
   - Select **Load Shader Preset**

2. **Popular Shader Presets**:
   - **CRT-Geom**: Realistic CRT monitor simulation
   - **Scanlines**: Classic arcade scanline effect
   - **LCD**: Game Boy LCD effect
   - **xBR/HqX**: Advanced scaling algorithms
   - **NTSC**: VHS/analog TV effect

3. **Apply and Save**:
   - After selecting shader, press **Apply**
   - Save with: Quick Menu → Shaders → Save Game/Core Preset

### Achievements (RetroAchievements)

Enable RetroAchievements for supported games:

1. **Create Account**:
   - Visit [retroachievements.org](https://retroachievements.org)
   - Register for free

2. **Configure in RetroArch**:
   - Settings → Achievements
   - Enable Achievements
   - Enter username and API key
   - Configure notification settings

3. **Play and Earn**:
   - Launch supported game
   - Earn achievements as you play
   - Track progress on RetroAchievements website

**Supported Systems**:
- NES, SNES, Game Boy, GBA, Genesis, and many more
- Check RetroAchievements website for full list

### Game Collections and Favorites

**Mark Favorites**:
- Select game → Press **Y** (or F on keyboard)
- Star icon appears on game
- Access favorites from "Favorites" collection

**Create Custom Collections**:
1. Start → Game Collection Settings
2. Create New Custom Collection
3. Name collection (e.g., "Beat 'Em Ups", "Co-op Games")
4. Press Y on games to add to collection
5. Collection appears in system carousel

### Kiosk Mode

Lock down EmulationStation for public use:

1. Start → UI Settings → UI Mode → Kiosk
2. Hides configuration options
3. Prevents users from changing settings
4. Exit Kiosk: Press Up, Up, Down, Down, Left, Right, Left, Right

### Command Line Launch

Launch games directly from terminal:

```bash
# Launch specific game
/Applications/RetroBat.app/Contents/MacOS/RetroBat --rom "/path/to/game.nes" --system nes

# Launch with specific emulator
/Applications/RetroBat.app/Contents/MacOS/RetroBat --rom "/path/to/game.sfc" --system snes --emulator snes9x
```

---

## 📚 Additional Resources

### Documentation
- [Installation Guide](INSTALL_MACOS.md) - Initial setup
- [Troubleshooting Guide](TROUBLESHOOTING_MACOS.md) - Common issues
- [FAQ](MACOS_FAQ.md) - Frequently asked questions
- [Architecture](ARCHITECTURE.md) - Technical details

### Community Resources
- [RetroBat Wiki](https://wiki.retrobat.org/) - Official wiki
- [RetroBat Forum](https://social.retrobat.org/forum) - Community support
- [Discord Server](https://discord.gg/GVcPNxwzuT) - Live chat
- [GitHub Repository](https://github.com/bayramog/retrobat-macos) - Source code

### External Resources
- [Libretro Docs](https://docs.libretro.com/) - RetroArch documentation
- [EmulationStation Guide](https://retropie.org.uk/docs/EmulationStation/) - General ES documentation
- [RetroAchievements](https://retroachievements.org) - Achievement tracking

---

## 💡 Tips and Tricks

### Performance Optimization
- Use RetroArch's threaded video option for better performance
- Enable "Hard GPU Sync" for reduced latency
- Lower resolution or disable shaders if experiencing slowdown
- Close other applications while playing demanding games

### Organization Best Practices
- Use descriptive ROM names
- Keep game collections under 1000 games per system for best performance
- Regularly backup your saves and configs
- Use CHD format for disc-based games (smaller size, better performance)

### Quality of Life Improvements
- Enable "Show Battery Indicator" for laptops
- Use "Quick System Select" for large collections
- Set up "Last Played" collection for easy access
- Configure "Random Game" hotkey for discovery
- Enable game videos for better browsing experience

---

**Need more help?** Check [TROUBLESHOOTING_MACOS.md](TROUBLESHOOTING_MACOS.md) or [MACOS_FAQ.md](MACOS_FAQ.md)
