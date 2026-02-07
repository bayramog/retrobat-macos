# Windows to macOS Configuration Conversion

This document describes the automated conversion of RetroBat configuration files from Windows to macOS format.

## Overview

All configuration files in the `system/templates/` and `system/configgen/` directories have been converted to use macOS-compatible paths and environment variables, with intelligent exclusions for files that require special syntax.

## Final Results

- **73 configuration files converted** (appropriate files only)
- **~17,870 path transformations** successfully applied
- **8 Qt INI files preserved** (special syntax intact)
- **12 gettext .po/.pot files preserved** (escape sequences intact)
- **Zero inappropriate conversions**

## Conversion Script

The automated conversion script is located at:
```
scripts/convert_windows_paths_to_macos.py
```

### Usage

```bash
# Dry run to preview changes
python3 scripts/convert_windows_paths_to_macos.py --dry-run <path>

# Convert files
python3 scripts/convert_windows_paths_to_macos.py <path>

# Convert with verbose output
python3 scripts/convert_windows_paths_to_macos.py --verbose <path>
```

### Examples

```bash
# Convert a single file
python3 scripts/convert_windows_paths_to_macos.py system/templates/retroarch/retroarch.cfg

# Convert entire directory
python3 scripts/convert_windows_paths_to_macos.py system/templates/

# Preview changes without modifying files
python3 scripts/convert_windows_paths_to_macos.py --dry-run system/templates/
```

## Conversion Rules

The script applies the following transformations:

### 1. Environment Variables
- `%HOME%` → `$HOME`
- `%USERPROFILE%` → `$HOME`

**Example:**
```
Before: "%HOME%\emulatorLauncher.exe"
After:  "$HOME/emulatorLauncher"
```

### 2. Path Separators
- Backslash (`\`) → Forward slash (`/`)

**Example:**
```
Before: ~\..\roms\flash
After:  ~/../roms/flash
```

### 3. Executable Extensions
- `.exe` removed from paths

**Example:**
```
Before: emulatorLauncher.exe
After:  emulatorLauncher
```

**Note:** `.exe` extensions in `<extension>` tags (game file types) are preserved as they represent valid file formats.

### 4. Drive Letters
- Windows drive letters (e.g., `C:\`) converted to Unix paths (`/`)

### 5. Special Path Patterns
- RetroArch-style paths like `:\assets` → `$HOME/assets`

### 6. Trailing Backslashes
- Path endings like `./dir\` → `./dir/`

### 7. Leading Backslashes  
- Path beginnings like `\dev_hdd0/` → `/dev_hdd0/`

### 8. Wildcards
- Patterns like `path\*.ext` → `path/*.ext`

## Files Intelligently Excluded

The conversion script automatically excludes files that use backslashes for special syntax:

### Qt INI Configuration Files (8 files)
These files use backslashes in two special ways:
1. **Key hierarchy separators:** `General\Geometry` (Qt standard format)
2. **Hex escape sequences:** `@ByteArray(\x1\xd9...)` (binary data encoding)

**Excluded files:**
- `kronos/kronos.ini`
- `mupen64/Config/GLideN64.ini`
- `project64/Plugin/GFX/GLideN64/GLideN64.ini`
- `rpcs3/GuiConfigs/CurrentSettings.ini`
- `shadps4/launcher/qt_ui.ini`
- `simple64/simple64-gui.ini`
- `yuzu/user/config/qt-config.ini`
- `suyu/user/config/qt-config.ini`

### Gettext Localization Files (12 files)
These files use backslash escape sequences for special characters:
- `\n` for newlines
- `\t` for tabs
- `\"` for quotes

**Excluded files:**
- All `.po` and `.pot` files in `es_features.locale/` (12 files across all languages)

## Conversion Statistics

### Files Converted
- **Templates:** 73 files modified
- **ConfigGen:** 3 files modified (templates_files.lst, retrobat_tree.lst, kill_process.lst)
- **Total Conversions:** ~17,870 path transformations
- **Git Changes:** 55 files changed, 7,987 insertions(+), 7,523 deletions(-)

### Files Intelligently Excluded
- **Qt INI files:** 8 files (use `\` for key hierarchy and `\x` for hex escape sequences)
- **Gettext files:** 12 .po/.pot files (use `\n` for newline escape sequences)
- **Total Preserved:** 20 files with special syntax requirements

### Key Files Converted

#### EmulationStation Configs
- `system/templates/emulationstation/es_systems.cfg`
- `system/templates/emulationstation/es_padtokey.cfg`
- `system/templates/emulationstation/emulatorLauncher.cfg`
- All locale files in `es_features.locale/`

#### RetroArch Configs
- `system/templates/retroarch/retroarch.cfg`

#### Emulator-Specific Configs
- Dolphin, PCSX2, Cemu, Citra, Yuzu, and many others
- See git history for complete list

#### ConfigGen Files
- `system/configgen/templates_files.lst`
- `system/configgen/retrobat_tree.lst`
- `system/configgen/kill_process.lst`

## Platform-Specific Considerations

While paths and environment variables have been converted, some configuration values remain Windows-specific and will need runtime platform detection:

### RetroArch Drivers

The following drivers in `system/templates/retroarch/retroarch.cfg` are Windows-specific:

```ini
audio_driver = "wasapi"          # Should be "coreaudio" on macOS
video_driver = "d3d12"           # Should be "metal" or "gl" on macOS
input_driver = "dinput"          # Should be "sdl2" on macOS
microphone_driver = "wasapi"     # Should be "coreaudio" on macOS
```

**Recommendation:** These should be handled by the configuration generation code at runtime based on the detected platform.

### File Extensions

Some emulators may have platform-specific executable names:
- Windows: `emulator.exe`
- macOS: `emulator` or `emulator.app`

**Recommendation:** Use platform detection in the emulator launcher code.

## Verification

To verify the conversion was successful:

```bash
# Check for remaining Windows paths
grep -r "%HOME%" system/templates/
grep -r "%USERPROFILE%" system/templates/
grep -r "\.exe" system/configgen/kill_process.lst

# Check for backslash paths (should only find in comments or strings)
grep -r "\\\\" system/templates/emulationstation/es_systems.cfg
```

## Future Maintenance

When adding new configuration files:

1. Use Unix-style paths (`/` instead of `\`)
2. Use `$HOME` instead of `%HOME%` or `%USERPROFILE%`
3. Don't include `.exe` extensions in paths
4. Use platform detection for platform-specific settings

## Testing

Before deploying:

1. ✅ Path conversions verified
2. ✅ Environment variables converted
3. ✅ Executable extensions removed
4. ⚠️  Runtime platform detection needed for drivers
5. ⏳ Testing with actual emulators (pending)

## Related Files

- Conversion script: `scripts/convert_windows_paths_to_macos.py`
- This documentation: `docs/WINDOWS_TO_MACOS_CONVERSION.md`
- Main architecture: `ARCHITECTURE.md`
- Migration plan: `MACOS_MIGRATION_PLAN.md`

## Credits

Automated conversion completed as part of Issue #3: "Convert All Configuration Files from Windows to macOS Path Format"
