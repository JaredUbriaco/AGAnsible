#!/bin/bash
# Complete Ansible Environment Setup for WSL/Linux
# Installs all required dependencies for the AGAnsible suite

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Track installation results
SUCCESSES=()
FAILURES=()
SKIP_FAILED=false
SHOW_PROGRESS=true

# Parse command line arguments
if [[ "$1" == "--skip-failed" ]]; then
    SKIP_FAILED=true
elif [[ "$1" == "--no-progress" ]]; then
    SHOW_PROGRESS=false
fi

# Progress indicator functions
spinner() {
    local pid=$1
    local message=$2
    local spin='-\|/'
    local i=0
    while kill -0 $pid 2>/dev/null; do
        i=$(( (i+1) %4 ))
        printf "\r${CYAN}${spin:$i:1}${NC} $message... "
        sleep 0.1
    done
    printf "\r"
}

show_progress() {
    if [ "$SHOW_PROGRESS" = true ]; then
        local message=$1
        local cmd=$2
        local log_file=$3
        
        echo -n "${BLUE}⏳${NC} $message... "
        
        # Run command in background and show spinner
        eval "$cmd" > "$log_file" 2>&1 &
        local pid=$!
        spinner $pid "$message"
        
        wait $pid
        local exit_code=$?
        
        if [ $exit_code -eq 0 ]; then
            echo -e "\r${GREEN}✅${NC} $message - Complete"
            return 0
        else
            echo -e "\r${RED}❌${NC} $message - Failed"
            return $exit_code
        fi
    else
        # No progress indicator, just run command
        eval "$cmd" > "$log_file" 2>&1
        return $?
    fi
}

progress_bar() {
    local current=$1
    local total=$2
    local width=50
    local percentage=$((current * 100 / total))
    local filled=$((current * width / total))
    local empty=$((width - filled))
    
    printf "\r${BLUE}[${NC}"
    printf "%${filled}s" | tr ' ' '='
    printf "%${empty}s" | tr ' ' ' '
    printf "${BLUE}]${NC} ${CYAN}%3d%%${NC} (%d/%d)" $percentage $current $total
}

echo "=========================================="
echo "AGAnsible Complete Environment Setup"
echo "=========================================="
echo ""

# Check if running as root
if [ "$EUID" -eq 0 ]; then 
   echo -e "${RED}Please do not run as root. The script will use sudo when needed.${NC}"
   exit 1
fi

# Check for sudo access
if ! sudo -n true 2>/dev/null; then
    echo "This script requires sudo access."
    echo "You will be prompted for your password."
    echo ""
fi

# Function to install package with error handling and progress
install_package() {
    local package_name=$1
    local description=$2
    local install_cmd=$3
    local log_file="/tmp/install_${package_name}.log"
    
    if [ "$SHOW_PROGRESS" = true ]; then
        echo -n "${BLUE}⏳${NC} Installing $description ($package_name)... "
        
        # Run installation in background
        eval "$install_cmd" > "$log_file" 2>&1 &
        local pid=$!
        
        # Show spinner while installing
        local spin='-\|/'
        local i=0
        while kill -0 $pid 2>/dev/null; do
            i=$(( (i+1) %4 ))
            printf "\r${CYAN}${spin:$i:1}${NC} Installing $description ($package_name)... "
            sleep 0.2
        done
        printf "\r"
        
        wait $pid
        local exit_code=$?
    else
        echo -n "Installing $description ($package_name)... "
        eval "$install_cmd" > "$log_file" 2>&1
        local exit_code=$?
    fi
    
    if [ $exit_code -eq 0 ]; then
        if [ "$SHOW_PROGRESS" = true ]; then
            echo -e "${GREEN}✅${NC} $description installed successfully"
        else
            echo -e "${GREEN}✅ Success${NC}"
        fi
        SUCCESSES+=("$package_name:$description")
        return 0
    else
        if [ "$SHOW_PROGRESS" = true ]; then
            echo -e "${RED}❌${NC} $description installation failed"
        else
            echo -e "${RED}❌ Failed${NC}"
        fi
        FAILURES+=("$package_name:$description")
        if [ "$SKIP_FAILED" = false ]; then
            echo "Error details:"
            tail -5 "$log_file" | sed 's/^/  /'
            echo ""
            echo "To continue with other packages despite failures, run: $0 --skip-failed"
            return 1
        else
            echo "  Continuing with other packages..."
            return 0
        fi
    fi
}

# Step 1: Update package lists
echo "Step 1: Updating package lists..."
if show_progress "Updating package lists" "sudo apt-get update" "/tmp/install_apt_update.log"; then
    echo ""
else
    echo -e "${RED}❌ Failed to update package lists${NC}"
    if [ "$SKIP_FAILED" = false ]; then
        echo "Error details:"
        tail -5 /tmp/install_apt_update.log | sed 's/^/  /'
        exit 1
    fi
fi

echo ""
echo "Step 2: Installing Python3 and pip..."
TOTAL_PACKAGES=5
CURRENT_PACKAGE=1
progress_bar $CURRENT_PACKAGE $TOTAL_PACKAGES
install_package "python3" "Python3" "sudo apt-get install -y python3 python3-pip python3-apt" || [ "$SKIP_FAILED" = true ]
CURRENT_PACKAGE=$((CURRENT_PACKAGE + 1))

echo ""
echo "Step 3: Installing Ansible..."
progress_bar $CURRENT_PACKAGE $TOTAL_PACKAGES
install_package "ansible" "Ansible" "sudo pip3 install --break-system-packages ansible" || [ "$SKIP_FAILED" = true ]
CURRENT_PACKAGE=$((CURRENT_PACKAGE + 1))

echo ""
echo "Step 4: Installing network and system tools..."
progress_bar $CURRENT_PACKAGE $TOTAL_PACKAGES
install_package "curl" "curl (for HTTP/curl tests)" "sudo apt-get install -y curl" || [ "$SKIP_FAILED" = true ]
CURRENT_PACKAGE=$((CURRENT_PACKAGE + 1))
progress_bar $CURRENT_PACKAGE $TOTAL_PACKAGES
install_package "dnsutils" "dnsutils (for DNS tests)" "sudo apt-get install -y dnsutils" || [ "$SKIP_FAILED" = true ]
CURRENT_PACKAGE=$((CURRENT_PACKAGE + 1))
progress_bar $CURRENT_PACKAGE $TOTAL_PACKAGES
install_package "git" "git (for version control)" "sudo apt-get install -y git" || [ "$SKIP_FAILED" = true ]
echo ""

echo ""
echo "Step 5: Installing Ansible Collections..."
if [ -f "requirements.yml" ]; then
    echo "Installing collections from requirements.yml..."
    if show_progress "Installing Ansible collections" "ansible-galaxy collection install -r requirements.yml" "/tmp/install_collections.log"; then
        echo ""
    else
        echo -e "${YELLOW}⚠️  Some collections may have failed to install${NC}"
        echo "You can install them manually later with: ansible-galaxy collection install -r requirements.yml"
        echo ""
    fi
else
    echo -e "${YELLOW}⚠️  requirements.yml not found. Skipping collection installation.${NC}"
    echo ""
fi

echo ""
echo "Step 6: Verifying installations..."
echo ""

# Verification function
verify_installation() {
    local tool=$1
    local command=$2
    
    if command -v "$tool" &> /dev/null; then
        local version=$($command 2>&1 | head -1)
        echo -e "${GREEN}✅${NC} $tool: $version"
        return 0
    else
        echo -e "${RED}❌${NC} $tool: Not found"
        return 1
    fi
}

verify_installation "python3" "python3 --version"
verify_installation "pip3" "pip3 --version"
verify_installation "ansible" "ansible --version"
verify_installation "curl" "curl --version"
verify_installation "dig" "dig -v"
verify_installation "git" "git --version"

echo ""
echo "=========================================="
echo "Installation Summary"
echo "=========================================="
echo ""

if [ ${#SUCCESSES[@]} -gt 0 ]; then
    echo -e "${GREEN}Successfully Installed (${#SUCCESSES[@]}):${NC}"
    for item in "${SUCCESSES[@]}"; do
        IFS=':' read -r pkg desc <<< "$item"
        echo "  ✅ $desc"
    done
    echo ""
fi

if [ ${#FAILURES[@]} -gt 0 ]; then
    echo -e "${RED}Failed Installations (${#FAILURES[@]}):${NC}"
    for item in "${FAILURES[@]}"; do
        IFS=':' read -r pkg desc <<< "$item"
        echo "  ❌ $desc"
        echo "     Log: /tmp/install_${pkg}.log"
    done
    echo ""
fi

# Log installation results to actionlog
ACTIONLOG_DIR="actionlog/scripts"
mkdir -p "$ACTIONLOG_DIR"
INSTALL_TIMESTAMP=$(date -Iseconds | tr ':' '-')

log_installation_result() {
    local status="$1"
    local actionlog_file="$ACTIONLOG_DIR/install_${INSTALL_TIMESTAMP}.txt"
    
    cat > "$actionlog_file" << EOF
============================================
INSTALLATION EXECUTION LOG
============================================
Script: install.sh
Timestamp: $(date -Iseconds)
Status: $status
Packages Installed: ${#SUCCESSES[@]}
Packages Failed: ${#FAILURES[@]}

Successfully Installed:
$(for item in "${SUCCESSES[@]}"; do
    IFS=':' read -r pkg desc <<< "$item"
    echo "  ✅ $desc"
done)

Failed Installations:
$(for item in "${FAILURES[@]}"; do
    IFS=':' read -r pkg desc <<< "$item"
    echo "  ❌ $desc"
done)

============================================
VALIDATION:
- Installation Execution: $(if [ "$status" = "SUCCESS" ]; then echo "PASS"; else echo "FAIL"; fi)
- All Packages Installed: $(if [ ${#FAILURES[@]} -eq 0 ]; then echo "PASS"; else echo "FAIL"; fi)
============================================
EOF
    echo "$actionlog_file"
}

echo "=========================================="
if [ ${#FAILURES[@]} -eq 0 ]; then
    echo -e "${GREEN}✅ Installation Complete!${NC}"
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
    log_installation_result "SUCCESS" > /dev/null
    echo "Actionlog: $(log_installation_result "SUCCESS")"
    exit 0
else
    echo -e "${YELLOW}⚠️  Installation completed with ${#FAILURES[@]} failure(s)${NC}"
    echo ""
    echo "Some packages failed to install. You can:"
    echo "  1. Review error logs in /tmp/install_*.log"
    echo "  2. Retry failed installations manually"
    echo "  3. Run with --skip-failed to continue despite errors"
    echo ""
    echo "To retry installation: $0"
    log_installation_result "FAILURE" > /dev/null
    echo "Actionlog: $(log_installation_result "FAILURE")"
    exit 1
fi
