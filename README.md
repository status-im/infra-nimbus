# Description

This repo defines Nimbus cluster infrastructure.

# Endpoints

These are [Beacon API](https://ethereum.github.io/beacon-APIs/) endpoints intended for community testing.

| Endpoint                                        | Host                                 |
|-------------------------------------------------|--------------------------------------|
| http://unstable.mainnet.beacon-api.nimbus.team/ | `metal-01.he-eu-hel1.nimbus.mainnet` |
| http://testing.mainnet.beacon-api.nimbus.team/  | `metal-02.he-eu-hel1.nimbus.mainnet` |
| http://unstable.prater.beacon-api.nimbus.team/  | `metal-01.he-eu-hel1.nimbus.prater`  |
| http://testing.prater.beacon-api.nimbus.team/   | `metal-02.he-eu-hel1.nimbus.prater`  |
| http://unstable.sepolia.beacon-api.nimbus.team/ | `metal-01.he-eu-hel1.nimbus.sepolia` |

These nodes have no validators attached.

# Dashboards

There's a dedicated Kibana dashboard for Nimbus fleet logs: https://nimbus-logs.infra.status.im/

There are explorers available for various testnets:

* https://mainnet.beaconcha.in/
* https://ropsten.beaconcha.in/
* https://prater.beaconcha.in/

# Repo Usage

For how to use this repo read the [Infra Repo Usage](https://github.com/status-im/infra-docs/blob/master/docs/general/infra_repo_usage.md) doc.
