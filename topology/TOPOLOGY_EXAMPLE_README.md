# Example Topology: Core <> Access <> Access (Daisy Chain)

This folder contains **sample topology JSON** for three switches. The layout is **Core <> Access <> Access**: the core switch connects only to the first access switch; the second access switch is daisy-chained from the first (no direct link to the core).

- **core-sw1** – core switch (1 neighbor: access-sw1), brand: Cisco IOS
- **access-sw1** – access switch (2 neighbors: core-sw1, access-sw2), brand: Cisco IOS
- **access-sw2** – daisy-chained access switch (1 neighbor: access-sw1 only), brand: Cisco IOS

## Files

| File | Purpose |
|------|--------|
| `topology_core-sw1_example.json` | CDP output parsed for core-sw1 |
| `topology_access-sw1_example.json` | CDP output parsed for access-sw1 |
| `topology_access-sw2_example.json` | CDP output parsed for access-sw2 |
| `topology.dot` | GraphViz DOT (from `visualize_topology.py topology dot`) |
| `topology.svg` | SVG diagram (from `visualize_topology.py topology svg`) |
| `topology_example.png` | Reference PNG: Core <> Access <> Access, interface labels on links, Cisco IOS on nodes |

## Generate outputs (from project root)

```bash
# Text summary (no deps)
python3 scripts/visualize_topology.py topology text

# SVG diagram (no deps)
python3 scripts/visualize_topology.py topology svg
# Open topology/topology.svg in a browser

# GraphViz DOT (then PNG if dot is installed)
python3 scripts/visualize_topology.py topology dot
dot -Tpng topology/topology.dot -o topology/topology.png   # requires: apt install graphviz

# PNG via matplotlib (requires networkx + matplotlib)
python3 scripts/visualize_topology.py topology png   # requires: pip install networkx matplotlib (or use a venv)
```

## Layout and interface labels

SVG and PNG outputs show **interface labels on each link** (local ↔ remote) so you can manually validate cabling:

- **core-sw1** Gi0/1 ↔ **access-sw1** Gi0/1  
- **access-sw1** Gi0/2 ↔ **access-sw2** Gi0/1  

```
core-sw1[Gi0/1] —— access-sw1[Gi0/1]    access-sw1[Gi0/2] —— access-sw2[Gi0/1]
```
