# Performance Test Results Template

## Test Information

**Date**: YYYY-MM-DD  
**Tester**: [Your Name/Handle]  
**RetroBat Version**: [Version Number]  
**Test Duration**: [Total Time]

## Hardware Configuration

**Model**: [e.g., Mac Studio M1 Max]  
**CPU**: [e.g., Apple M1 Max, 10-core]  
**GPU**: [e.g., 32-core GPU]  
**RAM**: [e.g., 64GB]  
**Storage**: [e.g., 1TB SSD]  
**macOS Version**: [e.g., 14.2 Sonoma]  
**Display**: [e.g., 27" 5K @ 60Hz]

## Test Environment

**Ambient Temperature**: [e.g., 22°C]  
**Power Source**: [Battery / AC Power]  
**Background Processes**: [None / List if any]  
**Other Notes**: [Any relevant environmental factors]

---

## EmulationStation Performance

### Test 1: Idle State (60 seconds)

| Metric | Value | Target | Status |
|--------|-------|--------|--------|
| Average FPS | [XX.XX] | ≥60 | ✅/❌ |
| Memory Usage | [XXX MB] | <500 MB | ✅/❌ |
| CPU Usage | [X.X%] | <5% | ✅/❌ |

**Notes**: [Any observations]

### Test 2: Menu Navigation (120 seconds)

| Metric | Value | Target | Status |
|--------|-------|--------|--------|
| Average FPS | [XX.XX] | ≥60 | ✅/❌ |
| Min FPS | [XX.XX] | ≥55 | ✅/❌ |
| Memory Usage | [XXX MB] | <600 MB | ✅/❌ |
| CPU Usage | [XX.X%] | <15% | ✅/❌ |
| Input Latency | [XX ms] | <16 ms | ✅/❌ |

**Notes**: [Any observations]

### Test 3: Game List Scrolling (120 seconds)

| Metric | Value | Target | Status |
|--------|-------|--------|--------|
| Average FPS | [XX.XX] | ≥60 | ✅/❌ |
| Min FPS | [XX.XX] | ≥55 | ✅/❌ |
| Memory Usage | [XXX MB] | <800 MB | ✅/❌ |
| CPU Usage | [XX.X%] | <30% | ✅/❌ |

**Test Configuration**:
- Theme: [Theme name]
- Game Count: [Number]
- View Mode: [Detailed/Grid/Video]

**Notes**: [Any observations]

### Test 4: Theme Loading (60 seconds)

| Metric | Value | Target | Status |
|--------|-------|--------|--------|
| Load Time | [X.X s] | <3 s | ✅/❌ |
| Peak Memory | [XXXX MB] | <1000 MB | ✅/❌ |
| CPU Usage | [XX.X%] | <50% | ✅/❌ |

**Themes Tested**: [List themes]

**Notes**: [Any observations]

---

## RetroArch Performance

### Core: NES (nestopia_libretro)

| Metric | Value | Target | Status |
|--------|-------|--------|--------|
| Average FPS | [XX.XX] | 60 | ✅/❌ |
| Frame Time | [XX.XX ms] | 16.67 ms | ✅/❌ |
| Memory Usage | [XX MB] | <50 MB | ✅/❌ |
| CPU Usage | [X.X%] | <5% | ✅/❌ |
| Audio Underruns | [X] | 0 | ✅/❌ |

**Test ROM**: [ROM name or "Homebrew test"]  
**Video Driver**: [Metal/OpenGL]  
**Notes**: [Any observations]

### Core: SNES (snes9x_libretro)

| Metric | Value | Target | Status |
|--------|-------|--------|--------|
| Average FPS | [XX.XX] | 60 | ✅/❌ |
| Frame Time | [XX.XX ms] | 16.67 ms | ✅/❌ |
| Memory Usage | [XX MB] | <75 MB | ✅/❌ |
| CPU Usage | [XX.X%] | <10% | ✅/❌ |
| Audio Underruns | [X] | 0 | ✅/❌ |

**Test ROM**: [ROM name]  
**Video Driver**: [Metal/OpenGL]  
**Notes**: [Any observations]

### Core: Genesis (genesis_plus_gx_libretro)

| Metric | Value | Target | Status |
|--------|-------|--------|--------|
| Average FPS | [XX.XX] | 60 | ✅/❌ |
| Frame Time | [XX.XX ms] | 16.67 ms | ✅/❌ |
| Memory Usage | [XX MB] | <60 MB | ✅/❌ |
| CPU Usage | [X.X%] | <8% | ✅/❌ |
| Audio Underruns | [X] | 0 | ✅/❌ |

**Test ROM**: [ROM name]  
**Video Driver**: [Metal/OpenGL]  
**Notes**: [Any observations]

### Core: PlayStation (pcsx_rearmed_libretro)

| Metric | Value | Target | Status |
|--------|-------|--------|--------|
| Average FPS | [XX.XX] | 60 | ✅/❌ |
| Frame Time | [XX.XX ms] | 16.67 ms | ✅/❌ |
| Memory Usage | [XXX MB] | <150 MB | ✅/❌ |
| CPU Usage | [XX.X%] | <25% | ✅/❌ |
| GPU Usage | [XX.X%] | <15% | ✅/❌ |
| Audio Underruns | [X] | 0 | ✅/❌ |

**Test ROM**: [ROM name]  
**Video Driver**: [Metal/OpenGL]  
**Notes**: [Any observations]

### Core: Nintendo 64 (mupen64plus_next_libretro)

| Metric | Value | Target | Status |
|--------|-------|--------|--------|
| Average FPS | [XX.XX] | 60 | ⚠️ |
| Frame Time | [XX.XX ms] | 16.67 ms | ⚠️ |
| Memory Usage | [XXX MB] | <200 MB | ✅/❌ |
| CPU Usage | [XX.X%] | <40% | ✅/❌ |
| GPU Usage | [XX.X%] | <30% | ✅/❌ |
| Audio Underruns | [X] | <5 | ⚠️ |

**Test ROM**: [ROM name]  
**Video Driver**: [Metal/OpenGL]  
**Notes**: [Performance varies by game - note specific game tested]

---

## Battery Life Tests (MacBooks Only)

### Idle Battery Drain

| Metric | Value | Target | Status |
|--------|-------|--------|--------|
| Duration | [60 min] | - | - |
| Battery Start | [100%] | - | - |
| Battery End | [XX%] | - | - |
| Drain Rate | [X%/hour] | <5%/hour | ✅/❌ |
| Avg Power | [X.X W] | <5W | ✅/❌ |

**Screen Brightness**: [50%]  
**Notes**: [Any observations]

### Light Emulation (NES/SNES)

| Metric | Value | Target | Status |
|--------|-------|--------|--------|
| Duration | [60 min] | - | - |
| Battery Start | [100%] | - | - |
| Battery End | [XX%] | - | - |
| Drain Rate | [XX%/hour] | <15%/hour | ✅/❌ |
| Avg Power | [XX.X W] | <15W | ✅/❌ |

**Core**: [nestopia_libretro/snes9x_libretro]  
**Screen Brightness**: [50%]  
**Notes**: [Any observations]

### Heavy Emulation (PSX/N64)

| Metric | Value | Target | Status |
|--------|-------|--------|--------|
| Duration | [60 min] | - | - |
| Battery Start | [100%] | - | - |
| Battery End | [XX%] | - | - |
| Drain Rate | [XX%/hour] | <25%/hour | ✅/❌ |
| Avg Power | [XX.X W] | <25W | ✅/❌ |

**Core**: [pcsx_rearmed_libretro/mupen64plus_next_libretro]  
**Screen Brightness**: [50%]  
**Notes**: [Any observations]

---

## Thermal Performance

### Sustained Load Test (30 minutes)

| Metric | Value | Target | Status |
|--------|-------|--------|--------|
| Baseline Temp | [XX°C] | - | - |
| Peak Temp | [XX°C] | <85°C | ✅/❌ |
| Avg Temp | [XX°C] | <80°C | ✅/❌ |
| Throttling Events | [X] | 0 | ✅/❌ |
| Fan Speed (if applicable) | [XXXX RPM] | - | - |

**Workload**: [Description of emulation load]  
**Ambient Temperature**: [XX°C]  
**Notes**: [Any observations]

### Thermal Recovery

| Metric | Value | Target | Status |
|--------|-------|--------|--------|
| Peak Temp | [XX°C] | - | - |
| Cooldown Time | [X min] | <5 min | ✅/❌ |
| Final Temp | [XX°C] | Near baseline | ✅/❌ |

**Notes**: [Any observations]

---

## Overall Assessment

### Performance Summary

**EmulationStation**: [Excellent / Good / Acceptable / Poor]  
**RetroArch (Light Systems)**: [Excellent / Good / Acceptable / Poor]  
**RetroArch (Heavy Systems)**: [Excellent / Good / Acceptable / Poor]  
**Battery Life**: [Excellent / Good / Acceptable / Poor / N/A]  
**Thermal Management**: [Excellent / Good / Acceptable / Poor]

### Bottlenecks Identified

1. [List any identified bottlenecks]
2. [...]

### Optimization Recommendations

1. [List recommendations based on test results]
2. [...]

### Issues Encountered

1. [List any issues or anomalies]
2. [...]

---

## Raw Data Files

- EmulationStation benchmark: `[filename.json]`
- RetroArch benchmark: `[filename.json]`
- System monitor logs: `[filename.csv]`

---

## Additional Notes

[Any additional observations, comparisons to other hardware, or relevant comments]

---

**Submission Date**: YYYY-MM-DD  
**Results Validated By**: [Name if peer-reviewed]
