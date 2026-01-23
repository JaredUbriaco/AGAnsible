# GitHub Setup Guide

Quick reference for setting up this repository on GitHub.

## 🚀 Quick Setup

### 1. Create GitHub Repository

1. Go to [GitHub.com](https://github.com)
2. Click **"New repository"** (or the **+** icon)
3. Repository name: `ansible-playbooks` (or your preferred name)
4. Description: "Ansible playbook collection with validation and logging"
5. **Visibility**: Public or Private (your choice)
6. **DO NOT** check "Initialize with README" (we already have one)
7. Click **"Create repository"**

### 2. Upload Files

#### Option A: Using Git Command Line

```bash
# Navigate to your ansible directory
cd /path/to/ansible

# Initialize git (if not already done)
git init

# Add all files
git add .

# Create initial commit
git commit -m "Initial commit: Ansible playbook collection"

# Add remote (replace YOUR_USERNAME with your GitHub username)
git remote add origin https://github.com/YOUR_USERNAME/ansible-playbooks.git

# Push to GitHub
git branch -M main
git push -u origin main
```

#### Option B: Using GitHub Desktop

1. Download [GitHub Desktop](https://desktop.github.com/)
2. File → Add Local Repository
3. Select your ansible directory
4. Commit all files
5. Publish repository to GitHub

#### Option C: Using GitHub Web Interface

1. After creating repository, GitHub will show upload instructions
2. Or use: **"uploading an existing file"** link
3. Drag and drop all files from your ansible directory
4. Commit changes

### 3. Verify Upload

Check your GitHub repository:
- ✅ README.md is visible
- ✅ All playbooks are present
- ✅ install.sh is present
- ✅ .gitignore is present

## 📋 Repository Settings

### Recommended Settings

1. **Description**: "Ansible playbook collection with validation, logging, and organized structure"

2. **Topics/Tags**: Add these topics:
   - `ansible`
   - `automation`
   - `networking`
   - `testing`
   - `wsl`
   - `playbooks`

3. **Website**: (Optional) Leave blank

4. **License**: Choose a license:
   - MIT License (permissive)
   - Apache License 2.0 (permissive)
   - GPL-3.0 (copyleft)

### Repository Visibility

- **Public**: Anyone can see and clone
- **Private**: Only you and collaborators can access

## 🔐 Security Settings

### Before Uploading

1. **Check for sensitive data**:
   ```bash
   # Search for potential passwords
   grep -r "password" . --exclude-dir=actionlog
   grep -r "secret" . --exclude-dir=actionlog
   grep -r "api_key" . --exclude-dir=actionlog
   ```

2. **Verify .gitignore**:
   - Actionlog files are ignored
   - Sensitive files are excluded
   - Temporary files are ignored

3. **Review files**:
   - No passwords in playbooks
   - No API keys in configuration
   - No SSH private keys

## 🔐 Authentication Setup

### Personal Access Token (Recommended)

1. **Create a Personal Access Token**:
   - Go to: https://github.com/settings/tokens
   - Click "Generate new token" → "Generate new token (classic)"
   - Name it: "WSL Ansible Access"
   - Select scopes: `repo` (full control of private repositories)
   - Click "Generate token"
   - **Copy the token** (you won't see it again!)

2. **Push using the token**:
   ```bash
   cd /path/to/ansible-playbooks
   git push -u origin main
   ```
   - Username: Your GitHub username
   - Password: **Paste your personal access token** (not your GitHub password)

3. **Credentials will be saved** for future use

### SSH Keys (Alternative)

1. **Generate SSH key**:
   ```bash
   ssh-keygen -t ed25519 -C "your-email@example.com"
   # Press Enter to accept default location
   # Press Enter for no passphrase (or set one)
   ```

2. **Copy public key**:
   ```bash
   cat ~/.ssh/id_ed25519.pub
   ```

3. **Add to GitHub**:
   - Go to: https://github.com/settings/keys
   - Click "New SSH key"
   - Title: "WSL Ansible"
   - Key: Paste the output from step 2
   - Click "Add SSH key"

4. **Update remote to use SSH**:
   ```bash
   cd /path/to/ansible-playbooks
   git remote set-url origin git@github.com:YOUR_USERNAME/REPO_NAME.git
   git push -u origin main
   ```

## 📥 Downloading to New System

### Quick Download

```bash
# Clone repository
git clone https://github.com/YOUR_USERNAME/ansible-playbooks.git

# Navigate to directory
cd ansible-playbooks

# Install
chmod +x install.sh
./install.sh

# Verify
./verify.sh
```

### One-Line Install

```bash
git clone https://github.com/YOUR_USERNAME/ansible-playbooks.git && \
cd ansible-playbooks && \
chmod +x install.sh && \
./install.sh && \
./verify.sh
```

## 🔄 Updating Repository

### Push Changes

```bash
# Make changes to files
# ...

# Stage changes
git add .

# Commit changes
git commit -m "Description of changes"

# Push to GitHub
git push origin main
```

### Pull Latest Changes

```bash
# Pull latest from GitHub
git pull origin main
```

## 📝 Adding Collaborators

1. Go to repository on GitHub
2. Click **Settings** → **Collaborators**
3. Click **Add people**
4. Enter GitHub username or email
5. Choose permission level:
   - **Read**: Can view and clone
   - **Write**: Can push changes
   - **Admin**: Full access

## 🏷️ Releases and Tags

### Create a Release

1. Go to repository → **Releases** → **Create a new release**
2. Choose tag version (e.g., `v1.0.0`)
3. Release title: "Initial Release" or version number
4. Description: Brief description of what's included
5. Click **"Publish release"**

### Tag a Version

```bash
# Create tag
git tag -a v1.0.0 -m "Initial release"

# Push tag to GitHub
git push origin v1.0.0
```

## 📊 Repository Statistics

GitHub automatically tracks:
- ⭐ Stars
- 🍴 Forks
- 👀 Watchers
- 📈 Traffic/Views

View in: **Insights** → **Traffic**

## 🔍 Repository Features

### Issues
- Track bugs and feature requests
- Enable in: **Settings** → **Features** → **Issues**

### Wiki
- Additional documentation
- Enable in: **Settings** → **Features** → **Wiki**

### Projects
- Kanban boards for project management
- Enable in: **Settings** → **Features** → **Projects**

## 📚 README Badges (Optional)

Add badges to README.md:

```markdown
![Ansible](https://img.shields.io/badge/Ansible-2.20+-blue)
![Python](https://img.shields.io/badge/Python-3.6+-green)
![License](https://img.shields.io/badge/License-MIT-yellow)
```

## ✅ Pre-Upload Checklist

- [ ] All files tested and working
- [ ] No sensitive data (passwords, keys)
- [ ] .gitignore configured correctly
- [ ] README.md is complete
- [ ] install.sh is executable
- [ ] All documentation files present
- [ ] Repository name is appropriate
- [ ] Description is clear

## 🎯 Post-Upload Checklist

- [ ] Repository is accessible
- [ ] README displays correctly
- [ ] All files are present
- [ ] Can clone repository
- [ ] Installation works on clean system

---

**Need Help?**
- [GitHub Docs](https://docs.github.com/)
- [Git Basics](https://git-scm.com/book)
