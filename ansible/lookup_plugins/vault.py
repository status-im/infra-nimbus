#!/usr/bin/env python

import json
import sys
import os
import hvac

from ansible.errors import AnsibleError
from ansible.plugins.lookup import LookupBase
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
    - Use the hvac library to grab one or more items stored in a Hashicorp Vault
    - The plugin use the variable <env> and <stage> form ansible to determined the path to query
options:
    path:
        description: Path of the secret in the Vault, by default the Path will be prefixed by the <env>/<stage>/<path>
        required: true
    field:
        description: Field to return from vault
        required: true
    stage:
        description: Override the value of stage used in the path 
        required: false
    env:
        description: Override the value of the env used in the path
        required: false
    override:
        description: Search only for the path specifed
        required: false
"""

Examples = """
- name: Get 'username' from Vault entry 'config' to fetch secret from 'example/test/config'
  debug:
    msg: "{{ lookup('vault, 'config', field='username' )}}"
  vars:
    env: 'example'
    stage: 'test'
- name: Get 'username' from Vault entry 'config' to fetch secret from 'example-2/prod/config' 
  debug:
    msg: "{{ lookup('vault, 'test', field='username', stage='prod', env='example-2' )}}"
  vars:
    env: 'example'
    stage: 'test'
- name: Get 'username' from Vault entry 'config' to fetch secret from 'other/path/to/config'
  debug:
    msg: "{{ lookup('vault, 'other/path/to/config', field='username', override=True)}}"
  vars:
    env: 'example'
    stage: 'test'
"""

RETURN = """
  _raw:
    description:
      - Items for Hashicorp Vault
"""
VAULT_CACERT      = os.environ.get('VAULT_CACERT',      './ansible/files/vault-ca.crt')
VAULT_CLIENT_CERT = os.environ.get('VAULT_CLIENT_CERT', './ansible/files/vault-client-user.crt')
VAULT_CLIENT_KEY  = os.environ.get('VAULT_CLIENT_KEY',  './ansible/files/vault-client-user.key')

class LookupModule(LookupBase):

    def run(self, terms, field: str, variables=None, override: str = False, **kwargs):
        self.vault = hvac.Client(cert=(VAULT_CLIENT_CERT, VAULT_CLIENT_KEY),verify=VAULT_CACERT)
        values = []
        env = kwargs.get("env", variables["env"])
        stage = kwargs.get("stage", variables["stage"])
        prefix = ""
        if override:
            display.debug("Overriding the env/stage behavior and using only the path provided: %s" % terms)
        else: 
            display.debug("Using the env : %s and the stage : %s" % (env, stage))
            prefix=f"{env}/{stage}/"
        for term in terms:
            rval = self.lookup(f"{prefix}{term}", field=field)
            if rval is None:
                raise AnsibleError("No matching term, field not found!")
            values.append(rval)

        return values

    def lookup(self, term, **kwargs):
        field  = kwargs.get('field')
        display.v("Querying Vault field %s at path %s" % (field,term))
        val = self.vault.secrets.kv.read_secret_version(term)
        if val:
            return str(val['data']['data'][field])

