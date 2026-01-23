# Requirements and Dependencies

## System Requirements

### Operating System
- **WSL2** (Windows Subsystem for Linux 2) - Recommended
- **Linux** (Debian, Ubuntu, or compatible distribution)
- **macOS** (with Homebrew)
- **Windows** (via WSL2 only)

### Minimum Specifications
- **RAM**: 512 MB minimum (1 GB recommended)
- **Disk Space**: 500 MB for Ansible and dependencies
- **Network**: Internet connectivity for package installation and testing

## Software Dependencies

### Required (Installed Automatically)
- **Python 3.6+** - Core runtime
- **pip3** - Python package manager
- **Ansible 2.9+** - Automation framework

### Optional (For Specific Playbooks)
- **curl** - Required for `playbooks/system/curl_test.yml`
  ```bash
  sudo apt-get install -y curl
  ```

- **dnsutils** (dig/nslookup) - Required for `playbooks/system/dns_test.yml`
  ```bash
  sudo apt-get install -y dnsutils
  ```
  Note: On RHEL/CentOS, use: `sudo yum install -y bind-utils`

- **Cisco Network Collections** - Required for Cisco playbooks
  ```bash
  ansible-galaxy collection install cisco.ios
  ```

## Package Manager Compatibility

### Debian/Ubuntu (apt)
```bash
sudo apt-get update
sudo apt-get install -y python3 python3-pip python3-apt
```

### Red Hat/CentOS (yum/dnf)
```bash
sudo yum install -y python3 python3-pip
# or
sudo dnf install -y python3 python3-pip
```

### macOS (Homebrew)
```bash
brew install python3
pip3 install ansible
```

## Python Packages

### Core Ansible Packages
- `ansible-core` - Core Ansible engine
- `ansible` - Full Ansible package (includes collections)

### Additional Collections (Optional)
- `cisco.ios` - Cisco IOS modules
- `ansible.netcommon` - Network common modules
- `community.general` - General community modules

Install collections:
```bash
ansible-galaxy collection install cisco.ios
ansible-galaxy collection install ansible.netcommon
```

## Network Requirements

### Outbound Connectivity
- **HTTP/HTTPS** - For package downloads and URL testing
- **ICMP** - For ping tests (may require firewall rules)
- **SSH** - For remote host management (port 22)

### DNS Resolution
- Functional DNS resolution required
- Test with: `ping -c 1 8.8.8.8`

## Permissions

### Required Permissions
- **sudo access** - For package installation
- **File write access** - For actionlog directory
- **Network access** - For testing connectivity

### File Permissions
```bash
# Ensure playbooks are executable (not required, but good practice)
chmod +x install.sh

# Actionlog directories created automatically with correct permissions
```

## Verification

### Check Installation
```bash
# Python version
python3 --version
# Should show: Python 3.x.x

# pip version
pip3 --version
# Should show: pip x.x.x

# Ansible version
ansible --version
# Should show: ansible [core 2.x.x]
```

### Test Connectivity
```bash
# Test ping
ping -c 1 8.8.8.8

# Test curl (if installed)
curl -I https://www.google.com

# Test DNS
nslookup google.com
```

## Troubleshooting Dependencies

### Issue: "python3: command not found"
**Solution:**
```bash
sudo apt-get update
sudo apt-get install -y python3
```

### Issue: "pip3: command not found"
**Solution:**
```bash
sudo apt-get install -y python3-pip
```

### Issue: "externally-managed-environment" error
**Solution:**
Use `--break-system-packages` flag:
```bash
sudo pip3 install --break-system-packages ansible
```

### Issue: "curl: command not found"
**Solution:**
```bash
sudo apt-get install -y curl
```

### Issue: "dig: command not found" or "nslookup: command not found"
**Solution:**
```bash
# Debian/Ubuntu
sudo apt-get install -y dnsutils

# RHEL/CentOS
sudo yum install -y bind-utils
```

### Issue: "Permission denied" on actionlog
**Solution:**
```bash
# Fix permissions
sudo chown -R $USER:$USER actionlog/
chmod -R 755 actionlog/
```

## Version Compatibility

### Tested Versions
- **Python**: 3.11, 3.12, 3.13
- **Ansible**: 2.9+, 2.20+
- **WSL**: WSL2 on Windows 10/11
- **Debian**: 12 (Bookworm), 13 (Trixie)

### Known Compatibility
- ✅ Debian 12/13
- ✅ Ubuntu 20.04/22.04/24.04
- ✅ WSL2
- ⚠️  Older Python 3.6-3.8 may have limited module support

## Additional Tools (Optional)

### Development Tools
- **git** - For version control
- **vim/nano** - Text editors
- **tree** - Directory visualization
  ```bash
  sudo apt-get install -y tree
  ```

### Network Tools
- **nmap** - Network scanning
- **tcpdump** - Packet capture
- **wireshark** - Network analysis

## Environment Variables

### Optional Configuration
```bash
# Set Ansible config path
export ANSIBLE_CONFIG=/path/to/ansible/ansible.cfg

# Set inventory path
export ANSIBLE_INVENTORY=/path/to/ansible/inventories/localhost.ini

# Add to ~/.bashrc for persistence
echo 'export ANSIBLE_CONFIG=/path/to/ansible/ansible.cfg' >> ~/.bashrc
```
