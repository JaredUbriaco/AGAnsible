#!/bin/bash
# Test All Playbooks - Quick verification script
# Runs all available playbooks to verify the complete setup

set -e

echo "=========================================="
echo "AGAnsible Complete Test Suite"
echo "=========================================="
echo ""

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

FAILURES=0
TESTS_RUN=0

# Function to run a test
run_test() {
    local test_name=$1
    local playbook=$2
    
    echo ""
    echo "----------------------------------------"
    echo "Testing: $test_name"
    echo "Playbook: $playbook"
    echo "----------------------------------------"
    
    if ansible-playbook "$playbook" > /tmp/ansible_test_$$.log 2>&1; then
        echo -e "${GREEN}✅ PASS${NC} - $test_name"
        TESTS_RUN=$((TESTS_RUN + 1))
        return 0
    else
        echo -e "${RED}❌ FAIL${NC} - $test_name"
        echo "Last 10 lines of output:"
        tail -10 /tmp/ansible_test_$$.log
        FAILURES=$((FAILURES + 1))
        TESTS_RUN=$((TESTS_RUN + 1))
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

# Check actionlog files
echo ""
echo "Actionlog Files Created:"
if [ -d "actionlog" ]; then
    find actionlog -name "*.txt" -type f | wc -l | xargs echo "  Total:"
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

# Final status
echo ""
if [ $FAILURES -eq 0 ]; then
    echo -e "${GREEN}✅ All tests passed!${NC}"
    echo ""
    echo "Your AGAnsible suite is fully operational!"
    exit 0
else
    echo -e "${YELLOW}⚠️  Some tests failed${NC}"
    echo "Check the output above for details"
    echo "Full logs available in: /tmp/ansible_test_$$.log"
    exit 1
fi
