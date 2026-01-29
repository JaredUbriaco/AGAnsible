# Group Variables

This directory contains variable files that apply to groups of hosts.

## File Structure

### `all.yml`
**Purpose**: Default variables for all hosts  
**Usage**: Automatically loaded for all hosts  
**Override**: Can be overridden by group-specific or host-specific variables

### Creating Group-Specific Variables

Create files named after your inventory groups:

- `group_vars/web-servers.yml` - Variables for [web-servers] group
- `group_vars/db-servers.yml` - Variables for [db-servers] group
- `group_vars/cisco-devices.yml` - Variables for [cisco-devices] group

## Variable Precedence

Variables are applied in this order (later overrides earlier):

1. `group_vars/all.yml` - Defaults for all hosts
2. `group_vars/<group_name>.yml` - Group-specific variables
3. `host_vars/<hostname>.yml` - Host-specific variables
4. Inventory file variables (`[group:vars]`)
5. Command line variables (`-e variable=value`)

## Usage Examples

### Override Default DNS Server
```bash
# Use different DNS server
ansible-playbook playbooks/system/dns_test.yml -e dns_default_server=8.8.8.8
```

### Override Ping Target
```bash
# Ping different host
ansible-playbook playbooks/base/ping_test.yml -e ping_default_target=1.1.1.1
```

### Create Group-Specific Variables
```yaml
# group_vars/production.yml
ping_default_count: 10
curl_default_timeout: 30
validation_max_packet_loss: 0
```

## Secure Variables

For sensitive data (passwords, API keys), use ansible-vault:

```bash
# Create encrypted vault file
ansible-vault create group_vars/production/vault.yml

# Edit encrypted vault file
ansible-vault edit group_vars/production/vault.yml
```

Then reference in your playbooks:
```yaml
ansible_password: "{{ vault_password }}"
```

## Best Practices

1. **Use descriptive names**: `ping_default_count` not `count`
2. **Document defaults**: Add comments explaining variable purpose
3. **Group logically**: Related variables together
4. **Secure secrets**: Use ansible-vault, never commit plain text passwords
5. **Version control**: Commit variable templates, not production secrets
