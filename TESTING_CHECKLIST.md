# Testing Checklist for AGAnsible Suite

Use this checklist when testing the AGAnsible suite on a fresh system.

## Pre-Testing Setup

### Initial WSL Setup
- [ ] WSL2 installed on Windows
- [ ] WSL distribution installed (Debian/Ubuntu)
- [ ] WSL launched and initial setup completed
- [ ] System updated: `sudo apt-get update && sudo apt-get upgrade -y`

### Repository Setup
- [ ] Repository cloned: `git clone https://github.com/JaredUbriaco/AGAnsible.git`
- [ ] Navigated to directory: `cd AGAnsible`
- [ ] Verified files present: `ls -la`

### Installation
- [ ] Installation script made executable: `chmod +x install.sh`
- [ ] Installation run: `./install.sh`
- [ ] Installation completed without errors
- [ ] All tools verified (Python, Ansible, curl, dig, git)

## Verification Steps

### Tool Verification
- [ ] Python3: `python3 --version` ✓
- [ ] pip3: `pip3 --version` ✓
- [ ] Ansible: `ansible --version` ✓
- [ ] curl: `curl --version` ✓
- [ ] dig: `dig -v` ✓
- [ ] git: `git --version` ✓

### Configuration Verification
- [ ] Run verification script: `./verify.sh`
- [ ] All checks pass
- [ ] ansible.cfg exists and is valid
- [ ] inventories/localhost.ini exists

## Playbook Testing

### Base Playbooks
- [ ] **Ping Test**: `ansible-playbook playbooks/base/ping_test.yml`
  - [ ] Playbook runs successfully
  - [ ] Actionlog file created in `actionlog/base/ping_test/`
  - [ ] Test shows SUCCESS status
  - [ ] IP addresses resolved correctly

### System Playbooks
- [ ] **Curl Test**: `ansible-playbook playbooks/system/curl_test.yml`
  - [ ] Playbook runs successfully
  - [ ] Actionlog file created in `actionlog/system/curl_test/`
  - [ ] Test shows SUCCESS status
  - [ ] URLs accessible (httpbin.org, google.com)
  - [ ] HTTP status codes correct (200)

- [ ] **DNS Test**: `ansible-playbook playbooks/system/dns_test.yml`
  - [ ] Playbook runs successfully
  - [ ] Actionlog file created in `actionlog/system/dns_test/`
  - [ ] Test shows SUCCESS status
  - [ ] zappos.com resolves correctly
  - [ ] DNS server 1.1.1.1 used
  - [ ] IP addresses extracted

### Quick Test Suite
- [ ] Run complete test suite: `./test_all.sh`
  - [ ] All tests pass
  - [ ] Summary shows 0 failures

## Actionlog Verification

### File Creation
- [ ] Actionlog directories exist:
  - [ ] `actionlog/base/ping_test/`
  - [ ] `actionlog/system/curl_test/`
  - [ ] `actionlog/system/dns_test/`

### File Content
- [ ] Each test creates a timestamped .txt file
- [ ] Files contain:
  - [ ] Test date/time
  - [ ] Status (SUCCESS/FAILURE)
  - [ ] Validation results (PASS/FAIL)
  - [ ] Full output

### File Access
- [ ] Can read actionlog files: `cat actionlog/base/ping_test/*.txt`
- [ ] Files have correct permissions (644)

## Documentation Verification

### Documentation Files Present
- [ ] README.md
- [ ] WSL_SETUP.md
- [ ] REQUIREMENTS.md
- [ ] COMPLETE_DEPENDENCIES.md
- [ ] QUICK_START.md
- [ ] VALIDATION_GUIDE.md
- [ ] TESTING_CHECKLIST.md (this file)

### Documentation Accuracy
- [ ] All commands in documentation work
- [ ] All file paths are correct
- [ ] No hardcoded user-specific paths
- [ ] Installation steps are accurate

## Network Connectivity

### Basic Connectivity
- [ ] Internet access: `ping -c 4 8.8.8.8`
- [ ] DNS resolution: `nslookup google.com`
- [ ] HTTP access: `curl -I https://www.google.com`

### Test Targets
- [ ] Can ping 8.8.8.8 (Google DNS)
- [ ] Can resolve zappos.com via 1.1.1.1
- [ ] Can access httpbin.org
- [ ] Can access google.com

## Troubleshooting (If Issues Found)

### Common Issues
- [ ] If Ansible not found: Re-run `./install.sh`
- [ ] If curl not found: Check `install.sh` ran completely
- [ ] If dig not found: Check `install.sh` ran completely
- [ ] If playbook fails: Check actionlog for details
- [ ] If network issues: Verify WSL network connectivity

### Verification Commands
```bash
# Check all tools
python3 --version && pip3 --version && ansible --version
curl --version && dig -v && git --version

# Check playbook syntax
ansible-playbook --syntax-check playbooks/base/ping_test.yml
ansible-playbook --syntax-check playbooks/system/curl_test.yml
ansible-playbook --syntax-check playbooks/system/dns_test.yml

# Run verification script
./verify.sh

# Run test suite
./test_all.sh
```

## Success Criteria

✅ **Complete Success**:
- All tools installed and verified
- All playbooks run successfully
- All actionlog files created
- All validations pass
- Documentation is accurate

## Notes for Testing

- Test on a **fresh WSL installation** if possible
- Document any issues encountered
- Note any missing dependencies
- Verify all paths work from any directory
- Test from different user accounts if possible

## Post-Testing

After successful testing:
- [ ] All playbooks work correctly
- [ ] All documentation is accurate
- [ ] No errors or warnings
- [ ] Ready for production use

---

**Testing Date**: _______________
**Tester**: _______________
**System**: _______________
**Results**: _______________
