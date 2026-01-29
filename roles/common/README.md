# Common Role

Reusable tasks for AGAnsible playbooks to reduce code duplication.

## Available Tasks

### `timestamp.yml`
Generates an ISO8601 format timestamp and sets it as a fact.

**Usage:**
```yaml
- import_tasks: roles/common/tasks/timestamp.yml
```

**Result:**
- Sets `timestamp` fact with format: `2026-01-22T10:30:45+00:00`

**Example:**
```yaml
- import_tasks: roles/common/tasks/timestamp.yml
- debug:
    var: timestamp
```

### `actionlog_setup.yml`
Creates the actionlog directory if it doesn't exist.

**Usage:**
```yaml
- import_tasks: roles/common/tasks/actionlog_setup.yml
```

**Variables:**
- `actionlog_dir` (required): Path to actionlog directory
- `actionlog_dir_mode` (optional): Directory permissions (default: '0755')

**Example:**
```yaml
vars:
  actionlog_dir: "{{ playbook_dir }}/../../actionlog/base/ping_test"

tasks:
  - import_tasks: roles/common/tasks/actionlog_setup.yml
```

## Benefits

- **Reduces duplication**: Common patterns extracted to reusable tasks
- **Consistency**: Ensures all playbooks use the same timestamp format
- **Maintainability**: Update timestamp logic in one place
- **DRY principle**: Don't Repeat Yourself

## Future Tasks

Additional common tasks can be added:
- Input validation
- Error handling patterns
- Result formatting
- Notification tasks
