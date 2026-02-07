# Performance Testing Suite for Apple Silicon

This directory contains the performance testing infrastructure for RetroBat on Apple Silicon Macs.

## Overview

The performance testing suite provides comprehensive tools and documentation for:
- Benchmarking EmulationStation UI performance
- Testing RetroArch core performance
- Monitoring system resources (CPU, memory, battery, thermal)
- Documenting and comparing results across hardware configurations

## Quick Start

### Prerequisites

1. macOS 11.0 or later (Big Sur+)
2. Apple Silicon Mac (M1, M2, M3, or later)
3. RetroBat installed and configured
4. Homebrew (recommended for additional tools)

### Running Your First Benchmark

```bash
# 1. Make scripts executable (if not already done)
chmod +x scripts/benchmark-*.sh
chmod +x scripts/monitor-*.sh

# 2. Start EmulationStation
open /Applications/RetroBat.app

# 3. In another terminal, run EmulationStation benchmark
./scripts/benchmark-emulationstation.sh

# 4. Run RetroArch benchmark
./scripts/benchmark-retroarch.sh

# 5. Monitor system performance
./scripts/monitor-system-performance.sh -d 300
```

## Directory Structure

```
tests/performance/
├── README.md                      # This file
├── test-config.json               # Test configurations and targets
├── RESULTS_TEMPLATE.md            # Template for reporting results
└── results/                       # Your test results (created automatically)
    ├── emulationstation/
    ├── retroarch/
    └── system/

scripts/
├── benchmark-emulationstation.sh  # EmulationStation performance tests
├── benchmark-retroarch.sh         # RetroArch core performance tests
└── monitor-system-performance.sh  # System-wide monitoring

docs/
├── PERFORMANCE_TESTING_GUIDE.md   # Complete testing guide
└── APPLE_SILICON_OPTIMIZATION.md  # Optimization documentation
```

## Benchmarking Scripts

### EmulationStation Benchmark

Tests UI performance including menu navigation, scrolling, and theme loading.

```bash
./scripts/benchmark-emulationstation.sh
```

**Requirements**:
- EmulationStation must be running
- Reasonable game library (100+ games recommended)

**Outputs**:
- JSON results file with metrics
- Log file with detailed information
- Location: `~/RetroBat/performance-tests/emulationstation/`

### RetroArch Benchmark

Tests emulation core performance across different systems.

```bash
./scripts/benchmark-retroarch.sh
```

**Requirements**:
- RetroArch installed at `/Applications/RetroArch.app`
- Cores installed in `~/.config/retroarch/cores/`
- Test ROMs (use homebrew/public domain ROMs)

**Outputs**:
- JSON results file with per-core metrics
- Log file with detailed information
- Location: `~/RetroBat/performance-tests/retroarch/`

### System Performance Monitor

Monitors CPU, memory, battery, and thermal metrics over time.

```bash
# Monitor system-wide for 5 minutes
./scripts/monitor-system-performance.sh

# Monitor specific process for 10 minutes
./scripts/monitor-system-performance.sh -p RetroArch -d 600

# Monitor with custom interval (1 second) for 3 minutes
./scripts/monitor-system-performance.sh -i 1 -d 180
```

**Options**:
- `-p, --process NAME`: Monitor specific process
- `-i, --interval SEC`: Sampling interval (default: 2 seconds)
- `-d, --duration SEC`: Total duration (default: 300 seconds)
- `-h, --help`: Show help message

**Outputs**:
- CSV file with time-series data
- Log file with summary statistics
- Location: `~/RetroBat/performance-tests/system/`

## Performance Targets

### EmulationStation

| Metric | Target | Acceptable |
|--------|--------|------------|
| Menu FPS | 60 | ≥55 |
| Memory Usage | <1 GB | <1.5 GB |
| CPU Usage (idle) | <5% | <10% |
| CPU Usage (active) | <30% | <50% |

### RetroArch

| System | FPS | CPU Usage | Memory |
|--------|-----|-----------|--------|
| NES | 60 (100%) | <5% | <50 MB |
| SNES | 60 (100%) | <10% | <75 MB |
| Genesis | 60 (100%) | <8% | <60 MB |
| PlayStation | 60 (100%) | <25% | <150 MB |
| N64 | ≥57 (≥95%) | <40% | <200 MB |

### Battery Life (MacBooks)

| Scenario | Target Drain | Power Draw |
|----------|--------------|------------|
| ES Idle | <5%/hour | <5W |
| Light Emulation | <15%/hour | <15W |
| Heavy Emulation | <25%/hour | <25W |

### Thermal

| Metric | Target |
|--------|--------|
| Peak CPU Temp | <85°C |
| Throttling Events | 0 |
| Cooldown Time | <5 minutes |

## Test Configuration

The `test-config.json` file defines:
- Standard test procedures
- Performance targets for each test
- Hardware profiles and expected performance
- Metrics collection parameters

You can customize this file to add new tests or adjust targets based on your requirements.

## Reporting Results

### Using the Template

1. Copy `RESULTS_TEMPLATE.md` to a new file:
   ```bash
   cp tests/performance/RESULTS_TEMPLATE.md tests/performance/my-results-$(date +%Y%m%d).md
   ```

2. Fill in your hardware information

3. Run benchmarks and record results

4. Complete all sections of the template

5. (Optional) Submit results to help the community!

### Result Submission

We encourage you to share your results:

1. **Via GitHub Issue**:
   - Create a new issue with label "performance-results"
   - Attach your completed results file
   - Include any relevant observations

2. **Via Pull Request**:
   - Add your results to `tests/performance/results/`
   - Create PR with description
   - Results will be reviewed and merged

3. **Via Community Forums**:
   - Post results in the Apple Silicon discussion thread
   - Help others understand performance expectations

## Advanced Usage

### Custom Test Scenarios

You can modify the scripts to test specific scenarios:

```bash
# Edit benchmark script to customize tests
nano scripts/benchmark-emulationstation.sh

# Adjust test duration, sample rates, etc.
```

### Integration with CI/CD

The scripts can be integrated into automated testing pipelines:

```yaml
# Example GitHub Actions workflow
- name: Run performance tests
  run: |
    ./scripts/benchmark-emulationstation.sh
    ./scripts/benchmark-retroarch.sh
```

### Profiling with Xcode Instruments

For deep performance analysis:

1. Install Xcode:
   ```bash
   xcode-select --install
   ```

2. Launch Instruments:
   ```bash
   open -a Instruments
   ```

3. Choose profiling template:
   - Time Profiler (CPU analysis)
   - Allocations (memory analysis)
   - Metal System Trace (GPU analysis)

4. Select RetroBat or RetroArch as target

5. Run your test scenario while recording

See [PERFORMANCE_TESTING_GUIDE.md](../../docs/PERFORMANCE_TESTING_GUIDE.md) for detailed instructions.

## Troubleshooting

### Benchmarks Not Running

**Issue**: Script reports process not found

**Solution**:
- Ensure EmulationStation/RetroArch is running
- Check process name: `ps aux | grep -i emulationstation`
- Verify installation paths

### Inconsistent Results

**Issue**: Results vary significantly between runs

**Possible Causes**:
- Background processes consuming resources
- System thermal throttling
- Display sleep/wake cycles
- Network activity

**Solutions**:
- Close all other applications
- Run multiple tests and average results
- Ensure consistent environmental conditions
- Disable automatic sleep

### Permission Errors

**Issue**: Cannot access process information

**Solution**:
```bash
# Grant terminal full disk access
# System Settings > Privacy & Security > Full Disk Access
# Add Terminal.app or your terminal emulator
```

### High Memory Usage

**Issue**: System swapping to disk during tests

**Solution**:
- Close unnecessary applications
- Reduce game library size temporarily
- Use simpler themes for testing
- Consider hardware upgrade if consistently swapping

## Best Practices

1. **Consistent Environment**:
   - Test at similar times of day
   - Maintain consistent ambient temperature
   - Use same power source (AC vs battery)
   - Close background applications

2. **Multiple Runs**:
   - Run each test at least 3 times
   - Average results for reliability
   - Discard outliers with explanation

3. **Documentation**:
   - Note any anomalies
   - Record environmental conditions
   - Include software versions
   - Document any customizations

4. **Baseline Comparison**:
   - Keep initial test results as baseline
   - Compare future tests against baseline
   - Track performance over software updates

5. **Hardware Variations**:
   - Test across different hardware if available
   - Note RAM, storage, and configuration differences
   - Document display resolution and refresh rate

## Contributing

### Adding New Tests

To add a new test to the suite:

1. Create test script in `scripts/`
2. Update `test-config.json` with test parameters
3. Add documentation to `PERFORMANCE_TESTING_GUIDE.md`
4. Submit PR with description

### Improving Scripts

Contributions welcome for:
- More accurate FPS measurement
- Better thermal monitoring
- GPU usage tracking
- Automated result analysis
- Cross-platform compatibility

## Resources

### Documentation
- [Performance Testing Guide](../../docs/PERFORMANCE_TESTING_GUIDE.md) - Comprehensive testing procedures
- [Apple Silicon Optimization](../../docs/APPLE_SILICON_OPTIMIZATION.md) - Optimization techniques
- [RetroBat Wiki](https://wiki.retrobat.org/) - General RetroBat documentation

### Tools
- [Stats](https://github.com/exelban/stats) - macOS system monitor
- [iStat Menus](https://bjango.com/mac/istatmenus/) - Advanced monitoring
- [Instruments](https://developer.apple.com/xcode/) - Xcode profiling tools

### Community
- [GitHub Issues](https://github.com/bayramog/retrobat-macos/issues) - Report issues
- [Discussions](https://github.com/bayramog/retrobat-macos/discussions) - Ask questions
- [Discord](https://discord.gg/retrobat) - Real-time chat

## Changelog

### Version 1.0.0 (2026-02-07)
- Initial release of performance testing suite
- EmulationStation benchmark script
- RetroArch benchmark script
- System performance monitor
- Documentation and guides
- Test configuration files
- Results template

## License

This testing suite is part of the RetroBat macOS project.
See the main repository LICENSE file for details.

---

**Last Updated**: February 7, 2026  
**Version**: 1.0.0  
**Maintainers**: RetroBat macOS Team
