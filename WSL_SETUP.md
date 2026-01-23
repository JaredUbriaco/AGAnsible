# Complete WSL Environment Setup Guide

Complete guide for setting up WSL2 and the AGAnsible suite from scratch.

## 🚀 Initial WSL2 Setup (Windows)

### Step 1: Install WSL2

On Windows PowerShell (as Administrator):
```powershell
wsl --install
```

Or for specific distribution:
```powershell
wsl --install -d Ubuntu
# or
wsl --install -d Debian
```

### Step 2: Restart Windows

After installation, restart your computer when prompted.

### Step 3: Launch WSL

- Open WSL from Start Menu, or
- Run `wsl` from PowerShell/Command Prompt

### Step 4: Complete WSL Initial Setup

On first launch:
1. Create a username (when prompted)
2. Set a password (when prompted)
3. Update the system:
   ```bash
   sudo apt-get update
   sudo apt-get upgrade -y
   ```

## 📦 AGAnsible Suite Installation

### Step 1: Clone Repository

```bash
cd ~
git clone https://github.com/JaredUbriaco/AGAnsible.git
cd AGAnsible
```

### Step 2: Run Complete Installation

```bash
chmod +x install.sh
./install.sh
```

This installs **everything** needed:
- ✅ Python3, pip3, python3-apt
- ✅ Ansible
- ✅ curl (for HTTP tests)
- ✅ dnsutils (for DNS tests)
- ✅ git (for version control)

### Step 3: Verify Installation

```bash
./verify.sh
```

### Step 4: Test Installation

```bash
# Test ping playbook
ansible-playbook playbooks/base/ping_test.yml

# Test curl playbook
ansible-playbook playbooks/system/curl_test.yml

# Test DNS playbook
ansible-playbook playbooks/system/dns_test.yml
```

## 📋 Complete Dependency List

### Core Requirements (Auto-Installed)
- **Python 3.6+** - Runtime environment
- **pip3** - Python package manager
- **python3-apt** - Python apt bindings
- **Ansible 2.9+** - Automation framework

### Network Tools (Auto-Installed)
- **curl** - HTTP client (required for curl_test.yml)
- **dnsutils** - DNS utilities including dig/nslookup (required for dns_test.yml)

### Development Tools (Auto-Installed)
- **git** - Version control system

## 🔧 System Configuration

### Sudo Access
Ensure your user has sudo access:
```bash
# Check sudo access
sudo -v

# If not configured, add user to sudo group (as root)
sudo usermod -aG sudo $USER
```

### Network Configuration
Ensure network connectivity:
```bash
# Test internet connectivity
ping -c 4 8.8.8.8

# Test DNS resolution
nslookup google.com

# Test HTTP connectivity
curl -I https://www.google.com
```

### File Permissions
```bash
# Ensure scripts are executable
chmod +x install.sh
chmod +x verify.sh
chmod +x install_optional_tools.sh

# Actionlog directories created automatically with correct permissions
```

## ✅ Verification Checklist

After installation, verify:

- [ ] Python3 installed: `python3 --version`
- [ ] pip3 installed: `pip3 --version`
- [ ] Ansible installed: `ansible --version`
- [ ] curl installed: `curl --version`
- [ ] dig installed: `dig -v`
- [ ] git installed: `git --version`
- [ ] Network connectivity works
- [ ] All playbooks can run

## 🧪 Testing All Playbooks

### Base Playbooks (Agnostic)
```bash
# Ping test
ansible-playbook playbooks/base/ping_test.yml
```

### System Playbooks
```bash
# Curl test
ansible-playbook playbooks/system/curl_test.yml

# DNS test
ansible-playbook playbooks/system/dns_test.yml
```

### Cisco Playbooks
```bash
# SSH test (requires Cisco device configuration)
ansible-playbook -i inventories/cisco.ini playbooks/cisco/ssh_test.yml
```

## 🔍 Troubleshooting

### Issue: "sudo: command not found"
**Solution:**
```bash
# Install sudo
apt-get update
apt-get install -y sudo

# Add user to sudo group (as root)
usermod -aG sudo $USER

# Log out and back in
```

### Issue: "apt-get: command not found"
**Solution:**
- Ensure you're in WSL, not Windows
- Verify you're using Debian/Ubuntu-based distribution

### Issue: Network connectivity problems
**Solution:**
```bash
# Check WSL network
ip addr show

# Restart WSL network (from Windows PowerShell)
wsl --shutdown
# Then restart WSL
```

### Issue: "Permission denied" errors
**Solution:**
```bash
# Fix script permissions
chmod +x *.sh

# Fix actionlog permissions
sudo chown -R $USER:$USER actionlog/
chmod -R 755 actionlog/
```

## 📚 Additional Resources

- [WSL Documentation](https://docs.microsoft.com/en-us/windows/wsl/)
- [Ansible Documentation](https://docs.ansible.com/)
- [Debian Package Management](https://www.debian.org/doc/manuals/debian-reference/ch02.en.html)

## 🎯 Quick Setup Summary

```bash
# 1. Install WSL2 (from Windows PowerShell as Admin)
wsl --install

# 2. Restart Windows, then launch WSL

# 3. Update system
sudo apt-get update && sudo apt-get upgrade -y

# 4. Clone and install AGAnsible
cd ~
git clone https://github.com/JaredUbriaco/AGAnsible.git
cd AGAnsible
chmod +x install.sh
./install.sh

# 5. Verify
./verify.sh

# 6. Test
ansible-playbook playbooks/base/ping_test.yml
```

---

**Last Updated**: January 2026
**Tested On**: WSL2 Debian 13 (Trixie), Ubuntu 22.04
