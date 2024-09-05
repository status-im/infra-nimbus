#!/usr/bin/env python

import json
import sys
import os
import hvac


from ansible.errors import AnsibleError
from ansible.plugins.lookup import LookupBase

try:
    from __main__ import display
except ImportError:
    from ansible.utils.display import Display
    display = Display()


DOCUMENTATION = """
lookup: vault
auth:
    -  Alexis Pentori <alexis@status.im>
requirements:
    - hvac library
    - VAULT_ADDR environment var
    - VAULT_TOKEN environment var
short_description: look up data from a Hashicorp vault
decription:
    - Use the hvac library  to grab one or more items stored in a Hashicorp Vault
options:
    path:
        description: path of the secret in the Vault
        required: true
    field:
        description: field to return from vault
        required: true
"""

Examples = """
- name: get 'username' from Vault entry 'test'
  debug:
    msg: "{{ lookup('vault, 'test', field='username' ) }}"
"""

RETURN = """
  _raw:
    description:
      - Items for Hashicorp Vault
"""

class LookupModule(LookupBase):

    def run(self, terms, **kwargs):
        VAULT_CACERT      = os.environ.get('VAULT_CACERT',      './ansible/files/vault-ca.crt')
        VAULT_CLIENT_CERT = os.environ.get('VAULT_CLIENT_CERT', './ansible/files/vault-client-user.crt')
        VAULT_CLIENT_KEY  = os.environ.get('VAULT_CLIENT_KEY',  './ansible/files/vault-client-user.key')

        self.vault = hvac.Client(cert=(VAULT_CLIENT_CERT, VAULT_CLIENT_KEY),verify=VAULT_CACERT)
        values = []

        for term in terms:
            rval = self.lookup(term, kwargs)
            if rval is None:
                raise AnsibleError("No matching term, field found!")
            values.append(rval)

        return values

    def lookup(self, term, kwargs):
        field  = kwargs.get('field')
        val = self.vault.secrets.kv.read_secret_version(term)
        if val:
            return str(val['data']['data'][field])


def main():
    if len(sys.argv) < 3:
        print("Usage: %s <path> <field>" % os.path.basename(__file__))
        return -1
    print(LookupModule().run(sys.argv[1], field=sys.argv[2]))

    return 0

if __name__ == "__main__":
    sys.exit(main())
