# Localhost-Capable Tests for AGAnsible

This document lists all playbooks and tests that can run on localhost without requiring actual network devices or remote infrastructure.

## Current System Tests (✅ Implemented)

### 1. **Ping Test** (`playbooks/system/ping_test.yml`)
- **Purpose**: Network connectivity test
- **What it tests**: ICMP ping to target IP
- **Can run on**: localhost
- **Status**: ✅ Working

### 2. **Curl Test** (`playbooks/system/curl_test.yml`)
- **Purpose**: HTTP/HTTPS connectivity
- **What it tests**: HTTP requests to web servers
- **Can run on**: localhost
- **Status**: ✅ Working

### 3. **DNS Test** (`playbooks/system/dns_test.yml`)
- **Purpose**: DNS resolution
- **What it tests**: DNS queries to different DNS servers
- **Can run on**: localhost
- **Status**: ✅ Working

### 4. **Port Scan** (`playbooks/system/port_scan.yml`) ⭐ NEW
- **Purpose**: TCP port connectivity
- **What it tests**: Port availability on target hosts
- **Can run on**: localhost (tests localhost ports)
- **Status**: ✅ Created (ready to test)

### 5. **Network Interfaces** (`playbooks/system/network_interfaces.yml`) ⭐ NEW
- **Purpose**: Network interface information
- **What it tests**: Interface configuration, routing, DNS
- **Can run on**: localhost
- **Status**: ✅ Created (ready to test)

### 6. **SSL Certificate Check** (`playbooks/system/ssl_cert_check.yml`) ⭐ NEW
- **Purpose**: SSL/TLS certificate validation
- **What it tests**: Certificate validity and expiration
- **Can run on**: localhost (tests remote HTTPS endpoints)
- **Status**: ✅ Created (ready to test)

## Additional Tests We Should Add

### 7. **Traceroute Test** (Recommended)
- **Purpose**: Network path discovery
- **What it tests**: Route packets take to destination
- **Can run on**: localhost
- **Tools needed**: `traceroute` or `mtr`
- **Status**: ⚠️ Not yet implemented

### 8. **Bandwidth Test** (Recommended)
- **Purpose**: Network throughput measurement
- **What it tests**: Upload/download speeds
- **Can run on**: localhost (with iperf3 server)
- **Tools needed**: `iperf3`
- **Status**: ⚠️ Partially implemented in `performance_test.yml`

### 9. **Network Statistics** (Recommended)
- **Purpose**: Network interface statistics
- **What it tests**: Bytes sent/received, packet counts, errors
- **Can run on**: localhost
- **Tools needed**: `ss`, `netstat`, or `/proc/net/dev`
- **Status**: ⚠️ Not yet implemented

### 10. **Firewall Rules Check** (Recommended)
- **Purpose**: Local firewall configuration
- **What it tests**: iptables/nftables rules
- **Can run on**: localhost
- **Tools needed**: `iptables`, `nftables`, or `ufw`
- **Status**: ⚠️ Not yet implemented

### 11. **ARP Table Check** (Optional)
- **Purpose**: ARP table information
- **What it tests**: MAC address to IP mappings
- **Can run on**: localhost
- **Tools needed**: `arp` or `ip neigh`
- **Status**: ⚠️ Not yet implemented

### 12. **Service Status Check** (Optional)
- **Purpose**: Network service status
- **What it tests**: SSH, HTTP, DNS services running
- **Can run on**: localhost
- **Tools needed**: `systemctl`, `service`, or `ss`
- **Status**: ⚠️ Not yet implemented

### 13. **DNS Resolution Speed** (Optional)
- **Purpose**: DNS query performance
- **What it tests**: Response time for DNS queries
- **Can run on**: localhost
- **Tools needed**: `dig` with timing
- **Status**: ⚠️ Not yet implemented

### 14. **HTTP Response Time** (Optional)
- **Purpose**: Web server response time
- **What it tests**: HTTP request/response latency
- **Can run on**: localhost (tests remote servers)
- **Tools needed**: `curl` with timing
- **Status**: ⚠️ Not yet implemented

### 15. **Localhost Performance Test** (Optional)
- **Purpose**: Local network stack performance
- **What it tests**: Loopback interface performance
- **Can run on**: localhost
- **Tools needed**: `iperf3` (localhost to localhost)
- **Status**: ⚠️ Partially implemented in `performance_test.yml`

## Tests That Require Network Devices (Cannot Run on Localhost)

These tests require actual network infrastructure:

- **BGP Status** (`playbooks/network/bgp_status.yml`) - Requires BGP-enabled router
- **OSPF Status** (`playbooks/network/ospf_status.yml`) - Requires OSPF-enabled router
- **MPLS LSP** (`playbooks/network/mpls_lsp.yml`) - Requires MPLS-enabled router
- **Config Backup** (`playbooks/multi-vendor/config_backup.yml`) - Requires network device
- **Topology Discovery** (`playbooks/topology/discover_topology.yml`) - Requires network devices with CDP/LLDP
- **Cisco SSH Test** (`playbooks/cisco/ssh_test.yml`) - Requires Cisco device

## Recommended Implementation Priority

### High Priority (Most Useful)
1. ✅ **Port Scan** - Already created
2. ✅ **Network Interfaces** - Already created
3. ✅ **SSL Certificate Check** - Already created
4. **Traceroute Test** - Network path discovery
5. **Network Statistics** - Interface performance metrics

### Medium Priority (Useful)
6. **Bandwidth Test** - Throughput measurement (enhance existing)
7. **Firewall Rules Check** - Security validation
8. **Service Status Check** - Service availability

### Low Priority (Nice to Have)
9. **ARP Table Check** - Network layer information
10. **DNS Resolution Speed** - Performance metric
11. **HTTP Response Time** - Performance metric
12. **Localhost Performance Test** - Loopback performance

## Usage Examples

### Run all system tests:
```bash
# Test individual playbooks
ansible-playbook playbooks/system/ping_test.yml -e output_format=both
ansible-playbook playbooks/system/curl_test.yml -e output_format=both
ansible-playbook playbooks/system/dns_test.yml -e output_format=both
ansible-playbook playbooks/system/port_scan.yml -e output_format=both
ansible-playbook playbooks/system/network_interfaces.yml -e output_format=both
ansible-playbook playbooks/system/ssl_cert_check.yml -e output_format=both
```

### Customize tests:
```bash
# Port scan with custom ports
ansible-playbook playbooks/system/port_scan.yml \
  -e target_hosts='["localhost"]' \
  -e target_ports='[22,80,443,3306,5432,8080]'

# SSL check with custom URLs
ansible-playbook playbooks/system/ssl_cert_check.yml \
  -e target_urls='["https://example.com","https://test.com"]'
```

## Summary

**Current Status**:
- ✅ 6 system tests implemented
- ⚠️ 9 additional tests recommended
- ✅ All tests support actionlog (text + JSON)
- ✅ All tests can run on localhost

**Next Steps**:
1. Test the 3 new playbooks (port_scan, network_interfaces, ssl_cert_check)
2. Implement traceroute test
3. Implement network statistics test
4. Enhance bandwidth test for localhost
