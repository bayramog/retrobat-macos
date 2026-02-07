#!/bin/bash
################################################################################
# System Performance Monitor for Apple Silicon
# 
# Monitors memory, CPU, GPU, battery, and thermal performance
# specifically for RetroBat on macOS
################################################################################

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Configuration
RESULTS_DIR="${HOME}/RetroBat/performance-tests/system"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
RESULTS_FILE="${RESULTS_DIR}/system_monitor_${TIMESTAMP}.csv"
LOG_FILE="${RESULTS_DIR}/system_monitor_${TIMESTAMP}.log"

# Monitoring parameters
INTERVAL=2  # seconds between samples
DURATION=300  # total monitoring duration (5 minutes default)
PROCESS_NAME=""  # Process to monitor (empty = system-wide)

################################################################################
# Helper Functions
################################################################################

print_header() {
    echo -e "${BLUE}================================${NC}"
    echo -e "${BLUE}$1${NC}"
    echo -e "${BLUE}================================${NC}"
}

print_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠ $1${NC}"
}

print_error() {
    echo -e "${RED}✗ $1${NC}"
}

print_info() {
    echo -e "${BLUE}ℹ $1${NC}"
}

################################################################################
# System Information
################################################################################

get_system_info() {
    echo "timestamp,cpu_percent,memory_mb,memory_percent,gpu_percent,battery_percent,battery_status,temperature_c,power_watts"
}

################################################################################
# Memory Monitoring
################################################################################

get_memory_usage() {
    if [[ -n "${PROCESS_NAME}" ]]; then
        # Process-specific memory
        local pid=$(pgrep -i "${PROCESS_NAME}" | head -1)
        if [[ -n "$pid" ]]; then
            ps -p "$pid" -o rss= | awk '{print $1/1024}'
        else
            echo "0"
        fi
    else
        # System-wide memory
        vm_stat | grep "Pages active" | awk '{print $3}' | sed 's/\.//' | awk '{print $1*4096/1024/1024}'
    fi
}

get_memory_percent() {
    local total_mem=$(sysctl -n hw.memsize)
    local used_mem=$(vm_stat | perl -ne '/page size of (\d+)/ and $size=$1; /Pages active:\s+(\d+)/ and printf("%.0f", $1 * $size / 1024 / 1024);')
    echo "scale=2; $used_mem * 100 / ($total_mem / 1024 / 1024)" | bc
}

################################################################################
# CPU Monitoring
################################################################################

get_cpu_usage() {
    if [[ -n "${PROCESS_NAME}" ]]; then
        # Process-specific CPU
        local pid=$(pgrep -i "${PROCESS_NAME}" | head -1)
        if [[ -n "$pid" ]]; then
            ps -p "$pid" -o %cpu= | awk '{print $1}'
        else
            echo "0"
        fi
    else
        # System-wide CPU
        top -l 1 -n 0 | grep "CPU usage" | awk '{print $3}' | sed 's/%//'
    fi
}

################################################################################
# GPU Monitoring (Metal)
################################################################################

get_gpu_usage() {
    # GPU usage on macOS requires powermetrics (requires sudo) or Activity Monitor sampling
    # For now, we'll use ioreg to get GPU power state as a proxy
    
    if command -v ioreg &> /dev/null; then
        # This is a simplified approach - actual GPU usage requires more sophisticated tools
        local gpu_state=$(ioreg -r -c IOAccelerator | grep -i "PerformanceStatistics" | wc -l)
        echo "$gpu_state"
    else
        echo "0"
    fi
}

################################################################################
# Battery Monitoring
################################################################################

get_battery_info() {
    if command -v pmset &> /dev/null; then
        local battery_percent=$(pmset -g batt | grep -Eo "\d+%" | sed 's/%//' || echo "0")
        local battery_status=$(pmset -g batt | grep -o "'.*'" | sed "s/'//g" || echo "AC")
        echo "${battery_percent},${battery_status}"
    else
        echo "0,N/A"
    fi
}

################################################################################
# Thermal Monitoring
################################################################################

get_temperature() {
    # macOS doesn't expose CPU temperature directly without additional tools
    # This would require powermetrics or third-party tools
    # Placeholder for now
    echo "0"
}

################################################################################
# Power Consumption
################################################################################

get_power_consumption() {
    # Power consumption monitoring requires powermetrics (sudo) or IOKit
    # Placeholder for now
    if command -v ioreg &> /dev/null; then
        # Try to get power from battery info
        local power=$(ioreg -r -c "AppleSmartBattery" | grep '"InstantAmperage"' | awk '{print $3}' || echo "0")
        echo "$power"
    else
        echo "0"
    fi
}

################################################################################
# Main Monitoring Loop
################################################################################

monitor_system() {
    local samples=$((DURATION / INTERVAL))
    local current_sample=0
    
    print_header "System Performance Monitoring"
    echo "Process: ${PROCESS_NAME:-System-wide}"
    echo "Interval: ${INTERVAL}s"
    echo "Duration: ${DURATION}s"
    echo "Samples: ${samples}"
    echo ""
    
    mkdir -p "${RESULTS_DIR}"
    
    # Write CSV header
    get_system_info > "${RESULTS_FILE}"
    
    print_info "Monitoring started. Press Ctrl+C to stop early."
    echo ""
    
    while [[ $current_sample -lt $samples ]]; do
        local timestamp=$(date +%s)
        local cpu=$(get_cpu_usage)
        local mem_mb=$(get_memory_usage)
        local mem_pct=$(get_memory_percent)
        local gpu=$(get_gpu_usage)
        local battery_info=$(get_battery_info)
        local battery_pct=$(echo "$battery_info" | cut -d, -f1)
        local battery_status=$(echo "$battery_info" | cut -d, -f2)
        local temp=$(get_temperature)
        local power=$(get_power_consumption)
        
        # Write to CSV
        echo "${timestamp},${cpu},${mem_mb},${mem_pct},${gpu},${battery_pct},${battery_status},${temp},${power}" >> "${RESULTS_FILE}"
        
        # Display current stats
        printf "\r[%3d/%3d] CPU: %5.1f%% | Mem: %6.0f MB (%4.1f%%) | Battery: %3d%% (%s)" \
            "$((current_sample + 1))" "$samples" "$cpu" "$mem_mb" "$mem_pct" "$battery_pct" "$battery_status"
        
        sleep "${INTERVAL}"
        ((current_sample++))
    done
    
    echo ""
    print_success "Monitoring complete"
}

################################################################################
# Analysis and Reporting
################################################################################

generate_report() {
    print_header "Performance Report"
    
    if [[ ! -f "${RESULTS_FILE}" ]]; then
        print_error "Results file not found"
        return 1
    fi
    
    echo ""
    print_info "Analyzing results..."
    
    # Calculate statistics using awk
    awk -F',' 'NR>1 {
        cpu_sum+=$2; cpu_max=(cpu_max>$2)?cpu_max:$2; cpu_min=(cpu_min<$2||cpu_min==0)?$2:cpu_min;
        mem_sum+=$3; mem_max=(mem_max>$3)?mem_max:$3; mem_min=(mem_min<$3||mem_min==0)?$3:mem_min;
        count++
    }
    END {
        if (count > 0) {
            printf "CPU Usage:\n"
            printf "  Average: %.2f%%\n", cpu_sum/count
            printf "  Maximum: %.2f%%\n", cpu_max
            printf "  Minimum: %.2f%%\n", cpu_min
            printf "\n"
            printf "Memory Usage:\n"
            printf "  Average: %.2f MB\n", mem_sum/count
            printf "  Maximum: %.2f MB\n", mem_max
            printf "  Minimum: %.2f MB\n", mem_min
            printf "\n"
        }
    }' "${RESULTS_FILE}"
    
    echo "Results saved to: ${RESULTS_FILE}"
    echo ""
    
    print_info "Recommendations:"
    
    # Check for high CPU usage
    local avg_cpu=$(awk -F',' 'NR>1 {sum+=$2; count++} END {if(count>0) print sum/count; else print 0}' "${RESULTS_FILE}")
    if (( $(echo "$avg_cpu > 80" | bc -l) )); then
        print_warning "High average CPU usage detected (${avg_cpu}%)"
        echo "  Consider optimizing CPU-intensive operations"
    fi
    
    # Check for high memory usage
    local avg_mem=$(awk -F',' 'NR>1 {sum+=$3; count++} END {if(count>0) print sum/count; else print 0}' "${RESULTS_FILE}")
    if (( $(echo "$avg_mem > 1024" | bc -l) )); then
        print_warning "High average memory usage detected (${avg_mem} MB)"
        echo "  Consider optimizing memory allocation"
    fi
    
    echo ""
    print_success "Analysis complete"
}

################################################################################
# Usage
################################################################################

usage() {
    echo "Usage: $0 [OPTIONS]"
    echo ""
    echo "Options:"
    echo "  -p, --process NAME    Monitor specific process (e.g., 'emulationstation')"
    echo "  -i, --interval SEC    Sampling interval in seconds (default: 2)"
    echo "  -d, --duration SEC    Total monitoring duration in seconds (default: 300)"
    echo "  -h, --help           Show this help message"
    echo ""
    echo "Examples:"
    echo "  $0                                    # Monitor system for 5 minutes"
    echo "  $0 -p emulationstation -d 600         # Monitor EmulationStation for 10 minutes"
    echo "  $0 -p RetroArch -i 1 -d 180           # Monitor RetroArch for 3 minutes (1s interval)"
}

################################################################################
# Main
################################################################################

main() {
    # Parse arguments
    while [[ $# -gt 0 ]]; do
        case $1 in
            -p|--process)
                PROCESS_NAME="$2"
                shift 2
                ;;
            -i|--interval)
                INTERVAL="$2"
                shift 2
                ;;
            -d|--duration)
                DURATION="$2"
                shift 2
                ;;
            -h|--help)
                usage
                exit 0
                ;;
            *)
                print_error "Unknown option: $1"
                usage
                exit 1
                ;;
        esac
    done
    
    # Run monitoring
    monitor_system 2>&1 | tee "${LOG_FILE}"
    
    # Generate report
    generate_report
}

# Handle Ctrl+C gracefully
trap 'echo ""; print_warning "Monitoring interrupted"; generate_report; exit 0' INT

# Run main function
main "$@"
