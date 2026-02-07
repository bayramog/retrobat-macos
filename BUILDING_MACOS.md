# macOS Development Environment Setup

This guide walks through setting up a macOS Apple Silicon (ARM64) development environment for building and testing RetroBat.

## Requirements

- macOS 12 (Monterey) or later
- Apple Silicon (M1/M2/M3/M4)
- Xcode Command Line Tools
- Homebrew
- .NET 6+ SDK (recommended: .NET 8)

## 1) Install Xcode Command Line Tools

```bash
xcode-select --install
```

Verify:

```bash
xcode-select -p
```

## 2) Install Homebrew

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

Verify:

```bash
brew --version
```

## 3) Install .NET SDK

Recommended: .NET 8 SDK via Homebrew.

```bash
brew install dotnet-sdk
```

Verify:

```bash
dotnet --version
```

## 4) Install Required Dependencies

Use the Brewfile for a complete setup (recommended):

```bash
brew bundle
```

Or install only the core build tools:

```bash
brew install p7zip wget sdl2
```

Optional SDL3 (only if needed by specific emulators):

```bash
brew install sdl3
```

## 5) Configure Your IDE

Choose one of the following:

- Visual Studio Code: install from Homebrew cask or the VS Code website.
- JetBrains Rider: install from JetBrains Toolbox.

For VS Code (optional):

```bash
brew install --cask visual-studio-code
```

## 6) Clone EmulatorLauncher Source Repository

EmulatorLauncher is tracked in the main RetroBat org and will be needed for the .NET 6+ port later.

```bash
git clone https://github.com/RetroBat-Official/emulatorlauncher.git
```

## 7) Verify Tooling

Run the verification script:

```bash
./verify-tools.sh
```

This checks:
- Core tools (7z, wget, curl, git, dotnet)
- SDL libraries (SDL2, SDL3)
- RetroBuild compilation

## 8) Test Build (RetroBuild)

Use the macOS build configuration and run a test build:

```bash
cp build-macos.ini build.ini
cd src/RetroBuild

dotnet build -c Release

cd ../..
dotnet run --project src/RetroBuild/RetroBuild.csproj
```

Build output will appear in:

- build/
- retrobat-v*.zip
- retrobat-v*.zip.sha256.txt

## Notes

- The macOS build uses system tools from PATH (Homebrew) instead of bundled Windows binaries.
- SDL2 is required for EmulationStation. SDL3 is optional.
- Apple Silicon is the supported target for this port.

## References

- Brewfile
- docs/BUILDING_RETROBUILD_MACOS.md
- system/tools/macos/README.md
