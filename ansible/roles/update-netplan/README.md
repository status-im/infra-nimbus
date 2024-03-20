# Description

This role simply copies [Netplan](https://netplan.io/) config files for intended hosts.

This is necesssary because Innova Hosting does not provide addresses DHCP, network configuration is manualy done by support at first installation. We need to add IPv6 addresses to the hosts which need to be added separately.

For more details see the issue:
- https://github.com/status-im/infra-nimbus/issues/176
