# Description

This repo defines Nimbus cluster infrastructure.

# Requirements

In order to use this you will need secrets(passwords, certs, keys) contained within the [infra-pass](https://github.com/status-im/infra-pass) repository. If you can't see it ask jakub@status.im to get you access for it.

In order for this to work first you need to install necessary Terraform plugins and get the right secrets from the [infra-pass](https://github.com/status-im/infra-pass) repo, to do that simply run:
```
make
# alternatively
make plugins
make secrets
```
This will put the necessary certificates, keys, and passwords are in place so you can deploy and configure hosts.

# Usage

To deploy hosts for the subsystem run:
```
terraform plan
terraform apply
```
Then configure the cluster:
```
ansible-playbook ansible/nimbus.yml
```

__For more details see `README.md` files in `ansible` folders.__

# Dashboards

There's a dedicated Kibana dashboard for Nimbus fleet logs: https://nimbus-logs.infra.status.im/

There are explorers available for various testnets:

* https://pyrmont.beaconcha.in/
* https://prater.beaconcha.in/

# Details

Read the [Terraform and Ansible](https://github.com/status-im/infra-docs/blob/master/articles/ansible_terraform.md) article in our `infra-docs` repo.
