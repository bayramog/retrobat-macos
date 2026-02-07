# ❓ RetroBat for macOS - Frequently Asked Questions

Common questions and answers about RetroBat on macOS.

## 📋 Table of Contents

- [General Questions](#-general-questions)
- [Compatibility Questions](#-compatibility-questions)
- [Installation & Setup](#-installation--setup)
- [Performance & Optimization](#-performance--optimization)
- [Games & ROMs](#-games--roms)
- [Controllers & Input](#-controllers--input)
- [Features & Functionality](#-features--functionality)
- [Legal & Ethics](#-legal--ethics)
- [Feature Requests](#-feature-requests)

---

## 🌟 General Questions

### What is RetroBat?

RetroBat is a unified frontend for retro gaming emulators that simplifies installation, configuration, and management of EmulationStation and 50+ emulators. It provides a beautiful interface for browsing and playing games from dozens of classic gaming systems.

### Is RetroBat the same as RetroPie or Batocera?

No, but they're similar:
- **RetroPie**: Raspberry Pi focused, Linux-based
- **Batocera**: Standalone Linux OS for retro gaming
- **RetroBat**: Application that runs on Windows and macOS, not a standalone OS

RetroBat provides similar functionality but as a regular application on your existing operating system.

### Is RetroBat free?

Yes! RetroBat is completely free and open-source software (LGPL v3 license). However:
- ❌ **Not for commercial use**
- ❌ **Cannot be sold pre-installed**
- ✅ **Free for personal use**
- ✅ **Open source and modifiable**

### How is the macOS version different from Windows?

The macOS version:
- **Native ARM64** for Apple Silicon (M1/M2/M3/M4)
- Uses **Homebrew** for dependencies instead of bundled Windows executables
- Follows **macOS conventions** for file locations and app structure
- **Same features** and user experience as Windows version
- **Same EmulationStation frontend** with identical interface

### Can I use my Windows RetroBat installation on macOS?

Not directly, but you can transfer data:
- ✅ **ROMs**: Copy to `~/RetroBat/roms/`
- ✅ **BIOS files**: Copy to `~/RetroBat/bios/`
- ✅ **Save files**: May work if compatible with macOS emulator versions
- ⚠️ **Configurations**: Need adjustment (different paths and emulator locations)
- ❌ **Emulators**: Must use macOS versions

### Is this an official RetroBat project?

This is a **community-maintained port** to macOS. The original RetroBat is developed by the official RetroBat Team for Windows. This port maintains the same spirit and feature set while adapting to macOS.

---

## 🖥️ Compatibility Questions

### What Macs are supported?

**Supported**:
- ✅ Mac mini (M1/M2/M4, 2020+)
- ✅ MacBook Air (M1/M2/M3, 2020+)
- ✅ MacBook Pro (M1/M2/M3/M4 Pro/Max/Ultra, 2020+)
- ✅ iMac (M1/M3, 2021+)
- ✅ Mac Studio (M1/M2 Max/Ultra, 2022+)
- ✅ Mac Pro (M2 Ultra, 2023+)

**Minimum**: macOS 12 (Monterey) or later

**Not Supported**:
- ❌ Intel-based Macs (x86_64)
- ❌ macOS 11 (Big Sur) or earlier
- ❌ 32-bit systems (no longer exists on macOS)

### Will you support Intel Macs?

No current plans. Intel Mac support would require:
- Maintaining two separate builds (ARM64 and x86_64)
- Finding Intel-compatible emulators (many are Apple Silicon only)
- Testing on older hardware
- Apple is phasing out Intel support

Focus is on Apple Silicon for the future.

### Which emulators work on macOS?

Most popular emulators have macOS ARM64 versions:

**Excellent Support** (Native ARM64):
- RetroArch (multi-system)
- Dolphin (GameCube/Wii)
- PPSSPP (PSP)
- DuckStation (PS1)
- melonDS (Nintendo DS)
- mGBA (Game Boy Advance)
- Snes9x (SNES)
- MAME (Arcade)

**Good Support** (Available but may require Rosetta):
- PCSX2 (PS2) - Native ARM in development
- RPCS3 (PS3) - Experimental ARM support
- Citra/Lime3DS (3DS)
- Cemu (Wii U) - Native ARM in development

**Limited/No Support**:
- Xenia (Xbox 360) - Windows only
- RCPS3 (PS3) - Limited macOS support
- Yuzu/Sudachi (Switch) - Legal issues, limited support

For a complete list, see the [Emulator Compatibility Document](docs/MACOS_EMULATOR_COMPATIBILITY.md).

### Can I play Nintendo Switch games?

**Legally and technically complex**:
- Emulators: Yuzu (discontinued), Ryujinx (active), Sudachi (fork)
- ⚠️ **Legal gray area** - Nintendo actively pursues emulator developers
- Requires dumping keys from **your own Switch** (illegal to share)
- Performance depends on game and your Mac specs
- **Not officially supported** but may work

We recommend focusing on older systems with established emulation.

### What about PS3, Xbox 360, or newer systems?

**PS3 (RPCS3)**:
- ⚠️ Experimental macOS support
- Requires powerful Mac (M1 Pro/Max or better)
- Many games don't work or run poorly
- Expect issues

**Xbox 360 (Xenia)**:
- ❌ Windows only
- No macOS version available
- Unlikely to come to macOS

**PS4/Xbox One**:
- ❌ No viable emulators yet
- Too new for reliable emulation

---

## 🔧 Installation & Setup

### Do I need Xcode installed?

**No**, you only need **Xcode Command Line Tools**:
```bash
xcode-select --install
```

The full Xcode IDE (10+ GB) is **not required** unless you're developing.

### Why do I need Homebrew?

Homebrew provides essential tools that RetroBat needs:
- `p7zip` - Extract game archives
- `wget` - Download files
- `sdl2` - Graphics and controller support
- `.NET SDK` - Run RetroBat tools

macOS doesn't include these by default, so Homebrew makes installation easy.

### Can I install RetroBat without Homebrew?

Theoretically yes, but **not recommended**:
- You'd need to manually compile and install all dependencies
- Much more complex and error-prone
- No official support for this method

Just use Homebrew - it's the standard for macOS package management.

### Where does RetroBat store files?

**Application**:
```
/Applications/RetroBat.app/
```

**User Data**:
```
~/RetroBat/
├── roms/          # Your game files
├── bios/          # BIOS files
├── saves/         # Save states
├── screenshots/   # Screenshots
└── themes/        # Custom themes
```

**Configuration**:
```
~/.emulationstation/       # EmulationStation config
~/Library/Application Support/RetroBat/  # App settings
~/.config/retroarch/       # RetroArch config
```

### Can I move RetroBat to an external drive?

**Yes**, but with caveats:

1. **Application bundle** should stay in `/Applications/`
2. **User data** (`~/RetroBat/`) can be moved:
   ```bash
   # Move data to external drive
   mv ~/RetroBat /Volumes/ExternalDrive/RetroBat
   
   # Create symbolic link
   ln -s /Volumes/ExternalDrive/RetroBat ~/RetroBat
   ```

3. **External drive requirements**:
   - Format: **APFS** or **exFAT** (not NTFS)
   - Connection: **USB 3.0+** for good performance
   - Keep drive mounted and named consistently

### How much storage space do I need?

**Minimum**: 20 GB for RetroBat and a few emulators

**Recommended by collection size**:
- **Small** (few games): 50 GB
- **Medium** (100-500 games): 100-200 GB
- **Large** (1000+ games): 500 GB - 1 TB
- **Massive** (full libraries): 1-2 TB

**Size factors**:
- ROM size varies by system (NES = KB, PS2 = GB)
- Save states add minimal space (few MB per game)
- Scraped images/videos: 100-500 MB per system
- Emulators: 50 MB - 2 GB each

---

## ⚡ Performance & Optimization

### What specs do I need for good performance?

**Retro Systems** (NES, SNES, Genesis, PS1, N64):
- ✅ **Any Apple Silicon Mac** handles these easily
- Even base M1 MacBook Air is overkill

**Modern Systems** (PS2, GameCube, Wii, PSP):
- ✅ **M1/M2 base models** work well
- Some demanding games may need M1 Pro or better

**High-End Systems** (PS3, Wii U, Switch):
- ⚠️ **M1 Pro/Max or better** recommended
- M1 Ultra or M2 Ultra for best performance
- Many games still won't run at full speed

**Memory Recommendations**:
- 8 GB: Basic retro gaming (up to PS1/N64)
- 16 GB: Recommended for most users
- 32 GB+: PS3/Switch emulation, multitasking

### Why is performance worse than expected?

**Common causes**:

1. **Thermal throttling**: Check temperatures
2. **Power settings**: Use high-performance mode
3. **Background apps**: Close unnecessary programs
4. **Wrong renderer**: Try Vulkan/Metal instead of OpenGL
5. **Excessive enhancements**: Disable upscaling, shaders, etc.
6. **Outdated emulator**: Update to latest version

See [Performance section in Troubleshooting](TROUBLESHOOTING_MACOS.md#-performance-problems) for detailed solutions.

### Does RetroBat drain battery quickly?

**Depends on what you play**:

- **Retro games** (NES, SNES): 4-6 hours on MacBook
- **3D games** (N64, PS1): 3-4 hours
- **Modern systems** (PS2, GameCube): 2-3 hours
- **Demanding emulation** (PS3, Wii U): 1-2 hours

**Battery saving tips**:
- Lower screen brightness
- Disable shaders and enhancements
- Use power-efficient renderers
- Enable frame limiter
- Close background apps
- Use "Low Power Mode" in Battery settings (macOS 12+)

### Can I improve performance without upgrading hardware?

**Yes! Try these**:

1. **Optimization guide**: [Performance section](TROUBLESHOOTING_MACOS.md#-performance-problems)
2. **Use Vulkan/Metal renderers** (faster than OpenGL)
3. **Disable visual enhancements**: Shaders, upscaling, AA
4. **Update emulators**: Newer versions often faster
5. **Adjust emulator settings**: Per-system tweaking
6. **Free up RAM**: Close other applications
7. **Cool your Mac**: External cooling pad for laptops

### Should I use an external GPU (eGPU)?

**Generally not recommended for Apple Silicon**:
- Apple Silicon has **integrated GPU** optimized for the system
- eGPUs provide **minimal benefit** and add latency
- Most emulators don't take advantage of eGPUs
- Better to invest in a Mac with more powerful chip

eGPUs were more useful for Intel Macs (no longer supported).

---

## 🎮 Games & ROMs

### Where can I get ROMs?

**Legal sources**:
- ✅ Dump from your own cartridges/discs using hardware tools
- ✅ Purchase from legitimate digital stores (e.g., GOG, Steam re-releases)
- ✅ Download public domain/homebrew games from developer sites
- ✅ Backup games you legally own

**Illegal sources**:
- ❌ ROM download sites
- ❌ Torrents
- ❌ Sharing copyrighted games

**We cannot and will not provide links to pirated content.**

### Is it legal to download ROMs?

**Generally NO**, even if you own the game:
- Copyright law doesn't have a "backup copy" exemption
- Downloading is distribution (illegal in most countries)
- "Abandonware" is not a legal concept
- Nintendo, Sony, etc. actively enforce copyrights

**Legal alternatives**:
- Extract ROMs from your own cartridges
- Buy re-releases on modern platforms
- Play officially licensed collections
- Use homebrew games

**We do not condone piracy.** RetroBat is a tool; use it legally.

### What ROM formats are best?

**Recommended formats**:

| System | Best Format | Why |
|--------|-------------|-----|
| NES/SNES | `.zip` | Compressed, widely compatible |
| N64 | `.z64` | Standard format |
| GameCube/Wii | `.rvz` | Highly compressed, fast |
| PS1 | `.chd` | Compressed, single file |
| PS2 | `.chd` or `.iso` | CHD is smaller |
| PSP | `.cso` | Compressed ISO |
| Dreamcast | `.chd` | All-in-one format |
| Arcade | `.zip` | Standard for MAME |

**Why CHD?**
- **Compressed**: 30-60% smaller than ISO
- **Single file**: No .cue/.bin pairs
- **Fast**: Built-in compression is efficient
- **Widely supported**: Most emulators support it

### How do I convert ROMs to CHD?

**Using chdman** (MAME tool):

```bash
# Install chdman
brew install mame-tools

# Convert CD game (with .cue file)
chdman createcd -i game.cue -o game.chd

# Convert DVD game (ISO)
chdman createdvd -i game.iso -o game.chd

# Batch convert
for file in *.cue; do
  chdman createcd -i "$file" -o "${file%.cue}.chd"
done
```

### Can I use 7z/zip compressed ROMs?

**Depends on emulator/core**:

- ✅ **RetroArch cores**: Most support .zip/.7z
- ✅ **Cartridge systems**: Usually work compressed
- ⚠️ **Disc systems**: Often need extraction
- ❌ **Multi-file games**: Won't work compressed

**Test first** - if a compressed ROM doesn't work, extract it.

### How do I organize large ROM collections?

**Best practices**:

1. **Use consistent naming**:
   - Follow No-Intro (cartridge) or Redump (disc) naming
   - Include region: `Game Name (USA).ext`
   - Avoid special characters

2. **Folder structure**:
   ```
   ~/RetroBat/roms/
   ├── nes/
   ├── snes/
   ├── n64/
   └── [system]/
       ├── [game files]
       └── images/         # Custom artwork
   ```

3. **Scrape metadata**:
   - Use EmulationStation's scraper
   - Creates searchable database
   - Adds box art and descriptions

4. **Use collections**:
   - Genre collections (RPG, Fighting, Puzzle)
   - Custom lists (Favorites, Multiplayer)
   - "Last Played" for quick access

5. **Archive what you don't play**:
   - Move rarely-played games to external storage
   - Keep your main collection focused

---

## 🎮 Controllers & Input

### What controllers work best?

**Highly Recommended**:
1. **PlayStation 5 DualSense** - Best overall, haptics, USB-C
2. **Xbox Series X|S Controller** - Great ergonomics, reliable
3. **8BitDo Pro 2** - Versatile, multiple modes, great for retro

**Also Good**:
- PlayStation 4 DualShock 4
- Nintendo Switch Pro Controller
- 8BitDo SN30 Pro+
- Xbox One Controller

**Avoid**:
- Very cheap no-name controllers (poor quality, compatibility issues)
- Vintage controllers without adapters (need special hardware)

### Can I use original console controllers?

**Yes, with USB adapters**:

| Console | Adapter Needed | Compatibility |
|---------|----------------|---------------|
| NES/SNES | USB adapter | Good |
| N64 | Raphnet N64 adapter | Good |
| GameCube | USB adapter or Wii U adapter | Excellent |
| PS1/PS2 | USB adapter | Good |
| Xbox (original) | USB adapter | Fair |
| Wii | Mayflash DolphinBar | Good |

**Popular adapter brands**:
- Raphnet
- Mayflash
- 8BitDo (Bluetooth adapters)

### Can I use multiple controllers?

**Yes!** RetroBat supports up to **8 controllers** simultaneously (emulator-dependent):

1. Connect all controllers
2. Configure each in EmulationStation
3. Controllers assigned as Player 1, 2, 3, etc.
4. Most multiplayer games work automatically

**Multiplayer support varies**:
- 2 players: Nearly all systems
- 4 players: N64, GameCube, Wii, PS2, some PS1
- 8 players: Few games support (some PC Engine games)

### Wireless vs. Wired - which is better?

**Wired (USB)**:
- ✅ Lower latency (~1-2ms)
- ✅ No battery concerns
- ✅ No pairing issues
- ✅ More reliable
- ❌ Cable can be annoying

**Wireless (Bluetooth)**:
- ✅ Freedom of movement
- ✅ Cleaner setup
- ❌ Slight latency (+4-8ms)
- ❌ Battery management
- ❌ Occasional disconnects

**Recommendation**: Use wired for fighting games and competitive play, wireless for casual gaming.

### Can I use keyboard and mouse?

**Keyboard**: ✅ Yes, fully supported
- Configure in EmulationStation
- Works for all systems
- Good for DOS games and computers (Amiga, C64)

**Mouse**: ⚠️ Limited support
- Works for mouse-based systems (Amiga, DOS, some PS1 games)
- Not ideal for console games
- Some emulators support it (MAME for lightgun games)

### How do I fix input lag?

**Optimization steps**:

1. **Use wired controller**
2. **Enable "Run-Ahead"** in RetroArch (Settings → Latency)
3. **Reduce video buffering**: Settings → Video → Max Swapchain Images = 2
4. **Disable V-Sync** (may cause tearing)
5. **Use "Hard GPU Sync"**: Settings → Video → Hard GPU Sync = ON
6. **Lower audio latency**: Settings → Audio → Audio Latency = 32-64ms
7. **Disable unnecessary visual effects**

See [Troubleshooting Guide](TROUBLESHOOTING_MACOS.md#controller-issues) for more details.

---

## 🌟 Features & Functionality

### Can I use online multiplayer (NetPlay)?

**Yes**, via RetroArch NetPlay:

**Supported**:
- Most RetroArch cores
- NES, SNES, Genesis, PS1, N64, etc.
- Peer-to-peer connection

**Requirements**:
- Both players need same ROM (same hash)
- Same RetroArch core version
- Low latency internet connection (<50ms ideal)

**Setup**:
1. Host starts NetPlay session
2. Share IP address with friend
3. Friend connects
4. Play together!

See [User Guide - NetPlay](MACOS_USER_GUIDE.md#netplay-online-multiplayer) for detailed instructions.

### Does RetroBat support achievements?

**Yes!** Via **RetroAchievements.org**:

- Free service with 10,000+ games
- Achievements for retro games
- Leaderboards
- Social features
- Rich Presence (Discord integration)

**Setup**:
1. Create account at [retroachievements.org](https://retroachievements.org)
2. Configure in RetroArch
3. Play and earn achievements!

See [User Guide - Achievements](MACOS_USER_GUIDE.md#achievements-retroachievements).

### Can I add custom themes?

**Yes!** EmulationStation supports custom themes:

**Install themes**:
1. Built-in downloader: Start → Updates & Downloads → Theme Downloader
2. Manual install: Download and place in `~/.emulationstation/themes/`
3. Apply: Start → UI Settings → Theme Set

**Popular theme repositories**:
- [EmulationStation Themes](https://github.com/topics/emulationstation-theme)
- [RetroBat Themes](https://github.com/RetroBat-Official/es-theme-carbon)

### Can I customize per-game settings?

**Yes!** Multiple levels of configuration:

1. **Global settings**: Apply to all games
2. **Per-system settings**: Apply to all games in a system (e.g., all SNES games)
3. **Per-game settings**: Override for specific game

**Configure**:
- Select game → Start → Game Settings → This Game
- Change emulator, core, video settings, etc.
- Settings saved in game metadata

### Can I scrape custom artwork?

**Yes!** Multiple methods:

1. **Built-in scraper**: Start → Scraper
   - ScreenScraper (best, requires account)
   - TheGamesDB
   - ArcadeDB (for arcade games)

2. **Manual images**:
   - Place in `~/.emulationstation/downloaded_images/[system]/`
   - Name must match ROM name
   - Formats: .png, .jpg

3. **Edit metadata**:
   - Select game → Start → Edit This Game's Metadata
   - Point to custom image path

### Does RetroBat auto-update?

**Not yet**, but planned:

**Current method**:
1. Check [Releases page](https://github.com/bayramog/retrobat-macos/releases)
2. Download new version
3. Install over old version
4. Your data (`~/RetroBat/`) is preserved

**Future**: Auto-update feature planned for stable release.

---

## ⚖️ Legal & Ethics

### Is emulation legal?

**Emulators**: ✅ **YES**, emulators are legal
- Protected by Sony v. Bleem (2000)
- Emulators are reverse-engineered, not using copyrighted code
- Developing and using emulators is legal in most countries

**ROMs**: ⚠️ **Generally NO**
- Copyrighted material
- Downloading is copyright infringement
- No legal "backup copy" exception
- "Abandonware" is not a legal concept

**BIOS files**: ⚠️ **Generally NO**
- Also copyrighted
- Should extract from your own console
- Downloading violates copyright

### What about "abandonware" games?

**"Abandonware" is not a legal term**:
- Games are still copyrighted
- Companies may not actively enforce, but copyright exists
- No different from any other piracy legally

**Truly legal alternatives**:
- Public domain games (rare)
- Homebrew games (free, legal)
- Licensed re-releases
- Games with explicit permission from developers

### Can I stream/record gameplay?

**Generally YES**, but:

✅ **Okay**:
- Streaming homebrew games
- Recording gameplay for personal use
- Educational/commentary content (fair use)
- Games you legally own

⚠️ **Risky**:
- Streaming/monetizing copyrighted games
- Some companies (Nintendo) actively DMCA streamers
- Platform policies vary (Twitch, YouTube)

**Best practice**: Check game/publisher policies before streaming.

### Can I sell pre-loaded systems?

**NO!** ❌ Absolutely forbidden:

- Violates RetroBat license (non-commercial)
- Violates emulator licenses
- Violates game copyrights
- Illegal in most countries
- Damages the retro gaming community

**Don't buy pre-loaded systems** - they're illegal and support piracy.

### How can I support game developers?

**Ways to support legitimately**:

1. **Buy official re-releases**:
   - Nintendo Switch Online
   - PlayStation Classic collections
   - Sega Genesis Classics on Steam
   - Retro game compilations

2. **Support indie homebrew**:
   - Buy from itch.io
   - Support via Patreon
   - Spread the word

3. **Preserve legally**:
   - Dump your own games
   - Support preservation efforts
   - Contribute to documentation

4. **Buy original hardware**:
   - Support retro game stores
   - Collect original games legitimately

---

## 💡 Feature Requests

### Will you add [feature]?

Check the [GitHub Issues](https://github.com/bayramog/retrobat-macos/issues) first:
- Feature may already be planned
- Discuss with developers
- Contribute if you can code!

**Commonly requested features**:
- ✅ Planned: Auto-updates
- ✅ Planned: More theme options
- ⏳ Investigating: Cloud save sync
- ⏳ Investigating: iOS/iPadOS port
- ❌ Not planned: Intel Mac support

### Can you add [emulator]?

**Depends on**:
- Emulator has macOS ARM64 version
- Emulator license compatible
- Demand from users
- Developer time

**Request it**: Open a [GitHub Issue](https://github.com/bayramog/retrobat-macos/issues) with:
- Emulator name and link
- Systems it supports
- Why it's better than alternatives
- macOS compatibility status

### Will there be a version for older macOS?

**No current plans**:
- macOS 12+ required for modern .NET and SDL features
- Apple Silicon (M1+) is the target
- Backporting is significant work
- macOS 12 is already 3+ years old

**Recommendation**: Update to macOS 13+ for best compatibility.

### Can I contribute to the project?

**Yes! Contributions welcome**:

**Ways to help**:
1. **Code**: Submit pull requests
2. **Documentation**: Improve guides
3. **Testing**: Report bugs
4. **Design**: Create themes
5. **Support**: Help users in Discord/forums
6. **Translate**: Localize to other languages

See [CONTRIBUTING.md](https://github.com/bayramog/retrobat-macos/blob/main/CONTRIBUTING.md) for details.

### Where can I request help?

**Support channels**:

1. **Documentation**:
   - [Installation Guide](INSTALL_MACOS.md)
   - [User Guide](MACOS_USER_GUIDE.md)
   - [Troubleshooting](TROUBLESHOOTING_MACOS.md)
   - [This FAQ](MACOS_FAQ.md)

2. **GitHub Issues**: [Report bugs/requests](https://github.com/bayramog/retrobat-macos/issues)

3. **Discord**: [RetroBat Discord](https://discord.gg/GVcPNxwzuT)
   - #macos-support channel
   - Active community
   - Real-time help

4. **Forum**: [RetroBat Forum](https://social.retrobat.org/forum)
   - Detailed discussions
   - Searchable archive

### Is there a roadmap?

**Current priorities** (as of 2026):

**Phase 1** (Complete):
- ✅ Core tools migration
- ✅ Build system
- ✅ Documentation

**Phase 2** (In Progress):
- ⏳ EmulationStation port
- ⏳ Emulator compatibility
- ⏳ Beta testing

**Phase 3** (Upcoming):
- ⏳ Stable release
- ⏳ Auto-updates
- ⏳ Enhanced themes
- ⏳ Community features

**Phase 4** (Future):
- 🔮 Cloud saves
- 🔮 Mobile companion app
- 🔮 Streaming to Apple TV

See [MACOS_MIGRATION_PLAN.md](MACOS_MIGRATION_PLAN.md) for technical details.

---

## 🆘 Still Have Questions?

**Check these resources**:

1. **Documentation**:
   - [Installation Guide](INSTALL_MACOS.md)
   - [User Guide](MACOS_USER_GUIDE.md)
   - [Troubleshooting](TROUBLESHOOTING_MACOS.md)

2. **Community**:
   - [Discord Server](https://discord.gg/GVcPNxwzuT)
   - [RetroBat Forum](https://social.retrobat.org/forum)
   - [GitHub Discussions](https://github.com/bayramog/retrobat-macos/discussions)

3. **Official Sites**:
   - [RetroBat Website](https://www.retrobat.org/)
   - [RetroBat Wiki](https://wiki.retrobat.org/)
   - [GitHub Repository](https://github.com/bayramog/retrobat-macos)

**Didn't find your answer?** [Ask on Discord](https://discord.gg/GVcPNxwzuT) or [open a GitHub Discussion](https://github.com/bayramog/retrobat-macos/discussions)!

---

**Happy Retro Gaming! 🎮**
