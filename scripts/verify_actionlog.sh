#!/bin/bash
# Verify actionlog system health and integrity
# Checks that actionlog system is working correctly

set -e

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
cd "$PROJECT_ROOT"

ERRORS=0
WARNINGS=0

echo "=========================================="
echo "Actionlog System Health Check"
echo "=========================================="
echo ""

# Check 1: Actionlog directory exists
echo -n "Checking actionlog directory structure... "
if [ -d "actionlog" ]; then
    echo -e "${GREEN}✅${NC}"
else
    echo -e "${RED}❌${NC} actionlog directory not found"
    ERRORS=$((ERRORS + 1))
fi

# Check 2: Required subdirectories exist or can be created
echo -n "Checking actionlog subdirectories... "
REQUIRED_DIRS=(
    "actionlog/base/ping_test"
    "actionlog/system/curl_test"
    "actionlog/system/dns_test"
    "actionlog/cisco/ssh_test"
    "actionlog/multi-vendor/config_backup"
    "actionlog/network/bgp_status"
    "actionlog/network/ospf_status"
    "actionlog/network/mpls_lsp"
    "actionlog/network/performance_test"
    "actionlog/topology/discover_topology"
    "actionlog/scripts"
    "actionlog/test_suite"
)

MISSING_DIRS=()
for dir in "${REQUIRED_DIRS[@]}"; do
    if [ ! -d "$dir" ]; then
        MISSING_DIRS+=("$dir")
    fi
done

if [ ${#MISSING_DIRS[@]} -eq 0 ]; then
    echo -e "${GREEN}✅${NC} All directories exist"
else
    echo -e "${YELLOW}⚠️${NC} ${#MISSING_DIRS[@]} directories missing (will be created on first run)"
    WARNINGS=$((WARNINGS + 1))
fi

# Check 3: write_actionlog.yml exists
echo -n "Checking write_actionlog.yml task... "
if [ -f "roles/common/tasks/write_actionlog.yml" ]; then
    echo -e "${GREEN}✅${NC}"
else
    echo -e "${RED}❌${NC} write_actionlog.yml not found"
    ERRORS=$((ERRORS + 1))
fi

# Check 4: actionlog_setup.yml exists
echo -n "Checking actionlog_setup.yml task... "
if [ -f "roles/common/tasks/actionlog_setup.yml" ]; then
    echo -e "${GREEN}✅${NC}"
else
    echo -e "${RED}❌${NC} actionlog_setup.yml not found"
    ERRORS=$((ERRORS + 1))
fi

# Check 5: All playbooks use actionlog
echo -n "Checking playbook actionlog integration... "
PLAYBOOKS_WITH_ACTIONLOG=$(grep -l "import_tasks.*write_actionlog\|actionlog_dir" playbooks/**/*.yml 2>/dev/null | grep -v template | wc -l)
TOTAL_PLAYBOOKS=$(find playbooks -name "*.yml" -not -path "*/templates/*" 2>/dev/null | wc -l)

if [ "$PLAYBOOKS_WITH_ACTIONLOG" -eq "$TOTAL_PLAYBOOKS" ]; then
    echo -e "${GREEN}✅${NC} All $TOTAL_PLAYBOOKS playbooks integrated"
else
    echo -e "${RED}❌${NC} Only $PLAYBOOKS_WITH_ACTIONLOG/$TOTAL_PLAYBOOKS playbooks integrated"
    ERRORS=$((ERRORS + 1))
fi

# Check 6: JSON schemas exist
echo -n "Checking JSON schemas... "
if [ -f "schemas/actionlog_schema.json" ]; then
    SCHEMA_COUNT=$(find schemas -name "*_schema.json" 2>/dev/null | wc -l)
    echo -e "${GREEN}✅${NC} $SCHEMA_COUNT schemas found"
else
    echo -e "${YELLOW}⚠️${NC} Base schema not found"
    WARNINGS=$((WARNINGS + 1))
fi

# Check 7: Test write permissions
echo -n "Testing write permissions... "
TEST_FILE="actionlog/.write_test_$$"
if touch "$TEST_FILE" 2>/dev/null; then
    rm -f "$TEST_FILE"
    echo -e "${GREEN}✅${NC}"
else
    echo -e "${RED}❌${NC} Cannot write to actionlog directory"
    ERRORS=$((ERRORS + 1))
fi

# Check 8: Existing actionlog files
echo -n "Checking existing actionlog files... "
ACTIONLOG_FILES=$(find actionlog -name "*.txt" -o -name "*.json" 2>/dev/null | wc -l)
if [ "$ACTIONLOG_FILES" -gt 0 ]; then
    echo -e "${GREEN}✅${NC} $ACTIONLOG_FILES files found"
else
    echo -e "${YELLOW}⚠️${NC} No actionlog files found (normal if no tests run yet)"
    WARNINGS=$((WARNINGS + 1))
fi

# Check 9: Validate JSON files (if any)
if [ "$ACTIONLOG_FILES" -gt 0 ]; then
    echo -n "Validating JSON actionlog files... "
    JSON_FILES=$(find actionlog -name "*.json" 2>/dev/null | wc -l)
    if [ "$JSON_FILES" -gt 0 ]; then
        INVALID_JSON=0
        while IFS= read -r json_file; do
            if ! python3 -c "import json; json.load(open('$json_file'))" 2>/dev/null; then
                INVALID_JSON=$((INVALID_JSON + 1))
            fi
        done < <(find actionlog -name "*.json" 2>/dev/null)
        
        if [ $INVALID_JSON -eq 0 ]; then
            echo -e "${GREEN}✅${NC} All $JSON_FILES JSON files valid"
        else
            echo -e "${RED}❌${NC} $INVALID_JSON/$JSON_FILES JSON files invalid"
            ERRORS=$((ERRORS + 1))
        fi
    else
        echo -e "${YELLOW}⚠️${NC} No JSON files to validate"
    fi
fi

# Summary
echo ""
echo "=========================================="
echo "Health Check Summary"
echo "=========================================="
echo "Errors: $ERRORS"
echo "Warnings: $WARNINGS"
echo ""

if [ $ERRORS -eq 0 ]; then
    echo -e "${GREEN}✅ Actionlog system is healthy!${NC}"
    echo ""
    echo "All components verified:"
    echo "  ✅ Directory structure"
    echo "  ✅ Task files"
    echo "  ✅ Playbook integration"
    echo "  ✅ Write permissions"
    echo ""
    exit 0
else
    echo -e "${RED}❌ Actionlog system has issues${NC}"
    echo ""
    echo "Please review the errors above"
    echo ""
    exit 1
fi
