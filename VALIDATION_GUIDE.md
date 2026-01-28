# Validation and Testing Guide

## Overview

All playbooks now include comprehensive validation and success/failure testing with detailed actionlog files.

## Validation Features

Each playbook includes:
- ✅ **Success/Failure Detection** - Automatic validation of test results
- ✅ **Detailed Logging** - Text files written to actionlog folders
- ✅ **Clear Status Indicators** - PASS/FAIL for each validation check
- ✅ **Timestamped Results** - Each test run creates a unique log file
- ✅ **Error Handling** - Playbooks fail gracefully with clear error messages

## Actionlog Structure

```
actionlog/
├── base/
│   └── ping_test/          # Ping test results
│       └── ping_test_<timestamp>.txt
│
├── cisco/
│   └── ssh_test/           # SSH connectivity test results
│       └── ssh_test_<hostname>_<timestamp>.txt
│
└── system/
    └── curl_test/          # Curl/HTTP test results
        └── curl_test_<hostname>_<timestamp>.txt
```

## Test Validations

### Ping Test (`base/ping_test.yml`)
**Validations:**
- Packet loss < 100%: PASS/FAIL
- Packets received > 0: PASS/FAIL
- Overall status: SUCCESS/FAILURE

**Failure Conditions:**
- 100% packet loss
- No packets received
- Ping command fails

### SSH Test (`cisco/ssh_test.yml`)
**Validations:**
- SSH Connection: PASS/FAIL
- Device Response: PASS/FAIL
- Test Completed: PASS

**Failure Conditions:**
- SSH connection timeout
- Authentication failure
- Device unresponsive

### Curl Test (`system/curl_test.yml`)
**Validations:**
- Curl Installation: PASS/FAIL
- All URLs Accessible: PASS/FAIL
- HTTP Status Codes: PASS/FAIL

**Failure Conditions:**
- Curl not installed
- URL unreachable
- Wrong HTTP status code
- Connection timeout

### DNS Test (`system/dns_test.yml`)
**Validations:**
- DNS Tool Installed: PASS/FAIL
- DNS Resolution: PASS/FAIL
- IP Addresses Found: PASS/FAIL
- DNS Server Response: PASS/FAIL

**Failure Conditions:**
- dig/nslookup not installed
- DNS resolution failed
- No IP addresses found
- DNS server timeout

## Running Tests

### Ping Test
```bash
cd /path/to/ansible
ansible-playbook playbooks/base/ping_test.yml
```

### SSH Test (Cisco)
```bash
ansible-playbook -i inventories/cisco.ini playbooks/cisco/ssh_test.yml
```

### Curl Test
```bash
ansible-playbook playbooks/system/curl_test.yml
```

### DNS Test
```bash
ansible-playbook playbooks/system/dns_test.yml
```

## Viewing Results

### Latest Results
```bash
# Latest ping test
ls -t actionlog/base/ping_test/*.txt | head -1 | xargs cat

# Latest SSH test
ls -t actionlog/cisco/ssh_test/*.txt | head -1 | xargs cat

# Latest curl test
ls -t actionlog/system/curl_test/*.txt | head -1 | xargs cat

# Latest DNS test
ls -t actionlog/system/dns_test/*.txt | head -1 | xargs cat
```

### All Results
```bash
# List all ping test results
ls -lth actionlog/base/ping_test/

# List all SSH test results
ls -lth actionlog/cisco/ssh_test/

# List all curl test results
ls -lth actionlog/system/curl_test/
```

## Actionlog File Format

Each actionlog file contains:
1. **Header** - Test name and date
2. **Configuration** - Test parameters and settings
3. **Status** - Overall SUCCESS/FAILURE
4. **Results** - Detailed test output
5. **Validation** - PASS/FAIL for each check
6. **Full Output** - Complete command/response data

## Example Actionlog Content

```
============================================
PING TEST RESULTS
============================================
Test Date: 2026-01-22T22:37:03-06:00
Target Host: 8.8.8.8
Ping Count: 4

STATUS: SUCCESS
MESSAGE: All packets received

Packet Loss: 0%
Packets Transmitted: 4
Packets Received: 4

FULL OUTPUT:
[Complete ping output...]

============================================
VALIDATION:
- Packet loss < 100%: PASS
- Packets received > 0: PASS
============================================
```
