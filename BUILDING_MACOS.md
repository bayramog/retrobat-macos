# Building RetroBat on macOS Apple Silicon

This guide provides step-by-step instructions for setting up a development environment to build and test RetroBat on macOS Apple Silicon (M1/M2/M3/M4).

## Table of Contents

1. [System Requirements](#system-requirements)
2. [Prerequisites Installation](#prerequisites-installation)
3. [Development Tools Setup](#development-tools-setup)
4. [Clone Required Repositories](#clone-required-repositories)
5. [Verify Build Environment](#verify-build-environment)
6. [Building the Project](#building-the-project)
7. [Troubleshooting](#troubleshooting)
8. [Next Steps](#next-steps)

---

## System Requirements

### Minimum Requirements
- **Operating System**: macOS 12 (Monterey) or later
- **Processor**: Apple Silicon (M1, M2, M3, M4) - ARM64 only
- **Memory**: 8 GB RAM (16 GB recommended)
- **Storage**: 20 GB free space (for tools, dependencies, and build artifacts)
- **Internet**: Required for downloading dependencies

### Recommended Configuration
- **Operating System**: macOS 13 (Ventura) or macOS 14 (Sonoma)
- **Processor**: M2 or newer
- **Memory**: 16 GB RAM or more
- **Storage**: 50 GB free space

---

## Prerequisites Installation

### 1. Install Xcode and Command Line Tools

The Command Line Tools include essential compilers and build tools required for development on macOS.

#### Option A: Full Xcode (Recommended for comprehensive development)

1. Download from the Mac App Store:
   ```bash
   open "https://apps.apple.com/us/app/xcode/id497799835"
   ```

2. After installation, accept the license:
   ```bash
   sudo xcodebuild -license accept
   ```

3. Install Command Line Tools:
   ```bash
   xcode-select --install
   ```

#### Option B: Command Line Tools Only (Lighter weight)

```bash
xcode-select --install
```

**Verify Installation:**
```bash
xcode-select -p
# Should output: /Applications/Xcode.app/Contents/Developer
# Or: /Library/Developer/CommandLineTools

gcc --version
# Should show Apple clang version
```

---

### 2. Install Homebrew Package Manager

Homebrew is the package manager for macOS that simplifies installing development tools and libraries.

#### Install Homebrew

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

#### Add Homebrew to PATH

For Apple Silicon Macs, add Homebrew to your shell profile:

```bash
# For zsh (default shell on macOS)
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
eval "$(/opt/homebrew/bin/brew shellenv)"

# For bash (if you're using bash)
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.bash_profile
eval "$(/opt/homebrew/bin/brew shellenv)"
```

**Verify Installation:**
```bash
brew --version
# Should show Homebrew version (e.g., Homebrew 4.x.x)

which brew
# Should output: /opt/homebrew/bin/brew
```

**Update Homebrew:**
```bash
brew update
```

---

### 3. Install .NET 6+ SDK

RetroBat's build tools and emulatorLauncher require .NET 6 or later for cross-platform support.

#### Install via Homebrew (Recommended)

```bash
brew install --cask dotnet-sdk
```

#### Or Download from Microsoft

Alternatively, download the .NET SDK for macOS ARM64:
- Visit: https://dotnet.microsoft.com/download/dotnet/8.0
- Download: .NET 8.0 SDK for macOS ARM64

**Verify Installation:**
```bash
dotnet --version
# Should show version 6.0.x or later (8.0.x recommended)

dotnet --list-sdks
# Should list installed SDK versions
```

**Check Runtime Information:**
```bash
dotnet --info
# Should show macOS ARM64 runtime information
```

---

### 4. Install Required Dependencies

Install essential tools and libraries required for building RetroBat components.

#### Using Homebrew (Recommended)

Create a `Brewfile` in the project root or install individually:

```bash
# Essential compression tools
brew install p7zip

# Download utilities
brew install wget

# SDL3 for controller support (when available)
# Note: SDL3 may not be in stable Homebrew yet
# brew install sdl3

# SDL2 (for EmulationStation)
brew install sdl2

# Git (if not already installed)
brew install git

# CMake (for building C++ components)
brew install cmake

# Additional libraries for EmulationStation
brew install boost
brew install freeimage
brew install freetype
brew install eigen
brew install curl
```

#### All-in-One Installation

```bash
brew install p7zip wget sdl2 git cmake boost freeimage freetype eigen curl
```

**Verify Installations:**
```bash
# Check p7zip
7z --version

# Check wget
wget --version

# Check SDL2
brew list sdl2

# Check CMake
cmake --version

# Check other libraries
brew list boost freeimage freetype eigen curl
```

---

### 5. Install and Configure IDE

Choose one of the following IDEs for .NET development:

#### Option A: Visual Studio Code (Recommended - Free)

**Install:**
```bash
brew install --cask visual-studio-code
```

**Install Required Extensions:**

Open VS Code and install the following extensions:
1. **C# Dev Kit** (by Microsoft) - for .NET development
2. **C/C++** (by Microsoft) - for EmulationStation development
3. **CMake Tools** (by Microsoft) - for CMake projects
4. **.NET Install Tool** - manages .NET SDKs

**Command line installation:**
```bash
code --install-extension ms-dotnettools.csdevkit
code --install-extension ms-vscode.cpptools
code --install-extension ms-vscode.cmake-tools
code --install-extension ms-dotnettools.vscode-dotnet-runtime
```

**Configure VS Code:**
1. Open VS Code settings (Cmd + ,)
2. Search for "dotnet"
3. Ensure "Omnisharp: Use Modern Net" is enabled

#### Option B: JetBrains Rider (Commercial - Free for Open Source)

**Install:**
```bash
brew install --cask rider
```

**Configure Rider:**
1. Launch Rider
2. Configure .NET SDK path if not auto-detected
3. Install plugins: 
   - C++ support (if needed)
   - CMake support

**Free License for Open Source:**
Apply for a free license at: https://www.jetbrains.com/community/opensource/

#### Option C: Visual Studio for Mac (Being Deprecated)

**Note**: Visual Studio for Mac is being discontinued. Use VS Code or Rider instead.

---

## Clone Required Repositories

### 1. Clone Main RetroBat macOS Repository

```bash
# Navigate to your development directory
cd ~/Developer  # or your preferred location

# Clone the macOS port repository
git clone https://github.com/bayramog/retrobat-macos.git
cd retrobat-macos
```

### 2. Clone emulatorLauncher Source Repository

The emulatorLauncher is the core component that launches emulators from EmulationStation.

```bash
# Create a workspace directory for all RetroBat components
mkdir -p ~/Developer/retrobat-workspace
cd ~/Developer/retrobat-workspace

# Clone emulatorLauncher (official RetroBat repository)
git clone https://github.com/RetroBat-Official/emulatorlauncher.git
cd emulatorlauncher

# Check out the latest stable branch or main
git checkout main
```

**Repository Structure:**
```
~/Developer/
├── retrobat-macos/          # Main macOS port repository
│   ├── system/
│   ├── bios/
│   ├── scripts/
│   └── ...
└── retrobat-workspace/
    ├── emulatorlauncher/    # emulatorLauncher C# source
    └── emulationstation/    # (to be added later)
```

### 3. (Optional) Clone EmulationStation Source

This will be needed later for porting EmulationStation to macOS:

```bash
cd ~/Developer/retrobat-workspace

# Clone RetroBat's EmulationStation fork
git clone https://github.com/RetroBat-Official/emulationstation.git
cd emulationstation
```

---

## Verify Build Environment

### Create Verification Script

Create a script to verify all tools are installed correctly:

```bash
# Create the script
cat > ~/Developer/retrobat-macos/verify-setup.sh << 'EOF'
#!/bin/bash

echo "========================================"
echo "RetroBat macOS Build Environment Check"
echo "========================================"
echo ""

# Color codes
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color

check_command() {
    if command -v $1 &> /dev/null; then
        echo -e "${GREEN}✓${NC} $1 is installed"
        if [ ! -z "$2" ]; then
            echo "  Version: $($1 $2 2>&1 | head -n 1)"
        fi
        return 0
    else
        echo -e "${RED}✗${NC} $1 is NOT installed"
        return 1
    fi
}

check_brew_package() {
    if brew list $1 &> /dev/null; then
        echo -e "${GREEN}✓${NC} $1 is installed (Homebrew)"
        return 0
    else
        echo -e "${RED}✗${NC} $1 is NOT installed"
        return 1
    fi
}

echo "1. Checking System Information..."
echo "   OS: $(sw_vers -productName) $(sw_vers -productVersion)"
echo "   Architecture: $(uname -m)"
echo ""

echo "2. Checking Development Tools..."
check_command "xcode-select" "-p"
check_command "gcc" "--version"
check_command "git" "--version"
echo ""

echo "3. Checking Package Manager..."
check_command "brew" "--version"
echo ""

echo "4. Checking .NET SDK..."
check_command "dotnet" "--version"
if command -v dotnet &> /dev/null; then
    echo "   Installed SDKs:"
    dotnet --list-sdks | sed 's/^/   /'
fi
echo ""

echo "5. Checking Required Tools..."
check_command "7z" "--version"
check_command "wget" "--version"
check_command "cmake" "--version"
echo ""

echo "6. Checking Libraries..."
check_brew_package "sdl2"
check_brew_package "boost"
check_brew_package "freeimage"
check_brew_package "freetype"
check_brew_package "eigen"
check_brew_package "curl"
echo ""

echo "7. Checking IDEs..."
if [ -d "/Applications/Visual Studio Code.app" ]; then
    echo -e "${GREEN}✓${NC} Visual Studio Code is installed"
elif [ -d "/Applications/Rider.app" ]; then
    echo -e "${GREEN}✓${NC} JetBrains Rider is installed"
else
    echo -e "${RED}✗${NC} No supported IDE found (VS Code or Rider)"
fi
echo ""

echo "========================================"
echo "Environment Check Complete"
echo "========================================"
EOF

# Make it executable
chmod +x ~/Developer/retrobat-macos/verify-setup.sh
```

### Run Verification

```bash
cd ~/Developer/retrobat-macos
./verify-setup.sh
```

**Expected Output:**
All items should show a green checkmark (✓). If any items show a red X (✗), review the installation steps above.

---

## Building the Project

### 1. Build emulatorLauncher (C# .NET)

```bash
cd ~/Developer/retrobat-workspace/emulatorlauncher

# Restore NuGet packages
dotnet restore

# Build the project (Release configuration)
dotnet build --configuration Release

# Publish for macOS ARM64
dotnet publish --configuration Release --runtime osx-arm64 --self-contained false

# Output will be in: bin/Release/net6.0/osx-arm64/publish/
```

**Verify Build:**
```bash
# Check if binary was created
ls -l bin/Release/net*/osx-arm64/publish/

# Try running it (may require additional configuration)
./bin/Release/net*/osx-arm64/publish/emulatorLauncher --help
```

### 2. Build EmulationStation (C++ SDL2)

**Note**: This is a more complex build and will be documented separately. For now, focus on understanding the dependencies.

```bash
cd ~/Developer/retrobat-workspace/emulationstation

# Create build directory
mkdir build
cd build

# Configure with CMake for macOS
cmake .. -DCMAKE_OSX_ARCHITECTURES=arm64

# Build (may not work yet without porting)
make -j$(sysctl -n hw.ncpu)
```

### 3. Test .NET Project Creation

Create a simple test project to verify your .NET setup:

```bash
# Create a test directory
mkdir -p ~/Developer/test-dotnet
cd ~/Developer/test-dotnet

# Create a new console app
dotnet new console -n TestApp

# Build and run
cd TestApp
dotnet build
dotnet run

# Should output: "Hello, World!"
```

---

## Troubleshooting

### Common Issues and Solutions

#### Issue: "xcode-select: command not found"
**Solution**: Install Command Line Tools
```bash
xcode-select --install
```

#### Issue: "brew: command not found"
**Solution**: Reinstall Homebrew or add it to PATH
```bash
eval "$(/opt/homebrew/bin/brew shellenv)"
```

#### Issue: ".NET SDK not found"
**Solution**: Reinstall .NET SDK and verify PATH
```bash
brew reinstall --cask dotnet-sdk
dotnet --version
```

#### Issue: "Permission denied" when running scripts
**Solution**: Make scripts executable
```bash
chmod +x script-name.sh
```

#### Issue: "SDL2 library not found"
**Solution**: Reinstall SDL2 and verify installation
```bash
brew reinstall sdl2
brew list sdl2
```

#### Issue: "Cannot find 7z command"
**Solution**: Ensure p7zip is installed and in PATH
```bash
brew reinstall p7zip
which 7z
```

#### Issue: CMake cannot find libraries
**Solution**: Set environment variables for Homebrew libraries
```bash
export CMAKE_PREFIX_PATH="/opt/homebrew:$CMAKE_PREFIX_PATH"
```

### Getting Help

If you encounter issues not covered here:

1. **Check GitHub Issues**: https://github.com/bayramog/retrobat-macos/issues
2. **Review Documentation**: 
   - [Migration Plan](MACOS_MIGRATION_PLAN.md)
   - [Architecture Overview](ARCHITECTURE.md)
3. **Join Discord**: https://discord.gg/GVcPNxwzuT
4. **Open an Issue**: Use the issue templates in [ISSUES.md](ISSUES.md)

---

## Next Steps

After successfully setting up your development environment:

1. **Read the Migration Plan**: [MACOS_MIGRATION_PLAN.md](MACOS_MIGRATION_PLAN.md)
2. **Understand the Architecture**: [ARCHITECTURE.md](ARCHITECTURE.md)
3. **Review Open Issues**: Check GitHub Issues for tasks to work on
4. **Start Contributing**:
   - Port RetroBuild to .NET 6+ (Issue #2)
   - Replace system tools (Issue #3)
   - Port emulatorLauncher (Issue #5)
   - Port EmulationStation (Issue #4)

### Development Workflow

1. **Create a branch** for your work:
   ```bash
   git checkout -b feature/your-feature-name
   ```

2. **Make changes and test**:
   ```bash
   dotnet build
   dotnet test  # when tests are available
   ```

3. **Commit and push**:
   ```bash
   git add .
   git commit -m "Description of changes"
   git push origin feature/your-feature-name
   ```

4. **Create a Pull Request** on GitHub

### Testing Your Changes

- **Always test on a real macOS device** (not a VM if possible)
- **Test on multiple macOS versions** if you have access
- **Test with different hardware** (M1, M2, M3 if possible)
- **Document any issues** you encounter

---

## Additional Resources

### Documentation
- **.NET on macOS**: https://docs.microsoft.com/en-us/dotnet/core/install/macos
- **Homebrew Documentation**: https://docs.brew.sh/
- **CMake Tutorial**: https://cmake.org/cmake/help/latest/guide/tutorial/
- **SDL2 Documentation**: https://wiki.libsdl.org/SDL2/

### RetroBat Resources
- **Official Website**: https://www.retrobat.org/
- **Wiki**: https://wiki.retrobat.org/
- **Forum**: https://social.retrobat.org/forum
- **Discord**: https://discord.gg/GVcPNxwzuT

### Development Tools
- **Visual Studio Code**: https://code.visualstudio.com/docs
- **JetBrains Rider**: https://www.jetbrains.com/rider/documentation/
- **Git Documentation**: https://git-scm.com/doc

---

## Maintenance

### Keeping Your Environment Updated

Regularly update your development tools:

```bash
# Update Homebrew and all packages
brew update && brew upgrade

# Update .NET SDK
brew upgrade --cask dotnet-sdk

# Update VS Code
brew upgrade --cask visual-studio-code

# Update Xcode (via Mac App Store)
```

### Clean Build

If you need to start fresh:

```bash
# Clean .NET projects
cd ~/Developer/retrobat-workspace/emulatorlauncher
dotnet clean

# Remove build artifacts
rm -rf bin/ obj/

# Clean CMake builds
cd ~/Developer/retrobat-workspace/emulationstation/build
rm -rf *
```

---

## Contributing

We welcome contributions to the macOS port! Please:

1. Follow the coding standards used in the project
2. Write clear commit messages
3. Document your changes
4. Test thoroughly on macOS
5. Update documentation as needed

For more information, see [CONTRIBUTING.md](CONTRIBUTING.md) (to be created).

---

## License

RetroBat is licensed under LGPL v3. See [license.txt](license.txt) for details.

---

**Last Updated**: 2026-02-07  
**For**: RetroBat macOS Port v8.0.0  
**Maintained By**: RetroBat macOS Team
