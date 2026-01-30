# Ansible Vault

AGAnsible uses **Ansible Vault** for storing secrets (passwords, API keys) so they are encrypted at rest and never committed in plain text.

## When to use vault

- Playbooks that connect to **network devices** (e.g. Cisco SSH) or **remote hosts** need credentials.
- Store those credentials in **encrypted vault files** and reference them from inventory or group_vars.
- **Localhost-only** playbooks (ping, curl, DNS, etc.) do not need vault.

## Encrypting the SSH password

Yes. You can encrypt the SSH password (and enable password) in two ways:

### Method 1: Whole file encrypted (recommended)

Put `ansible_password` and other secrets in a vault file, then encrypt the **entire file**. On disk the file is encrypted; nothing is stored in plain text.

```bash
ansible-vault create group_vars/cisco-devices/vault.yml
```

Inside the editor, add plain YAML (Ansible encrypts the file when you save):

```yaml
ansible_user: admin
ansible_password: your_ssh_password
ansible_become_password: your_enable_password
```

Run playbooks with `--ask-vault-pass` or `--vault-password-file` so Ansible can decrypt the file. The SSH password is never written to disk in plain text.

### Method 2: Encrypt only the password string

Encrypt just the password value and paste it into YAML as a `!vault |` block. The rest of the file can stay in plain text (or you can mix encrypted and non-encrypted vars).

```bash
ansible-vault encrypt_string 'your_ssh_password' --name 'ansible_password'
```

Paste the output into your vault or group_vars file:

```yaml
ansible_user: admin
ansible_password: !vault |
          $ANSIBLE_VAULT;1.1;AES256
          663864396539663162646264356130...
ansible_become_password: !vault |
          $ANSIBLE_VAULT;1.1;AES256
          ...
```

You still need to provide the vault password when running playbooks (`--ask-vault-pass` or `--vault-password-file`). Use `agansible vault encrypt-string 'secret' --name ansible_password` for the same via the CLI.

**Summary:** Method 1 = one encrypted file (simplest). Method 2 = individual encrypted strings (useful if you want to commit a file that contains only encrypted secrets and no plain-text passwords).

## Quick start

### 1. Create an encrypted vault file

For a group (e.g. `cisco-devices`):

```bash
mkdir -p group_vars/cisco-devices
ansible-vault create group_vars/cisco-devices/vault.yml
```

You will be prompted for a **vault password**. Remember it; you will need it when running playbooks. Add variables such as:

```yaml
ansible_user: admin
ansible_password: your_ssh_password
ansible_become: yes
ansible_become_method: enable
ansible_become_password: your_enable_password
```

Save and exit. The file is encrypted; `.gitignore` already excludes `group_vars/*/vault` so it will not be committed.

### 2. Run a playbook that uses vault

```bash
ansible-playbook -i inventories/example_cisco.ini playbooks/cisco/ssh_test.yml --ask-vault-pass
```

Enter the vault password when prompted.

### 3. Optional: use a vault password file

To avoid typing the password every time (e.g. in automation):

```bash
# Create a password file (do not commit it)
echo 'your_vault_password' > vault/.vault_pass
chmod 600 vault/.vault_pass
```

Add `vault/.vault_pass` to `.gitignore`, then run:

```bash
ansible-playbook -i inventories/example_cisco.ini playbooks/cisco/ssh_test.yml --vault-password-file vault/.vault_pass
```

## Common commands

| Action | Command |
|--------|--------|
| Create new vault | `ansible-vault create group_vars/<group>/vault.yml` |
| Edit vault | `ansible-vault edit group_vars/<group>/vault.yml` |
| View (decrypt only) | `ansible-vault view group_vars/<group>/vault.yml` |
| Encrypt existing file | `ansible-vault encrypt group_vars/<group>/vault.yml` |
| Decrypt file | `ansible-vault decrypt group_vars/<group>/vault.yml` |
| Encrypt a string | `ansible-vault encrypt_string 'secret' --name 'variable_name'` |

## Using the agansible CLI

```bash
agansible vault create group_vars/cisco-devices/vault.yml
agansible vault edit group_vars/cisco-devices/vault.yml
agansible vault view group_vars/cisco-devices/vault.yml
agansible vault encrypt-string 'my_secret' --name ansible_password
```

These delegate to `ansible-vault`; you will be prompted for the vault password when required.

## Where vault files live

| Location | Purpose |
|----------|---------|
| `group_vars/<group>/vault.yml` | Secrets for an inventory group (e.g. cisco-devices) |
| `host_vars/<host>/vault.yml` | Secrets for a single host |

Inventory or non-secret group_vars can reference vault variables. Example in `group_vars/cisco-devices.yml` (unencrypted):

```yaml
# Load vault variables (vault.yml in same directory is auto-loaded when encrypted)
# Or use: ansible_password: "{{ vault_password }}" and define vault_password in vault.yml
```

Ansible automatically loads `group_vars/<group>/vault.yml` when present; ensure the play runs with `--ask-vault-pass` or `--vault-password-file` so the file can be decrypted.

## Security

- **Never commit** vault password files or unencrypted secrets.
- `.gitignore` already includes: `group_vars/*/vault`, `host_vars/*/vault`, `*.vault`, `**/secrets.yml`, `**/passwords.yml`, `**/credentials.yml`.
- Use a strong vault password and restrict access to the password file (e.g. `chmod 600`).
- For CI/CD, use a secret manager or environment variable for the vault password and pass it via `--vault-password-file` or `ANSIBLE_VAULT_PASSWORD_FILE`.

## Improvements and best practices

- **Rekey after rotation:** If you change the vault password, re-encrypt existing vault files:  
  `ansible-vault rekey group_vars/cisco-devices/vault.yml`
- **SSH keys instead of passwords:** Where possible use `ansible_ssh_private_key_file` and key-based auth; then vault only the key file path or use a small vault for the few hosts that still need a password.
- **Separate vaults per environment:** Use different vault files (e.g. `group_vars/production/vault.yml` vs `group_vars/staging/vault.yml`) or [Vault IDs](https://docs.ansible.com/ansible/latest/vault_guide/vault_managing_passwords.html#using-multiple-vault-passwords) so one compromise doesn’t expose all environments.
- **Vault password file:** Use `--vault-password-file vault/.vault_pass` and `chmod 600` so only you can read it; keep it out of git.

## Template

See **../vault/vault.example.yml** for an example list of variable names. Copy that structure into your vault file; do not put real secrets in the example.

For more detail, see **../vault/readmevault.md**.
