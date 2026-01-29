#!/usr/bin/python
"""
AGAnsible Network Topology Discovery Module
Discovers network topology using CDP/LLDP neighbor information
"""

from ansible.module_utils.basic import AnsibleModule
import re
import json

DOCUMENTATION = '''
---
module: network_topology
short_description: Discover network topology using CDP/LLDP
description:
    - Discovers network neighbors using CDP (Cisco Discovery Protocol) or LLDP (Link Layer Discovery Protocol)
    - Returns structured topology information
version_added: "1.0.0"
options:
    neighbor_output:
        description:
            - Output from 'show cdp neighbors detail' or 'show lldp neighbors detail' command
        required: true
        type: str
    protocol:
        description:
            - Protocol used for discovery (cdp or lldp)
        required: false
        default: 'cdp'
        choices: ['cdp', 'lldp']
        type: str
    device_name:
        description:
            - Name of the current device
        required: true
        type: str
author:
    - AGAnsible Team
'''

EXAMPLES = '''
- name: Discover topology using CDP
  network_topology:
    neighbor_output: "{{ cdp_output.stdout }}"
    protocol: cdp
    device_name: "{{ inventory_hostname }}"
  register: topology_result
'''

RETURN = '''
topology:
    description: Discovered topology information
    returned: always
    type: dict
    sample: |
        {
            "device": "router1",
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
'''


def parse_cdp_neighbors(output):
    """Parse CDP neighbor output"""
    neighbors = []
    current_neighbor = {}
    
    lines = output.split('\n')
    for line in lines:
        line = line.strip()
        
        # Device ID
        if 'Device ID:' in line:
            if current_neighbor:
                neighbors.append(current_neighbor)
            current_neighbor = {'device_id': line.split('Device ID:')[1].strip()}
        
        # Local Interface
        elif 'Interface:' in line:
            parts = line.split(',')
            for part in parts:
                if 'Interface:' in part:
                    current_neighbor['local_interface'] = part.split('Interface:')[1].strip()
                elif 'Port ID' in part:
                    current_neighbor['remote_interface'] = part.split('Port ID')[1].strip()
        
        # Platform
        elif 'Platform:' in line:
            current_neighbor['platform'] = line.split('Platform:')[1].strip()
        
        # Capabilities
        elif 'Capabilities:' in line:
            caps = line.split('Capabilities:')[1].strip()
            current_neighbor['capabilities'] = [c.strip() for c in caps.split(',') if c.strip()]
    
    if current_neighbor:
        neighbors.append(current_neighbor)
    
    return neighbors


def parse_lldp_neighbors(output):
    """Parse LLDP neighbor output"""
    neighbors = []
    current_neighbor = {}
    
    lines = output.split('\n')
    for line in lines:
        line = line.strip()
        
        # Local Interface
        if 'Local Intf:' in line:
            if current_neighbor:
                neighbors.append(current_neighbor)
            current_neighbor = {'local_interface': line.split('Local Intf:')[1].strip()}
        
        # Chassis ID / Device ID
        elif 'Chassis id:' in line or 'System Name:' in line:
            if 'System Name:' in line:
                current_neighbor['device_id'] = line.split('System Name:')[1].strip()
            elif 'Chassis id:' in line and 'device_id' not in current_neighbor:
                current_neighbor['device_id'] = line.split('Chassis id:')[1].strip()
        
        # Remote Interface
        elif 'Port id:' in line or 'Port Description:' in line:
            if 'Port Description:' in line:
                current_neighbor['remote_interface'] = line.split('Port Description:')[1].strip()
            elif 'Port id:' in line and 'remote_interface' not in current_neighbor:
                current_neighbor['remote_interface'] = line.split('Port id:')[1].strip()
        
        # System Description (Platform)
        elif 'System Description:' in line:
            current_neighbor['platform'] = line.split('System Description:')[1].strip()
    
    if current_neighbor:
        neighbors.append(current_neighbor)
    
    return neighbors


def main():
    module = AnsibleModule(
        argument_spec=dict(
            neighbor_output=dict(type='str', required=True),
            protocol=dict(type='str', default='cdp', choices=['cdp', 'lldp']),
            device_name=dict(type='str', required=True),
        ),
        supports_check_mode=True
    )
    
    neighbor_output = module.params['neighbor_output']
    protocol = module.params['protocol']
    device_name = module.params['device_name']
    
    try:
        if protocol == 'cdp':
            neighbors = parse_cdp_neighbors(neighbor_output)
        else:  # lldp
            neighbors = parse_lldp_neighbors(neighbor_output)
        
        topology = {
            'device': device_name,
            'protocol': protocol,
            'neighbor_count': len(neighbors),
            'neighbors': neighbors
        }
        
        module.exit_json(
            changed=False,
            topology=topology,
            neighbor_count=len(neighbors)
        )
    
    except Exception as e:
        module.fail_json(msg=f"Error parsing topology: {str(e)}")


if __name__ == '__main__':
    main()
