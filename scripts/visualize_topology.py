#!/usr/bin/env python3
"""
Network Topology Visualization Script
Generates visual representation of discovered network topology
"""

import json
import sys
from pathlib import Path
from collections import defaultdict

try:
    import networkx as nx
    import matplotlib.pyplot as plt
    HAS_VISUALIZATION = True
except ImportError:
    HAS_VISUALIZATION = False
    print("Warning: networkx and matplotlib not installed. Install with: pip3 install networkx matplotlib")


def load_topology_files(topology_dir):
    """Load all topology JSON files from directory"""
    topologies = {}
    topology_path = Path(topology_dir)
    
    if not topology_path.exists():
        print(f"Error: Topology directory not found: {topology_dir}")
        return topologies
    
    for json_file in topology_path.glob("topology_*.json"):
        try:
            with open(json_file) as f:
                data = json.load(f)
                device_name = data.get('device', json_file.stem)
                topologies[device_name] = data
        except Exception as e:
            print(f"Warning: Could not load {json_file}: {e}")
    
    return topologies


def build_topology_graph(topologies):
    """Build NetworkX graph from topology data"""
    if not HAS_VISUALIZATION:
        return None
    
    G = nx.Graph()
    
    for device, topology in topologies.items():
        G.add_node(device, device_type=topology.get('protocol', 'unknown'))
        
        for neighbor in topology.get('neighbors', []):
            neighbor_id = neighbor.get('device_id', 'unknown')
            local_intf = neighbor.get('local_interface', 'unknown')
            remote_intf = neighbor.get('remote_interface', 'unknown')
            
            G.add_node(neighbor_id)
            G.add_edge(
                device,
                neighbor_id,
                local_interface=local_intf,
                remote_interface=remote_intf
            )
    
    return G


def generate_text_topology(topologies):
    """Generate text-based topology representation"""
    output = []
    output.append("=" * 60)
    output.append("Network Topology Summary")
    output.append("=" * 60)
    output.append("")
    
    for device, topology in topologies.items():
        output.append(f"Device: {device}")
        output.append(f"  Protocol: {topology.get('protocol', 'unknown').upper()}")
        output.append(f"  Neighbors: {topology.get('neighbor_count', 0)}")
        output.append("")
        
        for neighbor in topology.get('neighbors', []):
            output.append(f"  -> {neighbor.get('device_id', 'unknown')}")
            output.append(f"     Local Interface: {neighbor.get('local_interface', 'N/A')}")
            output.append(f"     Remote Interface: {neighbor.get('remote_interface', 'N/A')}")
            if neighbor.get('platform'):
                output.append(f"     Platform: {neighbor.get('platform')}")
            output.append("")
    
    return "\n".join(output)


def generate_graphviz_topology(topologies, output_file):
    """Generate GraphViz DOT format topology"""
    output = []
    output.append("digraph NetworkTopology {")
    output.append("  rankdir=LR;")
    output.append("  node [shape=box];")
    output.append("")
    
    edges = []
    for device, topology in topologies.items():
        for neighbor in topology.get('neighbors', []):
            neighbor_id = neighbor.get('device_id', 'unknown')
            local_intf = neighbor.get('local_interface', '')
            remote_intf = neighbor.get('remote_interface', '')
            
            label = f"{local_intf} - {remote_intf}"
            edges.append(f'  "{device}" -> "{neighbor_id}" [label="{label}"];')
    
    output.extend(edges)
    output.append("}")
    
    with open(output_file, 'w') as f:
        f.write("\n".join(output))
    
    print(f"GraphViz DOT file created: {output_file}")
    print(f"Render with: dot -Tpng {output_file} -o topology.png")


def visualize_topology(topologies, output_file):
    """Generate visual topology graph"""
    if not HAS_VISUALIZATION:
        print("Visualization libraries not available. Generating text output instead.")
        return generate_text_topology(topologies)
    
    G = build_topology_graph(topologies)
    
    if G is None or len(G.nodes()) == 0:
        print("No topology data to visualize")
        return
    
    plt.figure(figsize=(12, 8))
    pos = nx.spring_layout(G, k=2, iterations=50)
    
    nx.draw_networkx_nodes(G, pos, node_color='lightblue', node_size=2000)
    nx.draw_networkx_labels(G, pos, font_size=10)
    nx.draw_networkx_edges(G, pos, edge_color='gray', alpha=0.5)
    nx.draw_networkx_edge_labels(
        G, pos,
        edge_labels={(u, v): f"{G[u][v].get('local_interface', '')}" 
                     for u, v in G.edges()},
        font_size=8
    )
    
    plt.title("Network Topology Map", size=16)
    plt.axis('off')
    plt.tight_layout()
    plt.savefig(output_file, dpi=300, bbox_inches='tight')
    print(f"Topology visualization saved: {output_file}")


def main():
    if len(sys.argv) < 2:
        print("Usage: visualize_topology.py <topology_directory> [output_format]")
        print("  output_format: text, dot, png (default: text)")
        sys.exit(1)
    
    topology_dir = sys.argv[1]
    output_format = sys.argv[2] if len(sys.argv) > 2 else 'text'
    
    # Load topology files
    topologies = load_topology_files(topology_dir)
    
    if not topologies:
        print("No topology files found")
        sys.exit(1)
    
    # Generate output based on format
    if output_format == 'text':
        output = generate_text_topology(topologies)
        print(output)
    
    elif output_format == 'dot':
        output_file = f"{topology_dir}/topology.dot"
        generate_graphviz_topology(topologies, output_file)
    
    elif output_format == 'png':
        output_file = f"{topology_dir}/topology.png"
        visualize_topology(topologies, output_file)
    
    else:
        print(f"Unknown output format: {output_format}")
        print("Supported formats: text, dot, png")
        sys.exit(1)


if __name__ == '__main__':
    main()
