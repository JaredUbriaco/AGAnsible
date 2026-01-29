#!/bin/bash
# Utility script to log script execution results to actionlog
# Usage: source this script and call log_to_actionlog function

# Function to log script execution to actionlog
log_to_actionlog() {
    local script_name="$1"
    local status="$2"  # SUCCESS or FAILURE
    local message="$3"
    local details="${4:-}"
    local metrics="${5:-}"
    
    # Get script directory
    local script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
    local project_root="$(dirname "$script_dir")"
    local actionlog_dir="$project_root/actionlog/scripts"
    
    # Create actionlog directory
    mkdir -p "$actionlog_dir"
    
    # Generate timestamp
    local timestamp=$(date -Iseconds | tr ':' '-')
    local log_file="$actionlog_dir/${script_name}_${timestamp}.txt"
    
    # Create log entry
    cat > "$log_file" << EOF
============================================
SCRIPT EXECUTION LOG
============================================
Script: $script_name
Timestamp: $(date -Iseconds)
Status: $status
Message: $message

$(if [ -n "$details" ]; then
    echo "DETAILS:"
    echo "$details"
fi)

$(if [ -n "$metrics" ]; then
    echo "METRICS:"
    echo "$metrics"
fi)

============================================
VALIDATION:
- Script Execution: $(if [ "$status" = "SUCCESS" ]; then echo "PASS"; else echo "FAIL"; fi)
============================================
EOF
    
    echo "$log_file"
}

# Function to log with JSON format
log_to_actionlog_json() {
    local script_name="$1"
    local status="$2"
    local message="$3"
    local details="${4:-}"
    local metrics="${5:-}"
    
    local script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
    local project_root="$(dirname "$script_dir")"
    local actionlog_dir="$project_root/actionlog/scripts"
    
    mkdir -p "$actionlog_dir"
    local timestamp=$(date -Iseconds | tr ':' '-')
    local log_file="$actionlog_dir/${script_name}_${timestamp}.json"
    
    # Create JSON log entry
    python3 << EOF > "$log_file"
import json
import sys
from datetime import datetime

data = {
    "test_name": "Script Execution",
    "timestamp": datetime.now().isoformat(),
    "host": "$(hostname)",
    "status": "$status",
    "message": "$message",
    "details": {
        "script_name": "$script_name",
        "exit_code": "${6:-0}"
    },
    "metrics": {},
    "validation": {
        "script_execution": "PASS" if "$status" == "SUCCESS" else "FAIL"
    },
    "playbook_metadata": {
        "version": "1.0.0",
        "author": "AGAnsible Team",
        "description": "Script execution log"
    }
}

if "$details":
    data["details"].update($details)

if "$metrics":
    data["metrics"].update($metrics)

print(json.dumps(data, indent=2))
EOF
    
    echo "$log_file"
}
