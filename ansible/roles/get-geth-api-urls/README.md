# Description

This role assembles the list of Web3 Eth1 URLs used by Nimbus Beacon nodes to sync with Eth1 chain.

# Configuration

There are only two important configuration keys:
```yaml
geth_node_api_consul_name: 'my-geth-node-rpc'
infura_api_tokens:
 - 'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa'
 - 'bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb'
 - 'cccccccccccccccccccccccccccccccc'
```
And the more we have the less likely that we hit the Infura threshold.
Infura endpoints are only used for Mainnet.

The Geth node Consul service is expected to have an `url` in metadata.
