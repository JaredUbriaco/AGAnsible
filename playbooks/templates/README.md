# Playbook Templates

Templates for creating new AGAnsible playbooks.

## Usage

1. Copy `playbook_template.yml` to your desired location
2. Replace all `{{ PLACEHOLDERS }}` with actual values
3. Customize the tasks section for your specific test
4. Update variables section with your test parameters

## Template Variables

Replace these placeholders:

- `{{ PLAYBOOK_NAME }}` - Name of your playbook (e.g., "SSL Certificate Test")
- `{{ TARGET_HOSTS }}` - Target hosts (e.g., "all", "web-servers")
- `{{ CATEGORY }}` - Category folder (e.g., "base", "system", "cisco")
- `{{ TEST_NAME }}` - Test name for files (e.g., "ssl_cert_test")
- `{{ PLAYBOOK_DESCRIPTION }}` - Description of what the playbook does
- `{{ PLAYBOOK_VERSION }}` - Version number (default: "1.0.0")
- `{{ PLAYBOOK_AUTHOR }}` - Author name (default: "AGAnsible Team")

## Example

```bash
# Copy template
cp playbooks/templates/playbook_template.yml playbooks/system/ssl_cert_test.yml

# Edit and replace placeholders
# PLAYBOOK_NAME: SSL Certificate Test
# TARGET_HOSTS: all
# CATEGORY: system
# TEST_NAME: ssl_cert_test
# PLAYBOOK_DESCRIPTION: Validates SSL certificate expiration and validity
```

## Template Features

The template includes:
- ✅ Playbook metadata (version, author, description)
- ✅ Actionlog directory setup (using common role)
- ✅ Timestamp generation (using common role)
- ✅ Result validation
- ✅ Actionlog file writing
- ✅ Error handling and failure reporting

## Customization

Add your specific test logic in the tasks section:

```yaml
tasks:
  - import_tasks: ../../../roles/common/tasks/actionlog_setup.yml
  - import_tasks: ../../../roles/common/tasks/timestamp.yml
  
  # Your custom test tasks here
  - name: Check SSL certificate
    command: openssl s_client -connect {{ target_host }}:443
    register: ssl_result
  
  # Continue with validation and logging...
```

## Best Practices

1. **Follow naming conventions**: Use descriptive names
2. **Use common roles**: Import timestamp and actionlog tasks
3. **Validate inputs**: Add input validation tasks
4. **Handle errors**: Use `failed_when: false` for tests, validate results
5. **Document variables**: Add comments explaining variables
6. **Test thoroughly**: Run playbook multiple times before committing
