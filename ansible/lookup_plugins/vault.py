#!/usr/bin/env python

import json
import sys
import os
import hvac
import hashlib
import base64
from cryptography.fernet import Fernet

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

LOG_PREFIX = "[lookup/vault]"

class LookupModule(LookupBase):

    def run(self, terms, field: str, variables=None, override: str = False, **kwargs):
        self.vault = hvac.Client(cert=(VAULT_CLIENT_CERT, VAULT_CLIENT_KEY),verify=VAULT_CACERT)
        parent_pid = os.getppid()
        self.cache_file = f"./ansible/files/cache/vault/{parent_pid}.cache"
        self.cache_encryption_key = base64.urlsafe_b64encode(hashlib.sha256(self.vault.token.encode()).digest())
        values = []
        env = kwargs.get("env", variables["env"])
        stage = kwargs.get("stage", variables["stage"])
        prefix = ""
        if override:
            display.debug(f"{LOG_PREFIX} Overriding the env/stage behavior and using only the path provided: {terms}")
        else:
            display.debug(f"{LOG_PREFIX} Using the env : {env} and the stage : {stage}")
            prefix=f"{env}/{stage}/"
        for term in terms:
            rval = self.lookup(f"{prefix}{term}", field=field)
            if rval is None:
                raise AnsibleError("No matching term, field not found!")
            values.append(rval)

        return values

    def lookup(self, term, **kwargs):
        field = kwargs.get('field')
        cached_data = self.read_cache(field, term)
        if cached_data:
            return cached_data
        display.vvv(f"{LOG_PREFIX} Querying Vault field {field} at path {term}")
        val = self.vault.secrets.kv.read_secret_version(term)
        if not val:
            return None
        if field not in val['data']['data']:
            raise AnsibleError(f'No such field in Vault entry: {field}')
        self.write_cache(term, val['data']['data'])
        return str(val['data']['data'][field])

    def read_cache(self, field, term):
        display.vvv(f"{LOG_PREFIX} Checking local cache file.")
        encrypted_data = self._read_cache_file()
        cache_data = self._decrypt_cache_data(encrypted_data) if encrypted_data else {}
        try:
            return cache_data[term][field]
        except KeyError:
            display.v(f"{LOG_PREFIX} Missing value in cache for path {term} and field {field}")
            return None
        return None

    def write_cache(self, term, content):
        encrypted_data = self._read_cache_file()
        cache_data = self._decrypt_cache_data(encrypted_data) if encrypted_data else {}
        cache_data[term] = content
        display.vvv(f"{LOG_PREFIX} Writing to a local cache file.")
        encrypted_data = self._encrypt_cache_data(cache_data)
        self._write_cache_file(encrypted_data)

    def _read_cache_file(self):
        try:
            with open(self.cache_file, "rb") as f:
                encrypted_data = f.read()
            return encrypted_data
        except FileNotFoundError:
            display.vvv(f"{LOG_PREFIX} Cache file {self.cache_file} does not exist.")
            return None

    def _write_cache_file(self, encrypted_data):
        try:
            with open(self.cache_file, "wb") as f:
                f.write(encrypted_data)
        except Exception as e:
            display.error(f"{LOG_PREFIX} Failed to write to a cache file: {e}.")
        display.vvv(f"{LOG_PREFIX} Cache file {self.cache_file} updated successfully.")

    def _decrypt_cache_data(self, encrypted_data):
        cipher = Fernet(self.cache_encryption_key)
        decrypted_data = cipher.decrypt(encrypted_data).decode()
        return json.loads(decrypted_data)

    def _encrypt_cache_data(self, cache_data):
        cipher = Fernet(self.cache_encryption_key)
        return cipher.encrypt(json.dumps(cache_data).encode())


def main():
    if len(sys.argv) < 2:
        print("Usage: %s <path> <field>" % os.path.basename(__file__))
        return 1

    tokens = sys.argv[1].split('/')
    if len(tokens) < 2:
        print("Path too short: %s" % sys.argv[1])
        return 1

    print(LookupModule().run(
        ['/'.join(tokens[2:])],
        field=sys.argv[2],
        variables={'env':tokens[0],'stage':tokens[1]}
    ))
    return 0

if __name__ == "__main__":
    sys.exit(main())
