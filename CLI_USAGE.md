# AGAnsible CLI Usage Guide

The `agansible` command provides a unified command-line interface for the AGAnsible suite.

## Installation

The CLI wrapper is included in the repository. Make it executable:

```bash
chmod +x agansible
```

For system-wide access, create a symlink:

```bash
sudo ln -s $(pwd)/agansible /usr/local/bin/agansible
```

## Commands

### `agansible install`

Install all required dependencies for AGAnsible.

**Options:**
- `--skip-failed`: Continue installation even if some packages fail
- `--no-progress`: Disable progress indicators

**Examples:**
```bash
# Standard installation
agansible install

# Continue on failures
agansible install --skip-failed

# No progress bars
agansible install --no-progress
```

### `agansible verify`

Verify installation and setup. Checks:
- Ansible installation
- Python installation
- Playbook structure
- Configuration files
- DNS utilities

**Examples:**
```bash
agansible verify
```

### `agansible test`

Run the complete test suite.

**Options:**
- `--verbose` or `-v`: Show detailed output
- `--playbook <name>`: Run specific playbook only
- `--format <fmt>`: Output format (text, json, both)

**Examples:**
```bash
# Run all tests
agansible test

# Verbose output
agansible test --verbose

# Specific playbook
agansible test --playbook ping_test

# JSON output
agansible test --format json
```

### `agansible run`

Run a specific playbook with optional ansible-playbook options.

**Usage:**
```bash
agansible run <playbook_path> [ansible-playbook options]
```

**Examples:**
```bash
# Run ping test
agansible run playbooks/base/ping_test.yml

# Run with custom variables
agansible run playbooks/base/ping_test.yml -e target_host=1.1.1.1

# Run with JSON output
agansible run playbooks/system/curl_test.yml -e output_format=json

# Run with verbose output
agansible run playbooks/system/dns_test.yml -v
```

### `agansible list`

List all available playbooks organized by category.

**Example:**
```bash
agansible list
```

**Output:**
```
Available Playbooks:

Base Playbooks:
  - playbooks/base/ping_test.yml

System Playbooks:
  - playbooks/system/curl_test.yml
  - playbooks/system/dns_test.yml

Cisco Playbooks:
  - playbooks/cisco/ssh_test.yml
```

### `agansible version`

Show version information for AGAnsible CLI and dependencies.

**Example:**
```bash
agansible version
```

### `agansible help`

Show help message with all available commands and options.

**Example:**
```bash
agansible help
# or
agansible --help
# or
agansible -h
```

## Quick Start

1. **Install dependencies:**
   ```bash
   agansible install
   ```

2. **Verify installation:**
   ```bash
   agansible verify
   ```

3. **Run tests:**
   ```bash
   agansible test
   ```

4. **Run specific playbook:**
   ```bash
   agansible run playbooks/base/ping_test.yml
   ```

## Integration with Ansible

The `agansible run` command passes all additional arguments directly to `ansible-playbook`, so you can use all standard Ansible options:

```bash
# Use specific inventory
agansible run playbook.yml -i inventories/example_remote.ini

# Set variables
agansible run playbook.yml -e var1=value1 -e var2=value2

# Verbose output
agansible run playbook.yml -vvv

# Check mode
agansible run playbook.yml --check

# Diff mode
agansible run playbook.yml --diff
```

## Tab Completion

For bash completion, add to your `~/.bashrc`:

```bash
# AGAnsible CLI completion
_agansible_completion() {
    local cur prev opts
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"
    opts="install verify test run list version help"

    if [[ ${cur} == -* ]] ; then
        COMPREPLY=( $(compgen -W "${opts}" -- ${cur}) )
        return 0
    fi
}
complete -F _agansible_completion agansible
```

Then reload:
```bash
source ~/.bashrc
```

## Error Handling

The CLI provides clear error messages and exit codes:

- **Exit 0**: Success
- **Exit 1**: Error (command not found, file not found, etc.)

All commands validate prerequisites and provide helpful error messages if requirements are not met.

## Examples

### Complete Workflow

```bash
# 1. Install
agansible install

# 2. Verify
agansible verify

# 3. List available playbooks
agansible list

# 4. Run a test
agansible test

# 5. Run specific playbook with custom options
agansible run playbooks/base/ping_test.yml -e target_host=8.8.8.8 -e ping_count=10
```

### Advanced Usage

```bash
# Install with error recovery
agansible install --skip-failed

# Test with JSON output
agansible test --format json --verbose

# Run playbook on remote inventory
agansible run playbooks/system/curl_test.yml -i inventories/example_remote.ini

# Run with vault password
agansible run playbooks/cisco/ssh_test.yml --vault-password-file ~/.vault_pass
```

---

For more information, see the main [README.md](README.md).
