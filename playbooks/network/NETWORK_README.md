# Network Protocol Monitoring Playbooks

Playbooks for monitoring advanced network protocols and routing.

## Available Playbooks

### `bgp_status.yml`
**Purpose**: Monitor BGP (Border Gateway Protocol) neighbor status and routing information

**Supported Devices**:
- Cisco IOS
- Juniper JunOS
- Arista EOS

**Usage**:
```bash
ansible-playbook -i inventories/example_cisco.ini playbooks/network/bgp_status.yml
```

**Output**:
- BGP neighbor count
- BGP status (UP/DOWN)
- Full BGP summary output
- Results saved to `actionlog/network/bgp_status/`

### `ospf_status.yml`
**Purpose**: Monitor OSPF (Open Shortest Path First) neighbor status and routing information

**Supported Devices**:
- Cisco IOS
- Juniper JunOS
- Arista EOS

**Usage**:
```bash
ansible-playbook -i inventories/example_cisco.ini playbooks/network/ospf_status.yml
```

**Output**:
- OSPF neighbor count
- Neighbors in FULL state
- Neighbors in other states (INIT, TWO-WAY, EXSTART, EXCHANGE, LOADING)
- OSPF status
- Results saved to `actionlog/network/ospf_status/`

### `mpls_lsp.yml`
**Purpose**: Monitor MPLS LSP (Label Switched Path) status and statistics

**Supported Devices**:
- Juniper JunOS (full support)
- Cisco IOS (LDP neighbor support)
- Arista EOS (LDP neighbor support)

**Usage**:
```bash
ansible-playbook -i inventories/example_juniper.ini playbooks/network/mpls_lsp.yml
```

**Output**:
- MPLS LSP count (Juniper)
- LSPs in UP state
- LSPs in DOWN state
- LDP neighbor count (Cisco/Arista)
- Results saved to `actionlog/network/mpls_lsp/`

## Prerequisites

1. **Install Required Collections**:
   ```bash
   ansible-galaxy collection install -r requirements.yml
   ```

2. **Configure Inventory**:
   - Use appropriate inventory file for your device type
   - Set `ansible_network_os` variable correctly
   - Configure credentials securely using ansible-vault

3. **Device Access**:
   - SSH access to network devices
   - Appropriate user permissions
   - Network connectivity

## Example Inventories

- `inventories/example_cisco.ini` - Cisco devices
- `inventories/example_juniper.ini` - Juniper devices
- `inventories/example_arista.ini` - Arista devices

## Variables

All playbooks support standard variables:
- `output_format`: "text", "json", or "both" (default: "text")
- `validate_json_schema`: true/false (default: false)
- `api_response_format`: true/false (default: false)

## Troubleshooting

### "Device not supported" error
- Ensure `ansible_network_os` is set correctly in inventory
- Verify the device type is in the supported list
- Check that the appropriate collection is installed

### "Command execution failed"
- Verify SSH connectivity to device
- Check user permissions
- Ensure the protocol is configured on the device
- Review device logs for errors

### "Collection not found"
- Install collections: `ansible-galaxy collection install -r requirements.yml`
- Verify collection name matches requirements.yml
- Check Ansible version compatibility

## Best Practices

1. **Use ansible-vault** for storing credentials
2. **Test on non-production devices** first
3. **Review actionlog files** for detailed results
4. **Monitor regularly** to establish baselines
5. **Set up alerts** for critical protocol failures

## Future Enhancements

- IS-IS protocol monitoring
- EIGRP monitoring
- RIP monitoring
- Protocol-specific health checks
- Automated remediation actions
