# Description

This role assembles the list of Web3 Eth1 URLs used by Nimbus Beacon nodes to sync with Eth1 chain.

# Configuration

There are only two important configuration keys:
```yaml
geth_node_api_fleet_names: ['nimbus.geth', 'nimbus.mainnet']
geth_node_api_consul_name: 'my-geth-node-rpc'
```
The Geth node Consul service is expected to have an `url` in metadata.
