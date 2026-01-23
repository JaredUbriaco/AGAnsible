# Quick Start Guide

## Installation (One-Time Setup)

```bash
# 1. Navigate to ansible directory
cd /path/to/ansible

# 2. Run installation script
chmod +x install.sh
./install.sh

# Or install manually:
sudo apt-get update
sudo apt-get install -y python3 python3-pip python3-apt
sudo pip3 install --break-system-packages ansible
```

## Running Tests

### Ping Test (Agnostic)
```bash
ansible-playbook playbooks/base/ping_test.yml
```

### Curl Test (System)
```bash
ansible-playbook playbooks/system/curl_test.yml
```

### SSH Test (Cisco)
```bash
ansible-playbook -i inventories/cisco.ini playbooks/cisco/ssh_test.yml
```

## Viewing Results

```bash
# Latest ping test
cat $(ls -t actionlog/base/ping_test/*.txt | head -1)

# Latest curl test
cat $(ls -t actionlog/system/curl_test/*.txt | head -1)
```

## The Trinity

1. **Inventory** (`inventories/`) = WHERE (target hosts)
2. **Playbooks** (`playbooks/`) = WHAT (tasks to run)
3. **Modules** = HOW (tools that execute)

## Folder Organization

- **base/** = Works on ANY system (agnostic)
- **cisco/** = Cisco-specific requirements
- **system/** = OS/system-level features

## Common Commands

```bash
# Check Ansible version
ansible --version

# List all playbooks
find playbooks -name "*.yml"

# List all actionlog results
find actionlog -name "*.txt" | sort
```
