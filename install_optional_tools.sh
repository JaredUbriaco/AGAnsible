#!/bin/bash
# Install Optional Tools for Ansible Playbooks
# Installs curl and dnsutils for system-level playbooks

set -e

echo "=========================================="
echo "Installing Optional Tools for Playbooks"
echo "=========================================="
echo ""

# Check if running as root
if [ "$EUID" -eq 0 ]; then 
   echo "Please do not run as root. The script will use sudo when needed."
   exit 1
fi

# Check for sudo access
if ! sudo -n true 2>/dev/null; then
    echo "This script requires sudo access."
    echo "You will be prompted for your password."
    echo ""
fi

echo "Step 1: Updating package lists..."
sudo apt-get update

echo ""
echo "Step 2: Installing curl (for curl_test.yml)..."
sudo apt-get install -y curl

echo ""
echo "Step 3: Installing dnsutils (for dns_test.yml)..."
sudo apt-get install -y dnsutils

echo ""
echo "Step 4: Verifying installations..."
echo "curl version:"
curl --version | head -1
echo ""
echo "dig version:"
dig -v | head -1

echo ""
echo "=========================================="
echo "Optional Tools Installation Complete!"
echo "=========================================="
echo ""
echo "You can now run:"
echo "  - curl test: ansible-playbook playbooks/system/curl_test.yml"
echo "  - DNS test: ansible-playbook playbooks/system/dns_test.yml"
echo ""
