# Description

This role assembles the list of Web3 Eth1 URLs used by Nimbus Beacon nodes to sync with Eth1 chain.

# Configuration

There is only one important configuration key:
```yaml
infura_api_tokens:
 - 'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa'
 - 'bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb'
 - 'cccccccccccccccccccccccccccccccc'
```
And the more we have the less likely that we hit the Infura treshhold.
