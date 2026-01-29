#!/bin/bash
# Test All Playbooks - Quick verification script
# Runs all available playbooks to verify the complete setup

set -e

# Parse command line arguments
VERBOSE=false
if [[ "$1" == "--verbose" ]] || [[ "$1" == "-v" ]]; then
    VERBOSE=true
fi

echo "=========================================="
echo "AGAnsible Complete Test Suite"
echo "=========================================="
echo ""

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

FAILURES=0
TESTS_RUN=0
TEST_RESULTS=()

# Create log directory
LOG_DIR="actionlog/test_suite"
mkdir -p "$LOG_DIR"
TIMESTAMP=$(date -Iseconds | tr ':' '-')
LOG_FILE="$LOG_DIR/test_suite_${TIMESTAMP}.log"
SUMMARY_FILE="$LOG_DIR/test_suite_${TIMESTAMP}_summary.txt"

# Also log to standardized actionlog format
ACTIONLOG_DIR="actionlog/scripts"
mkdir -p "$ACTIONLOG_DIR"

# Function to parse errors and provide suggestions
parse_error() {
    local log_file=$1
    local suggestions=""
    
    if grep -q "command not found" "$log_file"; then
        suggestions="Missing command detected. Run: ./install.sh"
    elif grep -q "Permission denied" "$log_file"; then
        suggestions="Permission issue. Check file permissions or run with sudo if needed."
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

# Function to run a test
run_test() {
    local test_name=$1
    local playbook=$2
    local test_log="$LOG_DIR/${test_name}_${TIMESTAMP}.log"
    
    echo ""
    echo "----------------------------------------"
    echo "Testing: $test_name"
    echo "Playbook: $playbook"
    echo "----------------------------------------"
    
    # Run the test and capture full output
    if ansible-playbook "$playbook" > "$test_log" 2>&1; then
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
    echo "Usage: cd /path/to/ansible && ./test_all.sh"
    exit 1
fi

# Verify Ansible is installed
if ! command -v ansible-playbook &> /dev/null; then
    echo -e "${RED}Error: Ansible not installed${NC}"
    echo "Run: ./install.sh"
    exit 1
fi

echo "Starting test suite..."
echo ""

# Test 1: Ping Test (Base)
run_test "Ping Test" "playbooks/base/ping_test.yml"

# Test 2: Curl Test (System)
run_test "Curl Test" "playbooks/system/curl_test.yml"

# Test 3: DNS Test (System)
run_test "DNS Test" "playbooks/system/dns_test.yml"

# Summary
echo ""
echo "=========================================="
echo "Test Summary"
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
    echo "AGAnsible Test Suite Summary"
    echo "=========================================="
    echo "Test Date: $(date)"
    echo "Tests Run: $TESTS_RUN"
    echo "Passed: $((TESTS_RUN - FAILURES))"
    echo "Failed: $FAILURES"
    echo ""
    echo "Test Results:"
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
} > "$SUMMARY_FILE"

# Check actionlog files
echo ""
echo "Actionlog Files Created:"
if [ -d "actionlog" ]; then
    total_files=$(find actionlog -name "*.txt" -type f 2>/dev/null | wc -l)
    echo "  Total: $total_files"
    echo ""
    echo "Latest results:"
    for dir in actionlog/*/*/; do
        if [ -d "$dir" ]; then
            latest=$(ls -t "$dir"*.txt 2>/dev/null | head -1)
            if [ -n "$latest" ]; then
                echo "  $(basename $(dirname $dir))/$(basename $dir): $(basename $latest)"
            fi
        fi
    done
else
    echo "  No actionlog directory found"
fi

# Log test suite execution to actionlog
log_test_suite_result() {
    local status="$1"
    local actionlog_file="$ACTIONLOG_DIR/test_suite_${TIMESTAMP}.txt"
    
    cat > "$actionlog_file" << EOF
============================================
TEST SUITE EXECUTION LOG
============================================
Script: test_all.sh
Timestamp: $(date -Iseconds)
Status: $status
Tests Run: $TESTS_RUN
Tests Passed: $((TESTS_RUN - FAILURES))
Tests Failed: $FAILURES

Test Results:
$(for result in "${TEST_RESULTS[@]}"; do
    IFS=':' read -r result_status result_name result_playbook <<< "$result"
    echo "  - $result_name: $result_status"
done)

Log Files:
  - Test suite log: $LOG_FILE
  - Summary report: $SUMMARY_FILE
  - Individual test logs: $LOG_DIR/

============================================
VALIDATION:
- Test Suite Execution: $(if [ "$status" = "SUCCESS" ]; then echo "PASS"; else echo "FAIL"; fi)
- All Tests Passed: $(if [ $FAILURES -eq 0 ]; then echo "PASS"; else echo "FAIL"; fi)
============================================
EOF
    echo "$actionlog_file"
}

# Final status
echo ""
echo "=========================================="
if [ $FAILURES -eq 0 ]; then
    echo -e "${GREEN}✅ All tests passed!${NC}"
    echo ""
    echo "Your AGAnsible suite is fully operational!"
    echo "Summary report: $SUMMARY_FILE"
    log_test_suite_result "SUCCESS" > /dev/null
    echo "Actionlog: $(log_test_suite_result "SUCCESS")"
    exit 0
else
    echo -e "${YELLOW}⚠️  Some tests failed${NC}"
    echo ""
    echo "Check the output above for details"
    echo "Full logs available in: $LOG_DIR/"
    echo "Summary report: $SUMMARY_FILE"
    log_test_suite_result "FAILURE" > /dev/null
    echo "Actionlog: $(log_test_suite_result "FAILURE")"
    echo ""
    echo "To see detailed output, run: $0 --verbose"
    exit 1
fi
