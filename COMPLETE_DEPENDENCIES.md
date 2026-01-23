# Complete Dependencies List

Complete list of all dependencies required for the AGAnsible suite.

## 📦 Core Dependencies (Required)

### Python Environment
- **python3** (3.6+) - Python runtime
- **python3-pip** - Python package manager
- **python3-apt** - Python bindings for apt package manager

### Automation Framework
- **ansible** (2.9+) - Automation and configuration management
- **ansible-core** - Core Ansible engine (installed with ansible)

## 🔧 System Tools (Required)

### Network Tools
- **curl** - HTTP/HTTPS client
  - Used by: `playbooks/system/curl_test.yml`
  - Package: `curl`
  
- **dnsutils** - DNS utilities (includes dig and nslookup)
  - Used by: `playbooks/system/dns_test.yml`
  - Package: `dnsutils` (Debian/Ubuntu) or `bind-utils` (RHEL/CentOS)
  - Provides: `dig`, `nslookup`, `host`

### Development Tools
- **git** - Version control system
  - Used for: Repository management, version control
  - Package: `git`

## 📋 Installation Commands

### Debian/Ubuntu (apt)
```bash
sudo apt-get update
sudo apt-get install -y \
  python3 \
  python3-pip \
  python3-apt \
  curl \
  dnsutils \
  git

sudo pip3 install --break-system-packages ansible
```

### RHEL/CentOS (yum/dnf)
```bash
sudo yum update -y
sudo yum install -y \
  python3 \
  python3-pip \
  curl \
  bind-utils \
  git

sudo pip3 install ansible
```

### macOS (Homebrew)
```bash
brew install python3 curl bind git
pip3 install ansible
```

## ✅ Verification Commands

After installation, verify all tools:

```bash
# Python
python3 --version
pip3 --version

# Ansible
ansible --version
ansible-playbook --version

# Network tools
curl --version
dig -v
nslookup -version

# Development
git --version
```

## 🔍 What Each Tool Does

### Python3
- **Purpose**: Runtime environment for Ansible
- **Required for**: All Ansible operations
- **Version**: 3.6 or higher

### pip3
- **Purpose**: Python package installer
- **Required for**: Installing Ansible and Python packages
- **Usage**: `pip3 install <package>`

### python3-apt
- **Purpose**: Python bindings for Debian package management
- **Required for**: Ansible apt module functionality
- **Note**: Only needed on Debian/Ubuntu systems

### Ansible
- **Purpose**: Automation and configuration management
- **Required for**: All playbook execution
- **Version**: 2.9 or higher

### curl
- **Purpose**: HTTP/HTTPS client
- **Required for**: `playbooks/system/curl_test.yml`
- **Features**: URL testing, HTTP requests, file downloads

### dnsutils
- **Purpose**: DNS query and testing tools
- **Required for**: `playbooks/system/dns_test.yml`
- **Tools included**:
  - `dig` - DNS lookup utility
  - `nslookup` - Name server lookup
  - `host` - DNS lookup utility

### git
- **Purpose**: Version control system
- **Required for**: Repository management, cloning, updates
- **Usage**: Clone repository, track changes

## 🚀 Automated Installation

All dependencies are installed automatically by running:
```bash
./install.sh
```

No manual installation needed. The script handles everything.

## 📊 Dependency Tree

```
AGAnsible Suite
├── Python3 (runtime)
│   ├── pip3 (package manager)
│   └── python3-apt (apt bindings)
├── Ansible (automation)
│   └── ansible-core (core engine)
├── curl (HTTP client)
├── dnsutils (DNS tools)
│   ├── dig
│   └── nslookup
└── git (version control)
```

## 🔄 Updating Dependencies

### Update System Packages
```bash
sudo apt-get update
sudo apt-get upgrade -y
```

### Update Ansible
```bash
sudo pip3 install --upgrade --break-system-packages ansible
```

### Update All Tools
```bash
sudo apt-get update
sudo apt-get upgrade -y curl dnsutils git
sudo pip3 install --upgrade --break-system-packages ansible
```

## 🐛 Troubleshooting Dependencies

### Missing Python3
```bash
sudo apt-get install -y python3
```

### Missing pip3
```bash
sudo apt-get install -y python3-pip
```

### Missing Ansible
```bash
sudo pip3 install --break-system-packages ansible
```

### Missing curl
```bash
sudo apt-get install -y curl
```

### Missing dnsutils
```bash
# Debian/Ubuntu
sudo apt-get install -y dnsutils

# RHEL/CentOS
sudo yum install -y bind-utils
```

### Missing git
```bash
sudo apt-get install -y git
```

## 📝 Notes

- All dependencies are **required**, not optional
- The `install.sh` script installs everything automatically
- No manual dependency installation needed
- All tools are verified after installation
- See `WSL_SETUP.md` for complete environment setup

---

**Last Updated**: January 2026
