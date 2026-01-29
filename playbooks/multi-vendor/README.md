# Multi-Vendor Network Device Playbooks

Playbooks that support multiple network device vendors.

## Available Playbooks

### `config_backup.yml`
**Purpose**: Backup configurations from multiple vendor devices

**Supported Vendors**:
- Cisco IOS
- Cisco NXOS
- Juniper JunOS
- Arista EOS

**Usage**:
```bash
# Backup all devices in inventory
ansible-playbook -i inventories/example_multi_host.ini playbooks/multi-vendor/config_backup.yml

# Backup specific group
ansible-playbook -i inventories/example_cisco.ini playbooks/multi-vendor/config_backup.yml --limit cisco-routers
```

**Features**:
- Automatic vendor detection
- Vendor-specific backup commands
- Organized backup storage by vendor
- Timestamped backup files
- Comprehensive logging

**Backup Locations**:
- Cisco IOS: `backups/cisco-ios/`
- Cisco NXOS: `backups/cisco-nxos/`
- Juniper JunOS: `backups/juniper-junos/`
- Arista EOS: `backups/arista-eos/`

**Output**:
- Backup files saved to `backups/` directory
- Results logged to `actionlog/multi-vendor/config_backup/`

## Prerequisites

1. **Install Required Collections**:
   ```bash
   ansible-galaxy collection install -r requirements.yml
   ```

2. **Configure Inventory**:
   - Set `ansible_network_os` for each device:
     - `cisco.ios.ios` for Cisco IOS
     - `cisco.nxos.nxos` for Cisco NXOS
     - `junipernetworks.junos.junos` for Juniper JunOS
     - `arista.eos.eos` for Arista EOS

3. **Credentials**:
   - Configure SSH credentials
   - Use ansible-vault for secure storage

## Example Multi-Vendor Inventory

```ini
[cisco-devices]
router1 ansible_host=10.0.0.1 ansible_network_os=cisco.ios.ios

[juniper-devices]
router2 ansible_host=10.0.0.2 ansible_network_os=junipernetworks.junos.junos

[arista-devices]
switch1 ansible_host=10.0.0.3 ansible_network_os=arista.eos.eos

[all-network-devices:children]
cisco-devices
juniper-devices
arista-devices
```

## Variables

- `backup_dir`: Directory for backups (default: `backups/`)
- `backup_timestamp`: Timestamp for backup files (auto-generated)
- `output_format`: "text", "json", or "both" (default: "text")

## Troubleshooting

### "Unsupported device type"
- Verify `ansible_network_os` is set correctly
- Check that the appropriate collection is installed
- Ensure the device type matches a supported vendor

### "Backup failed"
- Check SSH connectivity
- Verify user permissions
- Review device logs
- Check disk space on backup location

### "Collection not found"
- Install collections: `ansible-galaxy collection install -r requirements.yml`
- Verify collection installation: `ansible-galaxy collection list`

## Best Practices

1. **Regular Backups**: Schedule regular configuration backups
2. **Version Control**: Consider committing backups to git (without secrets)
3. **Secure Storage**: Store backups securely, especially if they contain credentials
4. **Test Restores**: Periodically test configuration restore procedures
5. **Documentation**: Document backup procedures and locations

## Future Enhancements

- Configuration comparison (diff)
- Automated restore procedures
- Configuration validation
- Compliance checking
- Change tracking
