# Apple Silicon Performance Quick Reference

Quick reference card for performance testing and optimization on Apple Silicon Macs.

## 🚀 Quick Start

```bash
# Run all benchmarks
./scripts/benchmark-emulationstation.sh
./scripts/benchmark-retroarch.sh
./scripts/monitor-system-performance.sh -d 300
```

## 📊 Performance Targets (at a glance)

| Component | Metric | Target |
|-----------|--------|--------|
| 🎮 EmulationStation | FPS | ≥60 |
| 🎮 EmulationStation | Memory | <1 GB |
| 🎮 EmulationStation | CPU | <5% idle, <30% active |
| 🕹️ RetroArch (NES) | FPS | 60 (100%) |
| 🕹️ RetroArch (SNES) | FPS | 60 (100%) |
| 🕹️ RetroArch (PSX) | FPS | 60 (100%) |
| 🕹️ RetroArch (N64) | FPS | ≥57 (≥95%) |
| 🔋 Battery (idle) | Drain | <5%/hour |
| 🔋 Battery (gaming) | Drain | <25%/hour |
| 🌡️ Temperature | Max | <85°C |

## 🛠️ Essential Commands

### System Information
```bash
# Check chip model
sysctl -n machdep.cpu.brand_string

# Check architecture
uname -m  # Should be: arm64

# Check macOS version
sw_vers -productVersion

# Check memory
sysctl -n hw.memsize | awk '{print $1/1024/1024/1024 " GB"}'

# Check GPU
system_profiler SPDisplaysDataType | grep "Chipset Model"
```

### Performance Monitoring
```bash
# CPU usage
top -l 1 | grep "CPU usage"

# Memory pressure
memory_pressure

# Battery status
pmset -g batt

# Temperature (if tools available)
sudo powermetrics --samplers thermal -n 1

# Process monitoring
ps aux | grep -i emulationstation
ps aux | grep -i retroarch
```

### RetroArch Operations
```bash
# Launch RetroArch
/Applications/RetroArch.app/Contents/MacOS/RetroArch

# Check RetroArch version
/Applications/RetroArch.app/Contents/MacOS/RetroArch --version

# List installed cores
ls ~/.config/retroarch/cores/*.dylib

# Test core with ROM
/Applications/RetroArch.app/Contents/MacOS/RetroArch \
  -L ~/.config/retroarch/cores/snes9x_libretro.dylib \
  /path/to/rom.smc
```

## 🎯 Optimization Quick Fixes

### EmulationStation Slow
```bash
# Use simpler theme
# Disable video previews
# Reduce scraper image quality
# Clear cache: rm -rf ~/.emulationstation/cache
```

### RetroArch Low FPS
```bash
# Switch to Metal driver
# Disable shaders
# Disable rewind
# Close background apps
```

### High Memory Usage
```bash
# Close other applications
# Use simpler EmulationStation theme
# Restart EmulationStation/RetroArch
# Clear caches
```

### Thermal Throttling
```bash
# Take breaks during gaming
# Ensure good ventilation
# Clean cooling vents
# Use in cooler environment
```

## 🔍 Quick Diagnostics

### Is performance normal?
```bash
# 1. Check if running on Apple Silicon
[ "$(uname -m)" = "arm64" ] && echo "✓ ARM64" || echo "✗ Not ARM64"

# 2. Check if EmulationStation is using too much CPU
ps aux | awk '/[e]mulationstation/ {if($3>50) print "⚠ High CPU: "$3"%"; else print "✓ Normal CPU: "$3"%"}'

# 3. Check if RetroArch is using too much CPU
ps aux | awk '/[R]etroArch/ {if($3>80) print "⚠ High CPU: "$3"%"; else print "✓ Normal CPU: "$3"%"}'

# 4. Check memory pressure
memory_pressure | grep -q "System-wide memory free percentage" && echo "✓ Memory OK"

# 5. Check battery status (laptops only)
pmset -g batt | grep -q "AC Power" && echo "✓ On AC" || echo "⚠ On Battery"
```

## 📝 Pre-Flight Checklist

Before starting performance tests:

- [ ] Close all other applications
- [ ] Disable automatic sleep: `sudo pmset -a sleep 0`
- [ ] Ensure adequate free disk space (>10GB)
- [ ] Note current system temperature
- [ ] For battery tests: Charge to 100%, disconnect AC
- [ ] For battery tests: Set screen brightness to 50%
- [ ] Verify EmulationStation/RetroArch installed correctly
- [ ] Prepare test ROMs (homebrew/public domain)

## 🎮 Recommended Test ROMs

Use these for consistent testing:

| System | Test ROM | Why |
|--------|----------|-----|
| NES | Micro Mages | Stress test |
| SNES | SNES Test | Comprehensive |
| Genesis | MD Test | Standard test |
| Game Boy | 240p Test Suite | Display test |
| GBA | GBA Test | Hardware test |

## 🔧 Configuration Files

### Location of Important Files

```bash
# EmulationStation config
~/.emulationstation/es_settings.cfg

# RetroArch config
~/.config/retroarch/retroarch.cfg

# Optimal RetroArch config for Apple Silicon
system/templates/retroarch/retroarch-apple-silicon.cfg

# Performance test results
~/RetroBat/performance-tests/
```

### Quick Config Backup
```bash
# Backup EmulationStation config
cp ~/.emulationstation/es_settings.cfg ~/es_settings.cfg.backup

# Backup RetroArch config
cp ~/.config/retroarch/retroarch.cfg ~/retroarch.cfg.backup

# Restore if needed
cp ~/es_settings.cfg.backup ~/.emulationstation/es_settings.cfg
cp ~/retroarch.cfg.backup ~/.config/retroarch/retroarch.cfg
```

## 🆘 Emergency Performance Reset

If something goes wrong:

```bash
# 1. Kill all emulation processes
killall -9 emulationstation RetroArch

# 2. Clear caches
rm -rf ~/.emulationstation/cache
rm -rf ~/.config/retroarch/cache

# 3. Reset RetroArch to defaults
mv ~/.config/retroarch/retroarch.cfg ~/.config/retroarch/retroarch.cfg.old
# RetroArch will create new config on next launch

# 4. Reboot system
sudo reboot
```

## 📚 Documentation Links

- **Full Testing Guide**: [docs/PERFORMANCE_TESTING_GUIDE.md](../docs/PERFORMANCE_TESTING_GUIDE.md)
- **Optimization Guide**: [docs/APPLE_SILICON_OPTIMIZATION.md](../docs/APPLE_SILICON_OPTIMIZATION.md)
- **Test Suite README**: [tests/performance/README.md](../tests/performance/README.md)

## 🤝 Getting Help

### Check Logs
```bash
# EmulationStation log
cat ~/.emulationstation/es_log.txt

# RetroArch log
cat ~/.config/retroarch/logs/retroarch.log

# System log
log show --predicate 'process == "emulationstation"' --last 1h
```

### Report Performance Issues

When reporting issues, include:
1. Hardware model (Mac Studio M1 Max, etc.)
2. macOS version
3. RetroBat version
4. Benchmark results
5. Steps to reproduce
6. Expected vs actual behavior

### Community Resources
- GitHub Issues: https://github.com/bayramog/retrobat-macos/issues
- Discussions: https://github.com/bayramog/retrobat-macos/discussions

## 📊 Results Interpretation

### Good Performance
- ES: 60 FPS, <1GB RAM, <10% CPU idle
- RA: 60 FPS (100%), <30% CPU for most systems
- Battery: >6 hours light gaming
- Thermal: <75°C sustained

### Acceptable Performance
- ES: 55-60 FPS, <1.5GB RAM, <20% CPU idle
- RA: 57-60 FPS (95-100%), <50% CPU
- Battery: 4-6 hours light gaming
- Thermal: 75-85°C sustained

### Needs Optimization
- ES: <55 FPS, >1.5GB RAM, >20% CPU idle
- RA: <57 FPS (<95%), >60% CPU
- Battery: <4 hours light gaming
- Thermal: >85°C or throttling events

---

**Version**: 1.0.0  
**Last Updated**: February 7, 2026  
**Print this for quick reference!**
