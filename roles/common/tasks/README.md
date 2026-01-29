# Common Role Tasks

Reusable tasks for AGAnsible playbooks.

## Available Tasks

### `timestamp.yml`
Generates ISO8601 timestamp and sets it as a fact.

**Usage:**
```yaml
- import_tasks: roles/common/tasks/timestamp.yml
```

**Result:** Sets `timestamp` fact

### `actionlog_setup.yml`
Creates actionlog directory if it doesn't exist.

**Usage:**
```yaml
vars:
  actionlog_dir: "{{ playbook_dir }}/../../actionlog/base/test"

tasks:
  - import_tasks: roles/common/tasks/actionlog_setup.yml
```

**Variables:**
- `actionlog_dir` (required): Path to actionlog directory
- `actionlog_dir_mode` (optional): Directory permissions (default: '0755')

### `write_actionlog.yml`
Writes actionlog file in text, JSON, or both formats.

**Usage:**
```yaml
vars:
  actionlog_data:
    test_name: "Test Name"
    timestamp: "{{ timestamp }}"
    status: "SUCCESS"
    message: "Test completed"
    # ... other fields

tasks:
  - import_tasks: roles/common/tasks/write_actionlog.yml
    vars:
      actionlog_filename: "test_{{ timestamp }}"
```

**Variables:**
- `actionlog_data` (required): Dictionary containing test results
- `actionlog_dir` (required): Directory for actionlog files
- `actionlog_filename` (required): Base filename without extension
- `output_format` (optional): "text", "json", or "both" (default: from group_vars or "text")

**actionlog_data Structure:**
```yaml
actionlog_data:
  test_name: "Test Name"
  timestamp: "2026-01-22T10:30:45+00:00"
  host: "localhost"
  status: "SUCCESS" or "FAILURE"
  message: "Test message"
  details: {}  # Optional: Additional details
  metrics: {}  # Optional: Test metrics
  validation: {}  # Optional: Validation results
  full_output: ""  # Optional: Full command output
  playbook_metadata: {}  # Optional: Playbook info
```

**Output Formats:**
- `text`: Creates `.txt` file with formatted text
- `json`: Creates `.json` file with structured JSON
- `both`: Creates both `.txt` and `.json` files

### `retry_network.yml`
Documentation for retry patterns (see file for details).

## Examples

### Complete Example with JSON Output
```yaml
---
- name: Example Test
  hosts: all
  vars:
    output_format: "json"  # or "text" or "both"
    actionlog_dir: "{{ playbook_dir }}/../../actionlog/base/test"
  
  tasks:
    - import_tasks: roles/common/tasks/actionlog_setup.yml
    - import_tasks: roles/common/tasks/timestamp.yml
    
    - name: Run test
      command: echo "test"
      register: test_result
    
    - name: Prepare actionlog data
      set_fact:
        actionlog_data:
          test_name: "Example Test"
          timestamp: "{{ timestamp }}"
          status: "SUCCESS"
          message: "Test completed"
          metrics:
            execution_time: "1.5s"
    
    - name: Write actionlog
      import_tasks: roles/common/tasks/write_actionlog.yml
      vars:
        actionlog_filename: "example_test_{{ timestamp }}"
```
