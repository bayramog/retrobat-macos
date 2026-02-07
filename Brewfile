# Brewfile for RetroBat macOS Development
#
# Install all dependencies with: brew bundle
# Update dependencies with: brew bundle install --verbose
#
# This Brewfile includes all required tools and libraries for:
# - Building RetroBat with RetroBuild
# - Compiling EmulationStation from source
# - Running emulators and RetroArch

# ============================================================================
# Core Build Tools (Required for RetroBuild)
# ============================================================================

# p7zip - Archive extraction and creation (replaces 7za.exe)
brew "p7zip"

# wget - Download utility (replaces wget.exe)
brew "wget"

# curl - Already built-in on macOS, but ensure latest version
brew "curl"

# git - Version control (built-in with Xcode, but ensure latest)
brew "git"

# pkg-config - Helper tool for compiling
brew "pkg-config"

# .NET SDK - Required for building and running RetroBuild
brew "dotnet-sdk"

# ============================================================================
# EmulationStation Dependencies (Required for ES compilation)
# ============================================================================

# SDL2 - Cross-platform multimedia library (replaces SDL2.dll)
# Required for EmulationStation graphics, input, and audio
brew "sdl2"

# SDL3 - Next-generation SDL (optional, replaces SDL3.dll)
# Only needed for emulators that specifically require SDL3
# Note: May need to build from source if not in Homebrew
# brew "sdl3"

# CMake - Build system for EmulationStation
brew "cmake"

# Boost - C++ libraries for EmulationStation
brew "boost"

# FreeImage - Image loading library
brew "freeimage"

# FreeType - Font rendering library
brew "freetype"

# Eigen - C++ template library for linear algebra
brew "eigen"

# GLM - OpenGL Mathematics library
brew "glm"

# OpenGL - Graphics API (built-in on macOS)
# No brew package needed, use native framework

# ============================================================================
# Additional Development Tools (Optional but Recommended)
# ============================================================================

# Visual Studio Code - Code editor
cask "visual-studio-code"

# JetBrains Rider (Commercial - Free for Open Source)
# Uncomment if you prefer Rider over VS Code
# cask "rider"

# Xcode Command Line Tools (required, install separately if needed)
# xcode-select --install

# ============================================================================
# Optional: Emulator Runtime Dependencies
# ============================================================================

# Additional libraries that may be needed by specific emulators
# Uncomment as needed:

# brew "ffmpeg"        # Video encoding/decoding
# brew "libpng"        # PNG image support
# brew "jpeg"          # JPEG image support
# brew "zlib"          # Compression library
# brew "openal-soft"   # Audio library

# ============================================================================
# Optional: Additional Utilities
# ============================================================================

# brew "tree"               # Display directory structure
# brew "htop"               # Better top command
# brew "jq"                 # JSON processor

# Mac App Store apps (requires mas-cli)
# Install mas-cli first: brew install mas
# mas "Xcode", id: 497799835
