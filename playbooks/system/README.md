# System Playbooks

System-level playbooks that can run on localhost without requiring network devices.

## Available Playbooks

### 1. `ping_test.yml`
**Purpose**: Network connectivity test using ICMP ping  
**Target**: Any IP address (default: 8.8.8.8)  
**Requirements**: `ping` command  
**Usage**: `ansible-playbook playbooks/system/ping_test.yml`

### 2. `curl_test.yml`
**Purpose**: HTTP/HTTPS connectivity test  
**Target**: Any URL (default: google.com, httpbin.org)  
**Requirements**: `curl` command  
**Usage**: `ansible-playbook playbooks/system/curl_test.yml`

### 3. `dns_test.yml`
**Purpose**: DNS resolution test  
**Target**: Any domain name (default: zappos.com)  
**DNS Server**: Configurable (default: 1.1.1.1)  
**Requirements**: `dig` or `nslookup`  
**Usage**: `ansible-playbook playbooks/system/dns_test.yml`

### 4. `port_scan.yml` ⭐ NEW
**Purpose**: Test TCP port connectivity  
**Target**: localhost, 127.0.0.1, or any host  
**Ports**: Configurable (default: 22, 80, 443, 8080)  
**Requirements**: `nc` (netcat) or Python3  
**Usage**: `ansible-playbook playbooks/system/port_scan.yml`

### 5. `network_interfaces.yml` ⭐ NEW
**Purpose**: Collect network interface information  
**Target**: localhost  
**Requirements**: `ip` command or `ifconfig`  
**Usage**: `ansible-playbook playbooks/system/network_interfaces.yml`

### 6. `ssl_cert_check.yml` ⭐ NEW
**Purpose**: Validate SSL/TLS certificates  
**Target**: HTTPS URLs (default: google.com, github.com, cloudflare.com)  
**Requirements**: `openssl` or Python3  
**Usage**: `ansible-playbook playbooks/system/ssl_cert_check.yml`

### 7. `traceroute_test.yml` ⭐ NEW
**Purpose**: Network path discovery  
**Target**: Any IP address (default: 8.8.8.8, 1.1.1.1)  
**Requirements**: `traceroute`, `mtr`, or Python3 (with root)  
**Usage**: `ansible-playbook playbooks/system/traceroute_test.yml`

### 8. `network_stats.yml` ⭐ NEW
**Purpose**: Network interface statistics  
**Target**: localhost  
**Requirements**: `ss` command, `/proc/net/dev` access  
**Usage**: `ansible-playbook playbooks/system/network_stats.yml`

### 9. `firewall_check.yml` ⭐ NEW
**Purpose**: Firewall configuration check  
**Target**: localhost  
**Requirements**: `iptables`, `nftables`, or `ufw`  
**Usage**: `ansible-playbook playbooks/system/firewall_check.yml`

## Customization

All playbooks support the following variables:

- `output_format`: "text", "json", or "both" (default: "text")
- `validate_json_schema`: true/false (default: false)

Playbook-specific variables are documented in each playbook file.

## Examples

### Run with JSON output:
```bash
ansible-playbook playbooks/system/ping_test.yml -e output_format=json
```

### Run with both formats:
```bash
ansible-playbook playbooks/system/curl_test.yml -e output_format=both
```

### Customize port scan:
```bash
ansible-playbook playbooks/system/port_scan.yml \
  -e target_hosts='["localhost","127.0.0.1"]' \
  -e target_ports='[22,80,443,3306,5432]'
```

### Customize SSL check:
```bash
ansible-playbook playbooks/system/ssl_cert_check.yml \
  -e target_urls='["https://example.com","https://test.com"]'
```

## Output

All playbooks create actionlog files in:
- `actionlog/system/<playbook_name>/`

Files are created in the format:
- `<playbook_name>_<host>_<timestamp>.txt`
- `<playbook_name>_<host>_<timestamp>.json` (if JSON format enabled)
