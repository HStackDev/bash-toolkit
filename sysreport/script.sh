#!/bin/bash


RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

## config

REPORT_DIR="./reports"
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
REPORT_FILE="${REPORT_DIR}/system_report_${TIMESTAMP}.txt"
LOG_FILE="${REPORT_DIR}/reporter.log"


# create reports dir if it doesn't exists
mkdir -p "$REPORT_DIR"

# log messages
log_message(){
    echo "[$(date +"%Y%m%d_%H%M%S")] $1" >> "$LOG_FILE"
}

## func to print section headers

print_header() {
    local header="$1"
    echo -e "\n${BLUE}================================"
    echo -e "${GREEN}   $header${NC}"
    echo -e "${BLUE}================================${NC}"
}


# func to get CPU usage
get_cpu_usage() {
    print_header "CPU INFORMATION"

    # CPU model
    echo "CPU Model:"
    lscpu | grep "Model name" | sed 's/Model name://g' | xargs
    echo ""

    # Number of cores
    echo "CPU Cores: $(nproc)"
    echo ""

    # CPU usage percentage
    echo "CPU Usage:"
    top -bn1 | grep "Cpu(s)" | awk '{print "  User: " $2 "\n  System: " $4 "\n  Idle: " $8}'
    echo ""

    # Load avg
    echo "Load Average (1, 5, 15 min):"
    uptime | awk -F'load average:' '{print $2}' | xargs
    echo ""


    # Top 5 CPU consuming processes
    echo "Top 5 CPU-Consuming Processes:"
    ps -eo pid,ppid,cmd,%cpu --sort=-%cpu | head -n 6
    echo ""
  
}

# func to get memory usage
get_mem_usage() {
    print_header "MEMORY INFORMATION"

    # Memory stat
    free -h | awk 'NR==1{printf " %-10s %-10s %-10s %-10s\n", $1, $2, $3, $4} NR==2{printf " %-10s %-10s %-10s %-10s\n", $1, $2, $3, $4}'
    echo ""

    # Swap info
    echo "Swap Information:"
    free -h | awk 'NR==3{printf "  Total: %-10s Used: %-10s Free: %-10s\n", $2, $3, $4}'
    echo ""

    # Top 5 memory consuming processes
    echo "Top 5 Memory-Consuming Processes:"
    ps aux --sort=-%mem | head -6 | tail -5 | awk '{printf "  %-8s %-6s %-6s %s\n", $1, $2, $4, $11}'

}

# func to get disk usage
get_disk_usage() {
    print_header "DISK INFO"

    # Disk usage for all mounted filesystems
    echo "Filesystem Usage:"
    df -h -t ext4 -t xfs -t btrfs -t zfs -t vfat \
     | awk ' \
        NR==1 { \
             printf "  %-20s %-10s %-10s %-10s %-6s %-20s\n", $1, $2, $3, $4, $5, $6 \
        } \
        NR>1 { \
             printf "  %-20s %-10s %-10s %-10s %-6s %-20s\n", $1, $2, $3, $4, $5, $6 \
        }'   
}

# func to get sys_info

get_system_info() {
    print_header "SYSTEM INFO"
    
    echo "Hostname: $(hostname)"
    echo "OS: $(source /etc/os-release && echo $PRETTY_NAME)"
    echo "Kernel Version: $(uname -r)"
    echo "System Uptime: $(uptime -p)"
    echo "Current Date/Time: $(date)"
    echo "Logged-in Users: $(who | wc -l)"
    echo "" 
}

# Main

generate_report() {
    echo -e "\n\n\n\n${YELLOW}Generating system resource report...${NC}"
    
    { 
        echo "╔═══════════════════════════════════════════════════════════════╗"
        echo "║          SYSTEM RESOURCE REPORT                               ║"
        echo "╚═══════════════════════════════════════════════════════════════╝"
        echo ""
        echo "Generated: $(date)"
        echo "Report File: $REPORT_FILE"

        get_system_info
        get_cpu_usage
        get_mem_usage
        get_disk_usage

        echo ""
        echo "═══════════════════════════════════════════════════════════════"
        echo "                    END OF REPORT"
        echo "═══════════════════════════════════════════════════════════════"
    } > $REPORT_FILE
}

generate_report

echo -e "${GREEN}Report generated successfully!${NC}"
echo -e "Location: ${BLUE}$REPORT_FILE${NC}\n\n"
