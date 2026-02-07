# Performance Testing Guide for Apple Silicon

This guide provides comprehensive instructions for testing and optimizing RetroBat performance on Apple Silicon Macs (M1, M2, M3, and later).

## Table of Contents

- [Overview](#overview)
- [Test Hardware](#test-hardware)
- [Prerequisites](#prerequisites)
- [Performance Metrics](#performance-metrics)
- [Testing Procedures](#testing-procedures)
- [Optimization Guide](#optimization-guide)
- [Troubleshooting](#troubleshooting)

## Overview

RetroBat on Apple Silicon should deliver excellent performance due to:
- Native ARM64 architecture support
- Metal API for GPU acceleration
- Unified memory architecture
- Efficient power management
- Advanced thermal design

### Performance Goals

| Component | Metric | Target |
|-----------|--------|--------|
| EmulationStation UI | Menu scrolling FPS | ≥60 FPS |
| EmulationStation UI | Memory usage | <1 GB |
| RetroArch | Emulation speed | 100% for supported systems |
| RetroArch | Memory usage | Reasonable per system |
| System | Battery impact | Documented per use case |
| System | Thermal behavior | No throttling under normal use |

## Test Hardware

### Officially Tested Configurations

- **Mac mini M1** (2020)
  - 8-core CPU, 8-core GPU
  - 8GB / 16GB RAM
  - macOS Sonoma 14.0+

- **MacBook Pro M1/M2** (2020-2023)
  - 8-core / 10-core CPU
  - 7-core / 10-core GPU
  - 16GB / 24GB RAM
  - macOS Sonoma 14.0+

- **Mac Studio M1 Max/Ultra** (2022)
  - 10-core / 20-core CPU
  - 24-core / 48-core GPU
  - 32GB / 64GB / 128GB RAM
  - macOS Sonoma 14.0+

- **iMac M3** (2023)
  - 8-core CPU, 10-core GPU
  - 8GB / 16GB / 24GB RAM
  - macOS Sonoma 14.0+

### Community Tested

Please contribute your test results for other configurations!

## Prerequisites

### Required Software

1. **RetroBat** - Latest macOS build
2. **Homebrew** - For dependencies
   ```bash
   /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
   ```

3. **Performance Tools** (optional but recommended)
   ```bash
   # Install monitoring tools
   brew install htop
   brew install --cask stats  # Menu bar system monitor
   ```

### Performance Testing Scripts

RetroBat includes performance testing scripts in the `scripts/` directory:

- `benchmark-emulationstation.sh` - EmulationStation UI performance
- `benchmark-retroarch.sh` - RetroArch core performance
- `monitor-system-performance.sh` - System-wide monitoring

Make scripts executable:
```bash
chmod +x scripts/benchmark-*.sh
chmod +x scripts/monitor-system-performance.sh
```

## Performance Metrics

### EmulationStation Metrics

1. **Frame Rate (FPS)**
   - Target: Consistent 60 FPS
   - Measure: During menu navigation and game list scrolling
   - Acceptable: 55-60 FPS average

2. **Memory Usage**
   - Target: <1GB for EmulationStation process
   - Measure: With typical game library (1000+ games)
   - Acceptable: <1.5GB with large libraries

3. **Input Latency**
   - Target: <16ms (1 frame at 60fps)
   - Measure: Time from button press to menu response
   - Acceptable: <33ms (2 frames)

4. **Theme Loading Time**
   - Target: <2 seconds for complex themes
   - Measure: Time to switch between themes
   - Acceptable: <5 seconds

### RetroArch Metrics

1. **Emulation Speed**
   - Target: 100% (full speed) for supported systems
   - Measure: In-game frame rate vs target frame rate
   - Acceptable: >95% for demanding systems

2. **Frame Time Consistency**
   - Target: <1ms variance
   - Measure: Standard deviation of frame times
   - Acceptable: <2ms variance

3. **Audio Latency**
   - Target: <64ms
   - Measure: Time from emulation to audio output
   - Acceptable: <128ms

4. **Input Latency**
   - Target: <16ms
   - Measure: Time from controller input to emulation response
   - Acceptable: <33ms

### System Metrics

1. **CPU Usage**
   - EmulationStation: <20% on idle, <50% during navigation
   - RetroArch: Varies by core, should not exceed 80% on supported systems

2. **GPU Usage**
   - Metal API should be utilized for rendering
   - Should scale appropriately with resolution

3. **Memory Usage**
   - System should not swap to disk during normal operation
   - Total usage should remain reasonable (<50% of available RAM)

4. **Battery Life** (Laptops)
   - EmulationStation idle: <5W power draw
   - Light emulation: <15W power draw
   - Heavy emulation: <25W power draw

5. **Thermal Behavior**
   - CPU temperature should remain below 85°C under sustained load
   - No thermal throttling during normal gaming sessions

## Testing Procedures

### 1. EmulationStation UI Performance

#### Test Setup
1. Ensure EmulationStation is installed and configured
2. Have a representative game library loaded (100+ games recommended)
3. Close all other applications

#### Running the Benchmark
```bash
# Start EmulationStation first
open /Applications/RetroBat.app

# In another terminal, run the benchmark
./scripts/benchmark-emulationstation.sh
```

#### Manual Testing Steps
While the benchmark script is running:

1. **Menu Navigation Test** (0-30 seconds)
   - Navigate through main menu
   - Open and close settings
   - Switch between systems

2. **Game List Scrolling Test** (30-60 seconds)
   - Rapidly scroll through game lists
   - Use both page-up/down and continuous scrolling
   - Test with different view modes (detailed, grid, etc.)

3. **Theme Switching Test** (60-90 seconds)
   - Switch to a complex theme
   - Wait for assets to load
   - Switch to another theme

4. **Idle Test** (90-120 seconds)
   - Leave EmulationStation on main menu
   - Observe background animations

#### Expected Results
- Average FPS: ≥60
- Memory usage: <1GB
- No UI stuttering or freezing
- Smooth animations

### 2. RetroArch Performance

#### Test Setup
1. Install RetroArch cores for systems you want to test
2. Prepare test ROMs (use homebrew/public domain ROMs)
3. Note: Some cores perform better than others on ARM64

#### Running the Benchmark
```bash
./scripts/benchmark-retroarch.sh
```

#### Manual Core Testing

For each core you want to test:

1. **Start Emulation**
   ```bash
   # Example: NES test
   /Applications/RetroArch.app/Contents/MacOS/RetroArch \
     -L ~/.config/retroarch/cores/nestopia_libretro.dylib \
     /path/to/test-rom.nes
   ```

2. **Monitor Performance**
   - Enable FPS display in RetroArch (F3 or Settings > On-Screen Display)
   - Play for 5-10 minutes
   - Note any frame drops or audio issues

3. **Check Statistics**
   - RetroArch Menu > Quick Menu > Information > Core Information
   - Note FPS, frame time, and any audio underruns

#### Recommended Test Cores

| System | Core | Expected Performance |
|--------|------|---------------------|
| NES | nestopia_libretro | 100% speed, <5% CPU |
| SNES | snes9x_libretro | 100% speed, <10% CPU |
| Genesis/MD | genesis_plus_gx_libretro | 100% speed, <8% CPU |
| PlayStation | pcsx_rearmed_libretro | 100% speed, <25% CPU |
| N64 | mupen64plus_next_libretro | 95-100% speed, varies by game |
| Dreamcast | flycast_libretro | 90-100% speed, demanding |

### 3. System-Wide Performance Monitoring

#### Basic Monitoring
```bash
# Monitor for 5 minutes (system-wide)
./scripts/monitor-system-performance.sh

# Monitor specific process for 10 minutes
./scripts/monitor-system-performance.sh -p RetroArch -d 600
```

#### Advanced Monitoring with Instruments (Xcode)

1. **Install Xcode** (if not already installed)
   ```bash
   xcode-select --install
   ```

2. **Launch Instruments**
   ```bash
   open -a Instruments
   ```

3. **Profile RetroArch or EmulationStation**
   - Choose "Time Profiler" for CPU analysis
   - Choose "Allocations" for memory analysis
   - Choose "Metal System Trace" for GPU analysis

4. **Run your test scenario** while Instruments records

5. **Analyze results**
   - Look for hot spots in CPU usage
   - Check for memory leaks
   - Verify Metal API usage

### 4. Battery Life Testing (Laptops Only)

#### Preparation
1. Fully charge the battery
2. Disconnect from power
3. Set screen brightness to 50%
4. Close all other applications
5. Disable automatic sleep

#### Test Scenarios

**Scenario 1: EmulationStation Idle**
```bash
# Monitor battery drain with ES running
./scripts/monitor-system-performance.sh -p emulationstation -d 3600
```
- Duration: 1 hour
- Expected: <5% battery drain per hour
- Power draw: <5W

**Scenario 2: Light Emulation (NES/SNES)**
```bash
./scripts/monitor-system-performance.sh -p RetroArch -d 3600
```
- Duration: 1 hour
- Expected: 10-15% battery drain per hour
- Power draw: 10-15W

**Scenario 3: Heavy Emulation (PSX/N64)**
```bash
./scripts/monitor-system-performance.sh -p RetroArch -d 3600
```
- Duration: 1 hour
- Expected: 15-25% battery drain per hour
- Power draw: 15-25W

#### Battery Monitoring Commands
```bash
# Check current battery status
pmset -g batt

# Check detailed power statistics
pmset -g pslog

# Monitor power usage (requires sudo)
sudo powermetrics --samplers battery -i 5000
```

### 5. Thermal Performance Testing

#### Thermal Monitoring Tools

**Option 1: Built-in Activity Monitor**
1. Open Activity Monitor
2. View > Window > CPU History
3. Observe CPU load during testing

**Option 2: Command Line**
```bash
# Monitor CPU usage
top -l 1 | grep "CPU usage"

# Check thermal pressure (requires sudo)
sudo powermetrics --samplers thermal -n 1
```

**Option 3: Third-party Tools**
```bash
# Install iStat Menus or Stats for detailed monitoring
brew install --cask stats
```

#### Thermal Test Procedure

1. **Baseline Temperature**
   - Let system idle for 10 minutes
   - Record baseline temperatures

2. **Stress Test**
   - Run demanding emulation (N64, PSX, Dreamcast)
   - Continue for 30 minutes
   - Monitor temperatures every 5 minutes

3. **Check for Throttling**
   ```bash
   # Monitor for thermal throttling
   sudo powermetrics --samplers thermal -i 5000 -n 360
   ```

4. **Expected Behavior**
   - Temperatures should stabilize under 85°C
   - No thermal throttling warnings
   - Fans should ramp up gradually (if present)

## Optimization Guide

### EmulationStation Optimizations

#### 1. Reduce Asset Loading
- Use simpler themes for large libraries
- Disable video previews if not needed
- Reduce scraper image quality

#### 2. Optimize Game Lists
- Use filters to show fewer games at once
- Disable metadata that's not needed
- Use game list caching

#### 3. Disable Unnecessary Features
```xml
<!-- In es_settings.xml -->
<bool name="VideoLowersMusic" value="false" />
<bool name="DrawFramerate" value="false" />
<bool name="SlideshowScreensaverControls" value="false" />
```

### RetroArch Optimizations

#### 1. Use Metal Video Driver
```
Settings > Drivers > Video Driver > metal
```

#### 2. Enable Frame Pacing
```
Settings > Video > Synchronization > Frame Delay > Auto
```

#### 3. Optimize Audio
```
Settings > Audio > Audio Latency (ms) > 64
Settings > Audio > Audio Sync > ON
```

#### 4. Core-Specific Settings
Each core may have optimization options in:
```
Quick Menu > Options > [Core-specific options]
```

### System-Level Optimizations

#### 1. Enable High Performance Mode
```bash
# Check current power management
sudo pmset -g

# Set high performance mode (on AC power)
sudo pmset -c powerbutton 0
sudo pmset -c lidwake 1
```

#### 2. Reduce Background Activity
- Disable Spotlight indexing for RetroBat directory
- Close cloud sync services during gaming
- Disable automatic backups during gaming sessions

#### 3. Use Native Resolution
- Running at non-native resolutions may impact performance
- Use system resolution or integer scaling

#### 4. Monitor Background Processes
```bash
# Check for CPU-hungry background processes
top -o cpu

# Kill unnecessary processes
killall -9 [process-name]
```

## Troubleshooting

### Low FPS in EmulationStation

**Symptoms**: Menu navigation is sluggish, scrolling is choppy

**Possible Causes**:
1. Large game library with high-res artwork
2. Complex theme with animations
3. Background processes consuming CPU
4. Integrated GPU on base models may struggle with 4K displays

**Solutions**:
1. Switch to a simpler theme
2. Reduce scraper image resolution
3. Close background applications
4. Lower display resolution
5. Disable video previews

### RetroArch Performance Issues

**Symptoms**: Emulation runs below 100% speed, audio stuttering

**Possible Causes**:
1. Core not optimized for ARM64
2. Incorrect video driver
3. V-Sync causing issues
4. Thermal throttling

**Solutions**:
1. Check if ARM64 native core is available
2. Switch to Metal video driver
3. Disable V-Sync and test
4. Ensure adequate cooling
5. Try alternative cores for the same system

### High Memory Usage

**Symptoms**: System slowing down, swap usage increasing

**Possible Causes**:
1. Memory leaks in emulation cores
2. Too many cached assets
3. Background applications

**Solutions**:
1. Restart EmulationStation/RetroArch periodically
2. Clear asset cache
3. Close unused applications
4. Increase RAM if using base model

### Thermal Throttling

**Symptoms**: Performance degrading over time, fan noise increasing

**Possible Causes**:
1. Prolonged high-load emulation
2. Poor ventilation
3. Dust accumulation
4. Ambient temperature too high

**Solutions**:
1. Take breaks during extended sessions
2. Ensure adequate ventilation around Mac
3. Clean cooling vents
4. Use in air-conditioned environment
5. Consider external cooling solutions

### Battery Draining Quickly

**Symptoms**: Battery life shorter than expected

**Possible Causes**:
1. Display brightness too high
2. Demanding emulation cores
3. Background processes active
4. Battery health degraded

**Solutions**:
1. Reduce screen brightness
2. Use less demanding emulation cores
3. Close background applications
4. Check battery health: Apple menu > About This Mac > System Report > Power
5. Play while connected to power for demanding games

## Performance Results Database

### Contributing Your Results

Please share your benchmark results to help the community!

1. Run the benchmark scripts
2. Save results from `~/RetroBat/performance-tests/`
3. Create an issue or PR with your results
4. Include: Hardware model, macOS version, EmulationStation/RetroArch versions

### Results Template

```markdown
**Hardware**: Mac Studio M1 Ultra
**RAM**: 64GB
**macOS**: 14.2 (Sonoma)
**RetroBat**: v1.0.0

**EmulationStation**:
- Menu FPS: 60 (avg), 58-60 (range)
- Memory: 850 MB (avg), 950 MB (peak)
- Theme: Carbon (default)
- Game Library: 2,500 games

**RetroArch**:
- NES (nestopia): 100% speed, 4% CPU
- SNES (snes9x): 100% speed, 8% CPU
- PSX (pcsx_rearmed): 100% speed, 22% CPU
- N64 (mupen64plus_next): 98% speed, varies

**Battery Life** (MacBook Pro M1):
- ES Idle: 8 hours estimated
- Light emulation: 6 hours
- Heavy emulation: 4 hours

**Notes**: Excellent performance across all tested systems. No thermal throttling observed.
```

## Resources

### Official Documentation
- [Apple Silicon Overview](https://support.apple.com/en-us/HT211814)
- [Metal Performance Guide](https://developer.apple.com/metal/)
- [macOS Performance Tools](https://developer.apple.com/documentation/xcode/improving-performance)

### Community Resources
- RetroBat Discord: [Performance Discussion]
- RetroBat Forums: [Apple Silicon Section]
- GitHub Issues: [Performance Label]

### Related Tools
- [Stats](https://github.com/exelban/stats) - System monitor for macOS
- [Macs Fan Control](https://crystalidea.com/macs-fan-control) - Fan speed control
- [iStat Menus](https://bjango.com/mac/istatmenus/) - Advanced system monitoring

## Changelog

### Version 1.0.0 (2024-02-07)
- Initial performance testing guide
- EmulationStation and RetroArch benchmarking procedures
- System monitoring tools
- Optimization recommendations
- Troubleshooting guide

---

**Last Updated**: February 7, 2026
**Maintainers**: RetroBat macOS Team
**Feedback**: Please report issues or suggestions on GitHub
