# Network Performance Testing Guide

Comprehensive guide for network performance testing using AGAnsible.

## Overview

The performance testing playbook measures multiple network performance metrics to provide a complete picture of network health and performance.

## Available Metrics

### Latency Metrics
- **Minimum Latency**: Best-case round-trip time
- **Average Latency**: Mean round-trip time
- **Maximum Latency**: Worst-case round-trip time
- **Jitter**: Variation in latency (calculated from min/avg/max)

### Packet Loss
- **Packet Loss Percentage**: Percentage of packets lost
- **Packets Transmitted**: Total packets sent
- **Packets Received**: Total packets received

### Throughput
- **Throughput (Mbps)**: Measured using iperf3 (if available)
- **Bandwidth Utilization**: Interface bandwidth usage

### Interface Statistics
- **Interface Errors**: Receive errors on network interface
- **Dropped Packets**: Packets dropped by interface

## Usage

### Basic Performance Test
```bash
ansible-playbook playbooks/network/performance_test.yml
```

### Custom Target Host
```bash
ansible-playbook playbooks/network/performance_test.yml -e target_host=1.1.1.1
```

### Extended Test
```bash
ansible-playbook playbooks/network/performance_test.yml \
  -e ping_count=200 \
  -e test_duration=120
```

### JSON Output
```bash
ansible-playbook playbooks/network/performance_test.yml \
  -e output_format=json \
  -e validate_json_schema=true
```

## Variables

### Required Variables
None - uses defaults from `group_vars/all.yml`

### Optional Variables
- `target_host`: Target host for testing (default: 8.8.8.8)
- `ping_count`: Number of ping packets (default: 100)
- `ping_interval`: Interval between pings in seconds (default: 0.1)
- `test_duration`: Duration for throughput test in seconds (default: 60)
- `interface`: Network interface for bandwidth monitoring (default: eth0)
- `output_format`: "text", "json", or "both" (default: "text")
- `validate_json_schema`: Validate JSON output (default: false)

## Prerequisites

### Required Tools
- `ping`: Usually pre-installed on Linux systems
  - Install: `apt-get install iputils-ping` (Debian/Ubuntu)

### Optional Tools
- `iperf3`: For throughput testing
  - Install: `apt-get install iperf3` (Debian/Ubuntu)
  - Note: Requires iperf3 server on target host

### System Requirements
- Linux system with network interface statistics
- Access to `/sys/class/net/` for interface statistics
- Network connectivity to target host

## Output Interpretation

### Latency Guidelines
- **Excellent**: < 10ms
- **Good**: 10-50ms
- **Acceptable**: 50-100ms
- **Poor**: > 100ms

### Packet Loss Guidelines
- **Excellent**: 0%
- **Good**: < 0.1%
- **Acceptable**: < 1%
- **Poor**: > 1%

### Jitter Guidelines
- **Excellent**: < 5ms
- **Good**: 5-10ms
- **Acceptable**: 10-20ms
- **Poor**: > 20ms

## Example Output

```
Performance Test Status: SUCCESS
Performance test completed successfully
Latency: Min=8.2ms, Avg=12.5ms, Max=18.7ms
Jitter: 5.25ms
Packet Loss: 0%
Throughput: 95.3 Mbps
Bandwidth Utilization: 12.4 Mbps
```

## Troubleshooting

### "ping command not found"
```bash
sudo apt-get install iputils-ping
```

### "iperf3 not available"
- Throughput test will be skipped
- Other metrics will still be collected
- Install iperf3 for throughput testing

### "Interface statistics not available"
- Check interface name: `ip link show`
- Verify `/sys/class/net/<interface>/` exists
- May not work on all systems (e.g., macOS, Windows)

### High latency
- Check network path
- Verify target host is reachable
- Check for network congestion
- Review routing paths

### High packet loss
- Check physical connections
- Verify network equipment health
- Check for network congestion
- Review interface errors

## Advanced Usage

### Multiple Target Testing
```bash
for host in 8.8.8.8 1.1.1.1 9.9.9.9; do
  ansible-playbook playbooks/network/performance_test.yml \
    -e target_host=$host \
    -e output_format=json
done
```

### Scheduled Testing
Add to crontab:
```bash
# Run performance test every hour
0 * * * * cd /path/to/ansible && ansible-playbook playbooks/network/performance_test.yml -e output_format=json
```

### Integration with Monitoring
- Parse JSON output for monitoring systems
- Use actionlog files for historical analysis
- Set up alerts based on thresholds

## Best Practices

1. **Baseline Establishment**: Run tests regularly to establish baselines
2. **Multiple Targets**: Test against multiple targets for comprehensive view
3. **Time-based Testing**: Run tests at different times to identify patterns
4. **Documentation**: Document expected performance levels
5. **Alerting**: Set up alerts for performance degradation

## Related Playbooks

- `playbooks/base/ping_test.yml` - Basic ping connectivity test
- `playbooks/network/bgp_status.yml` - BGP protocol monitoring
- `playbooks/network/ospf_status.yml` - OSPF protocol monitoring

## Future Enhancements

- TCP/UDP specific testing
- Path MTU discovery
- Network path tracing (traceroute integration)
- Historical trend analysis
- Automated performance regression detection
