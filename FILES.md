# File Structure and Documentation

Complete reference of all files in this repository and their purposes.

## 📄 Documentation Files

| File | Purpose | When to Read |
|------|---------|--------------|
| `README.md` | Main documentation - comprehensive guide | **Start here** |
| `QUICK_START.md` | Quick reference for common tasks | Quick lookup |
| `REQUIREMENTS.md` | System requirements and dependencies | Before installation |
| `VALIDATION_GUIDE.md` | Testing and validation documentation | Understanding test results |
| `DEPLOYMENT.md` | Guide for GitHub upload/download | Deploying to new systems |
| `GITHUB_SETUP.md` | GitHub repository setup guide | Setting up GitHub |
| `FILES.md` | This file - file structure reference | Understanding structure |

## 🔧 Configuration Files

| File | Purpose | Location |
|------|---------|----------|
| `ansible.cfg` | Ansible main configuration | Root directory |
| `.gitignore` | Git ignore rules | Root directory |
| `inventories/localhost.ini` | Default inventory file | `inventories/` |

## 📜 Scripts

| File | Purpose | Usage |
|------|---------|-------|
| `install.sh` | Installation script | `./install.sh` |
| `verify.sh` | Deployment verification | `./verify.sh` |

## 📁 Directory Structure

### `playbooks/` - Playbook Files

| Directory | Purpose | Playbooks |
|-----------|---------|-----------|
| `playbooks/base/` | Agnostic tests | `ping_test.yml` |
| `playbooks/cisco/` | Cisco-specific | `ssh_test.yml` |
| `playbooks/system/` | System-level tests | `curl_test.yml` |

### `inventories/` - Inventory Files

| File | Purpose |
|------|---------|
| `localhost.ini` | Localhost inventory for testing |

### `actionlog/` - Test Results

| Directory | Purpose | Created By |
|-----------|---------|------------|
| `actionlog/base/ping_test/` | Ping test results | `ping_test.yml` |
| `actionlog/cisco/ssh_test/` | SSH test results | `ssh_test.yml` |
| `actionlog/system/curl_test/` | Curl test results | `curl_test.yml` |

### Empty Directories (for future use)

- `roles/` - Reusable Ansible roles
- `group_vars/` - Variables for inventory groups
- `host_vars/` - Host-specific variables

## 📋 File Descriptions

### Documentation

#### README.md
- **Purpose**: Main documentation
- **Contents**:
  - Overview and features
  - Installation instructions
  - Project structure
  - The Trinity explanation
  - Usage examples
  - Troubleshooting
- **Read First**: Yes

#### QUICK_START.md
- **Purpose**: Quick reference guide
- **Contents**:
  - Installation commands
  - Common playbook commands
  - Viewing results
  - The Trinity summary
- **Use When**: Need quick command reference

#### REQUIREMENTS.md
- **Purpose**: System requirements
- **Contents**:
  - OS requirements
  - Software dependencies
  - Package manager compatibility
  - Version compatibility
  - Troubleshooting dependencies
- **Use When**: Setting up new system

#### VALIDATION_GUIDE.md
- **Purpose**: Testing documentation
- **Contents**:
  - Validation features
  - Actionlog structure
  - Test validations
  - Viewing results
  - File format
- **Use When**: Understanding test results

#### DEPLOYMENT.md
- **Purpose**: Deployment guide
- **Contents**:
  - Uploading to GitHub
  - Downloading to new system
  - Pre/post deployment checklists
  - Common issues
- **Use When**: Deploying to new system

#### GITHUB_SETUP.md
- **Purpose**: GitHub setup
- **Contents**:
  - Creating repository
  - Uploading files
  - Repository settings
  - Security checklist
- **Use When**: Setting up GitHub

### Configuration

#### ansible.cfg
- **Purpose**: Ansible configuration
- **Key Settings**:
  - Default inventory
  - Host key checking disabled
  - Forks set to 1
  - Python interpreter auto-detection
- **Location**: Root directory

#### .gitignore
- **Purpose**: Git ignore rules
- **Ignores**:
  - Actionlog files (*.txt in actionlog/)
  - Sensitive data (vault files, secrets)
  - OS files (.DS_Store, Thumbs.db)
  - IDE files (.vscode/, .idea/)
  - Temporary files
- **Location**: Root directory

#### inventories/localhost.ini
- **Purpose**: Default inventory
- **Contents**:
  - Localhost configuration
  - Python interpreter path
- **Location**: `inventories/`

### Scripts

#### install.sh
- **Purpose**: Automated installation
- **Does**:
  - Updates package lists
  - Installs Python3, pip3
  - Installs Ansible
  - Verifies installation
- **Usage**: `./install.sh`
- **Requires**: sudo access

#### verify.sh
- **Purpose**: Deployment verification
- **Checks**:
  - Ansible installation
  - Python installation
  - Playbook structure
  - Configuration files
  - Documentation files
  - Playbook syntax
- **Usage**: `./verify.sh`
- **Output**: Pass/fail status

### Playbooks

#### playbooks/base/ping_test.yml
- **Purpose**: Agnostic ping test
- **Tests**: Connectivity to 8.8.8.8
- **Validations**:
  - Packet loss < 100%
  - Packets received > 0
- **Actionlog**: `actionlog/base/ping_test/`
- **Works On**: Any system

#### playbooks/cisco/ssh_test.yml
- **Purpose**: Cisco SSH connectivity test
- **Tests**: SSH connection to Cisco devices
- **Validations**:
  - SSH connection
  - Device response
- **Actionlog**: `actionlog/cisco/ssh_test/`
- **Requires**: Cisco device or local test mode

#### playbooks/system/curl_test.yml
- **Purpose**: HTTP/curl test
- **Tests**: HTTP connectivity to URLs
- **Validations**:
  - Curl installation
  - URL accessibility
  - HTTP status codes
- **Actionlog**: `actionlog/system/curl_test/`
- **Requires**: curl installed

## 📊 File Sizes (Approximate)

- Documentation: ~50 KB total
- Playbooks: ~15 KB total
- Scripts: ~5 KB total
- Configuration: ~2 KB total
- **Total**: ~72 KB (excluding actionlog)

## 🔄 File Lifecycle

### Initial Setup
1. Clone/download repository
2. Run `install.sh`
3. Run `verify.sh`
4. Test with `ping_test.yml`

### Regular Use
1. Run playbooks
2. Check actionlog files
3. Review results

### Updates
1. Pull latest from GitHub
2. Run `verify.sh` to check
3. Test playbooks

## 📝 Adding New Files

### New Playbook
1. Create in appropriate category (`base/`, `cisco/`, `system/`)
2. Create actionlog directory
3. Test playbook
4. Commit to git

### New Documentation
1. Create `.md` file
2. Add to root directory
3. Update `README.md` if needed
4. Commit to git

### New Script
1. Create script file
2. Make executable: `chmod +x script.sh`
3. Test script
4. Commit to git

## 🗂️ Directory Permissions

All directories should have:
- **Read**: 755 (rwxr-xr-x)
- **Write**: Owner only
- **Execute**: All users (for navigation)

## 📦 What Gets Committed to Git

### ✅ Committed
- All documentation files
- All playbooks
- Configuration files
- Scripts
- Inventory files
- Directory structure

### ❌ Not Committed (via .gitignore)
- Actionlog result files (*.txt)
- Sensitive data (vault files, secrets)
- OS-specific files
- IDE files
- Temporary files

## 🔍 Finding Files

### By Purpose
```bash
# Documentation
find . -name "*.md" -type f

# Playbooks
find playbooks -name "*.yml" -type f

# Scripts
find . -name "*.sh" -type f

# Configuration
find . -name "*.cfg" -o -name "*.ini" -type f
```

### By Category
```bash
# Base playbooks
ls playbooks/base/

# Cisco playbooks
ls playbooks/cisco/

# System playbooks
ls playbooks/system/
```

---

**Last Updated**: January 2026
