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


def _platform_from_topo(topo):
    """Get brand/platform for display: top-level platform or first neighbor's platform."""
    p = topo.get("platform") or ""
    if p:
        return p
    neighbors = topo.get("neighbors") or []
    if neighbors and neighbors[0].get("platform"):
        return neighbors[0]["platform"]
    return ""


def build_topology_graph(topologies):
    """Build NetworkX graph from topology data (with platform for brand display)."""
    if not HAS_VISUALIZATION:
        return None
    
    G = nx.Graph()
    
    for device, topology in topologies.items():
        platform = _platform_from_topo(topology)
        G.add_node(device, device_type=topology.get('protocol', 'unknown'), platform=platform)
        
        for neighbor in topology.get('neighbors', []):
            neighbor_id = neighbor.get('device_id', 'unknown')
            local_intf = neighbor.get('local_interface', 'unknown')
            remote_intf = neighbor.get('remote_interface', 'unknown')
            G.add_node(neighbor_id, platform=neighbor.get('platform', ''))
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


def _shorten_interface(name):
    """Shorten interface name for display (e.g. GigabitEthernet0/1 -> Gi0/1)."""
    if not name:
        return name
    s = name.strip()
    if s.startswith("GigabitEthernet"):
        return "Gi" + s[15:]
    if s.startswith("FastEthernet"):
        return "Fa" + s[12:]
    if s.startswith("Ethernet"):
        return "Eth" + s[8:]
    return s[:12] + ".." if len(s) > 14 else s


def _node_sort_key(name):
    """Order: Core first, then Access (by name). Core <> Access <> Access (daisy chain)."""
    n = name.lower()
    if "core" in n:
        return (0, name)
    if "access" in n:
        return (1, name)
    return (2, name)


def generate_svg_topology(topologies, output_file):
    """Generate SVG: Core <> Access <> Access (daisy chain), interface labels on links, brand on nodes."""
    # Build edges with interface labels: (node_a, node_b, local_intf, remote_intf)
    edge_data = []
    seen = set()
    for device, topo in topologies.items():
        for n in topo.get("neighbors", []):
            nid = n.get("device_id", "unknown")
            local_intf = n.get("local_interface", "") or "N/A"
            remote_intf = n.get("remote_interface", "") or "N/A"
            key = (min(device, nid), max(device, nid))
            if key not in seen:
                seen.add(key)
                edge_data.append((device, nid, local_intf, remote_intf))
    # All nodes, then order: Core first, then Access (so left-to-right = Core <> Access <> Access)
    all_nodes = []
    for a, b, _, _ in edge_data:
        if a not in all_nodes:
            all_nodes.append(a)
        if b not in all_nodes:
            all_nodes.append(b)
    order = sorted(all_nodes, key=_node_sort_key)
    n_nodes = max(len(order), 2)
    w, h = 560, 300
    pad = 95
    box_w = 140
    box_h = 56
    step = (w - 2 * pad) / max(1, n_nodes - 1)
    pos = {n: (pad + i * step, h // 2) for i, n in enumerate(order)}
    lines = [
        '<?xml version="1.0" encoding="UTF-8"?>',
        f'<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 {w} {h}" width="{w}" height="{h}">',
        '<style>.node-name { font: 14px sans-serif; font-weight: bold; } .node-platform { font: 11px sans-serif; fill: #555; } .edge-label { font: 11px sans-serif; fill: #333; }</style>'
    ]
    # 1) Draw edges (lines only)
    for a, b, local_intf, remote_intf in edge_data:
        x1, y1 = pos.get(a, (0, 0))
        x2, y2 = pos.get(b, (0, 0))
        lines.append(f'  <line x1="{x1}" y1="{y1}" x2="{x2}" y2="{y2}" stroke="#333" stroke-width="2"/>')
    # 2) Draw node boxes and labels (hostname + platform/brand) so they sit above lines
    for name, (x, y) in pos.items():
        lines.append(f'  <rect x="{x - box_w/2}" y="{y - box_h/2}" width="{box_w}" height="{box_h}" fill="#e0e8f0" stroke="#333"/>')
        platform = _platform_from_topo(topologies.get(name, {}))
        lines.append(f'  <text x="{x}" y="{y - 6}" class="node-name" text-anchor="middle">{name}</text>')
        if platform:
            lines.append(f'  <text x="{x}" y="{y + 10}" class="node-platform" text-anchor="middle">{platform}</text>')
    # 3) Draw interface labels ON TOP so they are visible (manual validation)
    for a, b, local_intf, remote_intf in edge_data:
        x1, y1 = pos.get(a, (0, 0))
        x2, y2 = pos.get(b, (0, 0))
        mid_x, mid_y = (x1 + x2) / 2, (y1 + y2) / 2 - 16
        label = f"{_shorten_interface(local_intf)} \u2194 {_shorten_interface(remote_intf)}"
        lines.append(f'  <text x="{mid_x}" y="{mid_y}" class="edge-label" text-anchor="middle">({label})</text>')
    lines.append('</svg>')
    with open(output_file, 'w') as f:
        f.write('\n'.join(lines))
    print(f"SVG topology saved: {output_file}")


def generate_graphviz_topology(topologies, output_file):
    """Generate GraphViz DOT format topology with interface labels on edges."""
    output = []
    output.append("digraph NetworkTopology {")
    output.append("  rankdir=LR;")
    output.append("  node [shape=box];")
    output.append("")
    edges = []
    for device, topology in topologies.items():
        for neighbor in topology.get('neighbors', []):
            neighbor_id = neighbor.get('device_id', 'unknown')
            local_intf = neighbor.get('local_interface', '') or 'N/A'
            remote_intf = neighbor.get('remote_interface', '') or 'N/A'
            label = f"{local_intf} <-> {remote_intf}"
            edges.append(f'  "{device}" -> "{neighbor_id}" [label="{label}"];')
    output.extend(edges)
    output.append("}")
    
    with open(output_file, 'w') as f:
        f.write("\n".join(output))
    
    print(f"GraphViz DOT file created: {output_file}")
    print(f"Render with: dot -Tpng {output_file} -o topology.png")


def visualize_topology(topologies, output_file):
    """Generate PNG: Core <> Access <> Access (daisy chain), interface labels on links, brand on nodes."""
    if not HAS_VISUALIZATION:
        print("Visualization libraries not available. Generating text output instead.")
        return generate_text_topology(topologies)
    
    G = build_topology_graph(topologies)
    
    if G is None or len(G.nodes()) == 0:
        print("No topology data to visualize")
        return
    
    # Fixed layout: left-to-right = Core <> Access <> Access (daisy chain)
    order = sorted(G.nodes(), key=_node_sort_key)
    pos = {n: (i, 0) for i, n in enumerate(order)}
    
    plt.figure(figsize=(12, 6))
    nx.draw_networkx_nodes(G, pos, node_color='lightblue', node_size=2800)
    # Node labels: hostname + platform/brand for manual validation
    node_labels = {}
    for n in G.nodes():
        platform = G.nodes[n].get('platform', '') or ''
        node_labels[n] = f"{n}\n{platform}" if platform else n
    nx.draw_networkx_labels(G, pos, labels=node_labels, font_size=10)
    nx.draw_networkx_edges(G, pos, edge_color='gray', alpha=0.6)
    # Edge labels: local_interface ↔ remote_interface for manual validation
    edge_labels = {}
    for u, v in G.edges():
        local_intf = G[u][v].get('local_interface', '') or 'N/A'
        remote_intf = G[u][v].get('remote_interface', '') or 'N/A'
        edge_labels[(u, v)] = f"{local_intf} \u2194 {remote_intf}"
    nx.draw_networkx_edge_labels(G, pos, edge_labels=edge_labels, font_size=8)
    
    plt.title("Network Topology Map (Core <> Access <> Access)", size=14)
    plt.axis('off')
    plt.tight_layout()
    plt.savefig(output_file, dpi=300, bbox_inches='tight')
    print(f"Topology visualization saved: {output_file}")


def main():
    if len(sys.argv) < 2:
        print("Usage: visualize_topology.py <topology_directory> [output_format]")
        print("  output_format: text, dot, png, svg (default: text)")
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
    
    elif output_format == 'svg':
        output_file = f"{topology_dir}/topology.svg"
        generate_svg_topology(topologies, output_file)
    
    else:
        print(f"Unknown output format: {output_format}")
        print("Supported formats: text, dot, png, svg")
        sys.exit(1)


if __name__ == '__main__':
    main()
