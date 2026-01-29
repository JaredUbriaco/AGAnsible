# Actionlog Directory

This directory contains test results and logs for all Ansible playbook executions.

## Structure

```
actionlog/
├── base/                      # Agnostic test results
│   └── ping_test/            # Ping test results
│
├── cisco/                     # Cisco-specific test results
│   └── ssh_test/              # SSH connectivity test results
│
├── system/                    # System-level test results
│   ├── curl_test/             # Curl/HTTP test results
│   └── dns_test/              # DNS resolution test results
│
├── multi-vendor/              # Multi-vendor operations
│   └── config_backup/         # Configuration backup results
│
├── network/                   # Network protocol monitoring
│   ├── bgp_status/            # BGP status monitoring
│   ├── ospf_status/           # OSPF status monitoring
│   ├── mpls_lsp/              # MPLS LSP monitoring
│   └── performance_test/      # Network performance testing
│
└── topology/                  # Network topology discovery
    └── discover_topology/     # Topology discovery results
```

## File Naming Convention

All actionlog files follow this pattern:
- Format: `{test_name}_{hostname}_{timestamp}.{txt|json}`
- Extension: `.txt` for text format, `.json` for JSON format

Examples:
- `ping_test_localhost_2026-01-22T10-30-45-00-00.txt`
- `ping_test_localhost_2026-01-22T10-30-45-00-00.json` (when `output_format=json`)
- `curl_test_server1_2026-01-22T10-30-45-00-00.txt`
- `bgp_status_router1_2026-01-22T10-30-45-00-00.json`
- `performance_test_localhost_2026-01-22T10-30-45-00-00.json`

## File Contents

Each test result file contains:
- Test execution timestamp
- Test status (SUCCESS/FAILURE)
- Detailed validation results
- Full output from test execution
- Pass/Fail indicators for each validation check

## Viewing Results

To view the latest test results:
```bash
# Latest ping test
ls -t actionlog/base/ping_test/*.{txt,json} 2>/dev/null | head -1 | xargs cat

# Latest SSH test
ls -t actionlog/cisco/ssh_test/*.{txt,json} 2>/dev/null | head -1 | xargs cat

# Latest curl test
ls -t actionlog/system/curl_test/*.{txt,json} 2>/dev/null | head -1 | xargs cat

# Latest DNS test
ls -t actionlog/system/dns_test/*.{txt,json} 2>/dev/null | head -1 | xargs cat

# Latest BGP status
ls -t actionlog/network/bgp_status/*.{txt,json} 2>/dev/null | head -1 | xargs cat

# Latest performance test
ls -t actionlog/network/performance_test/*.{txt,json} 2>/dev/null | head -1 | xargs cat
```

## Output Formats

All playbooks support multiple output formats:

### Text Format (Default)
- Human-readable text files
- Easy to read and parse manually
- Extension: `.txt`

### JSON Format
- Structured JSON data
- Easy to parse programmatically
- Supports schema validation
- Extension: `.json`

### Both Formats
- Generate both text and JSON files
- Use `output_format: both` in playbook vars

## Standardization

**✅ All playbooks use standardized actionlog system:**
- Consistent format across all playbooks
- Same data structure (test_name, timestamp, status, metrics, validation)
- Support for JSON output
- Schema validation capability
- Centralized logging via `write_actionlog.yml` task

**Total Playbooks with Actionlog**: 10/10 (100%)
