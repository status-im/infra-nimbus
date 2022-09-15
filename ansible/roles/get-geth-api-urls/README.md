# Description

This role assembles the list of Web3 Eth1 URLs used by Nimbus Beacon nodes to sync with Eth1 chain.

# Configuration

There are only two important configuration keys:
```yaml
geth_node_api_fleet_name: 'nimbus.geth'
geth_node_api_consul_names: ['my-geth-node-rpc']
```
The Geth node Consul service is expected to have an `url` in metadata.
