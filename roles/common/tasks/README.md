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
- `validate_json_schema` (optional): Validate JSON against schema (default: false)
- `validate_json_schema_fail_on_error` (optional): Fail on validation errors (default: true)

**JSON Schema Validation:**
When `validate_json_schema: true`, the task will:
1. Determine the appropriate schema based on `test_name`
2. Validate the JSON data against the schema
3. Fail if validation errors occur (unless `validate_json_schema_fail_on_error: false`)

### `validate_json_schema.yml`
Validates JSON data against a JSON schema file.

**Usage:**
```yaml
- import_tasks: roles/common/tasks/validate_json_schema.yml
  vars:
    json_data: "{{ my_data }}"
    schema_file: "schemas/my_schema.json"
    fail_on_error: true
```

**Variables:**
- `json_data` (required): Dictionary containing JSON data
- `schema_file` (required): Path to JSON schema file
- `fail_on_error` (optional): Whether to fail on validation errors (default: true)

### `api_response_format.yml`
Formats response as standardized JSON API format.

**Usage:**
```yaml
- import_tasks: roles/common/tasks/api_response_format.yml
  vars:
    api_data:
      playbook: "ping_test.yml"
      execution_time: 2.5
      results: { ... }
    api_status: "success"
    request_id: "req-12345"  # Optional
    api_version: "1.0"  # Optional
```

**Variables:**
- `api_data` (required): Dictionary containing the actual response data
- `request_id` (optional): Request ID for tracking (default: auto-generated)
- `api_version` (optional): API version (default: "1.0")
- `api_status` (optional): Status string (default: "success")
- `playbook_file` (optional): Playbook file path

**Result:** Sets `api_response` fact with standardized format:
```json
{
  "api_version": "1.0",
  "timestamp": "2026-01-22T10:30:45Z",
  "request_id": "req-12345",
  "status": "success",
  "data": { ... },
  "metadata": {
    "ansible_version": "2.15.0",
    "python_version": "3.11.0",
    "host": "localhost",
    "playbook": "ping_test.yml"
  }
}
```

## Examples

### Complete Example with JSON Output and Schema Validation
```yaml
---
- name: Example Test
  hosts: all
  vars:
    output_format: "json"
    validate_json_schema: true
    api_response_format: true
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
    
    - name: Write actionlog (with schema validation)
      import_tasks: roles/common/tasks/write_actionlog.yml
      vars:
        actionlog_filename: "example_test_{{ timestamp }}"
    
    - name: Format as API response
      import_tasks: roles/common/tasks/api_response_format.yml
      vars:
        api_data:
          playbook: "example_test.yml"
          results: "{{ actionlog_data }}"
        api_status: "success"
    
    - name: Display API response
      debug:
        var: api_response
```
