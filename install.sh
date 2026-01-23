#!/bin/bash
# Ansible Installation Script for WSL/Linux
# This script installs Python3, pip, and Ansible

set -e

echo "=========================================="
echo "Ansible Installation Script"
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
echo "Step 2: Installing Python3 and pip..."
sudo apt-get install -y python3 python3-pip python3-apt

echo ""
echo "Step 3: Installing Ansible..."
sudo pip3 install --break-system-packages ansible

echo ""
echo "Step 4: Verifying installation..."
ansible --version

echo ""
echo "=========================================="
echo "Installation Complete!"
echo "=========================================="
echo ""
echo "Next steps:"
echo "  1. Verify installation: ansible --version"
echo "  2. Run a test: ansible-playbook playbooks/base/ping_test.yml"
echo "  3. Check the README.md for more information"
echo ""
