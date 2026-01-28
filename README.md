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
- [Additional Resources](#additional-resources)

## 🎯 Overview

The AGAnsible suite provides:
- **Complete WSL environment setup** - Automated setup from scratch
- **Organized playbook structure** - Categorized by type (base, cisco, system)
- **Comprehensive validation** - Success/failure detection for all tests
- **Automatic logging** - Detailed actionlog files for every execution
- **Ready-to-use playbooks** - Network, system, and connectivity tests
- **Full documentation** - Complete guides for setup and usage

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

## 🚀 Complete Setup Guide

Follow these steps in order for a complete setup from scratch.

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

**For detailed WSL setup instructions**, see **[WSL_SETUP.md](WSL_SETUP.md)**.

**Linux users**: If you're already on Linux, proceed to Step 2.

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

## 📁 Project Structure

```
AGAnsible/
├── README.md                    # This file - main documentation
├── WSL_SETUP.md                 # Complete WSL setup guide
├── QUICK_START.md               # Quick reference
├── QUICK_TEST.md                # Quick testing guide
├── TESTING_CHECKLIST.md         # Comprehensive testing checklist
├── REQUIREMENTS.md              # System requirements
├── COMPLETE_DEPENDENCIES.md     # Complete dependency list
├── install.sh                   # Complete installation script
├── verify.sh                    # Verification script
├── test_all.sh                  # Test all playbooks
├── ansible.cfg                  # Ansible configuration
│
├── inventories/                 # The Trinity #1: WHERE (target hosts)
│   └── localhost.ini           # Localhost inventory
│
├── playbooks/                   # The Trinity #2: WHAT (tasks/automation)
│   ├── base/                   # Agnostic tests (work on any system)
│   │   └── ping_test.yml      # Ping connectivity test
│   ├── cisco/                  # Cisco-specific playbooks
│   │   └── ssh_test.yml       # SSH connectivity test
│   └── system/                 # System-level tests
│       ├── curl_test.yml      # HTTP/curl test
│       └── dns_test.yml       # DNS resolution test
│
├── roles/                       # Reusable Ansible roles (for future use)
├── group_vars/                  # Variables for inventory groups
├── host_vars/                   # Host-specific variables
│
└── actionlog/                   # Test results and logs (auto-created)
    ├── base/
    │   └── ping_test/          # Ping test results
    ├── cisco/
    │   └── ssh_test/           # SSH test results
    └── system/
        ├── curl_test/          # Curl test results
        └── dns_test/           # DNS test results
```

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
- **Examples**: Curl tests, DNS tests, service management
- **Requires**: Specific OS tools (curl, dnsutils, etc.)
- **Current playbooks**: `curl_test.yml`, `dns_test.yml`

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

## 📊 Actionlog System

All playbook executions automatically create detailed log files in the `actionlog/` directory.

### Structure
```
actionlog/
├── base/
│   └── ping_test/          # Ping test results
├── cisco/
│   └── ssh_test/           # SSH test results
└── system/
    ├── curl_test/          # Curl test results
    └── dns_test/           # DNS test results
```

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

## 🧪 Testing

### Quick Test Suite

Run all playbooks at once:
```bash
./test_all.sh
```

This will:
- Run all available playbooks
- Show pass/fail status for each
- Display summary of results
- List created actionlog files

**Expected output:**
```
✅ PASS - Ping Test
✅ PASS - Curl Test
✅ PASS - DNS Test

Tests Run: 3
Passed: 3
Failed: 0
```

### Individual Playbook Tests

```bash
# Test ping
ansible-playbook playbooks/base/ping_test.yml

# Test curl
ansible-playbook playbooks/system/curl_test.yml

# Test DNS
ansible-playbook playbooks/system/dns_test.yml
```

### Testing Resources

- **[TESTING_CHECKLIST.md](TESTING_CHECKLIST.md)** - Complete testing checklist
- **[QUICK_TEST.md](QUICK_TEST.md)** - Quick testing guide

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

## 🐛 Troubleshooting

### Issue: "WSL not installed" or "wsl: command not found"
**Solution:**
- Ensure you're running PowerShell as Administrator
- Use: `wsl --install`
- Restart Windows after installation
- See [WSL_SETUP.md](WSL_SETUP.md) for detailed instructions

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
chmod +x install.sh verify.sh test_all.sh

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

## 🔐 Security Notes

- **Passwords**: Never commit passwords or secrets to git
- **Credentials**: Store in `group_vars/` or `host_vars/` (add to `.gitignore`)
- **SSH Keys**: Use SSH keys instead of passwords when possible
- **Inventory**: Don't commit production inventories with sensitive data

## 📚 Additional Resources

### Documentation Files
- **[WSL_SETUP.md](WSL_SETUP.md)** - Complete WSL2 setup guide
- **[REQUIREMENTS.md](REQUIREMENTS.md)** - System requirements and dependencies
- **[COMPLETE_DEPENDENCIES.md](COMPLETE_DEPENDENCIES.md)** - Detailed dependency list
- **[TESTING_CHECKLIST.md](TESTING_CHECKLIST.md)** - Comprehensive testing guide
- **[QUICK_START.md](QUICK_START.md)** - Quick reference guide
- **[QUICK_TEST.md](QUICK_TEST.md)** - Quick testing guide

### External Resources
- [Ansible Documentation](https://docs.ansible.com/)
- [Ansible Best Practices](https://docs.ansible.com/ansible/latest/user_guide/playbooks_best_practices.html)
- [Ansible Network Modules](https://docs.ansible.com/ansible/latest/network/index.html)
- [WSL Documentation](https://docs.microsoft.com/en-us/windows/wsl/)

## ✅ Verification Checklist

After installation, verify:
- [ ] WSL2 installed and working (Windows users)
- [ ] `./install.sh` completed without errors
- [ ] `./verify.sh` shows all checks passing
- [ ] `ansible --version` works
- [ ] `ansible-playbook playbooks/base/ping_test.yml` succeeds
- [ ] Actionlog files are created in `actionlog/` directories
- [ ] All validations show PASS in actionlog files
- [ ] `./test_all.sh` runs successfully

---

**Last Updated**: January 2026  
**Tested On**: WSL2 Debian 13 (Trixie), Ubuntu 22.04  
**Repository**: https://github.com/JaredUbriaco/AGAnsible
