# GitHub Authentication Setup

## Current Configuration

- **Repository**: https://github.com/JaredUbriaco/AGAnsible
- **Email**: jaredubriacogaming2026@gmail.com
- **Username**: JaredUbriaco

## Authentication Methods

### Option 1: Personal Access Token (Recommended)

1. **Create a Personal Access Token**:
   - Go to: https://github.com/settings/tokens
   - Click "Generate new token" → "Generate new token (classic)"
   - Name it: "WSL Ansible Access"
   - Select scopes: `repo` (full control of private repositories)
   - Click "Generate token"
   - **Copy the token** (you won't see it again!)

2. **Push using the token**:
   ```bash
   cd /home/tom/ansible
   git push -u origin main
   ```
   - Username: `JaredUbriaco`
   - Password: **Paste your personal access token** (not your GitHub password)

3. **Credentials will be saved** for future use

### Option 2: SSH Keys

1. **Generate SSH key** (if not already done):
   ```bash
   ssh-keygen -t ed25519 -C "jaredubriacogaming2026@gmail.com"
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

4. **Test connection**:
   ```bash
   ssh -T git@github.com
   ```

5. **Update remote to use SSH**:
   ```bash
   cd /home/tom/ansible
   git remote set-url origin git@github.com:JaredUbriaco/AGAnsible.git
   git push -u origin main
   ```

## Quick Push Command

Once authenticated, you can push with:
```bash
cd /home/tom/ansible
git push -u origin main
```

## Verify Configuration

```bash
# Check git config
git config --global user.name
git config --global user.email

# Check remote
cd /home/tom/ansible
git remote -v
```
