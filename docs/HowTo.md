# AGAnsible: How-To — Full Verbose Instructions

This document provides full, step-by-step instructions for every phase of the AGAnsible project: environment setup, installation, verification, running tests, reviewing results, and troubleshooting.

---

## Table of Contents

1. [Prerequisites and What You Need](#1-prerequisites-and-what-you-need)
2. [Phase 1: Environment Setup (Windows with WSL2)](#2-phase-1-environment-setup-windows-with-wsl2)
3. [Phase 2: Get the Project](#3-phase-2-get-the-project)
4. [Phase 3: Install AGAnsible](#4-phase-3-install-agansible)
5. [Phase 4: Verify the Installation](#5-phase-4-verify-the-installation)
6. [Phase 5: Understanding Inventory and Configuration](#6-phase-5-understanding-inventory-and-configuration)
7. [Phase 6: Running a Single Test (Verbose Walkthrough)](#7-phase-6-running-a-single-test-verbose-walkthrough)
8. [Phase 7: Reviewing Test Results (Actionlog)](#8-phase-7-reviewing-test-results-actionlog)
9. [Phase 8: Running Multiple Tests](#9-phase-8-running-multiple-tests)
10. [Phase 9: Custom Inventories and Extra Variables](#10-phase-9-custom-inventories-and-extra-variables)
    - [Using Ansible Vault](#104-using-ansible-vault)
11. [Phase 10: Output Formats (Text, JSON, Both)](#11-phase-10-output-formats-text-json-both)
    - [Network Topology Discovery](#116-network-topology-discovery)
12. [Troubleshooting](#12-troubleshooting)
13. [Quick Reference and Checklists](#13-quick-reference-and-checklists)

---

## 1. Prerequisites and What You Need

### 1.1 Operating System

- **Windows 10/11:** You will use WSL2 (Windows Subsystem for Linux). All AGAnsible commands run inside the WSL Linux environment, not in Windows PowerShell or CMD.
- **Linux (native):** Use your existing distribution (Debian, Ubuntu, etc.). No WSL.

### 1.2 Permissions and Access

- **Windows:** Administrator access (for installing WSL2).
- **WSL/Linux:** A user account with `sudo` access (for installing packages).
- **Network:** Internet connectivity (for cloning the repo, installing packages, and running connectivity tests).

### 1.3 What Gets Installed (No Manual Install Required)

The `install.sh` script installs everything listed below. You do **not** need to install these by hand unless you prefer to:

| Component | Purpose |
|-----------|---------|
| Python 3.6+ | Runtime for Ansible |
| pip3 | Python package manager |
| python3-apt | Python bindings for apt (Debian/Ubuntu) |
| Ansible 2.9+ | Automation framework |
| curl | HTTP client (used by curl_test playbook) |
| dnsutils | DNS tools: dig, nslookup (used by dns_test playbook) |
| git | Version control (clone repo, optional use) |

Optional (if present in the project): Ansible Galaxy collections from `requirements.yml`.

---

## 2. Phase 1: Environment Setup (Windows with WSL2)

**If you are already on Linux, skip to [Phase 2](#3-phase-2-get-the-project).**

### 2.1 Open PowerShell as Administrator

1. Press **Win + X** on your keyboard.
2. Select **"Windows PowerShell (Admin)"** or **"Terminal (Admin)"**.
3. A window opens with an elevated prompt.

### 2.2 Install WSL2

In the PowerShell window, run:

```powershell
wsl --install
```

- This installs WSL2 and a default Linux distribution (usually Ubuntu).
- To install a specific distribution instead:

  ```powershell
  wsl --install -d Ubuntu
  # or
  wsl --install -d Debian
  ```

- Wait for the installation to complete. You may be prompted to restart.

### 2.3 Restart Windows

When prompted, restart your computer. WSL2 requires a restart after first install.

### 2.4 Launch WSL

After restart:

- **Option A:** Open **WSL** or **Ubuntu** (or your chosen distro) from the Start Menu.
- **Option B:** Open PowerShell or Command Prompt and type:

  ```powershell
  wsl
  ```

You should see a Linux shell prompt (e.g. `user@hostname:~$`).

### 2.5 First-Time WSL Setup (When Prompted)

On first launch, WSL may ask you to:

1. **Create a username:** Enter a Unix username (e.g. your name, no spaces).
2. **Create a password:** Enter a password (you will need this for `sudo`).

Then update the system:

```bash
sudo apt-get update
sudo apt-get upgrade -y
```

Enter your password when prompted.

### 2.6 Confirm You Are in WSL/Linux

Run:

```bash
uname -a
```

You should see Linux in the output. All further steps in this How-To assume you are in this WSL (or native Linux) shell.

**For more detail:** See **[WSL_SETUP.md](WSL_SETUP.md)**.

---

## 3. Phase 2: Get the Project

### 3.1 Navigate to Your Home Directory

```bash
cd ~
```

`~` is your home directory (e.g. `/home/yourusername`).

### 3.2 Clone the Repository

```bash
git clone https://github.com/JaredUbriaco/AGAnsible.git
```

- This creates a folder named **AGAnsible** in your current directory.
- If you do not have `git` yet, you will install it in Phase 3; you can download the project as a ZIP from GitHub and extract it, then continue from step 3.3.

### 3.3 Enter the Project Directory

```bash
cd AGAnsible
```

From now on, **all commands in this How-To are run from inside the AGAnsible directory** unless stated otherwise. You can confirm you are in the right place:

```bash
pwd
# Should show something like: /home/yourusername/AGAnsible

ls -la
# You should see: README.md, install.sh, verify.sh, playbooks/, inventories/, etc.
```

---

## 4. Phase 3: Install AGAnsible

### 4.1 Make the Install Script Executable

```bash
chmod +x install.sh
```

You only need to do this once (or after a fresh clone).

### 4.2 Run the Installer

```bash
./install.sh
```

- You may be prompted for your **sudo password** (the one you set in WSL).
- The script will:
  1. Update package lists (`apt-get update`).
  2. Install Python3, pip3, python3-apt.
  3. Install Ansible via pip3.
  4. Install curl, dnsutils, git.
  5. If the file `requirements.yml` exists, install Ansible Galaxy collections from it.
  6. Print a verification line for each tool (e.g. `ansible --version`).
  7. Print a summary of successes and failures.
  8. Write an **actionlog** file under `actionlog/scripts/` (e.g. `install_<timestamp>.txt`).

### 4.3 Install Script Options

| Option | Effect |
|--------|--------|
| (none) | Normal run; script may stop on first package failure. |
| `--skip-failed` | Continue installing other packages even if one fails. |
| `--no-progress` | Do not show progress spinners; useful for logs. |

Examples:

```bash
./install.sh --skip-failed
./install.sh --no-progress
```

### 4.4 What Success Looks Like

At the end you should see something like:

```
==========================================
✅ Installation Complete!

All required tools are now installed:
  ✅ Python3 and pip3
  ✅ Ansible
  ✅ curl (for curl_test.yml)
  ✅ dnsutils (for dns_test.yml)
  ✅ git (for version control)

Next steps:
  1. Verify installation: ./verify.sh
  2. Run a test: ansible-playbook playbooks/base/ping_test.yml
  3. Check README.md and WSL_SETUP.md for more information
Actionlog: actionlog/scripts/install_<timestamp>.txt
```

If any package failed and you did not use `--skip-failed`, fix the reported errors (e.g. network, permissions) and run `./install.sh` again, or run with `--skip-failed` to continue.

### 4.5 Optional: Inspect the Install Actionlog

```bash
ls -t actionlog/scripts/install_*.txt | head -1 | xargs cat
```

This prints the contents of the most recent install actionlog file.

---

## 5. Phase 4: Verify the Installation

### 5.1 Run the Verification Script

```bash
./verify.sh
```

This script checks:

- **Commands:** `ansible`, `ansible-playbook`, `python3`, `pip3`, and that at least one of `dig` or `nslookup` is available.
- **Files:** `playbooks/base/ping_test.yml`, `playbooks/cisco/ssh_test.yml`, `playbooks/system/curl_test.yml`, `playbooks/system/dns_test.yml`, `ansible.cfg`, `inventories/localhost.ini`.
- **Directories:** `actionlog/` (and optionally existing actionlog subdirs).
- **Documentation:** `README.md`, `HowTo.md`, `REQUIREMENTS.md`.
- **Syntax:** Runs `ansible-playbook --syntax-check` on `playbooks/base/ping_test.yml`.

Results are written to `actionlog/scripts/verify_<timestamp>.txt`.

### 5.2 What Success Looks Like

You should see a series of green checkmarks (✅) for each check and at the end:

```
==========================================
✅ Verification Complete - All checks passed!

Next steps:
  1. Run a test: ansible-playbook playbooks/base/ping_test.yml
  2. Check results: ls -la actionlog/base/ping_test/
Actionlog: actionlog/scripts/verify_<timestamp>.txt
```

If any check fails, the script prints which item failed and exits with a non-zero status. Fix the reported issue (e.g. run `./install.sh` again if a tool is missing) and run `./verify.sh` again.

---

## 6. Phase 5: Understanding Inventory and Configuration

### 6.1 Default Inventory: Where Playbooks Run

By default, Ansible uses the inventory file set in `ansible.cfg`:

- **File:** `inventories/localhost.ini`
- **Content (conceptually):** A group `[local]` with host `localhost` and `ansible_connection=local`, so playbooks run **on your current machine** without SSH.

So when you run:

```bash
ansible-playbook playbooks/base/ping_test.yml
```

Ansible runs the playbook against **localhost** (your WSL or Linux machine).

### 6.2 Ansible Configuration

The file **ansible.cfg** in the project root sets:

- **inventory** = `inventories/localhost.ini`
- **host_key_checking** = False
- **forks** = 1 (run one host at a time)
- **roles_path** = ./roles
- Other defaults (timeouts, interpreter, etc.)

You do not need to change this for local testing.

### 6.3 Using a Different Inventory

To run a playbook against other hosts (e.g. remote servers or network devices), specify an inventory file with `-i`:

```bash
ansible-playbook -i inventories/example_remote.ini playbooks/base/ping_test.yml
```

Example inventory files are in **inventories/**: `example_remote.ini`, `example_cisco.ini`, `example_arista.ini`, etc. Copy and edit them for your environment; do not commit passwords or secrets.

---

## 7. Phase 6: Running a Single Test (Verbose Walkthrough)

This section walks through one example: the **Ping Test**, from command to result.

### 7.1 Run the Ping Test

From the **AGAnsible** directory:

```bash
ansible-playbook playbooks/base/ping_test.yml
```

### 7.2 What Happens Step by Step

1. **Inventory:** Ansible loads `inventories/localhost.ini` (from ansible.cfg). The only host is **localhost** with `connection: local`.
2. **Playbook:** It runs the play defined in `playbooks/base/ping_test.yml`.
3. **Tasks in order:**
   - **Setup actionlog directory:** Ensures `actionlog/base/ping_test/` exists (via `roles/common/tasks/actionlog_setup.yml`).
   - **Ping:** Runs `ping -c 4 8.8.8.8` (default target and count). The task uses `failed_when: false` so Ansible does not fail on packet loss; the playbook decides success/failure.
   - **Parse output:** Extracts packet loss and packet counts from the ping stdout.
   - **Set result:** Sets `test_status` to **SUCCESS** or **FAILURE** (e.g. SUCCESS if packet loss &lt; 100% and packets received &gt; 0).
   - **Timestamp:** Gets a timestamp (e.g. via `roles/common/tasks/timestamp.yml`).
   - **Build actionlog data:** Fills a structure with test name, timestamp, host, status, message, details, metrics, validation, full output.
   - **Write actionlog:** Writes a file under `actionlog/base/ping_test/` (e.g. `ping_test_localhost_<timestamp>.txt`).
   - **Display:** Prints a short summary to the terminal (e.g. "Test Status: SUCCESS", "Results saved to: ...").
   - **Fail if failed:** If `test_status == FAILURE`, the playbook runs a `fail` task so the overall run fails (red in the terminal).

### 7.3 What You See in the Terminal

On success you see output similar to:

```
PLAY [Ping test to Google DNS (8.8.8.8)] ****
TASK [Setup actionlog directory] ****
ok: [localhost]
TASK [Ping 8.8.8.8 using command module] ****
ok: [localhost]
...
TASK [Display ping results] ****
ok: [localhost] => {
    "msg": [
        "Test Status: SUCCESS",
        "All packets received",
        "Packet Loss: 0%",
        "Output Format: text",
        "Results saved to: .../actionlog/base/ping_test/ping_test_localhost_<timestamp>.txt"
    ]
}
PLAY RECAP ****
localhost : ok=... changed=... unreachable=0 failed=0
```

So: **one command runs the test and writes a result file.** The path to the file is shown in the "Results saved to" line.

### 7.4 Running Other Single Playbooks (Localhost-Capable)

From the AGAnsible directory you can run any of these the same way (default inventory is localhost):

```bash
# Base
ansible-playbook playbooks/base/ping_test.yml

# System
ansible-playbook playbooks/system/curl_test.yml
ansible-playbook playbooks/system/dns_test.yml
ansible-playbook playbooks/system/port_scan.yml
ansible-playbook playbooks/system/network_interfaces.yml
ansible-playbook playbooks/system/ssl_cert_check.yml
ansible-playbook playbooks/system/firewall_check.yml
ansible-playbook playbooks/system/network_stats.yml
ansible-playbook playbooks/system/traceroute_test.yml
```

Each playbook writes its results under `actionlog/<category>/<playbook_name>/` (see [Phase 8](#8-phase-7-reviewing-test-results-actionlog)).

---

## 8. Phase 7: Reviewing Test Results (Actionlog)

Every playbook run that completes the actionlog step writes one or more files under **actionlog/**.

### 8.1 Where Results Are Stored

| Test / Script | Actionlog Directory |
|---------------|---------------------|
| Ping Test | `actionlog/base/ping_test/` |
| Curl Test | `actionlog/system/curl_test/` |
| DNS Test | `actionlog/system/dns_test/` |
| Port Scan | `actionlog/system/port_scan/` |
| Network Interfaces | `actionlog/system/network_interfaces/` |
| SSL Certificate Check | `actionlog/system/ssl_cert_check/` |
| Firewall Rules Check | `actionlog/system/firewall_check/` |
| Network Statistics | `actionlog/system/network_stats/` |
| Traceroute Test | `actionlog/system/traceroute_test/` |
| install.sh | `actionlog/scripts/` (e.g. `install_<timestamp>.txt`) |
| verify.sh | `actionlog/scripts/` (e.g. `verify_<timestamp>.txt`) |
| test_localhost.sh | `actionlog/scripts/` (e.g. `localhost_tests_<timestamp>.txt`) |

### 8.2 File Naming Convention

- **Pattern:** `<test_name>_<host>_<timestamp>.<txt|json>`
- **Example:** `ping_test_localhost_2026-01-29T12-30-45-00-00.txt`

Timestamps use ISO format with colons replaced by dashes so the filename is filesystem-safe.

### 8.3 How to View the Latest Result for a Test

**Ping test (text):**

```bash
ls -t actionlog/base/ping_test/*.txt 2>/dev/null | head -1 | xargs cat
```

**Curl test (text):**

```bash
ls -t actionlog/system/curl_test/*.txt 2>/dev/null | head -1 | xargs cat
```

**DNS test (text):**

```bash
ls -t actionlog/system/dns_test/*.txt 2>/dev/null | head -1 | xargs cat
```

If you use JSON output, replace `*.txt` with `*.json`. To pretty-print JSON:

```bash
ls -t actionlog/base/ping_test/*.json 2>/dev/null | head -1 | xargs cat | python3 -m json.tool
```

(Or use `jq` if installed: `... | xargs jq .`)

### 8.4 What’s Inside a Text Actionlog File (Example: Ping)

A typical **text** actionlog for the ping test looks like:

```
============================================
PING TEST RESULTS
============================================
Test Date: 2026-01-29T12:30:45+00:00
Host: localhost

STATUS: SUCCESS
MESSAGE: All packets received

DETAILS:
  target_host: 8.8.8.8
  ping_count: 4

METRICS:
- packet_loss_percent: 0
- packets_transmitted: 4
- packets_received: 4

FULL OUTPUT:
PING 8.8.8.8 (8.8.8.8) 56(84) bytes of data.
64 bytes from 8.8.8.8: icmp_seq=1 ttl=...
...

============================================
VALIDATION:
- packet_loss_under_100: PASS
- packets_received_gt_zero: PASS
============================================
```

To confirm the test succeeded:

1. **Terminal:** Playbook run ended with "failed=0" and "Test Status: SUCCESS" in the output.
2. **File:** This file exists and contains **STATUS: SUCCESS** and **VALIDATION:** lines with **PASS**.

### 8.5 Listing All Actionlog Files

To see all actionlog files created so far:

```bash
find actionlog -type f \( -name "*.txt" -o -name "*.json" \) | sort
```

To list only the latest file per directory (e.g. per test):

```bash
for dir in actionlog/base/ping_test actionlog/system/curl_test actionlog/system/dns_test; do
  [ -d "$dir" ] && echo "=== $dir ===" && ls -t "$dir"/*.txt "$dir"/*.json 2>/dev/null | head -1
done
```

---

## 9. Phase 8: Running Multiple Tests

### 9.1 Localhost-Only Suite (Recommended for Quick Validation)

This runs only playbooks that work on localhost (no network devices required):

```bash
./test_localhost.sh
```

**What it does:**

- Runs 9 playbooks in sequence: Ping, Curl, DNS, Port Scan, Network Interfaces, SSL Certificate Check, Firewall Rules Check, Network Statistics, Traceroute.
- For each: runs `ansible-playbook <playbook>`, then prints **PASS** or **FAIL**.
- Writes per-playbook logs under `actionlog/test_suite/localhost/`.
- Writes a summary file in the same directory.
- Writes a suite-level actionlog under `actionlog/scripts/` (e.g. `localhost_tests_<timestamp>.txt`).

**Options:**

| Option | Effect |
|--------|--------|
| (none) | Default: text actionlog, normal output. |
| `--verbose` or `-v` | More detailed output; full log path for each test. |
| `--json` or `-j` | Pass `output_format=json` to playbooks (where supported). |
| `--both` or `-b` | Pass `output_format=both` to playbooks (text + JSON). |

Examples:

```bash
./test_localhost.sh --verbose
./test_localhost.sh --json
./test_localhost.sh --both
```

**What success looks like:** You see a line like "✅ PASS" for each test and at the end "Tests Run: 9", "Passed: 9", "Failed: 0", plus a note about actionlog files created.

### 9.2 Full Test Suite (Including Network-Device Playbooks)

To run **all** playbooks (including those that expect network devices or custom inventory):

```bash
./test_all.sh
```

- Some playbooks (e.g. Cisco SSH, BGP, OSPF, config backup) may **fail** if you do not have the right inventory or devices. That is expected on a default localhost-only setup.
- Logs and summaries go to `actionlog/test_suite/` and `actionlog/scripts/`.

For daily validation without network devices, prefer **./test_localhost.sh**.

### 9.3 Viewing Suite Results

After running `./test_localhost.sh`, you can:

- **Summary file:**  
  `actionlog/test_suite/localhost/localhost_tests_<timestamp>_summary.txt`
- **Suite actionlog:**  
  `actionlog/scripts/localhost_tests_<timestamp>.txt`
- **Per-test logs:**  
  `actionlog/test_suite/localhost/<TestName>_<timestamp>.log`

Each playbook still writes its own actionlog under `actionlog/<category>/<playbook_name>/` as in Phase 7.

---

## 10. Phase 9: Custom Inventories and Extra Variables

### 10.1 Using a Different Inventory File

Override the default inventory with `-i`:

```bash
ansible-playbook -i inventories/example_remote.ini playbooks/base/ping_test.yml
```

Use a copy of an example inventory and edit host names, IPs, and users as needed. Do not commit passwords; use SSH keys or Ansible Vault.

### 10.2 Passing Extra Variables to a Playbook

Use `-e` to set or override variables:

**Ping test with custom target and count:**

```bash
ansible-playbook playbooks/base/ping_test.yml -e target_host="1.1.1.1" -e ping_count=10
```

**Port scan with custom ports and timeout:**

```bash
ansible-playbook playbooks/system/port_scan.yml \
  -e target_hosts='["localhost","127.0.0.1"]' \
  -e target_ports='[22,80,443,3306,5432,8080]' \
  -e port_timeout=10
```

**SSL certificate check with custom URLs:**

```bash
ansible-playbook playbooks/system/ssl_cert_check.yml \
  -e target_urls='["https://example.com","https://test.com"]' \
  -e cert_timeout=15
```

**Traceroute with custom targets and max hops:**

```bash
ansible-playbook playbooks/system/traceroute_test.yml \
  -e target_hosts='["8.8.8.8","1.1.1.1","208.67.222.222"]' \
  -e max_hops=20
```

Variable names and allowed values are defined in each playbook; check the playbook’s `vars:` section or documentation.

### 10.3 Cisco or Other Network Device Playbooks

These require an inventory that points to real devices and often use `network_cli` or vendor-specific collections. Example:

```bash
# Copy and edit the example inventory first
cp inventories/example_cisco.ini inventories/my_cisco.ini
# Edit my_cisco.ini with your device IPs and credentials (use vault for secrets)

# Store credentials in group_vars/cisco-devices/vault.yml (see VAULT.md), then:
ansible-playbook -i inventories/my_cisco.ini playbooks/cisco/ssh_test.yml --ask-vault-pass
```

See **inventories/example_cisco.ini**, **playbooks/cisco/ssh_test.yml**, and **[VAULT.md](VAULT.md)** for credentials and vault setup.

### 10.4 Using Ansible Vault

Use **Ansible Vault** when a playbook needs secrets (passwords, API keys)—for example when connecting to network devices or remote hosts. Localhost-only playbooks (ping, curl, DNS, etc.) do not need vault.

#### When to use vault

- Playbooks that target **Cisco or other network devices** (e.g. `playbooks/cisco/ssh_test.yml`, `playbooks/multi-vendor/config_backup.yml`).
- Playbooks that target **remote servers** with password-based auth.
- Any variables you do **not** want stored in plain text in the repo.

#### Step 1: Create an encrypted vault file

Create a vault file for an inventory group (e.g. `cisco-devices`):

```bash
mkdir -p group_vars/cisco-devices
ansible-vault create group_vars/cisco-devices/vault.yml
```

You will be prompted for a **vault password**. Remember it; you need it whenever you run a playbook that uses this vault. In the editor, add variables such as:

```yaml
ansible_user: admin
ansible_password: your_ssh_password
ansible_become: yes
ansible_become_method: enable
ansible_become_password: your_enable_password
```

Save and exit. The file is encrypted. `.gitignore` already excludes `group_vars/*/vault`, so it will not be committed.

You can use the **agansible** CLI instead:

```bash
agansible vault create group_vars/cisco-devices/vault.yml
```

#### Step 2: Run a playbook that uses the vault

Pass the vault password so Ansible can decrypt the file:

```bash
ansible-playbook -i inventories/my_cisco.ini playbooks/cisco/ssh_test.yml --ask-vault-pass
```

Enter the vault password when prompted. Ansible loads `group_vars/cisco-devices/vault.yml` automatically for hosts in the `cisco-devices` group.

#### Step 3 (optional): Use a vault password file

To avoid typing the password each time (e.g. for automation):

```bash
# Create a password file (do not commit it)
echo 'your_vault_password' > vault/.vault_pass
chmod 600 vault/.vault_pass
```

The path `vault/.vault_pass` is in `.gitignore`. Then run:

```bash
ansible-playbook -i inventories/my_cisco.ini playbooks/cisco/ssh_test.yml --vault-password-file vault/.vault_pass
```

#### Common vault commands

| What you want to do | Command |
|---------------------|--------|
| Create new encrypted vault | `ansible-vault create group_vars/<group>/vault.yml` or `agansible vault create group_vars/<group>/vault.yml` |
| Edit existing vault | `ansible-vault edit group_vars/<group>/vault.yml` or `agansible vault edit ...` |
| View decrypted contents | `ansible-vault view group_vars/<group>/vault.yml` or `agansible vault view ...` |
| Encrypt a single string (for pasting into YAML) | `ansible-vault encrypt_string 'secret' --name 'ansible_password'` or `agansible vault encrypt-string 'secret' --name ansible_password` |

#### Where to put vault files

- **By group:** `group_vars/<group>/vault.yml` (e.g. `group_vars/cisco-devices/vault.yml`). Used for all hosts in that group.
- **By host:** `host_vars/<hostname>/vault.yml`. Used for a single host.

For more detail and security notes, see **[VAULT.md](VAULT.md)** and **vault/VAULT_README.md**.

---

## 11. Phase 10: Output Formats (Text, JSON, Both)

Playbooks that use the common actionlog role can write **text**, **JSON**, or **both**.

### 11.1 Default: Text

If you do nothing, playbooks write a **.txt** file (human-readable, as in Phase 8).

### 11.2 JSON Output

To request **JSON** actionlog files:

```bash
ansible-playbook playbooks/base/ping_test.yml -e output_format=json
```

Result is written to `actionlog/base/ping_test/ping_test_localhost_<timestamp>.json`.

### 11.3 Both Text and JSON

To write **both** .txt and .json for the same run:

```bash
ansible-playbook playbooks/base/ping_test.yml -e output_format=both
```

Two files are created with the same timestamp base name, one `.txt` and one `.json`.

### 11.4 Using JSON with test_localhost.sh

```bash
./test_localhost.sh --json
./test_localhost.sh --both
```

This passes `output_format=json` or `output_format=both` to the playbooks that support it.

### 11.5 Viewing JSON Results

```bash
# Pretty-print latest ping test JSON
ls -t actionlog/base/ping_test/*.json 2>/dev/null | head -1 | xargs cat | python3 -m json.tool
```

If you have `jq` installed:

```bash
ls -t actionlog/base/ping_test/*.json 2>/dev/null | head -1 | xargs jq .
```

### 11.6 Network Topology Discovery

To discover network topology using CDP/LLDP and visualize it:

1. **Run the discovery playbook** (requires network devices with CDP/LLDP and an inventory with `network_devices`):
   ```bash
   ansible-playbook -i inventories/example_cisco.ini playbooks/topology/discover_topology.yml
   ```
2. **Visualize** (from project root): text summary, SVG (no extra deps), DOT, or PNG:
   ```bash
   python3 scripts/visualize_topology.py topology text
   python3 scripts/visualize_topology.py topology svg
   python3 scripts/visualize_topology.py topology png   # requires networkx + matplotlib
   ```
   Diagrams show Core <> Access <> Access ordering, interface labels on links, and brand/platform on nodes when present in the JSON.

See **[../playbooks/topology/TOPOLOGY_README.md](../playbooks/topology/TOPOLOGY_README.md)** for the full flow (CDP/LLDP → module → JSON → visualization) and **[../topology/TOPOLOGY_EXAMPLE_README.md](../topology/TOPOLOGY_EXAMPLE_README.md)** for the example topology.

---

## 12. Troubleshooting

### 12.1 "WSL not installed" or "wsl: command not found"

- **Cause:** WSL2 is not installed or not on PATH.
- **Fix:** On Windows, open PowerShell as Administrator and run `wsl --install`. Restart Windows if prompted. See **[WSL_SETUP.md](WSL_SETUP.md)**.

### 12.2 "Ansible not found" or "ansible-playbook: command not found"

- **Cause:** Ansible was not installed or not on your PATH.
- **Fix:** From the AGAnsible directory run `./install.sh`. Then run `which ansible-playbook` and `ansible --version` to confirm.

### 12.3 "Permission denied" when running install.sh or verify.sh

- **Cause:** Script is not executable or wrong user.
- **Fix:**
  ```bash
  chmod +x install.sh verify.sh test_localhost.sh test_all.sh
  ```
  Run as your normal user (not root); the scripts will use `sudo` when needed.

### 12.4 "curl is not installed" or "dig: command not found"

- **Cause:** System tools required by some playbooks are missing.
- **Fix:** Run `./install.sh` again; it installs curl and dnsutils. Or install manually:
  ```bash
  sudo apt-get update
  sudo apt-get install -y curl dnsutils
  ```

### 12.5 Playbook fails with "multiprocessing" or permission errors

- **Cause:** Some environments restrict use of multiprocessing or /dev/shm.
- **Fix:** The project uses `forks = 1` in ansible.cfg. If issues persist, run with:
  ```bash
  ansible-playbook --forks 1 playbooks/base/ping_test.yml
  ```
  Or set `ANSIBLE_FORKS=1` in the environment.

### 12.6 Ping test or connectivity test fails (e.g. 100% packet loss)

- **Cause:** Network or firewall blocking ICMP/HTTP/DNS.
- **Fix:**
  - Check internet: `ping -c 4 8.8.8.8` and `curl -I https://www.google.com`.
  - If using WSL, from Windows PowerShell run `wsl --shutdown`, then start WSL again.
  - Ensure no firewall is blocking outbound traffic.

### 12.7 "No such file or directory" for playbook or inventory

- **Cause:** You are not in the AGAnsible directory or path is wrong.
- **Fix:** Always run from the project root:
  ```bash
  cd /path/to/AGAnsible
  ansible-playbook playbooks/base/ping_test.yml
  ```
  Use absolute or correct relative paths if you use `-i` or custom paths.

### 12.8 Actionlog directory missing or not writable

- **Cause:** First run may create it; or permissions.
- **Fix:** Playbooks create `actionlog/<category>/<playbook_name>/` automatically. If you get permission errors:
  ```bash
  mkdir -p actionlog
  chmod -R u+rwX actionlog
  ```
  Run playbooks as the same user that owns the AGAnsible directory.

### 12.9 Syntax check fails for a playbook

- **Cause:** YAML or Ansible syntax error in the playbook.
- **Fix:** Run:
  ```bash
  ansible-playbook --syntax-check playbooks/base/ping_test.yml
  ```
  Fix the reported line and try again. To lint: `./scripts/lint.sh` or `pre-commit run`.

---

## 13. Quick Reference and Checklists

### 13.1 Full Journey Checklist

- [ ] **Environment:** WSL2 installed and updated (Windows) or native Linux ready.
- [ ] **Clone:** `git clone https://github.com/JaredUbriaco/AGAnsible.git` and `cd AGAnsible`.
- [ ] **Install:** `chmod +x install.sh && ./install.sh` — all tools installed, no errors.
- [ ] **Verify:** `./verify.sh` — all checks ✅.
- [ ] **First test:** `ansible-playbook playbooks/base/ping_test.yml` — SUCCESS and file under `actionlog/base/ping_test/`.
- [ ] **Review result:** `ls -t actionlog/base/ping_test/*.txt | head -1 | xargs cat` — STATUS: SUCCESS, VALIDATION: PASS.
- [ ] **Optional:** `./test_localhost.sh` — all 9 localhost tests PASS.

### 13.2 One-Line “From Zero” Summary (Copy-Paste)

```bash
# Windows: install WSL2 first (PowerShell as Admin: wsl --install), restart, then in WSL:
cd ~ && git clone https://github.com/JaredUbriaco/AGAnsible.git && cd AGAnsible && chmod +x install.sh verify.sh test_localhost.sh && ./install.sh && ./verify.sh && ansible-playbook playbooks/base/ping_test.yml
```

### 13.3 Where Things Live (Quick Table)

| What | Where |
|------|--------|
| Default inventory | `inventories/localhost.ini` |
| Ansible config | `ansible.cfg` |
| Playbooks | `playbooks/base/`, `playbooks/system/`, `playbooks/cisco/`, etc. |
| Shared tasks (actionlog, timestamp, write) | `roles/common/tasks/` |
| Ping test results | `actionlog/base/ping_test/*.txt` or `*.json` |
| Curl test results | `actionlog/system/curl_test/` |
| DNS test results | `actionlog/system/dns_test/` |
| Other system test results | `actionlog/system/<playbook_name>/` |
| Install/verify/suite logs | `actionlog/scripts/`, `actionlog/test_suite/` |

### 13.4 Related Documentation

| Document | Purpose |
|----------|---------|
| **[../README.md](../README.md)** | Project overview, table of contents, and main links. |
| **[WSL_SETUP.md](WSL_SETUP.md)** | Detailed WSL2 setup for Windows. |
| **[REQUIREMENTS.md](REQUIREMENTS.md)** | System requirements and dependencies. |
| **[VAULT.md](VAULT.md)** | Ansible Vault setup and usage for secrets. |
| **[../playbooks/topology/TOPOLOGY_README.md](../playbooks/topology/TOPOLOGY_README.md)** | Topology discovery (CDP/LLDP), module, visualization flow. |
| **[../topology/TOPOLOGY_EXAMPLE_README.md](../topology/TOPOLOGY_EXAMPLE_README.md)** | Example topology (Core <> Access <> Access) and SVG/PNG generation. |

---

**Last updated:** January 2026  
**Applies to:** AGAnsible suite on WSL2 (Debian/Ubuntu) and native Linux.
