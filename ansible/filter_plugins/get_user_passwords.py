#!/usr/bin/env python
from ansible.errors import AnsibleError
from ansible.plugins.loader import lookup_loader

class FilterModule(object):
    def filters(self):
        return { 'get_user_passwords': self.get_user_passwords }

    def get_user_passwords(self, users):
        vault = lookup_loader.get('vault')
        variables = { 'env': 'all', 'stage': 'all' }
        get_pass = lambda name: vault.run(terms=["users"], field=name, variables=variables)
        rval = {}
        for user in users:
            try:
                rval[user['name']] = get_pass(user['name'])[0]
            except AnsibleError as err:
                continue # Allow for users without passwords
        return rval
