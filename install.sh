#!/bin/bash
# Complete Ansible Environment Setup for WSL/Linux
# Installs all required dependencies for the AGAnsible suite

set -e

echo "=========================================="
echo "AGAnsible Complete Environment Setup"
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
echo "Step 4: Installing network and system tools..."
echo "  - curl (for HTTP/curl tests)"
sudo apt-get install -y curl

echo "  - dnsutils (for DNS tests)"
sudo apt-get install -y dnsutils

echo "  - git (for version control)"
sudo apt-get install -y git

echo ""
echo "Step 5: Verifying installations..."
echo "Python3:"
python3 --version

echo ""
echo "pip3:"
pip3 --version

echo ""
echo "Ansible:"
ansible --version

echo ""
echo "curl:"
curl --version | head -1

echo ""
echo "dig:"
dig -v | head -1

echo ""
echo "git:"
git --version

echo ""
echo "=========================================="
echo "Installation Complete!"
echo "=========================================="
echo ""
echo "All required tools are now installed:"
echo "  ✅ Python3 and pip3"
echo "  ✅ Ansible"
echo "  ✅ curl (for curl_test.yml)"
echo "  ✅ dnsutils (for dns_test.yml)"
echo "  ✅ git (for version control)"
echo ""
echo "Next steps:"
echo "  1. Verify installation: ./verify.sh"
echo "  2. Run a test: ansible-playbook playbooks/base/ping_test.yml"
echo "  3. Check README.md and WSL_SETUP.md for more information"
echo ""
