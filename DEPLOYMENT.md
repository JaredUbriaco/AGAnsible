# Deployment Guide

Complete guide for deploying this Ansible setup from GitHub to a new WSL system.

## 📤 Uploading to GitHub

### Step 1: Initialize Git Repository (if not already done)

```bash
cd /path/to/ansible
git init
```

### Step 2: Add Files

```bash
# Add all files
git add .

# Review what will be committed
git status
```

### Step 3: Create Initial Commit

```bash
git commit -m "Initial commit: Ansible playbook collection with validation and logging"
```

### Step 4: Create GitHub Repository

1. Go to GitHub.com
2. Click "New repository"
3. Name it (e.g., `ansible-playbooks`)
4. **Do NOT** initialize with README (we already have one)
5. Click "Create repository"

### Step 5: Push to GitHub

```bash
# Add remote (replace with your repository URL)
git remote add origin https://github.com/YOUR_USERNAME/ansible-playbooks.git

# Push to GitHub
git branch -M main
git push -u origin main
```

## 📥 Downloading to New WSL System

### Step 1: Install WSL2 (if needed)

On Windows:
```powershell
wsl --install
```

### Step 2: Clone Repository

```bash
# Navigate to home directory
cd ~

# Clone repository
git clone https://github.com/YOUR_USERNAME/ansible-playbooks.git

# Navigate to directory
cd ansible-playbooks
```

### Step 3: Run Installation

```bash
# Make install script executable
chmod +x install.sh

# Run installation
./install.sh
```

**Or install manually:**
```bash
sudo apt-get update
sudo apt-get install -y python3 python3-pip python3-apt
sudo pip3 install --break-system-packages ansible
```

### Step 4: Verify Installation

```bash
# Check Ansible version
ansible --version

# Run test playbook
ansible-playbook playbooks/base/ping_test.yml
```

### Step 5: Verify Actionlog

```bash
# Check that actionlog was created
ls -la actionlog/base/ping_test/

# View latest result
cat $(ls -t actionlog/base/ping_test/*.txt | head -1)
```

## 🔄 Updating from GitHub

### Pull Latest Changes

```bash
cd /path/to/ansible-playbooks
git pull origin main
```

### Update Ansible (if needed)

```bash
sudo pip3 install --upgrade --break-system-packages ansible
```

## 📋 Pre-Deployment Checklist

Before uploading to GitHub, ensure:

- [ ] All playbooks are tested and working
- [ ] No sensitive data in files (passwords, API keys, etc.)
- [ ] `.gitignore` is configured correctly
- [ ] `README.md` is up to date
- [ ] `install.sh` is executable
- [ ] All documentation files are present

## 🔐 Security Checklist

Before committing:

- [ ] No passwords in playbooks
- [ ] No API keys in files
- [ ] No SSH private keys
- [ ] Sensitive inventories excluded (via .gitignore)
- [ ] Vault files excluded (if using Ansible Vault)

## 🧪 Post-Deployment Testing

After downloading to new system:

```bash
# 1. Verify Ansible installation
ansible --version

# 2. Test ping playbook
ansible-playbook playbooks/base/ping_test.yml

# 3. Install curl (if needed)
sudo apt-get install -y curl

# 4. Test curl playbook
ansible-playbook playbooks/system/curl_test.yml

# 5. Verify actionlog creation
ls -la actionlog/base/ping_test/
ls -la actionlog/system/curl_test/
```

## 🐛 Common Deployment Issues

### Issue: "git: command not found"
**Solution:**
```bash
sudo apt-get update
sudo apt-get install -y git
```

### Issue: "Permission denied" on install.sh
**Solution:**
```bash
chmod +x install.sh
```

### Issue: "sudo: command not found"
**Solution:**
- Ensure you're in WSL, not Windows
- Install sudo: `apt-get install sudo` (as root)

### Issue: "Repository not found"
**Solution:**
- Check repository URL is correct
- Verify repository is public or you have access
- Check GitHub authentication

### Issue: "Actionlog directory not created"
**Solution:**
- Run a playbook first (it creates directories automatically)
- Or create manually: `mkdir -p actionlog/{base/ping_test,cisco/ssh_test,system/curl_test}`

## 📦 File Structure After Deployment

```
ansible-playbooks/
├── README.md                 ✅ Main documentation
├── QUICK_START.md            ✅ Quick reference
├── REQUIREMENTS.md           ✅ Dependencies
├── VALIDATION_GUIDE.md       ✅ Testing guide
├── DEPLOYMENT.md             ✅ This file
├── install.sh                ✅ Installation script
├── .gitignore                 ✅ Git ignore rules
├── ansible.cfg               ✅ Ansible configuration
├── inventories/               ✅ Inventory files
├── playbooks/                ✅ Playbook files
├── roles/                    ✅ (empty, for future use)
├── group_vars/               ✅ (empty, for future use)
├── host_vars/                ✅ (empty, for future use)
└── actionlog/                ✅ (created on first run)
```

## 🔄 Version Control Best Practices

### Commit Messages
```bash
# Good commit messages
git commit -m "Add new ping test playbook"
git commit -m "Update curl test with additional URLs"
git commit -m "Fix validation logic in ping test"

# Bad commit messages
git commit -m "update"
git commit -m "fix"
```

### Branch Strategy
```bash
# Create feature branch
git checkout -b feature/new-playbook

# Make changes and commit
git add .
git commit -m "Add new playbook"

# Push to GitHub
git push origin feature/new-playbook

# Create pull request on GitHub, then merge to main
```

## 📝 Adding New Files

When adding new playbooks:

1. **Create playbook** in appropriate category
2. **Create actionlog directory**:
   ```bash
   mkdir -p actionlog/category/playbook_name
   ```
3. **Test playbook**:
   ```bash
   ansible-playbook playbooks/category/playbook_name.yml
   ```
4. **Commit and push**:
   ```bash
   git add playbooks/category/playbook_name.yml
   git commit -m "Add new playbook: category/playbook_name"
   git push origin main
   ```

## 🌐 GitHub Repository Setup

### Recommended Repository Settings

1. **Description**: "Ansible playbook collection with validation, logging, and organized structure"
2. **Topics**: `ansible`, `automation`, `networking`, `testing`, `wsl`
3. **License**: Choose appropriate license (MIT, Apache, etc.)
4. **README**: Already included
5. **.gitignore**: Already configured

### Repository Structure on GitHub

```
ansible-playbooks/
├── .gitignore
├── README.md
├── QUICK_START.md
├── REQUIREMENTS.md
├── VALIDATION_GUIDE.md
├── DEPLOYMENT.md
├── install.sh
├── ansible.cfg
├── inventories/
├── playbooks/
│   ├── base/
│   ├── cisco/
│   └── system/
├── roles/
├── group_vars/
└── host_vars/
```

## ✅ Deployment Verification Script

Create a simple verification script:

```bash
#!/bin/bash
# verify.sh - Verify deployment

echo "Verifying Ansible deployment..."

# Check Ansible
if command -v ansible &> /dev/null; then
    echo "✅ Ansible installed: $(ansible --version | head -1)"
else
    echo "❌ Ansible not found"
    exit 1
fi

# Check Python
if command -v python3 &> /dev/null; then
    echo "✅ Python3 installed: $(python3 --version)"
else
    echo "❌ Python3 not found"
    exit 1
fi

# Check playbooks
if [ -f "playbooks/base/ping_test.yml" ]; then
    echo "✅ Playbooks directory structure exists"
else
    echo "❌ Playbooks not found"
    exit 1
fi

# Check actionlog directories
if [ -d "actionlog" ]; then
    echo "✅ Actionlog directory exists"
else
    echo "⚠️  Actionlog directory not created (will be created on first run)"
fi

echo ""
echo "✅ Deployment verification complete!"
```

## 🎯 Quick Deployment Commands

### One-Line Clone and Install

```bash
git clone https://github.com/YOUR_USERNAME/ansible-playbooks.git && \
cd ansible-playbooks && \
chmod +x install.sh && \
./install.sh
```

### Verify After Installation

```bash
ansible --version && \
ansible-playbook playbooks/base/ping_test.yml
```

---

**Last Updated**: January 2026
**Tested On**: WSL2 Debian 13 (Trixie), Ubuntu 22.04
