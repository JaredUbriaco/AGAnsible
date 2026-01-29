#!/bin/bash
# Linting script for AGAnsible
# Runs yamllint and ansible-lint on all relevant files

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

echo "=========================================="
echo "AGAnsible Linting"
echo "=========================================="
echo ""

# Check for yamllint
if ! command -v yamllint &> /dev/null; then
    echo -e "${YELLOW}yamllint not found. Install with: pip3 install yamllint${NC}"
    echo ""
else
    echo -e "${BLUE}Running yamllint...${NC}"
    if yamllint -c .yamllint.yml .; then
        echo -e "${GREEN}✅ yamllint passed${NC}"
    else
        echo -e "${RED}❌ yamllint failed${NC}"
        ERRORS=$((ERRORS + 1))
    fi
    echo ""
fi

# Check for ansible-lint
if ! command -v ansible-lint &> /dev/null; then
    echo -e "${YELLOW}ansible-lint not found. Install with: pip3 install ansible-lint${NC}"
    echo ""
else
    echo -e "${BLUE}Running ansible-lint...${NC}"
    if ansible-lint --config-file .ansible-lint .; then
        echo -e "${GREEN}✅ ansible-lint passed${NC}"
    else
        echo -e "${RED}❌ ansible-lint failed${NC}"
        ERRORS=$((ERRORS + 1))
    fi
    echo ""
fi

# Check for jsonschema and validate JSON files
if python3 -c "import jsonschema" 2>/dev/null; then
    echo -e "${BLUE}Validating JSON schemas...${NC}"
    if bash scripts/validate_json_schemas.sh actionlog/**/*.json 2>/dev/null; then
        echo -e "${GREEN}✅ JSON schema validation passed${NC}"
    else
        echo -e "${YELLOW}⚠️  JSON schema validation had issues (non-blocking)${NC}"
    fi
    echo ""
else
    echo -e "${YELLOW}jsonschema not found. Skipping JSON validation.${NC}"
    echo "Install with: pip3 install jsonschema"
    echo ""
fi

# Summary
echo "=========================================="
if [ $ERRORS -eq 0 ]; then
    echo -e "${GREEN}✅ All linting checks passed!${NC}"
    exit 0
else
    echo -e "${RED}❌ Linting failed with $ERRORS error(s)${NC}"
    exit 1
fi
