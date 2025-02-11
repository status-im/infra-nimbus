# Description

Herein lie all ansible related files __except__ for `ansible.cfg` at the root of the repo for easier usage without having to `cd` here.

# Usage

Simply run the play related to the specific type of configuration you want to deploy:
```sh
 > ls -1 ansible/*.yml
ansible/bootstrap.yml
ansible/upgrade.yml
ansible/main.yml
```
```sh
ansible-playbook ansible/main.yml
```

# Bootstrap

All hosts are bootstraped right after provisioning using these roles:

* [status-im/infra-role-bootstrap-linux](https://github.com/status-im/infra-role-bootstrap-linux)
* [status-im/infra-role-bootstrap-macos](https://github.com/status-im/infra-role-bootstrap-macos)
* [status-im/infra-role-bootstrap-windows](https://github.com/status-im/infra-role-bootstrap-windows)

If you want to re-run any bootstrap step you can do it like so:
```sh
ansible-playbook ansible/bootstrap.yml -t role::bootstrap:hostname
```
In this case only the `hostname` set of tasks will be executed due to the `role::bootstrap:hostname` tag.

# Inventory

The inventory we use is crated by Terraform via the [`terraform-provider-ansible`](https://github.com/nbering/terraform-provider-ansible) which generates the necessary data structures in the [Consul Key/Value store](https://www.consul.io/docs/dynamic-app-config/kv) that is later used by the [`terraform.py`](./terraform.py) script to provide hosts and their variables to Ansible.

Some ways to view existing hosts:
```sh
ansible localhost -m debug -a 'var=groups'
ansible all -o -m debug -a 'var=ansible_host' | columns -t
```

A backup of the Terraform state is created at `.terraform/terraform.tfstate.backup`. It is symetrically encrypted using [Fernet algorithm](https://cryptography.io/en/latest/fernet/) with a key generated from haed `CONSUL_HTTP_TOKEN` and can be decrypted by using [`decrypt_tf_backup.py`](https://github.com/status-im/infra-utils/blob/master/terraform/decrypt_tf_backup.py) script.

# Variables

Ansible variables can be provided to Ansible using the `--extra-vars`/`-e` flag. An example of such a flag is:
```yaml
compose_state: 'present'
compose_recreate: 'smart'
compose_restart: false
```

These are used in every role that starts docker containers. You can use them to change the behaviour of roles.
For example to re-create all metric related containers use:
```sh
ansible-playbook ansible/main.yml -e compose_recreate=always
```

# Secrets

Secrets are stored and provided in three ways:

* [password-store](https://www.passwordstore.org/) - Using [`passwordstore`](https://docs.ansible.com/ansible/latest/collections/community/general/passwordstore_lookup.html) plugin for core infra secrets.
* [Vault](https://www.vaultproject.io/) - Using [`vault`](./lookup_plugins/vault.py) plugin for service secrets.

Read [secrets management guide](https://docs.infra.status.im/guides/secret_management.html) for more details.
