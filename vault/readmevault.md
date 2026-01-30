# Ansible Vault

This directory holds **templates and documentation** for using Ansible Vault with AGAnsible. Encrypted vault files and vault password files should **not** be committed to git.

## Quick start

1. **Create a vault file** for a group (e.g. Cisco devices):
   ```bash
   mkdir -p group_vars/cisco-devices
   ansible-vault create group_vars/cisco-devices/vault.yml
   ```
   Add variables such as `ansible_user`, `ansible_password`, `ansible_become_password` (see `vault.example.yml`).

2. **Run a playbook** that needs those variables:
   ```bash
   ansible-playbook -i inventories/example_cisco.ini playbooks/cisco/ssh_test.yml --ask-vault-pass
   ```
   Or use a password file: `ansible-playbook ... --vault-password-file vault/.vault_pass` (add `vault/.vault_pass` to `.gitignore`).

## Template

- **`vault.example.yml`** – Unencrypted example showing variable names. Copy its structure into your vault file; do not put real secrets in the example.

## Where to put vault files

| Purpose | Location | Encrypt with |
|--------|----------|--------------|
| Group secrets (e.g. cisco-devices) | `group_vars/<group>/vault.yml` | `ansible-vault create` |
| Host secrets | `host_vars/<host>/vault.yml` | `ansible-vault create` |

These paths are already in `.gitignore` (`group_vars/*/vault`, `host_vars/*/vault`, `*.vault`), so encrypted files are not committed.

## Common commands

```bash
# Create new encrypted vault
ansible-vault create group_vars/cisco-devices/vault.yml

# Edit existing vault
ansible-vault edit group_vars/cisco-devices/vault.yml

# View (decrypt and display)
ansible-vault view group_vars/cisco-devices/vault.yml

# Encrypt an existing file
ansible-vault encrypt group_vars/cisco-devices/vault.yml

# Encrypt a single string (for pasting into YAML)
ansible-vault encrypt_string 'my_secret' --name 'ansible_password'
```

## Using the agansible CLI

```bash
agansible vault create group_vars/cisco-devices/vault.yml
agansible vault edit group_vars/cisco-devices/vault.yml
agansible vault view group_vars/cisco-devices/vault.yml
agansible vault encrypt-string 'secret' --name ansible_password
```

See **[docs/VAULT.md](../docs/VAULT.md)** for full documentation.
