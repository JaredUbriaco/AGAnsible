# Network Topology Discovery

Playbooks and tools for discovering and visualizing network topology.

## Available Playbooks

### `discover_topology.yml`
**Purpose**: Discover network topology using CDP/LLDP neighbor protocols

**Supported Devices**:
- Cisco IOS (CDP and LLDP)
- Juniper JunOS (LLDP)
- Arista EOS (LLDP)

**Usage**:
```bash
# Discover topology from all devices
ansible-playbook -i inventories/example_cisco.ini playbooks/topology/discover_topology.yml

# Use specific protocol
ansible-playbook -i inventories/example_cisco.ini playbooks/topology/discover_topology.yml -e discovery_protocol=cdp
```

**Variables**:
- `discovery_protocol`: "cdp", "lldp", or "auto" (default: "cdp")
- `topology_output_dir`: Directory for topology JSON files (default: `topology/`)

**Output**:
- Topology JSON files saved to `topology/` directory
- Results logged to `actionlog/topology/discover_topology/`
- Each device generates a topology JSON file with neighbor information

## Custom Module

### `library/network_topology.py`
Ansible module for parsing CDP/LLDP neighbor output and extracting topology information.

**Features**:
- Parses CDP neighbor detail output
- Parses LLDP neighbor detail output
- Returns structured topology data
- Handles multiple neighbor formats

**Usage in Playbooks**:
```yaml
- name: Parse topology
  network_topology:
    neighbor_output: "{{ cdp_output.stdout }}"
    protocol: cdp
    device_name: "{{ inventory_hostname }}"
  register: topology_result
```

## Visualization Tools

### `scripts/visualize_topology.py`
Python script for visualizing discovered topology.

**Installation**:
```bash
# For basic text output (no dependencies)
# Already works

# For PNG visualization
pip3 install networkx matplotlib

# For GraphViz DOT format
pip3 install graphviz
```

**Usage**:
```bash
# Text output
python3 scripts/visualize_topology.py topology/ text

# GraphViz DOT format
python3 scripts/visualize_topology.py topology/ dot
dot -Tpng topology/topology.dot -o topology.png

# PNG visualization (requires networkx/matplotlib)
python3 scripts/visualize_topology.py topology/ png
```

**Output Formats**:
- **text**: Human-readable text summary
- **dot**: GraphViz DOT format (can be rendered to PNG/SVG)
- **png**: Direct PNG image generation (requires libraries)

## Topology Data Structure

Each topology JSON file contains:
```json
{
  "device": "router1",
  "protocol": "cdp",
  "neighbor_count": 3,
  "neighbors": [
    {
      "device_id": "router2",
      "local_interface": "GigabitEthernet0/0",
      "remote_interface": "GigabitEthernet0/1",
      "platform": "Cisco IOS",
      "capabilities": ["Router", "Switch"]
    }
  ]
}
```

## Workflow

1. **Discover Topology**:
   ```bash
   ansible-playbook -i inventories/example_cisco.ini playbooks/topology/discover_topology.yml
   ```

2. **Visualize Results**:
   ```bash
   python3 scripts/visualize_topology.py topology/ png
   ```

3. **Review Topology Files**:
   ```bash
   ls -la topology/
   cat topology/topology_*.json
   ```

## Prerequisites

1. **Network Devices**:
   - CDP or LLDP enabled on devices
   - SSH access to devices
   - Appropriate user permissions

2. **Ansible Collections**:
   ```bash
   ansible-galaxy collection install -r requirements.yml
   ```

3. **Python Libraries** (for visualization):
   ```bash
   pip3 install networkx matplotlib graphviz
   ```

## Troubleshooting

### "No neighbors found"
- Verify CDP/LLDP is enabled on devices
- Check device configuration: `show cdp neighbors` or `show lldp neighbors`
- Ensure devices are physically connected

### "Protocol not supported"
- Cisco IOS supports both CDP and LLDP
- Juniper/Arista typically use LLDP only
- Use `discovery_protocol: auto` to try both

### "Module not found"
- Ensure `library/network_topology.py` is in the playbook directory
- Check Ansible can find the module: `ansible-doc -t module network_topology`

### Visualization fails
- Install required Python libraries
- Use text format as fallback
- Check GraphViz installation for DOT format

## Best Practices

1. **Regular Discovery**: Run topology discovery regularly to track changes
2. **Version Control**: Commit topology JSON files to track network evolution
3. **Documentation**: Document expected topology and compare against discovered
4. **Visualization**: Generate visual maps for documentation and presentations
5. **Integration**: Use topology data for network documentation automation

## Future Enhancements

- Layer 3 routing table analysis
- Automatic topology comparison (before/after)
- Integration with network documentation tools
- Topology validation against expected design
- Multi-protocol correlation (CDP + LLDP + ARP)
