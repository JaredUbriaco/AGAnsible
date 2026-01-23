#!/bin/bash
# verify.sh - Verify Ansible deployment and setup

set -e

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

# Check playbook structure
echo ""
echo "Checking playbook structure..."
check_path "playbooks/base/ping_test.yml" "Ping test playbook"
check_path "playbooks/cisco/ssh_test.yml" "SSH test playbook"
check_path "playbooks/system/curl_test.yml" "Curl test playbook"

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

# Summary
echo ""
echo "=========================================="
if [ $FAILURES -eq 0 ]; then
    echo -e "${GREEN}✅ Verification Complete - All checks passed!${NC}"
    echo ""
    echo "Next steps:"
    echo "  1. Run a test: ansible-playbook playbooks/base/ping_test.yml"
    echo "  2. Check results: ls -la actionlog/base/ping_test/"
    exit 0
else
    echo -e "${RED}❌ Verification Failed - $FAILURES issue(s) found${NC}"
    echo ""
    echo "Please review the errors above and:"
    echo "  1. Run install.sh if Ansible is not installed"
    echo "  2. Check file paths if files are missing"
    echo "  3. Review README.md for setup instructions"
    exit 1
fi
