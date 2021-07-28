#!/usr/bin/env python

# (c) 2018, Matt Stofko <matt@mjslabs.com>
# GNU General Public License v3.0+ (see LICENSE or
# https://www.gnu.org/licenses/gpl-3.0.txt)
#
# This plugin can be run directly by specifying the field followed by a list of
# entries, e.g.  bitwarden.py password google.com wufoo.com
#
# CHANGES:
# - Dropped custom_field argument
# - Started checking sources in order
# - Refactored Bitwarden class, added get_item()
# - Split LookupModule.run into two functions
from __future__ import (absolute_import, division, print_function)
__metaclass__ = type

import json
import os
import sys

from subprocess import Popen, PIPE, STDOUT, check_output

from ansible.errors import AnsibleError
from ansible.plugins.lookup import LookupBase

try:
    from __main__ import display
except ImportError:
    from ansible.utils.display import Display
    display = Display()


DOCUMENTATION = """
lookup: bitwarden
author:
  - Matt Stofko <matt@mjslabs.com>
requirements:
  - bw (command line utility)
  - BW_SESSION environment var (from `bw login` or `bw unlock`)
short_description: look up data from a bitwarden vault
description:
  - use the bw command line utility to grab one or more items stored in a
    bitwarden vault
options:
  _terms:
    description: name of item that contains the field to fetch
    required: true
field:
  description: field to return from bitwarden
  default: 'password'
sync:
  description: If True, call `bw sync` before lookup
"""

EXAMPLES = """
- name: get 'username' from Bitwarden entry 'Google'
  debug:
    msg: "{{ lookup('bitwarden', 'Google', field='username') }}"
"""

RETURN = """
  _raw:
    description:
      - Items from Bitwarden vault
"""


class Bitwarden(object):
    def __init__(self, path):
        self._cli_path = path
        self._bw_session = ""
        try:
            check_output([self._cli_path, "--version"])
        except OSError:
            raise AnsibleError("Command not found: {0}".format(self._cli_path))

    @property
    def session(self):
        return self._bw_session

    @session.setter
    def session(self, value):
        self._bw_session = value

    @property
    def cli_path(self):
        return self._cli_path

    @property
    def logged_in(self):
        # Parse Bitwarden status to check if logged in
        if self.status() == 'unlocked':
            return True
        else:
            return False

    def _run(self, args):
        my_env = os.environ.copy()
        if self.session != "":
            my_env["BW_SESSION"] = self.session
        p = Popen([self.cli_path] + args, stdin=PIPE,
                  stdout=PIPE, stderr=STDOUT, env=my_env)
        out, _ = p.communicate()
        out = out.decode()
        rc = p.wait()
        if rc != 0:
            display.debug("Received error when running '{0} {1}': {2}"
                          .format(self.cli_path, args, out))
            if out.startswith("Vault is locked."):
                raise AnsibleError("Error accessing Bitwarden vault. "
                                   "Run 'bw unlock' to unlock the vault.")
            elif out.startswith("You are not logged in."):
                raise AnsibleError("Error accessing Bitwarden vault. "
                                   "Run 'bw login' to login.")
            elif out.startswith("Failed to decrypt."):
                raise AnsibleError("Error accessing Bitwarden vault. "
                                   "Make sure BW_SESSION is set properly.")
            elif out.startswith("More than one result was found."):
                raise AnsibleError("More than one object found with this name.")
            elif out.startswith("Not found."):
                raise AnsibleError("Error accessing Bitwarden vault. "
                                   "Specified item not found: {}".format(args[-1]))
            else:
                print("Unknown failure in 'bw' command: \n%s" % out)
                return None
        return out.strip()

    def sync(self):
        self._run(['sync'])

    def status(self):
        try:
            data = json.loads(self._run(['status']))
        except json.decoder.JSONDecodeError as e:
            raise AnsibleError("Error decoding Bitwarden status: %s" % e)
        return data['status']

    def get_entry(self, key, field):
        return self._run(["get", field, key])

    def get_item(self, key):
        return json.loads(self.get_entry(key, 'item'))

    def get_notes(self, key):
        return self.get_item(key).get('notes')

    def get_custom_field(self, key, field):
        rval = self.get_entry(key, 'item')
        data = json.loads(rval)
        if 'fields' not in data:
            return None
        matching = [x for x in data['fields'] if x['name'] == field]
        if len(matching) == 0:
            return None
        return matching[0]['value']

    def get_itemid(self, key):
        return self.get_item(key).get('id')

    def get_attachments(self, key, itemid):
        return self._run(['get', 'attachment', key, '--itemid={}'.format(itemid), '--raw'])


class LookupModule(LookupBase):

    def run(self, terms, variables=None, **kwargs):
        self.bw = Bitwarden(path=kwargs.get('path', 'bw'))

        if not self.bw.logged_in:
            raise AnsibleError("Not logged into Bitwarden: please run "
                               "'bw login', or 'bw unlock' and set the "
                               "BW_SESSION environment variable first")

        values = []

        if kwargs.get('sync'):
            self.bw.sync()
        if kwargs.get('session'):
            self.bw.session = kwargs.get('session')

        for term in terms:
            rval = self.lookup(term, kwargs)
            if rval is None:
                raise AnsibleError("No matching term, field or attachment found!")
            values.append(rval)

        return values

    def lookup(self, term, kwargs):
        if 'file' in kwargs:
            # Try attachments first
            itemid = self.bw.get_itemid(term)
            if itemid is None:
                raise AnsibleError("No such object, wrong name")
            return self.bw.get_attachments(kwargs['file'], itemid)

        # By default check password
        field = kwargs.get('field', 'password')

        # Special field which contains notes.
        if field == 'notes':
            return self.bw.get_notes(term)

        # Try custom fields second
        val = self.bw.get_custom_field(term, field)
        if val:
            return val

        # If not found check default bw entries
        return self.bw.get_entry(term, field)

def main():
    if len(sys.argv) < 3:
        print("Usage: %s <field> <name> [name name ...]" % os.path.basename(__file__))
        return -1

    print(LookupModule().run(sys.argv[2:], variables=None, field=sys.argv[1], file='origin.crt'))

    return 0


if __name__ == "__main__":
    sys.exit(main())
