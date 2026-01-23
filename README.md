# Ansible Playbook Collection

A comprehensive Ansible setup for network and system testing with validation, logging, and organized playbook structure.

## 📋 Table of Contents

- [Overview](#overview)
- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [Project Structure](#project-structure)
- [The Trinity of Ansible](#the-trinity-of-ansible)
- [Quick Start](#quick-start)
- [Playbook Categories](#playbook-categories)
- [Usage Examples](#usage-examples)
- [Actionlog System](#actionlog-system)
- [Troubleshooting](#troubleshooting)

## 🎯 Overview

This repository contains a well-organized Ansible setup with:
- **Organized playbook structure** by category (base, cisco, system)
- **Comprehensive validation** for all tests
- **Automatic logging** to actionlog directories
- **Success/failure detection** with clear error messages
- **Ready-to-use examples** for common testing scenarios

## 📦 Prerequisites

### System Requirements
- **WSL2** (Windows Subsystem for Linux 2) or Linux system
- **Debian/Ubuntu** based distribution (or compatible package manager)
- **sudo access** for package installation
- **Internet connectivity** for downloading packages and testing

### Required Software (All Installed Automatically)
- **Python 3.6+** - Runtime environment
- **pip3** - Python package manager
- **Ansible 2.9+** - Automation framework
- **curl** - HTTP client (for curl_test.yml)
- **dnsutils** - DNS utilities (for dns_test.yml)
- **git** - Version control system

All dependencies are installed automatically by `install.sh`. No manual installation needed.

## 🚀 Installation

### For Complete WSL Setup
See **[WSL_SETUP.md](WSL_SETUP.md)** for complete WSL2 environment setup from scratch.

### Step 1: Clone or Download Repository

```bash
# If using git
git clone <repository-url>
cd ansible

# Or extract downloaded archive
cd ansible
```

### Step 2: Run Complete Installation Script

The installation script installs **everything** needed:
- Python3, pip3, python3-apt
- Ansible
- curl (for HTTP tests)
- dnsutils (for DNS tests)
- git (for version control)

```bash
# Make script executable
chmod +x install.sh

# Run complete installation (requires sudo password)
./install.sh
```

This single command installs all dependencies. No additional steps needed.

**Manual installation (not recommended):**

```bash
# Update package lists
sudo apt-get update

# Install Python3 and pip
sudo apt-get install -y python3 python3-pip python3-apt

# Install Ansible
sudo pip3 install --break-system-packages ansible

# Verify installation
ansible --version
```

### Step 3: Verify Installation

```bash
# Check Ansible version
ansible --version

# Test with ping playbook
cd /path/to/ansible
ansible-playbook playbooks/base/ping_test.yml
```

## 📁 Project Structure

```
ansible/
├── README.md                    # This file
├── QUICK_START.md               # Quick reference guide
├── VALIDATION_GUIDE.md          # Validation and testing guide
├── install.sh                   # Installation script
├── ansible.cfg                   # Ansible configuration
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
├── roles/                       # Reusable Ansible roles
├── group_vars/                  # Variables for inventory groups
├── host_vars/                   # Host-specific variables
│
└── actionlog/                   # Test results and logs
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

## 🏃 Quick Start

### Run a Ping Test (Agnostic)
```bash
cd /path/to/ansible
ansible-playbook playbooks/base/ping_test.yml
```

### Run a Curl Test (System)
```bash
ansible-playbook playbooks/system/curl_test.yml
```

### Run a DNS Test (System)
```bash
ansible-playbook playbooks/system/dns_test.yml
```

### Run SSH Test (Cisco - requires device)
```bash
ansible-playbook -i inventories/cisco.ini playbooks/cisco/ssh_test.yml
```

## 📂 Playbook Categories

### `base/` - Agnostic Playbooks
- **Purpose**: Work on **any** system (Linux, Windows, network devices)
- **Examples**: Ping tests, basic connectivity checks
- **No vendor-specific requirements**

### `cisco/` - Cisco-Specific Playbooks
- **Purpose**: Require Cisco devices or Cisco modules
- **Examples**: SSH tests to Cisco devices, IOS configuration
- **Requires**: `ansible_connection=network_cli` or Cisco network collections

### `system/` - System-Level Playbooks
- **Purpose**: Target operating system features
- **Examples**: Curl tests, service management, file operations
- **May require**: Specific OS tools (curl, systemd, etc.)

## 💡 Usage Examples

### Example 1: Ping Test
```bash
# Run ping test to Google DNS
ansible-playbook playbooks/base/ping_test.yml

# Output:
# - Tests connectivity to 8.8.8.8
# - Validates packet loss and received packets
# - Creates actionlog file with results
```

### Example 2: Curl Test
```bash
# Run curl test (requires curl installed)
ansible-playbook playbooks/system/curl_test.yml

# Output:
# - Tests HTTP connectivity to multiple URLs
# - Validates HTTP status codes
# - Creates actionlog file with results
```

### Example 3: Custom Inventory
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
├── base/ping_test/          # Ping test results
├── cisco/ssh_test/          # SSH test results
└── system/curl_test/       # Curl test results
```

### Viewing Results

```bash
# View latest ping test result
ls -t actionlog/base/ping_test/*.txt | head -1 | xargs cat

# View latest curl test result
ls -t actionlog/system/curl_test/*.txt | head -1 | xargs cat

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

### Issue: "Ansible not found"
**Solution:**
```bash
# Verify installation
which ansible
ansible --version

# Reinstall if needed
sudo pip3 install --break-system-packages ansible
```

### Issue: "Permission denied" errors
**Solution:**
```bash
# Ensure you have sudo access
sudo -v

# Check file permissions
ls -la ansible.cfg
```

### Issue: "curl is not installed"
**Solution:**
```bash
# Install curl
sudo apt-get update
sudo apt-get install -y curl
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
# Install Python3
sudo apt-get update
sudo apt-get install -y python3 python3-pip
```

## 📝 Adding New Playbooks

### Step 1: Create Playbook File
```bash
# Create in appropriate category
vim playbooks/base/my_test.yml
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
mkdir -p actionlog/base/my_test
```

### Step 4: Test
```bash
ansible-playbook playbooks/base/my_test.yml
```

## 🔐 Security Notes

- **Passwords**: Never commit passwords or secrets to git
- **Credentials**: Store in `group_vars/` or `host_vars/` (add to `.gitignore`)
- **SSH Keys**: Use SSH keys instead of passwords when possible
- **Inventory**: Don't commit production inventories with sensitive data

## 📚 Additional Resources

- [Ansible Documentation](https://docs.ansible.com/)
- [Ansible Best Practices](https://docs.ansible.com/ansible/latest/user_guide/playbooks_best_practices.html)
- [Ansible Network Modules](https://docs.ansible.com/ansible/latest/network/index.html)

## 📄 License

This project is provided as-is for educational and testing purposes.

## 🤝 Contributing

When adding new playbooks:
1. Follow the existing structure
2. Include validation and logging
3. Update this README if adding new categories
4. Test on clean WSL installation

## ✅ Verification Checklist

After installation, verify:
- [ ] `ansible --version` works
- [ ] `ansible-playbook playbooks/base/ping_test.yml` succeeds
- [ ] Actionlog files are created in `actionlog/base/ping_test/`
- [ ] All validations show PASS in actionlog files

---

**Last Updated**: January 2026
**Tested On**: WSL2 Debian 13 (Trixie)
