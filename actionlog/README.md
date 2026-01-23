# Actionlog Directory

This directory contains test results and logs for all Ansible playbook executions.

## Structure

```
actionlog/
├── base/              # Agnostic test results
│   └── ping_test/    # Ping test results
│
├── cisco/            # Cisco-specific test results
│   └── ssh_test/     # SSH connectivity test results
│
└── system/           # System-level test results
    └── curl_test/    # Curl/HTTP test results
```

## File Naming Convention

- **Ping Test**: `ping_test_<timestamp>.txt`
- **SSH Test**: `ssh_test_<hostname>_<timestamp>.txt`
- **Curl Test**: `curl_test_<hostname>_<timestamp>.txt`

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
ls -t actionlog/base/ping_test/ | head -1 | xargs cat

# Latest SSH test
ls -t actionlog/cisco/ssh_test/ | head -1 | xargs cat

# Latest curl test
ls -t actionlog/system/curl_test/ | head -1 | xargs cat
```
