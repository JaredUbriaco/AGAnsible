# Linting and Validation Guide

AGAnsible uses automated linting and validation to ensure code quality and consistency.

## Available Tools

### YAML Linting (`yamllint`)

Validates YAML syntax and style according to `.yamllint.yml` configuration.

**Installation:**
```bash
pip3 install yamllint
```

**Usage:**
```bash
# Lint all YAML files
yamllint -c .yamllint.yml .

# Lint specific file
yamllint playbooks/base/ping_test.yml
```

### Ansible Linting (`ansible-lint`)

Validates Ansible playbooks for best practices and common issues.

**Installation:**
```bash
pip3 install ansible-lint
```

**Usage:**
```bash
# Lint all playbooks
ansible-lint --config-file .ansible-lint .

# Lint specific playbook
ansible-lint playbooks/base/ping_test.yml
```

### JSON Schema Validation

Validates JSON actionlog files against JSON schemas.

**Installation:**
```bash
pip3 install jsonschema
```

**Usage:**
```bash
# Validate all JSON files (via script)
bash scripts/validate_json_schemas.sh actionlog/**/*.json

# Validate manually
python3 -c "
import json
import jsonschema

with open('schemas/actionlog_schema.json') as f:
    schema = json.load(f)
with open('actionlog/base/ping_test/ping_test_*.json') as f:
    data = json.load(f)
jsonschema.validate(instance=data, schema=schema)
"
```

## Quick Linting Script

Use the provided linting script for all checks:

```bash
./scripts/lint.sh
```

This script runs:
1. `yamllint` on all YAML files
2. `ansible-lint` on all playbooks
3. JSON schema validation on actionlog files

## Pre-commit Hooks

Install pre-commit hooks to automatically lint before commits:

```bash
# Install pre-commit
pip3 install pre-commit

# Install hooks
pre-commit install

# Run hooks manually
pre-commit run --all-files
```

The `.pre-commit-config.yaml` includes:
- YAML linting
- Ansible linting
- Trailing whitespace checks
- JSON validation
- File size checks
- Merge conflict detection

## CI/CD Integration

### GitHub Actions

Add to `.github/workflows/lint.yml`:

```yaml
name: Lint

on: [push, pull_request]

jobs:
  lint:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - name: Install dependencies
        run: |
          pip3 install yamllint ansible-lint jsonschema
      - name: Run linting
        run: ./scripts/lint.sh
```

### GitLab CI/CD

Add to `.gitlab-ci.yml`:

```yaml
lint:
  stage: test
  script:
    - pip3 install yamllint ansible-lint jsonschema
    - ./scripts/lint.sh
```

## Configuration Files

### `.yamllint.yml`

YAML linting rules:
- Max line length: 120 characters
- Indentation: 2 spaces
- Document start: Disabled (for Ansible)
- Truthy values: Allows yes/no (Ansible convention)

### `.ansible-lint`

Ansible linting rules:
- Uses default rules
- Excludes actionlog, schemas, .github directories
- Allows descriptive naming conventions
- 120 character line length

### `.pre-commit-config.yaml`

Pre-commit hook configuration:
- yamllint hook
- ansible-lint hook
- JSON schema validation hook
- Standard pre-commit hooks

## Troubleshooting

### yamllint errors

**Issue**: `line too long`
**Fix**: Break long lines or increase `max` in `.yamllint.yml`

**Issue**: `wrong indentation`
**Fix**: Use 2 spaces for indentation (not tabs)

### ansible-lint errors

**Issue**: `name[template]` warnings
**Fix**: Use descriptive task names

**Issue**: `yaml[truthy]` warnings
**Fix**: Use `true`/`false` instead of `yes`/`no` (or add to skip_list)

### JSON schema validation errors

**Issue**: Schema not found
**Fix**: Ensure schema files exist in `schemas/` directory

**Issue**: Validation fails
**Fix**: Check JSON structure matches schema requirements

## Best Practices

1. **Run linting before committing**: Use pre-commit hooks
2. **Fix linting errors**: Don't ignore warnings
3. **Keep configurations updated**: Update lint configs as project evolves
4. **Document exceptions**: If you need to skip a rule, document why
5. **CI/CD integration**: Always run linting in CI/CD pipelines

## Excluded Paths

The following paths are excluded from linting:
- `actionlog/` - Generated files
- `schemas/` - JSON schema files
- `.github/` - GitHub workflow files
- `node_modules/` - Dependencies (if any)

## Additional Resources

- [yamllint Documentation](https://yamllint.readthedocs.io/)
- [ansible-lint Documentation](https://ansible-lint.readthedocs.io/)
- [JSON Schema Specification](https://json-schema.org/)
- [Pre-commit Documentation](https://pre-commit.com/)
