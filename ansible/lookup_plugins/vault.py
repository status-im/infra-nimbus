#!/usr/bin/env python

import json
import sys
import os
import hvac
import tempfile

<<<<<<< Updated upstream
||||||| Stash base

=======
from subprocess import Popen, PIPE, STDOUT, check_output, run

>>>>>>> Stashed changes
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

PASS_CLIENT_CERT_PATH = "services/vault/certs/client-cluster/cert"
PASS_CLIENT_KEY_PATH = "services/vault/certs/client-cluster/privkey"
PASS_CACERT_PATH = "services/vault/certs/root-ca/cert"

def write_temp_file(pass_path, prefix):
    content = run(['pass', pass_path], stdin=PIPE, stdout=PIPE, stderr=PIPE)
    tmp = tempfile.NamedTemporaryFile(prefix=prefix, dir="/tmp/test", mode='w+b', delete=False)
    tmp.write(content.stdout)
    print(tmp.name)
    return tmp

def debug_file(path):
    print(f"debug - {path.name}")
    print(f"{path.read()}", end="")

class Vault():
    def __init__(self):
        self.client_cert = write_temp_file(PASS_CLIENT_CERT_PATH, "client_cert")
        self.client_key = write_temp_file(PASS_CLIENT_KEY_PATH, "client_key")
        self.cacert = write_temp_file(PASS_CACERT_PATH, "root_ca")
        self.client = hvac.Client(cert=(self.client_cert.name, self.client_key.name),verify=self.cacert.name)
        debug_file(self.cacert)
        debug_file(self.cacert)


    def read_secret(self, path, field):
        debug_file(self.cacert)
        var = self.client.secrets.kv.read_secret_version(path)
        if val:
            return str(val['data']['data'][field])

class LookupModule(LookupBase):

<<<<<<< Updated upstream
    def run(self, terms, field: str, variables=None, override: str = False, **kwargs):
        self.vault = hvac.Client(cert=(VAULT_CLIENT_CERT, VAULT_CLIENT_KEY),verify=VAULT_CACERT)
||||||| Stash base
    def run(self, terms, **kwargs):
        VAULT_CACERT      = os.environ.get('VAULT_CACERT',      './ansible/files/vault-ca.crt')
        VAULT_CLIENT_CERT = os.environ.get('VAULT_CLIENT_CERT', './ansible/files/vault-client-user.crt')
        VAULT_CLIENT_KEY  = os.environ.get('VAULT_CLIENT_KEY',  './ansible/files/vault-client-user.key')

        self.vault = hvac.Client(cert=(VAULT_CLIENT_CERT, VAULT_CLIENT_KEY),verify=VAULT_CACERT)
=======
    def run(self, terms, **kwargs):
        self.vault = Vault()
#        VAULT_CACERT      = os.environ.get('VAULT_CACERT',      './ansible/files/vault-ca.crt')
#        VAULT_CLIENT_CERT = os.environ.get('VAULT_CLIENT_CERT', './ansible/files/vault-client-user.crt')
#        VAULT_CLIENT_KEY  = os.environ.get('VAULT_CLIENT_KEY',  './ansible/files/vault-client-user.key')

#        self.vault = hvac.Client(cert=(VAULT_CLIENT_CERT, VAULT_CLIENT_KEY),verify=VAULT_CACERT)
>>>>>>> Stashed changes
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
<<<<<<< Updated upstream
        display.v("Querying Vault field %s at path %s" % (field,term))
        val = self.vault.secrets.kv.read_secret_version(term)
        if val:
            return str(val['data']['data'][field])

||||||| Stash base
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
=======
        return self.vault.read_secret(term, field)

def main():
    if len(sys.argv) < 3:
        print("Usage: %s <path> <field>" % os.path.basename(__file__))
        return -1

    
    print(LookupModule().run(sys.argv[1], field=sys.argv[2]))

    return 0

if __name__ == "__main__":
    sys.exit(main())
>>>>>>> Stashed changes
