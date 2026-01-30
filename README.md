# AGAnsible Suite

A comprehensive Ansible automation suite for network and system testing, auditing, and validation with complete WSL environment setup.

## 📋 Table of Contents

- [Overview](#overview)
- [Prerequisites](#prerequisites)
- [Complete Setup Guide](#complete-setup-guide)
  - [Step 1: WSL2 Environment Setup (Windows Users)](#step-1-wsl2-environment-setup-windows-users)
  - [Step 2: Clone Repository](#step-2-clone-repository)
  - [Step 3: Install AGAnsible Suite](#step-3-install-agansible-suite)
  - [Step 4: Verify Installation](#step-4-verify-installation)
- [Quick Start](#quick-start)
- [Project Structure](#project-structure)
- [The Trinity of Ansible](#the-trinity-of-ansible)
- [Playbook Categories](#playbook-categories)
- [Usage Examples](#usage-examples)
- [Actionlog System](#actionlog-system)
- [Testing](#testing)
- [Configuration](#configuration)
- [Troubleshooting](#troubleshooting)
- [Adding New Playbooks](#adding-new-playbooks)
- [Security Notes](#security-notes)
- [Additional Resources](#additional-resources)
- [Verification Checklist](#verification-checklist)

<a id="overview"></a>
## 🎯 Overview

The AGAnsible suite provides:
- **Complete WSL environment setup** - Automated setup from scratch
- **Organized playbook structure** - Categorized by type (base, cisco, system)
- **Comprehensive validation** - Success/failure detection for all tests
- **Automatic logging** - Detailed actionlog files for every execution
- **Ready-to-use playbooks** - Network, system, and connectivity tests
- **Full documentation** - Complete guides for setup and usage (see **[docs/HowTo.md](docs/HowTo.md)** for a full walkthrough)

<a id="prerequisites"></a>
## 📦 Prerequisites

### System Requirements
- **Windows 10/11** (for WSL2) or **Linux** system
- **Administrator access** (for WSL installation on Windows)
- **Internet connectivity** (for downloads and testing)
- **sudo access** (for package installation in WSL/Linux)

### What You'll Get
The installation automatically provides:
- **Python 3.6+** - Runtime environment
- **Ansible 2.9+** - Automation framework
- **curl** - HTTP client for web testing
- **dnsutils** - DNS utilities for DNS testing
- **git** - Version control system

All dependencies are installed automatically. No manual configuration needed.

<a id="complete-setup-guide"></a>
## 🚀 Complete Setup Guide

Follow these steps in order for a complete setup from scratch.

<a id="step-1-wsl2-environment-setup-windows-users"></a>
### Step 1: WSL2 Environment Setup (Windows Users)

**If you're on Windows**, you need to set up WSL2 first. **If you're already on Linux**, skip to Step 2.

#### Install WSL2

1. **Open PowerShell as Administrator**:
   - Press `Win + X`
   - Select "Windows PowerShell (Admin)" or "Terminal (Admin)"

2. **Install WSL2**:
   ```powershell
   wsl --install
   ```

   Or install a specific distribution:
   ```powershell
   wsl --install -d Ubuntu
   # or
   wsl --install -d Debian
   ```

3. **Restart Windows** when prompted

4. **Launch WSL**:
   - Open WSL from Start Menu, or
   - Run `wsl` from PowerShell/Command Prompt

5. **Complete Initial Setup**:
   - Create a username (when prompted)
   - Set a password (when prompted)
   - Update the system:
     ```bash
     sudo apt-get update
     sudo apt-get upgrade -y
     ```

**For detailed WSL setup instructions**, see **[docs/WSL_SETUP.md](docs/WSL_SETUP.md)**.

**Linux users**: If you're already on Linux, proceed to Step 2.

<a id="step-2-clone-repository"></a>
### Step 2: Clone Repository

Once WSL/Linux is ready:

```bash
# Navigate to home directory
cd ~

# Clone the repository
git clone https://github.com/JaredUbriaco/AGAnsible.git

# Navigate into the directory
cd AGAnsible
```

<a id="step-3-install-agansible-suite"></a>
### Step 3: Install AGAnsible Suite

The installation script installs **everything** needed:

```bash
# Make the script executable
chmod +x install.sh

# Run complete installation (you'll be prompted for sudo password)
./install.sh
```

**What gets installed:**
- ✅ Python3, pip3, python3-apt
- ✅ Ansible automation framework
- ✅ curl (for HTTP tests)
- ✅ dnsutils (for DNS tests)
- ✅ git (for version control)

The script verifies each installation automatically.

<a id="step-4-verify-installation"></a>
### Step 4: Verify Installation

```bash
# Run the verification script
./verify.sh
```

This checks:
- ✅ All tools are installed correctly
- ✅ Playbook structure is valid
- ✅ Configuration files are present
- ✅ Everything is ready to use

**Expected output**: All checks should show ✅ (green checkmarks)

<a id="quick-start"></a>
## 🏃 Quick Start

After installation, you can immediately run tests:

### Run All Tests
```bash
./test_all.sh
```

### Individual Playbook Tests

**Ping Test** (Basic connectivity):
```bash
ansible-playbook playbooks/base/ping_test.yml
```

**Curl Test** (HTTP connectivity):
```bash
ansible-playbook playbooks/system/curl_test.yml
```

**DNS Test** (DNS resolution):
```bash
ansible-playbook playbooks/system/dns_test.yml
```

**SSH Test** (Cisco devices - requires configuration):
```bash
ansible-playbook -i inventories/cisco.ini playbooks/cisco/ssh_test.yml
```

<a id="project-structure"></a>
## 📁 Project Structure

```
AGAnsible/
├── README.md                    # This file - main documentation
├── docs/                        # Long-form documentation
│   ├── HowTo.md                 # Full verbose how-to walkthrough
│   ├── VAULT.md                 # Ansible Vault usage and setup
│   ├── WSL_SETUP.md             # WSL setup guide (Windows)
│   └── REQUIREMENTS.md          # System requirements and dependencies
├── vault/                       # Vault template (vault.example.yml, VAULT_README.md)
├── install.sh                   # Installation script
├── verify.sh                    # Verification script
├── test_all.sh                  # Test all playbooks
├── test_localhost.sh            # Test localhost-capable playbooks only
├── menu.sh                      # Interactive menu (pick one playbook or test suite)
├── agansible                    # CLI wrapper (install, verify, menu, test, vault)
├── ansible.cfg                  # Ansible configuration
├── requirements.yml            # Ansible Galaxy collections
│
├── inventories/                 # WHERE: target hosts
│   ├── localhost.ini
│   └── example_*.ini            # Example inventories (Cisco, Juniper, etc.)
├── playbooks/                   # WHAT: tasks and automation
│   ├── base/                    # Agnostic (ping, etc.)
│   ├── cisco/                   # Cisco-specific
│   ├── system/                  # System tests (curl, dns, port_scan, ...)
│   ├── network/                 # Network protocols (BGP, OSPF, MPLS, ...)
│   ├── multi-vendor/            # Multi-vendor playbooks
│   ├── topology/                # Topology discovery
│   └── templates/               # Playbook template
├── roles/                       # Reusable roles (common, validation)
├── group_vars/                  # Group variables
├── library/                     # Custom Ansible modules (e.g. network_topology.py)
├── schemas/                     # JSON schemas for actionlog validation
├── scripts/                     # Lint, actionlog helpers, topology viz
│
└── actionlog/                   # Test results and logs (auto-created, mirrors playbooks/)
    ├── base/
    ├── cisco/
    ├── system/
    └── ...
```

**Organization:** Root keeps the main entry points (README, install/verify/test scripts, `agansible`, config). Long-form docs live in **docs/** so the root stays scannable. **Playbooks** are grouped by purpose (base, cisco, system, network, etc.). **actionlog/** mirrors the playbook layout for run output; **scripts/**, **schemas/**, and **library/** hold tooling and custom modules.

<a id="the-trinity-of-ansible"></a>
## 🔺 The Trinity of Ansible

Ansible operates on three fundamental components:

### 1. **Inventory** (`inventories/`) - WHERE
Defines **WHERE** to run tasks - the target hosts/systems.

**Example:**
```ini
[local]
localhost ansible_connection=local ansible_python_interpreter=/usr/bin/python3

[cisco-routers]
router1 ansible_host=10.0.0.1 ansible_connection=network_cli
```

### 2. **Playbooks** (`playbooks/`) - WHAT
Defines **WHAT** to do - YAML files containing tasks and plays.

**Example:**
```yaml
- name: Ping test
  hosts: all
  tasks:
    - name: Ping 8.8.8.8
      command: ping -c 4 8.8.8.8
```

### 3. **Modules** - HOW
Defines **HOW** to do it - the tools/commands that execute actions.

**How They Work Together:**
```
Inventory → Playbook → Modules → Execution
   (WHERE)    (WHAT)     (HOW)      (RESULT)
```

<a id="playbook-categories"></a>
## 📂 Playbook Categories

### `base/` - Agnostic Playbooks
- **Purpose**: Work on **any** system (Linux, Windows, network devices)
- **Examples**: Ping tests, basic connectivity checks
- **No vendor-specific requirements**
- **Current playbooks**: `ping_test.yml`

### `cisco/` - Cisco-Specific Playbooks
- **Purpose**: Require Cisco devices or Cisco modules
- **Examples**: SSH tests to Cisco devices, IOS configuration
- **Requires**: `ansible_connection=network_cli` or Cisco network collections
- **Current playbooks**: `ssh_test.yml`

### `system/` - System-Level Playbooks
- **Purpose**: Target operating system features
- **Examples**: Curl tests, DNS tests, port scan, network interfaces, SSL cert check
- **Requires**: Specific OS tools (curl, dnsutils, etc.)
- **Current playbooks**: `curl_test.yml`, `dns_test.yml`, `port_scan.yml`, `network_interfaces.yml`, `ssl_cert_check.yml`, `firewall_check.yml`, `network_stats.yml`, `traceroute_test.yml`

<a id="usage-examples"></a>
## 💡 Usage Examples

### Example 1: Ping Test
```bash
# Run ping test to Google DNS
ansible-playbook playbooks/base/ping_test.yml

# What it does:
# - Tests connectivity to 8.8.8.8
# - Validates packet loss and received packets
# - Creates actionlog file with results
# - Shows SUCCESS/FAILURE status
```

### Example 2: Curl Test
```bash
# Run curl test (tests HTTP connectivity)
ansible-playbook playbooks/system/curl_test.yml

# What it does:
# - Tests HTTP connectivity to httpbin.org and google.com
# - Validates HTTP status codes (200)
# - Creates actionlog file with results
# - Shows SUCCESS/FAILURE status
```

### Example 3: DNS Test
```bash
# Run DNS test (tests DNS resolution)
ansible-playbook playbooks/system/dns_test.yml

# What it does:
# - Resolves zappos.com using Cloudflare DNS (1.1.1.1)
# - Extracts and validates IP addresses
# - Creates actionlog file with results
# - Shows SUCCESS/FAILURE status
```

### Example 4: Custom Inventory
```bash
# Create custom inventory
cat > inventories/myhosts.ini << EOF
[webservers]
web1 ansible_host=192.168.1.10
web2 ansible_host=192.168.1.11
EOF

# Run playbook with custom inventory
ansible-playbook -i inventories/myhosts.ini playbooks/base/ping_test.yml
```

<a id="actionlog-system"></a>
## 📊 Actionlog System

All run output lives under `actionlog/`:

- **Playbook results** (one file per run): `actionlog/<category>/<playbook>/` (e.g. `actionlog/base/ping_test/`, `actionlog/system/curl_test/`). Created when you run a playbook (from the menu, CLI, or test scripts).
- **Suite run logs** (from `./test_all.sh` or `./test_localhost.sh`): `actionlog/test_suite/all/` or `actionlog/test_suite/localhost/` — one `.log` per test in that run.
- **Script summaries**: `actionlog/scripts/` (e.g. verify, install, test-suite summary).

See **actionlog/ACTIONLOG_README.md** for the full directory tree and labels.

### Viewing Results

```bash
# View latest ping test result
ls -t actionlog/base/ping_test/*.txt | head -1 | xargs cat

# View latest curl test result
ls -t actionlog/system/curl_test/*.txt | head -1 | xargs cat

# View latest DNS test result
ls -t actionlog/system/dns_test/*.txt | head -1 | xargs cat

# List all test results
ls -lth actionlog/base/ping_test/
```

### Actionlog File Format

Each file contains:
- **Test Date/Time**: Timestamp of execution
- **Status**: SUCCESS or FAILURE
- **Configuration**: Test parameters
- **Results**: Detailed output
- **Validation**: PASS/FAIL for each check
- **Full Output**: Complete command/response data

<a id="testing"></a>
## 🧪 Testing

### Quick Test Suite

#### Run All Tests (Including Network Device Tests)
```bash
./test_all.sh
```

This will:
- Run all available playbooks (including those requiring network devices)
- Show pass/fail status for each
- Display summary of results
- List created actionlog files

#### Run Localhost Tests Only (Recommended for Quick Validation)
```bash
./test_localhost.sh
```

This will:
- Run only localhost-capable tests (no network devices required)
- Test 9 fully implemented localhost playbooks
- Show pass/fail status for each
- Display summary of results
- List created actionlog files

**Options:**
```bash
./test_localhost.sh --verbose    # Show detailed output
./test_localhost.sh --json      # Generate JSON actionlog files
./test_localhost.sh --both      # Generate both text and JSON files
```

**Expected output:**
```
✅ PASS - Ping Test
✅ PASS - Curl Test
✅ PASS - DNS Test
✅ PASS - Port Scan
✅ PASS - Network Interfaces
✅ PASS - SSL Certificate Check
✅ PASS - Firewall Rules Check
✅ PASS - Network Statistics
✅ PASS - Traceroute Test

Tests Run: 9
Passed: 9
Failed: 0
```

**Note**: `test_localhost.sh` is recommended for quick validation as it only tests playbooks that can run on localhost without requiring network devices or remote infrastructure.

### Interactive menu (pick one option)

To run a single playbook (e.g. ping test) or a test suite without memorizing commands:

```bash
./menu.sh
# or
agansible menu
```

You get a numbered menu: run one playbook, run all localhost tests, run all tests, or verify. In this project, **each test is an Ansible playbook** (a YAML file that runs tasks); the menu lists them so you can choose by number.

### Individual Playbook Tests

```bash
# Test ping
ansible-playbook playbooks/base/ping_test.yml

# Test curl
ansible-playbook playbooks/system/curl_test.yml

# Test DNS
ansible-playbook playbooks/system/dns_test.yml
```

<a id="configuration"></a>
## 🔧 Configuration

### Ansible Configuration (`ansible.cfg`)

Key settings:
- `inventory = inventories/localhost.ini` - Default inventory
- `host_key_checking = False` - Skip SSH host key checking
- `forks = 1` - Run one task at a time (avoids multiprocessing issues)
- `interpreter_python = auto_silent` - Auto-detect Python

### Customizing Inventories

Edit `inventories/localhost.ini` or create new inventory files:

```ini
[local]
localhost ansible_connection=local

[remote]
server1 ansible_host=192.168.1.10 ansible_user=admin
server2 ansible_host=192.168.1.11 ansible_user=admin

[all:vars]
ansible_python_interpreter=/usr/bin/python3
```

<a id="troubleshooting"></a>
## 🐛 Troubleshooting

### Issue: "WSL not installed" or "wsl: command not found"
**Solution:**
- Ensure you're running PowerShell as Administrator
- Use: `wsl --install`
- Restart Windows after installation
- See [docs/WSL_SETUP.md](docs/WSL_SETUP.md) for detailed instructions

### Issue: "Ansible not found"
**Solution:**
```bash
# Verify installation
which ansible
ansible --version

# Reinstall if needed
./install.sh
# or manually:
sudo pip3 install --break-system-packages ansible
```

### Issue: "Permission denied" errors
**Solution:**
```bash
# Ensure you have sudo access
sudo -v

# Check file permissions
chmod +x install.sh verify.sh test_all.sh test_localhost.sh menu.sh

# Fix actionlog permissions if needed
sudo chown -R $USER:$USER actionlog/
chmod -R 755 actionlog/
```

### Issue: "curl is not installed" or "dig: command not found"
**Solution:**
```bash
# Re-run installation script (installs everything)
./install.sh

# Or install manually:
sudo apt-get install -y curl dnsutils
```

### Issue: "Unable to use multiprocessing"
**Solution:**
- Already configured in `ansible.cfg` with `forks = 1`
- If issue persists, add `--forks 1` to command:
```bash
ansible-playbook --forks 1 playbooks/base/ping_test.yml
```

### Issue: "Python not found"
**Solution:**
```bash
# Re-run installation script
./install.sh

# Or install manually:
sudo apt-get update
sudo apt-get install -y python3 python3-pip
```

### Issue: Network connectivity problems
**Solution:**
```bash
# Test basic connectivity
ping -c 4 8.8.8.8

# Test DNS
nslookup google.com

# If WSL network issues, restart WSL from Windows:
# PowerShell: wsl --shutdown
# Then restart WSL
```

<a id="adding-new-playbooks"></a>
## 📝 Adding New Playbooks

### Step 1: Create Playbook File
```bash
# Create in appropriate category
vim playbooks/base/my_test.yml
# or
vim playbooks/system/my_test.yml
```

### Step 2: Add Validation and Logging
Use existing playbooks as templates. Include:
- Actionlog directory creation
- Test execution with `failed_when: false`
- Validation logic
- Result logging to actionlog
- Success/failure handling

### Step 3: Create Actionlog Directory
```bash
mkdir -p actionlog/category/my_test
```

### Step 4: Test
```bash
ansible-playbook playbooks/category/my_test.yml
```

<a id="security-notes"></a>
## 🔐 Security Notes

- **Passwords**: Never commit passwords or secrets to git
- **Credentials**: Store in encrypted vault files; see **[docs/VAULT.md](docs/VAULT.md)** for Ansible Vault setup
- **SSH Keys**: Use SSH keys instead of passwords when possible
- **Inventory**: Don't commit production inventories with sensitive data

<a id="additional-resources"></a>
## 📚 Additional Resources

### Documentation Files
- **[docs/HowTo.md](docs/HowTo.md)** - Full verbose how-to: setup, run tests, review results (start here for a complete walkthrough)
- **[docs/WSL_SETUP.md](docs/WSL_SETUP.md)** - Complete WSL2 setup guide (Windows users)
- **[docs/REQUIREMENTS.md](docs/REQUIREMENTS.md)** - System requirements and dependencies
- **[docs/VAULT.md](docs/VAULT.md)** - Ansible Vault setup and usage for secrets

**Optional:** Use the `agansible` CLI: `agansible install`, `agansible verify`, `agansible menu` (interactive pick-one menu), `agansible test`, `agansible vault` (run `agansible help`). To lint playbooks: `./scripts/lint.sh` or `pre-commit install` then `pre-commit run`.

### External Resources
- [Ansible Documentation](https://docs.ansible.com/)
- [Ansible Best Practices](https://docs.ansible.com/ansible/latest/user_guide/playbooks_best_practices.html)
- [Ansible Network Modules](https://docs.ansible.com/ansible/latest/network/index.html)
- [WSL Documentation](https://docs.microsoft.com/en-us/windows/wsl/)

<a id="verification-checklist"></a>
## ✅ Verification Checklist

After installation, verify:
- [ ] WSL2 installed and working (Windows users)
- [ ] `./install.sh` completed without errors
- [ ] `./verify.sh` shows all checks passing
- [ ] `ansible --version` works
- [ ] `ansible-playbook playbooks/base/ping_test.yml` succeeds
- [ ] Actionlog files are created in `actionlog/` directories
- [ ] All validations show PASS in actionlog files
- [ ] `./test_all.sh` runs successfully (or `./test_localhost.sh` for localhost-only tests)

---

**Last Updated**: January 2026  
**Tested On**: WSL2 Debian 13 (Trixie), Ubuntu 22.04  
**Repository**: https://github.com/JaredUbriaco/AGAnsible
