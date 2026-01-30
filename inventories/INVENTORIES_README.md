# Inventory Files

This directory contains inventory files that define target hosts for Ansible playbooks.

## Available Inventories

### `localhost.ini`
**Purpose**: Local testing and development  
**Usage**: Default inventory for local system testing  
**Example**: `ansible-playbook playbooks/base/ping_test.yml`

### `example_remote.ini`
**Purpose**: Template for remote Linux servers  
**Usage**: Copy and modify with your actual remote hosts  
**Example**: `ansible-playbook -i inventories/example_remote.ini playbooks/system/curl_test.yml`

### `example_cisco.ini`
**Purpose**: Template for Cisco network devices  
**Usage**: Copy and modify with your actual Cisco devices  
**Prerequisites**: 
- Install Cisco collection: `ansible-galaxy collection install cisco.ios`
- Configure credentials securely using ansible-vault  
**Example**: `ansible-playbook -i inventories/example_cisco.ini playbooks/cisco/ssh_test.yml`

### `example_multi_host.ini`
**Purpose**: Template for multi-environment setups (dev/staging/prod)  
**Usage**: Copy and modify for your multi-host environments  
**Example**: `ansible-playbook -i inventories/example_multi_host.ini playbooks/base/ping_test.yml`

## Using Inventories

### Basic Usage
```bash
# Use default inventory (localhost.ini)
ansible-playbook playbooks/base/ping_test.yml

# Specify a different inventory
ansible-playbook -i inventories/example_remote.ini playbooks/system/curl_test.yml

# Use multiple inventories
ansible-playbook -i inventories/localhost.ini -i inventories/example_remote.ini playbook.yml
```

### Inventory Variables

Inventories can define variables at different levels:
- **Host variables**: Defined inline with host
- **Group variables**: Defined in `[group:vars]` section
- **All variables**: Defined in `[all:vars]` section

### Secure Credential Management

**Never commit passwords or secrets to git!**

Use ansible-vault for secure credential storage:

```bash
# Create encrypted vault file
ansible-vault create group_vars/cisco-devices/vault.yml

# Edit encrypted vault file
ansible-vault edit group_vars/cisco-devices/vault.yml

# View encrypted vault file
ansible-vault view group_vars/cisco-devices/vault.yml
```

Example vault content:
```yaml
ansible_user: admin
ansible_password: !vault |
          $ANSIBLE_VAULT;1.1;AES256
          663864396539663162646264356130...
ansible_become_password: !vault |
          $ANSIBLE_VAULT;1.1;AES256
          663864396539663162646264356130...
```

## Creating Custom Inventories

1. Copy an example inventory file
2. Modify host names and IP addresses
3. Update connection variables (ansible_user, ansible_host, etc.)
4. Add group-specific variables as needed
5. Store credentials securely using ansible-vault

## Inventory Best Practices

1. **Use descriptive group names**: `web-servers`, `db-servers`, `cisco-routers`
2. **Organize by function**: Group related hosts together
3. **Use variables**: Avoid hardcoding values
4. **Secure credentials**: Use ansible-vault, not plain text
5. **Document purpose**: Add comments explaining inventory structure
6. **Version control**: Commit inventory templates, not production inventories with secrets

## Dynamic Inventories

For cloud environments, consider using dynamic inventory plugins:
- AWS EC2: `amazon.aws.aws_ec2`
- Azure: `azure.azcollection.azure_rm`
- GCP: `google.cloud.gcp_compute`

See Ansible documentation for dynamic inventory setup.
