#!/bin/bash
# verify.sh - Verify Ansible deployment and setup

set -e

# Actionlog directory
ACTIONLOG_DIR="actionlog/scripts"
mkdir -p "$ACTIONLOG_DIR"
TIMESTAMP=$(date -Iseconds | tr ':' '-')

echo "=========================================="
echo "Ansible Deployment Verification"
echo "=========================================="
echo ""

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Track failures
FAILURES=0

# Function to check command
check_command() {
    if command -v $1 &> /dev/null; then
        VERSION=$($1 --version 2>&1 | head -1)
        echo -e "${GREEN}✅${NC} $1 installed: $VERSION"
        return 0
    else
        echo -e "${RED}❌${NC} $1 not found"
        FAILURES=$((FAILURES + 1))
        return 1
    fi
}

# Function to check file/directory
check_path() {
    if [ -e "$1" ]; then
        echo -e "${GREEN}✅${NC} $2 exists: $1"
        return 0
    else
        echo -e "${RED}❌${NC} $2 not found: $1"
        FAILURES=$((FAILURES + 1))
        return 1
    fi
}

# Check Ansible
echo "Checking Ansible installation..."
check_command ansible
check_command ansible-playbook

# Check Python
echo ""
echo "Checking Python installation..."
check_command python3
check_command pip3

# Check DNS utilities
echo ""
echo "Checking DNS utilities..."
if command -v dig &> /dev/null || command -v nslookup &> /dev/null; then
    if command -v dig &> /dev/null; then
        echo -e "${GREEN}✅${NC} dig installed: $(dig -v 2>&1 | head -1)"
    fi
    if command -v nslookup &> /dev/null; then
        echo -e "${GREEN}✅${NC} nslookup installed"
    fi
else
    echo -e "${RED}❌${NC} Neither dig nor nslookup found (install with: sudo apt-get install dnsutils)"
    FAILURES=$((FAILURES + 1))
fi

# Check playbook structure
echo ""
echo "Checking playbook structure..."
check_path "playbooks/base/ping_test.yml" "Ping test playbook"
check_path "playbooks/cisco/ssh_test.yml" "SSH test playbook"
check_path "playbooks/system/curl_test.yml" "Curl test playbook"
check_path "playbooks/system/dns_test.yml" "DNS test playbook"

# Check configuration
echo ""
echo "Checking configuration files..."
check_path "ansible.cfg" "Ansible configuration"
check_path "inventories/localhost.ini" "Localhost inventory"

# Check actionlog directories
echo ""
echo "Checking actionlog directories..."
if [ -d "actionlog" ]; then
    echo -e "${GREEN}✅${NC} Actionlog directory exists"
    if [ -d "actionlog/base/ping_test" ]; then
        echo -e "${GREEN}✅${NC} Actionlog subdirectories exist"
    else
        echo -e "${YELLOW}⚠️${NC} Actionlog subdirectories not created (will be created on first run)"
    fi
else
    echo -e "${YELLOW}⚠️${NC} Actionlog directory not created (will be created on first run)"
fi

# Check documentation
echo ""
echo "Checking documentation..."
check_path "README.md" "README"
check_path "QUICK_START.md" "Quick Start guide"
check_path "REQUIREMENTS.md" "Requirements documentation"

# Test playbook execution (optional)
echo ""
echo "Testing playbook execution..."
if ansible-playbook --syntax-check playbooks/base/ping_test.yml &> /dev/null; then
    echo -e "${GREEN}✅${NC} Ping test playbook syntax is valid"
else
    echo -e "${RED}❌${NC} Ping test playbook has syntax errors"
    FAILURES=$((FAILURES + 1))
fi

# Log verification results to actionlog
log_verification_result() {
    local status="$1"
    local actionlog_file="$ACTIONLOG_DIR/verify_${TIMESTAMP}.txt"
    
    cat > "$actionlog_file" << EOF
============================================
VERIFICATION EXECUTION LOG
============================================
Script: verify.sh
Timestamp: $(date -Iseconds)
Status: $status
Failures Found: $FAILURES

Checks Performed:
- Ansible installation
- Python installation
- DNS utilities
- Playbook structure
- Configuration files
- Actionlog directories
- Documentation

============================================
VALIDATION:
- Verification Execution: $(if [ "$status" = "SUCCESS" ]; then echo "PASS"; else echo "FAIL"; fi)
- All Checks Passed: $(if [ $FAILURES -eq 0 ]; then echo "PASS"; else echo "FAIL"; fi)
============================================
EOF
    echo "$actionlog_file"
}

# Summary
echo ""
echo "=========================================="
if [ $FAILURES -eq 0 ]; then
    echo -e "${GREEN}✅ Verification Complete - All checks passed!${NC}"
    echo ""
    echo "Next steps:"
    echo "  1. Run a test: ansible-playbook playbooks/base/ping_test.yml"
    echo "  2. Check results: ls -la actionlog/base/ping_test/"
    log_verification_result "SUCCESS" > /dev/null
    echo "Actionlog: $(log_verification_result "SUCCESS")"
    exit 0
else
    echo -e "${RED}❌ Verification Failed - $FAILURES issue(s) found${NC}"
    echo ""
    echo "Please review the errors above and:"
    echo "  1. Run install.sh if Ansible is not installed"
    echo "  2. Check file paths if files are missing"
    echo "  3. Review README.md for setup instructions"
    log_verification_result "FAILURE" > /dev/null
    echo "Actionlog: $(log_verification_result "FAILURE")"
    exit 1
fi
