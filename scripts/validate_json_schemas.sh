#!/bin/bash
# Pre-commit hook: Validate JSON files against schemas
# This script validates JSON files in actionlog directories against their schemas

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Check if jsonschema is installed
if ! python3 -c "import jsonschema" 2>/dev/null; then
    echo -e "${YELLOW}Warning: jsonschema not installed. Skipping JSON schema validation.${NC}"
    echo "Install with: pip3 install jsonschema"
    exit 0
fi

# Get script directory
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
SCHEMAS_DIR="$PROJECT_ROOT/schemas"

# Function to validate JSON against schema
validate_json() {
    local json_file="$1"
    local schema_file="$2"
    
    python3 << EOF
import json
import jsonschema
import sys

try:
    # Load schema
    with open('$schema_file', 'r') as f:
        schema = json.load(f)
    
    # Load JSON file
    with open('$json_file', 'r') as f:
        data = json.load(f)
    
    # Validate
    jsonschema.validate(instance=data, schema=schema)
    print("✅ Valid: $json_file")
    sys.exit(0)
except jsonschema.ValidationError as e:
    print(f"❌ Validation error in $json_file:")
    print(f"   {e.message}")
    print(f"   Path: {e.json_path}")
    sys.exit(1)
except Exception as e:
    print(f"❌ Error validating $json_file: {str(e)}")
    sys.exit(1)
EOF
}

# Determine schema based on filename
get_schema() {
    local json_file="$1"
    local basename=$(basename "$json_file" .json)
    
    # Try to match test type from filename
    if [[ "$basename" == *"ping_test"* ]]; then
        echo "$SCHEMAS_DIR/ping_test_schema.json"
    elif [[ "$basename" == *"curl_test"* ]]; then
        echo "$SCHEMAS_DIR/curl_test_schema.json"
    elif [[ "$basename" == *"dns_test"* ]]; then
        echo "$SCHEMAS_DIR/dns_test_schema.json"
    else
        # Default to base schema
        echo "$SCHEMAS_DIR/actionlog_schema.json"
    fi
}

# Main validation
errors=0
for json_file in "$@"; do
    # Skip if not in actionlog directory
    if [[ "$json_file" != *"actionlog"* ]]; then
        continue
    fi
    
    # Skip schema files themselves
    if [[ "$json_file" == *"schemas"* ]]; then
        continue
    fi
    
    schema_file=$(get_schema "$json_file")
    
    if [ ! -f "$schema_file" ]; then
        echo -e "${YELLOW}Warning: Schema not found: $schema_file${NC}"
        continue
    fi
    
    if ! validate_json "$json_file" "$schema_file"; then
        errors=$((errors + 1))
    fi
done

if [ $errors -gt 0 ]; then
    echo -e "\n${RED}JSON schema validation failed for $errors file(s)${NC}"
    exit 1
fi

exit 0
