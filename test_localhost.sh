#!/bin/bash
# Test Localhost Playbooks - Runs only localhost-capable tests
# This script tests playbooks that can run on localhost without requiring network devices
#
# Usage:
#   ./test_localhost.sh              # Run all localhost tests
#   ./test_localhost.sh --verbose    # Run with detailed output
#   ./test_localhost.sh --json       # Run with JSON output format

set -e

# Parse command line arguments
VERBOSE=false
OUTPUT_FORMAT="text"
if [[ "$1" == "--verbose" ]] || [[ "$1" == "-v" ]]; then
    VERBOSE=true
    shift
fi
if [[ "$1" == "--json" ]] || [[ "$1" == "-j" ]]; then
    OUTPUT_FORMAT="json"
    shift
fi
if [[ "$1" == "--both" ]] || [[ "$1" == "-b" ]]; then
    OUTPUT_FORMAT="both"
    shift
fi

echo "=========================================="
echo "AGAnsible Localhost Test Suite"
echo "=========================================="
echo ""
echo "This script runs only localhost-capable tests."
echo "These tests do not require network devices or remote infrastructure."
echo ""

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

FAILURES=0
TESTS_RUN=0
TEST_RESULTS=()

# Create log directory
LOG_DIR="actionlog/test_suite/localhost"
mkdir -p "$LOG_DIR"
TIMESTAMP=$(date -Iseconds | tr ':' '-')
LOG_FILE="$LOG_DIR/localhost_tests_${TIMESTAMP}.log"
SUMMARY_FILE="$LOG_DIR/localhost_tests_${TIMESTAMP}_summary.txt"

# Also log to standardized actionlog format
ACTIONLOG_DIR="actionlog/scripts"
mkdir -p "$ACTIONLOG_DIR"

# Function to parse errors and provide suggestions
parse_error() {
    local log_file=$1
    local suggestions=""
    
    if grep -q "command not found" "$log_file"; then
        suggestions="Missing command detected. Run: ./install.sh"
    elif grep -q "Permission denied\|multiprocessing" "$log_file"; then
        suggestions="Multiprocessing permission issue detected. This is often a sandbox/environment restriction. The script will continue but may show warnings. For production use, ensure /dev/shm is accessible."
    elif grep -q "Connection refused\|Connection timed out" "$log_file"; then
        suggestions="Network connectivity issue. Check network connection and firewall settings."
    elif grep -q "No such file or directory" "$log_file"; then
        suggestions="Missing file or directory. Verify playbook paths and inventory files."
    elif grep -q "syntax error" "$log_file"; then
        suggestions="YAML syntax error. Run: ansible-playbook --syntax-check <playbook>"
    elif grep -q "ModuleNotFoundError\|ImportError" "$log_file"; then
        suggestions="Missing Python module. Install required Ansible collections or Python packages."
    fi
    
    echo "$suggestions"
}

# Function to run a localhost test
run_localhost_test() {
    local test_name=$1
    local playbook=$2
    local test_log="$LOG_DIR/${test_name// /_}_${TIMESTAMP}.log"
    
    echo ""
    echo "----------------------------------------"
    echo "Testing: $test_name"
    echo "Playbook: $playbook"
    echo "----------------------------------------"
    
    # Build ansible-playbook command with optional output format
    # Disable multiprocessing to avoid /dev/shm permission issues in sandboxed environments
    local ansible_cmd="ANSIBLE_FORKS=1 ANSIBLE_SSH_PIPELINING=0 ansible-playbook --forks 1 \"$playbook\""
    if [ "$OUTPUT_FORMAT" != "text" ]; then
        ansible_cmd="$ansible_cmd -e output_format=$OUTPUT_FORMAT"
    fi
    
    # Run the test and capture full output
    # Suppress multiprocessing warnings if they occur (non-fatal)
    if eval "$ansible_cmd" > "$test_log" 2>&1; then
        echo -e "${GREEN}✅ PASS${NC} - $test_name"
        TEST_RESULTS+=("PASS:$test_name:$playbook")
        TESTS_RUN=$((TESTS_RUN + 1))
        if [ "$VERBOSE" = true ]; then
            echo -e "${BLUE}Full log: $test_log${NC}"
        fi
        return 0
    else
        echo -e "${RED}❌ FAIL${NC} - $test_name"
        FAILURES=$((FAILURES + 1))
        TESTS_RUN=$((TESTS_RUN + 1))
        TEST_RESULTS+=("FAIL:$test_name:$playbook")
        
        # Show error details
        echo ""
        echo -e "${YELLOW}Error Summary:${NC}"
        echo "Last 15 lines of output:"
        tail -15 "$test_log" | sed 's/^/  /'
        
        # Parse errors and provide suggestions
        local suggestions=$(parse_error "$test_log")
        if [ -n "$suggestions" ]; then
            echo ""
            echo -e "${YELLOW}💡 Suggestion:${NC} $suggestions"
        fi
        
        if [ "$VERBOSE" = true ]; then
            echo ""
            echo -e "${BLUE}Full error log:${NC}"
            cat "$test_log"
        else
            echo ""
            echo -e "${BLUE}Full log saved to: $test_log${NC}"
        fi
        
        return 1
    fi
}

# Check if we're in the right directory
if [ ! -f "ansible.cfg" ]; then
    echo -e "${RED}Error: Must run from ansible directory${NC}"
    echo "Usage: cd /path/to/ansible && ./test_localhost.sh"
    exit 1
fi

# Verify Ansible is installed
if ! command -v ansible-playbook &> /dev/null; then
    echo -e "${RED}Error: Ansible not installed${NC}"
    echo "Run: ./install.sh"
    exit 1
fi

# Display configuration
echo -e "${CYAN}Configuration:${NC}"
echo "  Output Format: $OUTPUT_FORMAT"
echo "  Verbose Mode: $VERBOSE"
echo "  Log Directory: $LOG_DIR"
echo ""
echo "Starting localhost test suite..."
echo ""

# ============================================
# LOCALHOST TESTS - Fully Implemented
# ============================================

echo -e "${BLUE}==========================================${NC}"
echo -e "${BLUE}Running Localhost-Capable Tests${NC}"
echo -e "${BLUE}==========================================${NC}"
echo ""

# Test 1: Ping Test (Base)
run_localhost_test "Ping Test" "playbooks/base/ping_test.yml"

# Test 2: Curl Test (System)
run_localhost_test "Curl Test" "playbooks/system/curl_test.yml"

# Test 3: DNS Test (System)
run_localhost_test "DNS Test" "playbooks/system/dns_test.yml"

# Test 4: Port Scan (System)
run_localhost_test "Port Scan" "playbooks/system/port_scan.yml"

# Test 5: Network Interfaces (System)
run_localhost_test "Network Interfaces" "playbooks/system/network_interfaces.yml"

# Test 6: SSL Certificate Check (System)
run_localhost_test "SSL Certificate Check" "playbooks/system/ssl_cert_check.yml"

# Test 7: Firewall Rules Check (System)
run_localhost_test "Firewall Rules Check" "playbooks/system/firewall_check.yml"

# Test 8: Network Statistics (System)
run_localhost_test "Network Statistics" "playbooks/system/network_stats.yml"

# Test 9: Traceroute Test (System)
run_localhost_test "Traceroute Test" "playbooks/system/traceroute_test.yml"

# Summary
echo ""
echo "=========================================="
echo "Localhost Test Summary"
echo "=========================================="
echo "Tests Run: $TESTS_RUN"
echo -e "Passed: ${GREEN}$((TESTS_RUN - FAILURES))${NC}"
if [ $FAILURES -gt 0 ]; then
    echo -e "Failed: ${RED}$FAILURES${NC}"
else
    echo -e "Failed: ${GREEN}0${NC}"
fi

# Generate summary report
{
    echo "=========================================="
    echo "AGAnsible Localhost Test Suite Summary"
    echo "=========================================="
    echo "Test Date: $(date)"
    echo "Output Format: $OUTPUT_FORMAT"
    echo "Tests Run: $TESTS_RUN"
    echo "Passed: $((TESTS_RUN - FAILURES))"
    echo "Failed: $FAILURES"
    echo ""
    echo "Localhost Tests (No network devices required):"
    for result in "${TEST_RESULTS[@]}"; do
        IFS=':' read -r status name playbook <<< "$result"
        if [ "$status" = "PASS" ]; then
            echo "  ✅ $name - PASSED"
        else
            echo "  ❌ $name - FAILED"
            echo "     Playbook: $playbook"
        fi
    done
    echo ""
    echo "Log Files:"
    echo "  Test suite log: $LOG_FILE"
    echo "  Individual test logs: $LOG_DIR/"
    echo ""
    echo "Note: These tests run on localhost only and do not require"
    echo "      network devices or remote infrastructure."
} > "$SUMMARY_FILE"

# Check actionlog files
echo ""
echo "Actionlog Files Created:"
if [ -d "actionlog" ]; then
    # Count localhost-related actionlog files
    localhost_dirs=(
        "actionlog/base/ping_test"
        "actionlog/system/curl_test"
        "actionlog/system/dns_test"
        "actionlog/system/port_scan"
        "actionlog/system/network_interfaces"
        "actionlog/system/ssl_cert_check"
        "actionlog/system/firewall_check"
        "actionlog/system/network_stats"
        "actionlog/system/traceroute_test"
    )
    
    total_files=0
    for dir in "${localhost_dirs[@]}"; do
        if [ -d "$dir" ]; then
            count=$(find "$dir" -name "*.txt" -o -name "*.json" 2>/dev/null | wc -l)
            total_files=$((total_files + count))
        fi
    done
    
    echo "  Total localhost test results: $total_files"
    echo ""
    echo "Latest results:"
    for dir in "${localhost_dirs[@]}"; do
        if [ -d "$dir" ]; then
            latest=$(ls -t "$dir"*.txt "$dir"*.json 2>/dev/null | head -1)
            if [ -n "$latest" ]; then
                echo "  $(basename $(dirname $dir))/$(basename $dir): $(basename $latest)"
            fi
        fi
    done
else
    echo "  No actionlog directory found"
fi

# Log test suite execution to actionlog
log_localhost_test_result() {
    local status="$1"
    local actionlog_file="$ACTIONLOG_DIR/localhost_tests_${TIMESTAMP}.txt"
    
    cat > "$actionlog_file" << EOF
============================================
LOCALHOST TEST SUITE EXECUTION LOG
============================================
Script: test_localhost.sh
Timestamp: $(date -Iseconds)
Status: $status
Output Format: $OUTPUT_FORMAT
Tests Run: $TESTS_RUN
Tests Passed: $((TESTS_RUN - FAILURES))
Tests Failed: $FAILURES

Localhost Tests (No network devices required):
$(for result in "${TEST_RESULTS[@]}"; do
    IFS=':' read -r result_status result_name result_playbook <<< "$result"
    echo "  - $result_name: $result_status"
done)

Log Files:
  - Test suite log: $LOG_FILE
  - Summary report: $SUMMARY_FILE
  - Individual test logs: $LOG_DIR/

Note: These tests run on localhost only and do not require
      network devices or remote infrastructure.

============================================
VALIDATION:
- Localhost Test Suite Execution: $(if [ "$status" = "SUCCESS" ]; then echo "PASS"; else echo "FAIL"; fi)
- All Localhost Tests Passed: $(if [ $FAILURES -eq 0 ]; then echo "PASS"; else echo "FAIL"; fi)
============================================
EOF
    echo "$actionlog_file"
}

# Final status
echo ""
echo "=========================================="
if [ $FAILURES -eq 0 ]; then
    echo -e "${GREEN}✅ All localhost tests passed!${NC}"
    echo ""
    echo "Your localhost-capable tests are fully operational!"
    echo "Summary report: $SUMMARY_FILE"
    log_localhost_test_result "SUCCESS" > /dev/null
    echo "Actionlog: $(log_localhost_test_result "SUCCESS")"
    echo ""
    echo -e "${CYAN}Note:${NC} These tests run on localhost only."
    echo "      For tests requiring network devices, use: ./test_all.sh"
    exit 0
else
    echo -e "${YELLOW}⚠️  Some localhost tests failed${NC}"
    echo ""
    echo "Check the output above for details"
    echo "Full logs available in: $LOG_DIR/"
    echo "Summary report: $SUMMARY_FILE"
    log_localhost_test_result "FAILURE" > /dev/null
    echo "Actionlog: $(log_localhost_test_result "FAILURE")"
    echo ""
    echo "To see detailed output, run: $0 --verbose"
    exit 1
fi
