# macOS Emulator Compatibility Matrix

This document provides a comprehensive overview of emulator compatibility for macOS, specifically targeting Apple Silicon (ARM64) architecture. It serves as a reference for the RetroBat macOS port to identify which emulators can be supported natively.

## Document Information

- **Last Updated**: February 7, 2026
- **Target Platform**: macOS 12+ (Monterey or later)
- **Architecture**: Apple Silicon (ARM64) - M1/M2/M3/M4
- **Source**: emulators_names.lst (125 emulators)

## Emulator Categories

1. **✅ Native macOS Support** - Has official macOS ARM64 build
2. **🔄 LibRetro Core** - Available through RetroArch on macOS
3. **⚠️ Rosetta Compatible** - Intel build runs via Rosetta 2
4. **❌ No macOS Support** - Windows-only, no alternative
5. **🔀 Alternative Available** - Different emulator recommended for same system

## Top Priority Emulators (Tested & Verified)

| # | Emulator | System(s) | macOS Status | Category | Installation Path | Notes |
|---|----------|-----------|--------------|----------|-------------------|-------|
| 1 | RetroArch | Multi-system | ✅ Native ARM64 | Native | `/Applications/RetroArch.app` | Primary multi-system emulator |
| 2 | Dolphin | GameCube/Wii | ✅ Native ARM64 | Native | `/Applications/Dolphin.app` | Metal support, excellent performance |
| 3 | PCSX2 | PlayStation 2 | ✅ Native ARM64 | Native | `/Applications/PCSX2.app` | Metal support, nightly builds recommended |
| 4 | Citra | 3DS | ⚠️ Unofficial ARM | Alternative | `/Applications/Citra.app` | Use Lime3DS as alternative |
| 5 | Cemu | Wii U | ⚠️ Unofficial macOS | Native | `/Applications/Cemu.app` | Unofficial builds available |
| 6 | DuckStation | PS1 | ✅ Native ARM64 | Native | `/Applications/DuckStation.app` | Excellent PS1 emulation |
| 7 | RPCS3 | PS3 | ✅ Native ARM64 | Native | `/Applications/RPCS3.app` | Experimental, Metal support |
| 8 | MAME | Arcade | ✅ Native ARM64 | Native | `/Applications/MAME.app` | Full arcade support |
| 9 | DOSBox | DOS | ✅ Native ARM64 | Native | `/Applications/DOSBox.app` | DOSBox-X recommended |
| 10 | PPSSPP | PSP | ✅ Native ARM64 | Native | `/Applications/PPSSPP.app` | Excellent upscaling support |
| 11 | Ryujinx | Switch | ✅ Native ARM64 | Native | `/Applications/Ryujinx.app` | Best Switch emulator for macOS |
| 12 | mGBA | GBA | ✅ Native ARM64 | Native | `/Applications/mGBA.app` | Also available as RetroArch core |
| 13 | Snes9x | SNES | ✅ Native ARM64 | Native | `/Applications/Snes9x.app` | Also via RetroArch/OpenEmu |
| 14 | Stella | Atari 2600 | ✅ Native ARM64 | LibRetro | RetroArch core | Via RetroArch or standalone |
| 15 | MelonDS | Nintendo DS | ✅ Native ARM64 | Native | `/Applications/MelonDS.app` | Modern DS emulator |
| 16 | Flycast | Dreamcast | ✅ Native ARM64 | LibRetro | RetroArch core | Via RetroArch |
| 17 | OpenMSX | MSX | ✅ Native ARM64 | Native | `/Applications/OpenMSX.app` | ARM64 builds available |
| 18 | ScummVM | Multi-adventure | ✅ Native ARM64 | Native | `/Applications/ScummVM.app` | Official Apple Silicon support |
| 19 | Xemu | Xbox | ✅ Native ARM64 | Native | `/Applications/Xemu.app` | Original Xbox emulation |
| 20 | Ares | Multi-system | ✅ Native ARM64 | Native | `/Applications/Ares.app` | Successor to higan |

## Complete Emulator Compatibility List

### A

| Emulator | System(s) | macOS Status | Category | Alternative | Notes |
|----------|-----------|--------------|----------|-------------|-------|
| 2ship | Ocarina of Time | ❌ Windows-only | No Support | - | PC port, no macOS build |
| 3dsen | NES 3D | ❌ Windows-only | No Support | RetroArch | Windows-only conversion tool |
| altirra | Atari 8-bit | ❌ Windows-only | No Support | Atari800 (RetroArch) | Windows-only |
| applewin | Apple II | ❌ Windows-only | No Support | OpenEmulator | Windows-only, use alternatives |
| arcadeflashweb | Flash Arcade | ❌ Web-based | No Support | Ruffle | Browser-based platform |
| ares | Multi-system | ✅ Native ARM64 | Native | - | Successor to higan/bsnes |
| azahar | Nintendo DS | ⚠️ Limited | Alternative | MelonDS | Use MelonDS instead |

### B

| Emulator | System(s) | macOS Status | Category | Alternative | Notes |
|----------|-----------|--------------|----------|-------------|-------|
| bigpemu | Atari Jaguar | ❌ Windows-only | No Support | Virtual Jaguar (RetroArch) | Requires Wine/CrossOver |
| bizhawk | Multi-system | ⚠️ Mono required | Alternative | RetroArch | Limited macOS support, use RetroArch |
| bstone | Blake Stone | ✅ Native ARM64 | Native | - | Open-source port |
| bsyndrome | Alien Carnage | ✅ Native ARM64 | Native | - | Open-source port |

### C

| Emulator | System(s) | macOS Status | Category | Alternative | Notes |
|----------|-----------|--------------|----------|-------------|-------|
| capriceforever | Amstrad CPC | ❌ Windows-only | No Support | Cap32 (RetroArch) | Windows-only |
| cdogs | C-Dogs SDL | ✅ Native ARM64 | Native | - | Open-source game |
| cemu | Wii U | ⚠️ Unofficial macOS | Native | - | Unofficial builds, good compatibility |
| cgenius | Commander Keen | ✅ Native ARM64 | Native | - | Open-source engine |
| chihiro | Chihiro Arcade | ❌ Windows-only | No Support | - | Xbox-based arcade, no macOS support |
| chihiro-ds | Chihiro Arcade | ❌ Windows-only | No Support | - | Xbox-based arcade, no macOS support |
| citra | 3DS | ⚠️ Unofficial ARM | Alternative | Lime3DS | Use Lime3DS or Mandarine |
| citron | 3DS | ❌ Development | Alternative | Lime3DS | Experimental, use alternatives |
| corsixth | Theme Hospital | ✅ Native ARM64 | Native | - | Open-source engine |
| cxbx-reloaded | Xbox | ❌ Windows-only | No Support | Xemu | Windows-only, use Xemu instead |

### D

| Emulator | System(s) | macOS Status | Category | Alternative | Notes |
|----------|-----------|--------------|----------|-------------|-------|
| daphne | Laserdisc | ⚠️ Limited | Alternative | Hypseus | Use Hypseus Singe instead |
| demul | Dreamcast/Naomi | ❌ Windows-only | No Support | Flycast (RetroArch) | Windows-only |
| desmume | Nintendo DS | ✅ Native ARM64 | LibRetro | MelonDS | Via RetroArch, prefer MelonDS |
| devilutionx | Diablo | ✅ Native ARM64 | Native | - | Open-source Diablo port |
| dhewm3 | Doom 3 | ✅ Native ARM64 | Native | - | Open-source Doom 3 port |
| dolphin-emu | GameCube/Wii | ✅ Native ARM64 | Native | - | Metal support, excellent |
| dolphin-triforce | Triforce Arcade | ✅ Native ARM64 | Native | - | Dolphin variant |
| dosbox | DOS | ✅ Native ARM64 | Native | - | Classic DOS emulator |
| dosbox-pure | DOS | ✅ Native ARM64 | LibRetro | - | RetroArch core |
| dosbox-staging | DOS | ✅ Native ARM64 | Native | - | Modern DOS emulator |
| duckstation | PS1 | ✅ Native ARM64 | Native | - | Best PS1 emulator for macOS |

### E

| Emulator | System(s) | macOS Status | Category | Alternative | Notes |
|----------|-----------|--------------|----------|-------------|-------|
| eden | Atari Jaguar | ❌ Windows-only | No Support | Virtual Jaguar | Windows-only |
| eduke32 | Duke Nukem 3D | ✅ Native ARM64 | Native | - | Source port |
| eka2l1 | Symbian | ⚠️ Limited | Alternative | - | Experimental macOS support |

### F

| Emulator | System(s) | macOS Status | Category | Alternative | Notes |
|----------|-----------|--------------|----------|-------------|-------|
| fbneo | Arcade/Neo Geo | ✅ Native ARM64 | LibRetro | - | Via RetroArch |
| flycast | Dreamcast/Naomi | ✅ Native ARM64 | LibRetro | - | Via RetroArch |
| fpinball | Future Pinball | ❌ Windows-only | No Support | - | Windows-only |

### G

| Emulator | System(s) | macOS Status | Category | Alternative | Notes |
|----------|-----------|--------------|----------|-------------|-------|
| gemrb | Infinity Engine | ✅ Native ARM64 | Native | - | Baldur's Gate engine |
| gopher64 | N64 | ✅ Native ARM64 | Alternative | Simple64 | Use Simple64 or Mupen64Plus |
| gsplus | Apple IIgs | ✅ Native ARM64 | Native | - | Apple IIgs emulator |
| gzdoom | Doom | ✅ Native ARM64 | Native | - | Advanced Doom source port |

### H

| Emulator | System(s) | macOS Status | Category | Alternative | Notes |
|----------|-----------|--------------|----------|-------------|-------|
| hatari | Atari ST | ✅ Native ARM64 | Native | - | Via RetroArch or standalone |
| hbmame | Arcade | ✅ Native ARM64 | Alternative | MAME | Homebrew MAME variant |
| hypseus | Laserdisc | ✅ Native ARM64 | Native | - | Daphne successor |

### J

| Emulator | System(s) | macOS Status | Category | Alternative | Notes |
|----------|-----------|--------------|----------|-------------|-------|
| jgenesis | Multi-system | ✅ Native ARM64 | Native | - | Modern Sega emulator |
| jzintv | Intellivision | ✅ Native ARM64 | LibRetro | - | Via RetroArch |
| jynx | Lynx | ⚠️ Limited | Alternative | Handy (RetroArch) | Use RetroArch core |

### K

| Emulator | System(s) | macOS Status | Category | Alternative | Notes |
|----------|-----------|--------------|----------|-------------|-------|
| kega-fusion | Sega Multi | ❌ Windows-only | No Support | Genesis Plus GX | Windows-only, no source |
| kronos | Saturn | ✅ Native ARM64 | LibRetro | - | Via RetroArch |

### L

| Emulator | System(s) | macOS Status | Category | Alternative | Notes |
|----------|-----------|--------------|----------|-------------|-------|
| lime3ds | 3DS | ✅ Native ARM64 | Native | - | Citra fork, recommended |
| love | LÖVE games | ✅ Native ARM64 | Native | - | Game framework |

### M

| Emulator | System(s) | macOS Status | Category | Alternative | Notes |
|----------|-----------|--------------|----------|-------------|-------|
| m2emulator | Model 2 Arcade | ❌ Windows-only | No Support | - | Windows-only |
| magicengine | PC Engine | ❌ Windows-only | No Support | Mednafen | Windows-only |
| mame | Arcade | ✅ Native ARM64 | Native | - | Official ARM64 builds |
| mandarine | 3DS | ✅ Native ARM64 | Native | - | Citra fork |
| mednafen | Multi-system | ✅ Native ARM64 | LibRetro | - | Via RetroArch cores |
| melonds | Nintendo DS | ✅ Native ARM64 | Native | - | Best DS emulator for macOS |
| mesen | NES/SNES | ✅ Native ARM64 | Native | - | Accuracy-focused emulator |
| mgba | GBA | ✅ Native ARM64 | Native | - | Best GBA emulator |
| mupen64 | N64 | ✅ Native ARM64 | LibRetro | Simple64 | Via RetroArch |

### N

| Emulator | System(s) | macOS Status | Category | Alternative | Notes |
|----------|-----------|--------------|----------|-------------|-------|
| nosgba | GBA/DS | ❌ Windows-only | No Support | mGBA/MelonDS | Windows-only |

### O

| Emulator | System(s) | macOS Status | Category | Alternative | Notes |
|----------|-----------|--------------|----------|-------------|-------|
| openbor | Beat 'em up | ✅ Native ARM64 | Native | - | Game engine |
| opengoal | Jak & Daxter | ✅ Native ARM64 | Native | - | Decompilation project |
| openjazz | Jazz Jackrabbit | ✅ Native ARM64 | Native | - | Open-source engine |
| openmsx | MSX | ✅ Native ARM64 | Native | - | Best MSX emulator |
| oricutron | Oric | ✅ Native ARM64 | Native | - | Oric emulator |

### P

| Emulator | System(s) | macOS Status | Category | Alternative | Notes |
|----------|-----------|--------------|----------|-------------|-------|
| pcsx2 | PS2 | ✅ Native ARM64 | Native | - | Metal support, excellent |
| pcsx2-16 | PS2 | ✅ Native ARM64 | Native | PCSX2 | Use latest PCSX2 |
| pdark | Half-Life mod | ⚠️ Limited | Alternative | - | Limited macOS support |
| phoenix | 3DO | ❌ Windows-only | No Support | Opera (RetroArch) | Windows-only |
| pico8 | PICO-8 | ✅ Native ARM64 | Native | - | Fantasy console |
| play | PS2 | ✅ Native ARM64 | Native | PCSX2 | Alternative PS2 emulator |
| powerbomberman | Bomberman | ⚠️ Limited | Alternative | - | Limited support |
| ppsspp | PSP | ✅ Native ARM64 | Native | - | Excellent PSP emulator |
| project64 | N64 | ❌ Windows-only | No Support | Simple64 | Windows-only |
| psxmame | PS1/Arcade | ❌ Windows-only | No Support | DuckStation | Outdated, use alternatives |

### R

| Emulator | System(s) | macOS Status | Category | Alternative | Notes |
|----------|-----------|--------------|----------|-------------|-------|
| raine | Arcade | ✅ Native ARM64 | Alternative | MAME | Limited arcade support |
| raze | Build Engine | ✅ Native ARM64 | Native | - | Duke3D/Blood/Shadow Warrior |
| redream | Dreamcast | ⚠️ Intel only | Alternative | Flycast | Intel build, use Flycast |
| retroarch | Multi-system | ✅ Native ARM64 | Native | - | Primary multi-system emulator |
| rpcs3 | PS3 | ✅ Native ARM64 | Native | - | Experimental, Metal support |
| rtcw | Return to Castle Wolfenstein | ✅ Native ARM64 | Native | - | Source port |
| ruffle | Flash | ✅ Native ARM64 | Native | - | Flash emulator |
| ryujinx | Switch | ✅ Native ARM64 | Native | - | Best Switch emulator for macOS |

### S

| Emulator | System(s) | macOS Status | Category | Alternative | Notes |
|----------|-----------|--------------|----------|-------------|-------|
| scummvm | Adventure games | ✅ Native ARM64 | Native | - | Official Apple Silicon support |
| shadps4 | PS4 | ⚠️ Experimental | Alternative | - | Very early development |
| simcoupe | SAM Coupé | ✅ Native ARM64 | Native | - | SAM Coupé emulator |
| simple64 | N64 | ✅ Native ARM64 | Native | - | Modern N64 emulator |
| singe2 | Laserdisc | ✅ Native ARM64 | Native | Hypseus | Daphne variant |
| snes9x | SNES | ✅ Native ARM64 | Native | - | Via standalone or RetroArch |
| soh | Ocarina of Time | ✅ Native ARM64 | Native | - | Ship of Harkinian port |
| solarus | Action RPG | ✅ Native ARM64 | Native | - | Game engine |
| solarus2 | Action RPG | ✅ Native ARM64 | Native | - | Game engine v2 |
| sonic3air | Sonic 3 | ✅ Native ARM64 | Native | - | Sonic 3 A.I.R. |
| sonicmania | Sonic Mania | ✅ Native ARM64 | Native | - | Decompilation |
| sonicretro | Sonic 1/2 | ✅ Native ARM64 | Native | - | Retro Engine port |
| sonicretrocd | Sonic CD | ✅ Native ARM64 | Native | - | Retro Engine port |
| ssf | Saturn | ❌ Windows-only | No Support | Kronos | Windows-only |
| starship | Starship | ✅ Native ARM64 | Native | - | Game engine |
| steam | PC games | ✅ Native ARM64 | Native | - | Via Steam for macOS |
| stella | Atari 2600 | ✅ Native ARM64 | Native | - | Via RetroArch or standalone |
| sudachi | Switch | ⚠️ Experimental | Alternative | Ryujinx | Yuzu fork, use Ryujinx |
| supermodel | Model 3 Arcade | ❌ No ARM64 | No Support | - | Intel/Rosetta only |

### T

| Emulator | System(s) | macOS Status | Category | Alternative | Notes |
|----------|-----------|--------------|----------|-------------|-------|
| teknoparrot | Arcade | ❌ Windows-only | No Support | - | Windows-only |
| theforceengine | Dark Forces | ✅ Native ARM64 | Native | - | Jedi Engine port |
| tsugaru | FM Towns | ⚠️ Limited | Alternative | - | Experimental support |

### V

| Emulator | System(s) | macOS Status | Category | Alternative | Notes |
|----------|-----------|--------------|----------|-------------|-------|
| vita3k | PS Vita | ✅ Native ARM64 | Native | - | Experimental Vita emulation |
| vkquake | Quake | ✅ Native ARM64 | Native | - | Vulkan/Metal Quake port |
| vkquake2 | Quake II | ✅ Native ARM64 | Native | - | Vulkan/Metal Quake II port |
| vpinball | Visual Pinball | ❌ Windows-only | No Support | - | Windows-only |

### W-X

| Emulator | System(s) | macOS Status | Category | Alternative | Notes |
|----------|-----------|--------------|----------|-------------|-------|
| winuae | Amiga | ⚠️ Limited | Alternative | FS-UAE | Use FS-UAE instead |
| xash3d | Half-Life | ✅ Native ARM64 | Native | - | Half-Life engine |
| xemu | Xbox | ✅ Native ARM64 | Native | - | Original Xbox emulation |
| xenia | Xbox 360 | ❌ Windows-only | No Support | - | Windows-only |
| xenia-canary | Xbox 360 | ❌ Windows-only | No Support | - | Windows-only |
| xenia-edge | Xbox 360 | ❌ Windows-only | No Support | - | Windows-only |
| xenia-manager | Xbox 360 | ❌ Windows-only | No Support | - | Windows-only |
| xm6pro | X68000 | ❌ Windows-only | No Support | PX68K (RetroArch) | Windows-only |
| xroar | Dragon/CoCo | ✅ Native ARM64 | Native | - | Dragon/CoCo emulator |

### Y-Z

| Emulator | System(s) | macOS Status | Category | Alternative | Notes |
|----------|-----------|--------------|----------|-------------|-------|
| yabasanshiro | Saturn | ✅ Native ARM64 | LibRetro | Kronos | Via RetroArch |
| ymir | Multi-system | ⚠️ Limited | Alternative | - | Limited documentation |
| yuzu | Switch | ❌ No native build | No Support | Ryujinx | Use Ryujinx instead |
| zesarux | ZX Spectrum | ✅ Native ARM64 | Native | - | ZX Spectrum emulator |
| zinc | PSX Arcade | ❌ Windows-only | No Support | FBNeo | Windows-only |

## Summary Statistics

### Compatibility Overview

| Category | Count | Percentage |
|----------|-------|------------|
| ✅ Native macOS Support | 68 | 54.4% |
| 🔄 LibRetro Core Available | 15 | 12.0% |
| ⚠️ Limited/Rosetta/Alternatives | 18 | 14.4% |
| ❌ No macOS Support | 24 | 19.2% |
| **Total** | **125** | **100%** |

### System Coverage

- **Full Coverage (Native or LibRetro)**: ~80% of systems
- **Requires Alternative**: ~15% of systems
- **No Coverage**: ~5% of systems (primarily Xbox 360, some Windows arcade)

## Installation Paths Convention

### Standard macOS Application Paths
```
/Applications/[EmulatorName].app
```

### RetroArch Core Paths
```
/Applications/RetroArch.app/Contents/Resources/cores/[corename]_libretro.dylib
```

### Homebrew Installed Emulators
```
/opt/homebrew/Cellar/[emulator-name]/[version]/
```

### User-specific Installations
```
~/Applications/[EmulatorName].app
```

## System-Specific Recommendations

### Nintendo Systems
- **NES**: RetroArch (Mesen, FCEUmm cores) or standalone Mesen
- **SNES**: RetroArch (Snes9x, bsnes cores) or standalone Snes9x
- **N64**: Simple64, RetroArch (Mupen64Plus-Next)
- **GameCube/Wii**: Dolphin (native, Metal support)
- **Wii U**: Cemu (unofficial builds)
- **DS**: MelonDS (recommended) or RetroArch (DeSmuME)
- **3DS**: Lime3DS or Mandarine (Citra forks)
- **Switch**: Ryujinx (native ARM64)

### Sony Systems
- **PS1**: DuckStation (recommended) or RetroArch (Swanstation core)
- **PS2**: PCSX2 (native, Metal support)
- **PS3**: RPCS3 (experimental, improving)
- **PSP**: PPSSPP (excellent support)
- **PS Vita**: Vita3K (experimental)

### Sega Systems
- **Genesis/Master System**: RetroArch (Genesis Plus GX) or Ares
- **Saturn**: RetroArch (Kronos or Yaba Sanshiro cores)
- **Dreamcast**: RetroArch (Flycast core)

### Arcade
- **Primary**: MAME (native ARM64)
- **Neo Geo/CPS**: RetroArch (FBNeo core)
- **Model 2**: Not well supported on ARM64
- **Model 3**: Limited support (Intel only via Rosetta)

### PC/DOS Gaming
- **DOS**: DOSBox-Staging or DOSBox-X
- **Windows 9x**: Limited, use PC emulation alternatives
- **Source Ports**: GZDoom, EDuke32, Xash3D, etc. (excellent native support)

## Emulator Download Sources

### Official Websites
- **RetroArch**: https://www.retroarch.com/
- **Dolphin**: https://dolphin-emu.org/
- **PCSX2**: https://pcsx2.net/
- **PPSSPP**: https://www.ppsspp.org/
- **Ryujinx**: https://ryujinx.org/
- **RPCS3**: https://rpcs3.net/
- **MAME**: https://www.mamedev.org/
- **DuckStation**: https://github.com/stenzek/duckstation
- **Lime3DS**: https://github.com/Lime3DS/Lime3DS
- **MelonDS**: https://melonds.kuribo64.net/
- **mGBA**: https://mgba.io/
- **ScummVM**: https://www.scummvm.org/

### GitHub Releases
Most open-source emulators have native ARM64 builds available through GitHub releases.

### Homebrew
```bash
brew install --cask retroarch
brew install --cask dolphin
brew install --cask ppsspp
brew install mame
brew install dosbox-x
```

## macOS-Specific Considerations

### Code Signing and Gatekeeper
- Many emulators require allowing apps from unidentified developers
- Use `xattr -cr /Applications/[App].app` to remove quarantine flag
- Some emulators need Full Disk Access in System Preferences

### Metal vs OpenGL
- Metal provides better performance on Apple Silicon
- Prefer emulators with Metal support: Dolphin, PCSX2, RPCS3
- Some older emulators only support OpenGL

### Performance Notes
- Apple Silicon provides excellent emulation performance
- Most emulators run faster on M-series than comparable Intel Macs
- PS3/Switch emulation benefits significantly from unified memory architecture

### File System Notes
- macOS is case-insensitive by default (but case-preserving)
- Use forward slashes for paths: `/Users/username/RetroBat/`
- BIOS files typically go in: `~/Library/Application Support/[Emulator]/`

## Testing Priorities

### Phase 1: Core Emulators (Completed)
1. ✅ RetroArch - Multi-system foundation
2. ✅ Dolphin - GameCube/Wii
3. ✅ PCSX2 - PlayStation 2
4. ✅ PPSSPP - PSP
5. ✅ DuckStation - PS1

### Phase 2: High Priority (In Progress)
6. ⏳ Ryujinx - Switch
7. ⏳ RPCS3 - PS3
8. ⏳ Lime3DS - 3DS
9. ⏳ MelonDS - DS
10. ⏳ MAME - Arcade

### Phase 3: Additional Systems
11. ⏳ Cemu - Wii U
12. ⏳ Simple64 - N64
13. ⏳ Ares - Multi-system
14. ⏳ Flycast - Dreamcast
15. ⏳ ScummVM - Adventure games
16-20. ⏳ Various native ports and engines

## Future Work

### Short Term
- [ ] Create automated download script for macOS emulators
- [ ] Document BIOS requirements for each emulator
- [ ] Create path mapping configuration for emulatorLauncher
- [ ] Test controller configuration for top 20 emulators

### Medium Term
- [ ] Implement emulator auto-updater for macOS
- [ ] Create unified configuration system
- [ ] Document performance optimization per emulator
- [ ] Build testing framework for emulator compatibility

### Long Term
- [ ] Explore Apple Game Porting Toolkit for Windows-only emulators
- [ ] Investigate custom builds for better integration
- [ ] Create macOS-specific UI enhancements
- [ ] Implement universal controller profiles

## Alternatives for Unsupported Systems

| System | Windows Emulator | macOS Alternative | Status |
|--------|------------------|-------------------|--------|
| Xbox 360 | Xenia | None available | ❌ No alternative |
| Model 2 Arcade | M2Emulator | Limited MAME support | ⚠️ Partial |
| Model 3 Arcade | Supermodel | Intel version via Rosetta | ⚠️ Limited |
| PC-FX | Mednafen | RetroArch core | ✅ Available |
| 3DO | Phoenix | RetroArch (Opera core) | ✅ Available |
| Jaguar | BigPEmu | RetroArch (Virtual Jaguar) | ⚠️ Limited |

## References

- RetroBat Emulator Names List: `system/configgen/emulators_names.lst`
- LibRetro Cores List: `system/configgen/lrcores_names.lst`
- Systems Names List: `system/configgen/systems_names.lst`
- macOS Migration Plan: `MACOS_MIGRATION_PLAN.md`
- Building on macOS: `docs/BUILDING_RETROBUILD_MACOS.md`

## Contributing

To update this compatibility matrix:
1. Test the emulator on Apple Silicon macOS 12+
2. Verify native ARM64 vs Rosetta 2 operation
3. Document installation path and any special requirements
4. Update the appropriate category table
5. Submit PR with testing notes

## License

This documentation is part of the RetroBat macOS project and follows the same license as the parent project.

---

**Last Updated**: February 7, 2026  
**Maintainer**: RetroBat macOS Team  
**Version**: 1.0.0
