# JSON Schemas

JSON Schema validation files for AGAnsible actionlog files.

## Available Schemas

### `actionlog_schema.json`
Base schema for all actionlog files. Defines the common structure:
- Required fields: `test_name`, `timestamp`, `status`
- Optional fields: `host`, `message`, `details`, `metrics`, `validation`, `full_output`, `playbook_metadata`

### `ping_test_schema.json`
Schema for ping test results. Extends `actionlog_schema.json` with:
- Required `details.target_host` and `details.ping_count`
- Required `metrics.packet_loss_percent`, `metrics.packets_transmitted`, `metrics.packets_received`

### `curl_test_schema.json`
Schema for curl/HTTP test results. Extends `actionlog_schema.json` with:
- `details.curl_path` and `details.curl_installed`
- `metrics.test_results` array with URL test results

### `dns_test_schema.json`
Schema for DNS test results. Extends `actionlog_schema.json` with:
- Required `details.target_domain`, `details.dns_server`, `details.dns_tool`
- `metrics.resolved_ips` array

## Usage

### Python Validation

```python
import json
import jsonschema

# Load schema
with open('schemas/actionlog_schema.json') as f:
    schema = json.load(f)

# Load data
with open('actionlog/base/ping_test/ping_test_*.json') as f:
    data = json.load(f)

# Validate
try:
    jsonschema.validate(instance=data, schema=schema)
    print("✅ Valid JSON")
except jsonschema.ValidationError as e:
    print(f"❌ Validation error: {e.message}")
```

### Ansible Validation

The `write_actionlog.yml` role task automatically validates JSON output against schemas when `validate_json_schema: true` is set.

## Adding New Schemas

1. Create new schema file in `schemas/` directory
2. Extend `actionlog_schema.json` using `$ref`
3. Add specific properties for your test type
4. Update this README
5. Add validation to `write_actionlog.yml` if needed

## Schema Versioning

Schemas follow semantic versioning:
- Major version changes: Breaking changes to structure
- Minor version changes: New optional fields
- Patch version changes: Documentation updates

Current schema version: 1.0.0
