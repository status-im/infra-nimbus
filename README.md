# Description

This repo defines Nimbus cluster infrastructure.

# Endpoints

These are [Beacon API](https://ethereum.github.io/beacon-APIs/) endpoints intended for community testing.

| Endpoint                                        | Host                                 |
|-------------------------------------------------|--------------------------------------|
| http://unstable.mainnet.beacon-api.nimbus.team/ | `linux-01.ih-eu-mda1.nimbus.mainnet` |
| http://testing.mainnet.beacon-api.nimbus.team/  | `linux-02.ih-eu-mda1.nimbus.mainnet` |
| http://unstable.sepolia.beacon-api.nimbus.team/ | `linux-01.ih-eu-mda1.nimbus.sepolia` |
| http://testing.holesky.beacon-api.nimbus.team/  | `geth-01.ih-eu-mda1.nimbus.holesky`  |
| http://unstable.holesky.beacon-api.nimbus.team/ | `geth-02.ih-eu-mda1.nimbus.holesky`  |

These nodes have no validators attached.

There are also archives of ERA files:

| Endpoint                          | Host                                 |
|-----------------------------------|--------------------------------------|
| https://mainnet.era.nimbus.team/  | `linux-03.ih-eu-mda1.nimbus.mainnet` |
| https://sepolia.era.nimbus.team/  | `linux-01.ih-eu-mda1.nimbus.sepolia` |
| https://sepolia.era1.nimbus.team/ | `linux-01.ih-eu-mda1.nimbus.sepolia` |
| https://holesky.era.nimbus.team/  | `geth-01.ih-eu-mda1.nimbus.holesky`  |

# Dashboards

The fleet catalog can be seen at: https://fleets.nimbus.team/

There's a dedicated Kibana dashboard for Nimbus fleet logs: https://nimbus-logs.infra.status.im/

There are explorers available for various testnets:

* https://mainnet.beaconcha.in/
* https://sepolia.beaconcha.in/
* https://holesky.beaconcha.in/

# Fleet Layouts

The fleet layout configuration used by Ansible can be found in [`ansible/vars/layout`](ansible/vars/layout).

But for finding which host holds which validator use TSV files in [`ansible/files/layout`](ansible/files/layout).

# Bootstrap Nodes

Some nodes in this repo are used as [bootstrap nodes](https://ethereum.org/en/developers/docs/nodes-and-clients/bootnodes/) for testnets and mainnet.

Currently this includes:

| Host                                            | IP             |
|-------------------------------------------------|----------------|
| `bootstrap-01.aws-eu-central-1a.nimbus.mainnet` | `3.120.104.18` |
| `bootstrap-02.aws-eu-central-1a.nimbus.mainnet` | `3.64.117.223` |

They are recorded in the [`eth2-networks`](https://github.com/eth-clients/eth2-networks/blob/934c948e69205dcf2deb87e4ae6cc140c335f94d/shared/mainnet/bootstrap_nodes.txt#L28-L30) repository.

# Repo Usage

Simplest way to run commands on fleets if you have SSH access:
```
 > ./foreach.sh nimbus-mainnet-small "sudo systemctl --no-block restart 'build-beacon-node-*'"
stable-small-01.aws-eu-central-1a.nimbus.mainnet
stable-small-02.aws-eu-central-1a.nimbus.mainnet
```
For more details read the [Infra Repo Usage](https://github.com/status-im/infra-docs/blob/master/docs/general/infra_repo_usage.md) doc.
