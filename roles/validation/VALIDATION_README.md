# Validation Role

Input validation tasks for AGAnsible playbooks to ensure security and reliability.

## Available Validation Tasks

### `validate_ip.yml`
Validates IP address format and octet ranges.

**Usage:**
```yaml
vars:
  ip_address: "8.8.8.8"

tasks:
  - import_tasks: roles/validation/tasks/validate_ip.yml
```

**Validates:**
- IP address format (X.X.X.X)
- Octet ranges (0-255)
- Non-empty value

**Example:**
```yaml
- name: Validate target IP
  import_tasks: roles/validation/tasks/validate_ip.yml
  vars:
    ip_address: "{{ target_host }}"
```

### `validate_url.yml`
Validates URL format and security.

**Usage:**
```yaml
vars:
  url: "https://www.example.com"

tasks:
  - import_tasks: roles/validation/tasks/validate_url.yml
```

**Validates:**
- URL format (http:// or https://)
- Domain name format
- Dangerous characters (prevents command injection)

**Example:**
```yaml
- name: Validate test URL
  import_tasks: roles/validation/tasks/validate_url.yml
  vars:
    url: "{{ test_url }}"
```

### `validate_domain.yml`
Validates domain name format and security.

**Usage:**
```yaml
vars:
  domain: "example.com"

tasks:
  - import_tasks: roles/validation/tasks/validate_domain.yml
```

**Validates:**
- Domain name format
- Maximum length (253 characters)
- Dangerous characters (prevents command injection)

**Example:**
```yaml
- name: Validate DNS domain
  import_tasks: roles/validation/tasks/validate_domain.yml
  vars:
    domain: "{{ target_domain }}"
```

## Security Benefits

- **Prevents command injection**: Validates input before use in commands
- **Format validation**: Ensures inputs match expected formats
- **Range checking**: Validates numeric ranges (IP octets)
- **Length validation**: Prevents buffer overflow attacks

## Best Practices

1. **Validate early**: Validate inputs at the start of playbooks
2. **Use in all playbooks**: Add validation to playbooks that accept user input
3. **Override when needed**: Use `-e` to override validation if needed for testing
4. **Document variables**: Document which variables require validation

## Example Playbook Usage

```yaml
---
- name: DNS Test with Validation
  hosts: all
  vars:
    target_domain: "example.com"
    dns_server: "8.8.8.8"
  
  tasks:
    - name: Validate domain name
      import_tasks: roles/validation/tasks/validate_domain.yml
      vars:
        domain: "{{ target_domain }}"
    
    - name: Validate DNS server IP
      import_tasks: roles/validation/tasks/validate_ip.yml
      vars:
        ip_address: "{{ dns_server }}"
    
    # Continue with actual test...
```
