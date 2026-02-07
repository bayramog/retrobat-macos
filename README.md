<h1 align="left">
  <br>
  <a href="https://www.retrobat.org/"><img src="https://github.com/RetroBat-Official/retrobat/blob/main/system/resources/retrobat_logo_v7.png" alt="retrobat" width="500"></a>
</h1>
<p align="left">
  <a href="https://discord.gg/GVcPNxwzuT">
      <img src="https://img.shields.io/discord/748519802255179917?color=blue&label=discord&logo=discord&logoColor=white&style=for-the-badge"
           alt="Discord">
    </a>
</p>

RetroBat is designed to automatically configure EmulationStation’s frontend interface with RetroArch and other stand alone emulators.

With it you will be able to quickly run games from many compatible ROM collections. This saves hours of configuration and installation time, leaving you free to play your favourite retro games.

RetroBat automatically downloads and installs all the relevant software needed to have the best retro gaming experience on your Windows PC.

RetroBat can also run in Portable Mode. This means you can play games from an external hard drive or from any removable storage device, as long as the computer meets the minimum requirements.

## 🍎 macOS Apple Silicon Port

> **⚠️ Work in Progress**: This fork is dedicated to porting RetroBat to macOS Apple Silicon (M1/M2/M3).

**Current Status**: Planning Phase Complete ✅

### 📚 Documentation
- 🚀 [**Quick Start (macOS)**](QUICKSTART_MACOS.md) - Fast setup for developers (15 min)
- 📘 [**Migration Plan**](MACOS_MIGRATION_PLAN.md) - Detailed technical plan
- 🏗️ [**Architecture**](ARCHITECTURE.md) - System architecture (current vs. target)
- 🔧 [**Building on macOS**](BUILDING_MACOS.md) - Developer setup guide
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

**Timeline**: ~21 weeks | **Next Step**: [Create GitHub Issues](ISSUES.md)

---

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
|**Controllers:**|Xinput controllers hightly recommanded. Test your controller [HERE](https://gamepad-tester.com)|

### macOS (In Development)

|**OS supported:**|macOS 12 (Monterey) or later|
|---|---|
|**Processor:**|Apple Silicon (M1/M2/M3/M4) arm64 only|
|**Graphics:**|Metal-compatible GPU (built-in with Apple Silicon)|
|**Memory:**|8 GB RAM minimum, 16 GB recommended|
|**Dependencies:**|[Homebrew](https://brew.sh/)|
|   |[.NET 6+ Runtime](https://dotnet.microsoft.com/download)|
|   |[Xcode Command Line Tools](https://developer.apple.com/xcode/)|
|**Controllers:**|SDL2/SDL3 compatible controllers. Most modern USB/Bluetooth controllers supported.|

> **Note**: macOS downloads will be available at [github.com/bayramog/retrobat-macos/releases](https://github.com/bayramog/retrobat-macos/releases) when ready.


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
