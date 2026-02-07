# Quick Start Guide - macOS Development Setup

This is a streamlined guide to get your macOS development environment up and running quickly. For detailed instructions, see [BUILDING_MACOS.md](BUILDING_MACOS.md).

## Prerequisites

- macOS 12 (Monterey) or later
- Apple Silicon Mac (M1/M2/M3/M4)
- 20 GB free disk space
- Internet connection

## Quick Setup (15-30 minutes)

### 1. Install Xcode Command Line Tools (2 min)

```bash
xcode-select --install
```

### 2. Install Homebrew (5 min)

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Add to PATH (for Apple Silicon)
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
eval "$(/opt/homebrew/bin/brew shellenv)"
```

### 3. Install All Dependencies (10-20 min)

```bash
# Navigate to the project directory
cd retrobat-macos

# Install all dependencies in one command
brew bundle

# This installs:
# - .NET SDK
# - Visual Studio Code
# - p7zip, wget, curl
# - SDL2, CMake, Boost, FreeImage, FreeType, Eigen
```

### 4. Verify Your Setup (1 min)

```bash
./verify-macos-setup.sh
```

**Expected output**: All checks should pass with green checkmarks (✓).

If any checks fail, see [BUILDING_MACOS.md](BUILDING_MACOS.md) for detailed troubleshooting.

## Next Steps

Once your environment is verified:

1. **Clone emulatorLauncher source**:
   ```bash
   mkdir -p ~/Developer/retrobat-workspace
   cd ~/Developer/retrobat-workspace
   git clone https://github.com/RetroBat-Official/emulatorlauncher.git
   ```

2. **Try building**:
   ```bash
   cd emulatorlauncher
   dotnet build
   ```

3. **Read the documentation**:
   - [Migration Plan](MACOS_MIGRATION_PLAN.md) - Overall project plan
   - [Architecture](ARCHITECTURE.md) - System architecture
   - [Building on macOS](BUILDING_MACOS.md) - Detailed build guide

4. **Check for tasks**: See [GitHub Issues](https://github.com/bayramog/retrobat-macos/issues)

## Troubleshooting

### Common Issues

**"brew: command not found"**
```bash
eval "$(/opt/homebrew/bin/brew shellenv)"
```

**".NET version too old"**
```bash
brew upgrade --cask dotnet-sdk
```

**"Missing dependencies"**
```bash
brew bundle
```

**Still having issues?**
- See [BUILDING_MACOS.md](BUILDING_MACOS.md) for detailed troubleshooting
- Run `./verify-macos-setup.sh` to diagnose issues
- Check [GitHub Issues](https://github.com/bayramog/retrobat-macos/issues)

## One-Liner (For Experienced Developers)

If you already have Homebrew and Xcode Command Line Tools:

```bash
brew bundle && ./verify-macos-setup.sh
```

## Support

- **Discord**: https://discord.gg/GVcPNxwzuT
- **Issues**: https://github.com/bayramog/retrobat-macos/issues
- **Wiki**: https://wiki.retrobat.org/

---

**Last Updated**: 2026-02-07  
**Status**: Active Development
