# Actionlog Directory

This directory holds **all run output**: per-playbook results, test-suite run logs, and script summaries. Everything is under `actionlog/` so you have one place to look.

## How it’s organized

| What ran | Where output goes | What you see |
|----------|-------------------|--------------|
| **One playbook** (e.g. from menu or `ansible-playbook playbooks/base/ping_test.yml`) | `actionlog/<category>/<playbook>/` | One result file per run (e.g. `ping_test_localhost_2026-01-28....txt` or `.json`) |
| **All localhost tests** (`./test_localhost.sh`) | Suite logs: `actionlog/test_suite/localhost/` | One `.log` per test in that run; playbook results still in `actionlog/base/`, `actionlog/system/`, etc. |
| **All tests** (`./test_all.sh`) | Suite logs: `actionlog/test_suite/all/` | Same idea: per-test `.log` files for that run; playbook results in category folders |
| **Script summaries** (verify, install, test suite summary) | `actionlog/scripts/` | Text summaries (e.g. `localhost_tests_*.txt`, `test_suite_*.txt`) |

So: **playbook results** live under **category folders** (`base/`, `system/`, `cisco/`, etc.). **Suite run logs** (from `test_all.sh` or `test_localhost.sh`) live under **test_suite/all/** or **test_suite/localhost/**.

## Directory structure

```
actionlog/
├── README.md                 # This file
│
├── test_suite/               # Logs from running the test scripts (test_all.sh / test_localhost.sh)
│   ├── all/                  # Run ./test_all.sh  → per-test .log files here
│   └── localhost/            # Run ./test_localhost.sh  → per-test .log files here
│
├── scripts/                  # Summaries from install.sh, verify.sh, test_*.sh
│   └── *.txt                 # e.g. localhost_tests_<timestamp>.txt, test_suite_<timestamp>.txt
│
├── base/                     # Results from playbooks in playbooks/base/
│   └── ping_test/            # ping_test_localhost_<timestamp>.{txt,json}
│
├── system/                   # Results from playbooks in playbooks/system/
│   ├── curl_test/
│   ├── dns_test/
│   ├── port_scan/
│   ├── network_interfaces/
│   ├── ssl_cert_check/
│   ├── firewall_check/
│   ├── network_stats/
│   └── traceroute_test/
│
├── cisco/                    # Results from playbooks in playbooks/cisco/
│   └── ssh_test/
│
├── network/                  # Results from playbooks in playbooks/network/
│   ├── bgp_status/
│   ├── ospf_status/
│   ├── mpls_lsp/
│   └── performance_test/
│
├── multi-vendor/
│   └── config_backup/
│
└── topology/
    └── discover_topology/
```

## Terminology

- **Playbook** = one YAML file (e.g. `playbooks/base/ping_test.yml`) that runs a set of tasks. In this project, each “test” is a playbook.
- **Test run** = one execution of a playbook; it produces one result file under `actionlog/<category>/<playbook>/`.
- **Suite run** = running `test_all.sh` or `test_localhost.sh`; it produces logs under `actionlog/test_suite/all/` or `test_suite/localhost/` plus playbook results in the category folders.

## File naming (playbook results)

- Pattern: `{playbook_name}_{hostname}_{timestamp}.{txt|json}`
- Examples: `ping_test_localhost_2026-01-28T20-00-29-06-00.txt`, `curl_test_localhost_...json`

## Viewing results

```bash
# Latest ping test result (from any run: menu, test_localhost, or test_all)
ls -t actionlog/base/ping_test/*.{txt,json} 2>/dev/null | head -1 | xargs cat

# Latest suite run logs (localhost tests)
ls -t actionlog/test_suite/localhost/*.log 2>/dev/null | head -5

# Latest suite run logs (all tests)
ls -t actionlog/test_suite/all/*.log 2>/dev/null | head -5
```

## Output formats

Playbook result files can be:

- **Text (default)** – `.txt`, human-readable
- **JSON** – `.json`, e.g. when you pass `-e output_format=json` or use `test_localhost.sh --json`

Both formats use the same structure (test name, timestamp, status, metrics, validation). JSON can be validated with the schemas in `schemas/`.
