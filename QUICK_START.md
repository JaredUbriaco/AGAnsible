# Quick Start Guide

Fast reference for getting started with AGAnsible.

## 🚀 Complete Setup (First Time)

### For Windows Users (WSL Setup Required)

1. **Install WSL2** (PowerShell as Admin):
   ```powershell
   wsl --install
   ```
   Restart Windows when prompted.

2. **Launch WSL** and complete initial setup (create username/password)

3. **Update system**:
   ```bash
   sudo apt-get update && sudo apt-get upgrade -y
   ```

### For All Users (After WSL/Linux is Ready)

```bash
# 1. Clone repository
cd ~
git clone https://github.com/JaredUbriaco/AGAnsible.git
cd AGAnsible

# 2. Install everything
chmod +x install.sh
./install.sh

# 3. Verify installation
./verify.sh

# 4. Test everything
./test_all.sh
```

**That's it!** All dependencies are installed automatically.

## 🏃 Running Tests

### Run All Tests
```bash
./test_all.sh
```

### Individual Tests

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

## 📊 Viewing Results

```bash
# Latest ping test
cat $(ls -t actionlog/base/ping_test/*.txt | head -1)

# Latest curl test
cat $(ls -t actionlog/system/curl_test/*.txt | head -1)

# Latest DNS test
cat $(ls -t actionlog/system/dns_test/*.txt | head -1)
```

## 🔺 The Trinity

1. **Inventory** (`inventories/`) = WHERE (target hosts)
2. **Playbooks** (`playbooks/`) = WHAT (tasks to run)
3. **Modules** = HOW (tools that execute)

## 📂 Folder Organization

- **base/** = Works on ANY system (agnostic)
- **cisco/** = Cisco-specific requirements
- **system/** = OS/system-level features

## 🔧 Common Commands

```bash
# Check Ansible version
ansible --version

# List all playbooks
find playbooks -name "*.yml"

# List all actionlog results
find actionlog -name "*.txt" | sort

# Run verification
./verify.sh

# Run all tests
./test_all.sh
```

## 📚 Need More Help?

- **Complete setup**: See [README.md](README.md) or [WSL_SETUP.md](WSL_SETUP.md)
- **Testing guide**: See [TESTING_CHECKLIST.md](TESTING_CHECKLIST.md)
- **Quick test**: See [QUICK_TEST.md](QUICK_TEST.md)
