<h1 align="left">
  <br>
  <a href="https://www.retrobat.org/"><img src="https://github.com/RetroBat-Official/retrobat/blob/main/system/resources/retrobat_logo_v7.png" alt="retrobat" width="500"></a>
</h1>
<p align="left">
  <a href="https://discord.gg/GVcPNxwzuT">
      <img src="https://img.shields.io/discord/748519802255179917?color=blue&label=discord&logo=discord&logoColor=white&style=for-the-badge"
           alt="Discord">
    </a>
  <img src="https://img.shields.io/badge/macOS-Apple%20Silicon-blue?style=for-the-badge&logo=apple&logoColor=white" alt="macOS Apple Silicon">
  <img src="https://img.shields.io/badge/Windows-11%20%7C%2010-blue?style=for-the-badge&logo=windows&logoColor=white" alt="Windows Support">
</p>

RetroBat is designed to automatically configure EmulationStation’s frontend interface with RetroArch and other stand alone emulators.

With it you will be able to quickly run games from many compatible ROM collections. This saves hours of configuration and installation time, leaving you free to play your favourite retro games.

RetroBat automatically downloads and installs all the relevant software needed to have the best retro gaming experience on your PC. Originally designed for Windows, **RetroBat is now being ported to macOS Apple Silicon (M1/M2/M3/M4)**.

RetroBat can also run in Portable Mode. This means you can play games from an external hard drive or from any removable storage device, as long as the computer meets the minimum requirements.

## 📦 Download

### Windows
- **Latest Release**: Visit the [official RetroBat website](https://www.retrobat.org/) for the Windows version
- **GitHub Releases**: [RetroBat Official Releases](https://github.com/RetroBat-Official/retrobat/releases)

### macOS (Apple Silicon)
- **Status**: In Development 🚧
- **This Repository**: The macOS port is being developed here at [bayramog/retrobat-macos](https://github.com/bayramog/retrobat-macos)
- **Releases**: Will be available on the [Releases page](https://github.com/bayramog/retrobat-macos/releases) once ready
- **Follow Progress**: See the [macOS Apple Silicon Port](#-macos-apple-silicon-port) section below

## 🍎 macOS Apple Silicon Port

> **⚠️ Work in Progress**: This fork is dedicated to porting RetroBat to macOS Apple Silicon (M1/M2/M3/M4).

**Current Status**: Planning Phase Complete ✅

### 📚 Documentation
- 📘 [**Migration Plan**](MACOS_MIGRATION_PLAN.md) - Detailed technical plan
- 🏗️ [**Architecture**](ARCHITECTURE.md) - System architecture (current vs. target)
- 📝 [**GitHub Issues**](ISSUES.md) - Issue templates for tracking
- 💡 [**EmulationStation Decision**](EMULATIONSTATION_DECISION.md) - Why we port RetroBat's ES fork

### 📊 Progress
- [x] Phase 1: Planning & Documentation (Week 1-2)
- [ ] Phase 2: Core Tools Migration (Week 3-5)
- [ ] Phase 3: Launcher Migration (Week 6-8)
- [ ] Phase 4: Emulator Compatibility (Week 8-10)
- [ ] Phase 5: Configuration Files (Week 10-11)
- [ ] Phase 6: Packaging (Week 11-13)
- [ ] Phase 7: Testing & Documentation (Week 13-15)
- [ ] Phase 8: Release (Week 15-16)

### 🛠️ Key Technologies
- **.NET 6+/8** - Cross-platform C# runtime
- **RetroBat EmulationStation** - Porting RetroBat's own ES fork (C++/SDL2)
- **SDL2/SDL3** - Cross-platform graphics and controller support
- **Homebrew** - Package management

### 📦 macOS Dependencies

RetroBat on macOS uses system tools from Homebrew instead of bundled Windows binaries:

**Core Build Tools:**
- `p7zip` - Archive extraction (replaces `7za.exe`)
- `wget` - File downloads (replaces `wget.exe`)
- `curl` - Built-in on macOS (replaces `curl.exe`)
- `git` - Built-in with Xcode Command Line Tools

**SDL Libraries (for EmulationStation):**
- `sdl2` - Required for EmulationStation (replaces `SDL2.dll`)
- `sdl3` - Optional for enhanced features (replaces `SDL3.dll`)

**Quick Install:**
```bash
# Install all dependencies
brew bundle

# Or install individually
brew install p7zip wget sdl2 dotnet-sdk

# Verify installation
./verify-tools.sh
```

For complete setup instructions, see:
- [Brewfile](Brewfile) - All required dependencies
- [system/tools/macos/README.md](system/tools/macos/README.md) - Detailed tool documentation
- [docs/BUILDING_RETROBUILD_MACOS.md](docs/BUILDING_RETROBUILD_MACOS.md) - Build instructions
- [verify-tools.sh](verify-tools.sh) - Tool verification script

**Timeline**: ~21 weeks | **Next Step**: [Create GitHub Issues](ISSUES.md)

### 🚀 Getting Started on macOS (When Available)

> **Note**: macOS installation will be available once development is complete. For now, you can follow the [Migration Plan](MACOS_MIGRATION_PLAN.md) to contribute.

**Prerequisites:**
```bash
# Install Homebrew (if not already installed)
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Install .NET Runtime
brew install --cask dotnet-sdk

# Install Xcode Command Line Tools
xcode-select --install
```

**Installation Steps (Future):**
1. Download the latest macOS release from [Releases](https://github.com/bayramog/retrobat-macos/releases)
2. Open the `.dmg` file and drag RetroBat to your Applications folder
3. Launch RetroBat from Applications
4. Follow the setup wizard to configure your emulators and ROMs

**Building from Source:**

See [INSTALL.md](INSTALL.md) for detailed build instructions for developers.

---

## 🖥️ Supported Platforms

| Platform | Status | Architecture | Download |
|----------|--------|--------------|----------|
| **Windows** | ✅ Stable | x86, x64 | [Official Website](https://www.retrobat.org/) |
| **macOS** | 🚧 In Development | ARM64 (Apple Silicon) | [Releases](https://github.com/bayramog/retrobat-macos/releases) (Coming Soon) |

> **macOS Note**: Only Apple Silicon (M1/M2/M3/M4) is supported. Intel-based Macs are not supported.

## 💻 System Requirements

### Windows

|**OS supported:**|Windows 11, Windows 10, Windows 8.1|
|---|---|
|**Processor:**|CPU with SSE2 support. 3 GHz and Dual Core, not older than 2008 is highly recommended.|
|**Graphics:**|Modern graphics card that supports Direct3D 11.1 / OpenGL 4.4 / Vulkan|
|**Dependancies:**|[Visual C++ 2010 Redistributable Packages (32 bit)](https://www.techpowerup.com/download/visual-c-redistributable-runtime-package-all-in-one/)|
|   |[Visual C++ 2015, 2017 and 2019 Redistributable Packages (32 bit)](https://www.techpowerup.com/download/visual-c-redistributable-runtime-package-all-in-one/)|
|   |[Visual C++ 2015, 2017 and 2019 Redistributable Packages (64 bit)](https://www.techpowerup.com/download/visual-c-redistributable-runtime-package-all-in-one/)|
|   |[DirectX](https://www.microsoft.com/download/details.aspx?id=35)|
|**Controllers:**|Xinput controllers highly recommended. Test your controller [HERE](https://gamepad-tester.com)|

### macOS (Apple Silicon)

|**OS supported:**|macOS 12 (Monterey) or later|
|---|---|
|**Processor:**|Apple Silicon (M1, M2, M3, M4) - **ARM64 only, Intel x86_64 not supported**|
|**Graphics:**|Apple GPU with Metal support (built into all Apple Silicon chips)|
|**Dependencies:**|[Homebrew](https://brew.sh/) - Package manager for macOS|
|   |[.NET 6+ Runtime](https://dotnet.microsoft.com/download) - Cross-platform runtime|
|   |Xcode Command Line Tools - `xcode-select --install`|
|**Controllers:**|SDL3-compatible controllers. USB and Bluetooth controllers supported. Test your controller [HERE](https://gamepad-tester.com)|

> **Note**: The macOS version is currently in active development. See the [macOS Apple Silicon Port](#-macos-apple-silicon-port) section above for current status and progress.


## 🦇 RetroBat Team

- Adrien Chalard "Kayl" - co-founder, developer
- Lorenzolamas - co-founder, community, graphics
- Fabrice Caruso - lead developer, theme creation
- GetUpOr - community, support
- RetroBoy - community, support
- Tartifless - developer, documentation
- Aynshe - community, support

## 💟 Special Thanks

- [Hel Mic](https://github.com/lehcimcramtrebor/) - for his wonderful themes.
- [Batocera](https://www.batocera.org/) - for their wonderful retrogaming dedicated Operating System.
- [Gitbook](https://www.gitbook.com/) - for supporting our project.

## ⚖ Licence

RetroBat (c) Adrien Chalard and the RetroBat Team.

RetroBat is a free and open source project. It should not be used for commercial purposes.
It is done by a team of enthusiasts in their free time mainly for fun.

All the code written by the RetroBat Team, unless covered by a licence from an upstream project, is given under the [LGPL v3 licence](https://www.gnu.org/licenses/lgpl-3.0.html).

It is not allowed to sell RetroBat on a pre-installed machine or on any storage devices. RetroBat includes softwares which cannot be associated with any commercial activities.

Shipping RetroBat with additional proprietary and copyrighted content is illegal, strictly forbidden and strongly discouraged by the RetroBat Team.

Otherwise, you can start a new project off RetroBat sources if you follow the same conditions.

Finally, the license which concerns the entire RetroBat project as a work, in particular the written or graphic content broadcast on its various media, is conditioned by the terms of the [CC BY-NC-SA 4.0 license](https://creativecommons.org/licenses/by-nc-sa/4.0/).

|<img src="https://www.gnu.org/graphics/gplv3-127x51.png" width="140" alt="gpl3licence" class="center">|<img src="https://upload.wikimedia.org/wikipedia/commons/thumb/1/12/Cc-by-nc-sa_icon.svg/180px-Cc-by-nc-sa_icon.svg.png" width="140" alt="cclicence" class="center">|
|---|---|

## © Credits

- EmulationStation (C) 2014 Alec Lofquist, contributions from community (MIT Licence).
- Carbon Theme (c) Fabrice Caruso (CC BY-NC-SA Licence). Originally based on the work of Eric Hettervik (Original Carbon Theme) and Nils Bonenberger (Simple Theme).
- WiimoteGun (c) Fabrice Caruso (GPL3 Licence).
- RetroArch by Libretro Team (GPL3 Licence).

## 💬 Social & Support

- Official Website: https://www.retrobat.org/
- Facebook Group: https://social.retrobat.org/facebook
- Wiki: https://wiki.retrobat.org/
- You need help ? You found a bug ? Please visit RetroBat Forum: https://social.retrobat.org/forum
- Join us on our Discord server: https://discord.gg/GVcPNxwzuT
- <a class="twitter-timeline" href="https://twitter.com/RetroBat_Off?ref_src=twsrc%5Etfw">Tweets by RetroBat_Off</a>
