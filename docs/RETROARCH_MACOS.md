# RetroArch for macOS Apple Silicon

This document describes the RetroArch integration for RetroBat macOS on Apple Silicon (M1/M2/M3/M4).

## Overview

RetroArch is the primary multi-system emulator in RetroBat, providing support for numerous gaming systems through libretro cores. The macOS port uses native Apple Silicon (ARM64) builds for optimal performance.

## Architecture

- **Platform**: macOS 12 (Monterey) or later
- **Architecture**: ARM64 (Apple Silicon) only
- **RetroArch Build**: Official buildbot stable releases
- **Cores**: ARM64 libretro cores from buildbot

## Build Configuration

RetroArch is configured in `build-macos.ini`:

```ini
retroarch_version=1.22.2
get_retroarch=1
retroarch_url=https://buildbot.libretro.com
```

### Download URLs

- **RetroArch Main**: `https://buildbot.libretro.com/stable/{version}/apple/osx/arm64/RetroArch.dmg`
- **Libretro Cores**: `https://buildbot.libretro.com/nightly/apple/osx/arm64/latest/{core}_libretro.dylib.zip`

## Supported Systems

RetroArch provides support for the following test systems through libretro cores:

### Nintendo
- **NES (Nintendo Entertainment System)**
  - Core: `fceumm`, `nestopia`
  - File Extensions: `.nes`, `.unif`, `.unf`

- **SNES (Super Nintendo)**
  - Core: `snes9x`, `bsnes`
  - File Extensions: `.smc`, `.sfc`, `.swc`, `.fig`

- **Game Boy / Game Boy Color**
  - Core: `gambatte`, `sameboy`, `mgba`
  - File Extensions: `.gb`, `.gbc`, `.sgb`

- **Game Boy Advance**
  - Core: `mgba`, `gpsp`
  - File Extensions: `.gba`

### Sega
- **Genesis / Mega Drive**
  - Core: `genesis_plus_gx`, `picodrive`
  - File Extensions: `.md`, `.gen`, `.bin`, `.smd`

### Sony
- **PlayStation 1**
  - Core: `pcsx_rearmed`, `swanstation`
  - File Extensions: `.cue`, `.bin`, `.img`, `.iso`, `.pbp`, `.chd`
  - **Note**: Requires BIOS files in `bios/` directory

## Libretro Cores

### Core Installation

Cores are automatically downloaded during the build process from:
1. Primary: RetroBat FTP server (if available)
2. Fallback: RetroArch buildbot (ARM64 nightly builds)

### Core List

All cores are defined in `system/configgen/lrcores_names.lst`. The build system automatically:
- Downloads ARM64-compatible `.dylib` files
- Extracts them to `build/emulators/retroarch/cores/`
- Falls back to buildbot if FTP download fails

### Core Selection Priority

For each system, multiple cores may be available. RetroBat will select cores based on:
1. System configuration
2. Core availability
3. Performance characteristics
4. Compatibility

## Configuration

### Default Settings

RetroArch configuration is located in `system/templates/retroarch/retroarch.cfg`. Key settings for macOS:

```cfg
audio_driver = "coreaudio"  # macOS Core Audio (replaces wasapi)
video_driver = "vulkan"     # or "metal" for native macOS
input_driver = "sdl2"       # SDL2 for controller support
```

### Directory Structure

```
build/emulators/retroarch/
├── RetroArch.app/          # Main application bundle
├── cores/                  # Libretro cores (.dylib)
├── config/                 # Core-specific configs
├── assets/                 # UI assets and sounds
└── shaders/                # Shader presets
```

## Shaders

RetroArch supports shader presets for enhanced graphics:

- **Location**: `system/shaders/` or `build/emulators/retroarch/shaders/`
- **Supported**: GLSL, Slang (Vulkan/Metal)
- **macOS Recommendation**: Use Metal-compatible Slang shaders for best performance

Common shader presets:
- CRT effects
- Scanline filters
- LCD effects
- Upscaling (xBR, Super Eagle)

## Controller Input

### SDL2 Support

RetroArch on macOS uses SDL2 for controller input, providing support for:
- Xbox controllers (USB/Bluetooth)
- PlayStation controllers (USB/Bluetooth)
- Nintendo Switch Pro Controller
- Generic USB/Bluetooth controllers

### Configuration

Controller mappings are stored in:
- `system/resources/inputmapping/retroarch_controller.json`
- `system/templates/user/inputmapping/retroarch_controller.json`

## Save States

### Save State Features

- **Quick Save**: Instant save state (default: F2)
- **Quick Load**: Instant load state (default: F4)
- **Save Slots**: Multiple save slots per game (0-9)
- **Auto Save**: Automatic save on exit (configurable)

### Save Locations

- **Save States**: `saves/{system}/{game}/`
- **SRAM/Battery**: `saves/{system}/{game}/`
- **Screenshots**: `screenshots/{system}/`

## Performance

### Apple Silicon Optimization

- **M1/M2/M3/M4**: Native ARM64 cores provide optimal performance
- **Metal API**: Hardware-accelerated graphics rendering
- **Audio**: Low-latency Core Audio integration

### Expected Performance

| System | Performance | Notes |
|--------|-------------|-------|
| NES | Perfect | Full speed, no issues |
| SNES | Perfect | Full speed with accuracy cores |
| Genesis | Perfect | Full speed, accurate emulation |
| PlayStation 1 | Excellent | Full speed with hardware rendering |
| Game Boy/GBC | Perfect | Full speed, accurate LCD emulation |
| GBA | Perfect | Full speed with mgba core |

## Troubleshooting

### Common Issues

#### RetroArch won't launch
- Verify macOS version (12+)
- Check if app is in quarantine: `xattr -d com.apple.quarantine RetroArch.app`
- Ensure proper permissions in System Preferences

#### Core won't load
- Verify core is ARM64 (`.dylib` file)
- Check core compatibility with RetroArch version
- Try alternative core for the same system

#### Audio crackling
- Adjust audio latency in RetroArch settings
- Try different audio driver (coreaudio vs. sdl2)
- Increase audio buffer size

#### Poor performance
- Disable shaders temporarily
- Try faster core alternative (e.g., snes9x vs. bsnes)
- Reduce resolution scale
- Disable rewind feature

### Logs

RetroArch logs can be found at:
- `~/Library/Application Support/RetroArch/retroarch.log`
- Or enable verbose logging in RetroArch settings

## Building from Source

If you need to build RetroArch manually:

```bash
cd /path/to/retrobat-macos
cp build-macos.ini build.ini
dotnet run --project src/RetroBuild/RetroBuild.csproj
```

This will:
1. Download RetroArch stable release (ARM64)
2. Extract to `build/emulators/retroarch/`
3. Download all libretro cores
4. Set up configuration files

## Testing

### Test Checklist

- [ ] RetroArch launches successfully
- [ ] NES games load and play (fceumm core)
- [ ] SNES games load and play (snes9x core)
- [ ] Genesis games load and play (genesis_plus_gx core)
- [ ] PlayStation 1 games load and play (swanstation core)
- [ ] Game Boy games load and play (gambatte core)
- [ ] Game Boy Advance games load and play (mgba core)
- [ ] Controller input works correctly
- [ ] Save states work (quick save/load)
- [ ] SRAM saves persist between sessions
- [ ] Shaders can be loaded and applied
- [ ] Audio plays without crackling
- [ ] Performance is acceptable (60 FPS)

### Test ROMs

Use homebrew or freely available test ROMs:
- **NES**: Homebrew games from NESDev
- **SNES**: SNES test ROMs
- **Genesis**: Homebrew demos
- **PlayStation 1**: PlayStation demos or homebrew
- **GB/GBC/GBA**: Homebrew games

## Resources

### Official Documentation
- [RetroArch Documentation](https://docs.libretro.com/)
- [Libretro Cores](https://docs.libretro.com/library/)
- [RetroArch Buildbot](https://buildbot.libretro.com/)

### Core Documentation
- [Beetle PSX](https://docs.libretro.com/library/beetle_psx/)
- [Genesis Plus GX](https://docs.libretro.com/library/genesis_plus_gx/)
- [mGBA](https://docs.libretro.com/library/mgba/)
- [SNES9x](https://docs.libretro.com/library/snes9x/)

### Community
- [Libretro Forums](https://forums.libretro.com/)
- [RetroArch Discord](https://discord.gg/retroarch)

## Known Limitations

### macOS-Specific

1. **Intel Macs Not Supported**: This build is ARM64 only
2. **Quarantine Issues**: macOS may quarantine downloaded apps
3. **Permissions**: Requires microphone/input monitoring permissions for some features
4. **Gatekeeper**: May need to allow app in Security & Privacy settings

### Core Limitations

Some cores may not be available or fully functional on ARM64:
- Check core compatibility before use
- Some Windows-only cores have no macOS equivalent
- Performance varies by core complexity

## Future Enhancements

Potential improvements for RetroArch integration:

- [ ] Core downloader UI integration
- [ ] Automatic BIOS verification
- [ ] Shader pack pre-installation
- [ ] Core update mechanism
- [ ] Save state sync across devices
- [ ] Achievement integration setup
- [ ] Online multiplayer configuration
- [ ] Custom core compilation support

## Version History

- **v1.22.2**: Current stable RetroArch version targeted for macOS Apple Silicon

---

**Last Updated**: February 2024
**Maintainer**: RetroBat macOS Team
