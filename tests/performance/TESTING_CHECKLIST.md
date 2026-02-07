# Apple Silicon Performance Testing Checklist

Complete checklist for systematic performance testing of RetroBat on Apple Silicon Macs.

**Date Started**: _______________  
**Tester**: _______________  
**Hardware**: _______________  
**macOS Version**: _______________

---

## 📋 Phase 1: Pre-Test Setup

### Environment Preparation
- [ ] Close all unnecessary applications
- [ ] Disable automatic sleep: `sudo pmset -a sleep 0`
- [ ] Verify at least 10GB free disk space
- [ ] Note ambient temperature: ______°C
- [ ] Clean desktop for focus
- [ ] Disable notifications (Do Not Disturb)

### Hardware Verification
- [ ] Confirm Apple Silicon: `uname -m` → arm64
- [ ] Record chip model: _______________
- [ ] Record RAM amount: _______ GB
- [ ] Record GPU cores: _______
- [ ] Check battery health (if MacBook): _______%
- [ ] Ensure adequate ventilation

### Software Verification
- [ ] EmulationStation installed: `/Applications/RetroBat.app`
- [ ] RetroArch installed: `/Applications/RetroArch.app`
- [ ] Benchmark scripts executable: `chmod +x scripts/*.sh`
- [ ] Test results directory created
- [ ] Backup current configurations

### Initial Baseline
- [ ] Record idle CPU temp: ______°C
- [ ] Record idle battery % (if MacBook): ______%
- [ ] Record idle memory usage: _______ GB
- [ ] Record background process count: _______
- [ ] Take screenshot of Activity Monitor

---

## 📋 Phase 2: EmulationStation Testing

### Test 2.1: Idle State (60 seconds)
- [ ] Start EmulationStation
- [ ] Wait for full initialization (30 seconds)
- [ ] Run benchmark: `./scripts/benchmark-emulationstation.sh`
- [ ] Record average FPS: _______ (Target: ≥60)
- [ ] Record memory usage: _______ MB (Target: <500)
- [ ] Record CPU usage: _______ % (Target: <5%)
- [ ] Save results file location: _______________
- [ ] Note any UI stuttering: Yes / No
- [ ] Screenshot saved: Yes / No

### Test 2.2: Menu Navigation (120 seconds)
During benchmark:
- [ ] Navigate through main menu (30 sec)
- [ ] Open and close settings menu (30 sec)
- [ ] Browse through system list (30 sec)
- [ ] Return to main screen (30 sec)

Results:
- [ ] Average FPS: _______ (Target: ≥60)
- [ ] Min FPS: _______ (Target: ≥55)
- [ ] Memory usage: _______ MB (Target: <600)
- [ ] CPU usage: _______ % (Target: <15%)
- [ ] Input latency felt: Excellent / Good / Poor
- [ ] Any lag noticed: Yes / No

### Test 2.3: Game List Scrolling (120 seconds)
- [ ] Select system with 100+ games
- [ ] Library size tested: _______ games
- [ ] Theme used: _______________

During benchmark:
- [ ] Rapid scroll up/down (40 sec)
- [ ] Page up/down navigation (40 sec)
- [ ] Switch view modes (40 sec)

Results:
- [ ] Average FPS: _______ (Target: ≥60)
- [ ] Min FPS: _______ (Target: ≥55)
- [ ] Memory usage: _______ MB (Target: <800)
- [ ] CPU usage: _______ % (Target: <30%)
- [ ] Scrolling smoothness: Excellent / Good / Poor

### Test 2.4: Theme Loading (60 seconds)
Themes tested:
- [ ] Theme 1: _______________ Load time: _____ sec
- [ ] Theme 2: _______________ Load time: _____ sec
- [ ] Theme 3: _______________ Load time: _____ sec

Results:
- [ ] Average load time: _______ sec (Target: <3)
- [ ] Peak memory: _______ MB (Target: <1000)
- [ ] Any crashes: Yes / No

### Test 2.5: Large Library (if applicable)
- [ ] Library size: _______ games (Target: 1000+)
- [ ] High-res artwork: Yes / No
- [ ] Video previews: Yes / No
- [ ] Test duration: 300 seconds

Results:
- [ ] Average FPS: _______ (Target: ≥60)
- [ ] Memory usage: _______ MB (Target: <1500)
- [ ] Initial load time: _______ sec
- [ ] System remains responsive: Yes / No

---

## 📋 Phase 3: RetroArch Testing

### Pre-Test Setup
- [ ] RetroArch version: _______________
- [ ] Video driver: Metal / OpenGL (Should be Metal)
- [ ] Audio driver: CoreAudio / Other
- [ ] Cores installed count: _______
- [ ] Test ROMs prepared (homebrew/public domain)

### Test 3.1: NES Performance (nestopia_libretro)
- [ ] Core installed: Yes / No
- [ ] Test ROM: _______________
- [ ] Test duration: 300 seconds

Results:
- [ ] Average FPS: _______ (Target: 60)
- [ ] Min FPS: _______
- [ ] Frame time: _______ ms (Target: 16.67)
- [ ] Memory usage: _______ MB (Target: <50)
- [ ] CPU usage: _______ % (Target: <5%)
- [ ] Audio underruns: _______ (Target: 0)
- [ ] Emulation speed: _______ % (Target: 100%)

### Test 3.2: SNES Performance (snes9x_libretro)
- [ ] Core installed: Yes / No
- [ ] Test ROM: _______________
- [ ] Test duration: 300 seconds

Results:
- [ ] Average FPS: _______ (Target: 60)
- [ ] Min FPS: _______
- [ ] Frame time: _______ ms (Target: 16.67)
- [ ] Memory usage: _______ MB (Target: <75)
- [ ] CPU usage: _______ % (Target: <10%)
- [ ] Audio underruns: _______ (Target: 0)
- [ ] Emulation speed: _______ % (Target: 100%)

### Test 3.3: Genesis Performance (genesis_plus_gx_libretro)
- [ ] Core installed: Yes / No
- [ ] Test ROM: _______________
- [ ] Test duration: 300 seconds

Results:
- [ ] Average FPS: _______ (Target: 60)
- [ ] Memory usage: _______ MB (Target: <60)
- [ ] CPU usage: _______ % (Target: <8%)
- [ ] Emulation speed: _______ % (Target: 100%)

### Test 3.4: PlayStation Performance (pcsx_rearmed_libretro)
- [ ] Core installed: Yes / No
- [ ] Test ROM: _______________
- [ ] Test duration: 300 seconds

Results:
- [ ] Average FPS: _______ (Target: 60)
- [ ] Memory usage: _______ MB (Target: <150)
- [ ] CPU usage: _______ % (Target: <25%)
- [ ] GPU usage: _______ % (Target: <15%)
- [ ] Emulation speed: _______ % (Target: 100%)

### Test 3.5: Nintendo 64 Performance (mupen64plus_next_libretro)
- [ ] Core installed: Yes / No
- [ ] Test ROM: _______________
- [ ] Test duration: 300 seconds

Results:
- [ ] Average FPS: _______ (Target: ≥57)
- [ ] Memory usage: _______ MB (Target: <200)
- [ ] CPU usage: _______ % (Target: <40%)
- [ ] GPU usage: _______ % (Target: <30%)
- [ ] Emulation speed: _______ % (Target: ≥95%)
- [ ] Audio quality: Good / Acceptable / Poor

### Test 3.6: Shader Performance (optional)
Shader preset tested: _______________
- [ ] No shader: _______ FPS
- [ ] Light shader (crt-easymode): _______ FPS
- [ ] Medium shader (crt-royale): _______ FPS
- [ ] Heavy shader: _______ FPS

---

## 📋 Phase 4: System Performance Monitoring

### Test 4.1: Sustained Load (30 minutes)
- [ ] Emulation core: _______________
- [ ] Start temperature: ______°C
- [ ] Monitor script running: `./scripts/monitor-system-performance.sh -d 1800`

10-minute intervals:
- [ ] 10 min - Temp: ______°C, CPU: ______%
- [ ] 20 min - Temp: ______°C, CPU: ______%
- [ ] 30 min - Temp: ______°C, CPU: ______%

Results:
- [ ] Peak temperature: ______°C (Target: <85°C)
- [ ] Throttling events: _______ (Target: 0)
- [ ] Average CPU: _______ %
- [ ] Average memory: _______ MB
- [ ] System stability: Stable / Unstable

### Test 4.2: Memory Stress Test
- [ ] Large game library loaded: Yes / No
- [ ] Multiple emulators opened: Count: _______
- [ ] Test duration: 600 seconds

Results:
- [ ] Peak memory: _______ MB
- [ ] Swap usage: _______ MB (Target: 0)
- [ ] Memory leaks detected: Yes / No
- [ ] System responsiveness: Good / Degraded

---

## 📋 Phase 5: Battery Life Testing (MacBooks Only)

### Setup
- [ ] Battery charged to: _______ %
- [ ] Disconnected from AC power
- [ ] Screen brightness: 50%
- [ ] Keyboard backlight: Off
- [ ] Automatic sleep: Disabled

### Test 5.1: Idle Battery Drain (60 minutes)
- [ ] Start battery: 100%
- [ ] EmulationStation running
- [ ] Monitor script: `./scripts/monitor-system-performance.sh -d 3600`

Results:
- [ ] End battery: _______ %
- [ ] Drain rate: _______ %/hour (Target: <5%)
- [ ] Average power: _______ W (Target: <5W)

### Test 5.2: Light Emulation Battery (60 minutes)
- [ ] Start battery: _______ %
- [ ] Core: nestopia_libretro / snes9x_libretro
- [ ] Game running continuously

Results:
- [ ] End battery: _______ %
- [ ] Drain rate: _______ %/hour (Target: <15%)
- [ ] Average power: _______ W (Target: <15W)
- [ ] Estimated total runtime: _______ hours

### Test 5.3: Heavy Emulation Battery (60 minutes)
- [ ] Start battery: _______ %
- [ ] Core: pcsx_rearmed_libretro / mupen64plus_next_libretro
- [ ] Game running continuously

Results:
- [ ] End battery: _______ %
- [ ] Drain rate: _______ %/hour (Target: <25%)
- [ ] Average power: _______ W (Target: <25W)
- [ ] Estimated total runtime: _______ hours

---

## 📋 Phase 6: Thermal Testing

### Test 6.1: Sustained Load Thermal
- [ ] Demanding emulation core selected
- [ ] Duration: 1800 seconds (30 minutes)
- [ ] Fan behavior noted: Active / Passive

Temperature readings every 5 minutes:
- [ ] 5 min: ______°C
- [ ] 10 min: ______°C
- [ ] 15 min: ______°C
- [ ] 20 min: ______°C
- [ ] 25 min: ______°C
- [ ] 30 min: ______°C

Results:
- [ ] Peak temp: ______°C (Target: <85°C)
- [ ] Temperature stabilized: Yes / No
- [ ] Throttling detected: Yes / No
- [ ] Fan noise level: Silent / Moderate / Loud

### Test 6.2: Thermal Recovery
- [ ] End temperature after stress: ______°C
- [ ] Idle for cooldown: 600 seconds

Temperature readings every 2 minutes:
- [ ] 2 min: ______°C
- [ ] 4 min: ______°C
- [ ] 6 min: ______°C
- [ ] 8 min: ______°C
- [ ] 10 min: ______°C

Results:
- [ ] Time to baseline: _______ sec (Target: <300)
- [ ] Final temperature: ______°C
- [ ] Cooling adequate: Yes / No

---

## 📋 Phase 7: Results Documentation

### Data Collection
- [ ] All benchmark JSON files saved
- [ ] All CSV monitor files saved
- [ ] Screenshots captured
- [ ] Logs exported
- [ ] Results organized in: _______________

### Analysis
- [ ] Results compiled in template: `RESULTS_TEMPLATE.md`
- [ ] Comparisons made to targets
- [ ] Bottlenecks identified: _______________
- [ ] Performance grade assigned: _______________

### Recommendations
- [ ] Optimization suggestions documented
- [ ] Configuration tweaks noted
- [ ] Known issues recorded
- [ ] Follow-up tests needed: _______________

---

## 📋 Phase 8: Submission (Optional)

### Community Contribution
- [ ] Results formatted per template
- [ ] Personal information removed (if desired)
- [ ] Hardware details complete
- [ ] Screenshots prepared
- [ ] Results submitted via: Issue / PR / Forum

### Validation
- [ ] Peer review requested: Yes / No
- [ ] Results validated by: _______________
- [ ] Added to community database: Yes / No

---

## 📝 Notes & Observations

### Positive Findings:
_______________________________________________
_______________________________________________
_______________________________________________

### Issues Encountered:
_______________________________________________
_______________________________________________
_______________________________________________

### Suggestions for Improvement:
_______________________________________________
_______________________________________________
_______________________________________________

### Additional Comments:
_______________________________________________
_______________________________________________
_______________________________________________

---

## ✅ Completion

**Testing Completed**: _______________ (Date)  
**Total Duration**: _______________ hours  
**Overall Performance Grade**: A / B / C / D / F  
**Ready for Submission**: Yes / No  

**Tester Signature**: _______________

---

**Version**: 1.0.0  
**Last Updated**: February 7, 2026  
**Print and use this checklist for systematic testing**
