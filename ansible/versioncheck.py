#!/usr/bin/env python3
# WARNING: If importing this fails set PYTHONPATH.
import yaml
import ansible
import subprocess
from os import path, environ
from packaging import version

SCRIPT_DIR = path.dirname(path.realpath(__file__))
# Where Ansible looks for installed roles.
ANSIBLE_ROLES_PATH = path.join(environ['HOME'], '.ansible/roles')


class Role:
    def __init__(self, name, version):
        self.name = name
        self.version = version

    @property
    def path(self):
        return path.join(ANSIBLE_ROLES_PATH, self.name)
    
    def exists(self):
        return path.isdir(self.path)

    def local_version(self):
        cmd = subprocess.run(
            ['git', 'rev-parse', 'HEAD'],
            capture_output=True,
            cwd=self.path
        )
        cmd.check_returncode()
        return str(cmd.stdout.strip(), 'utf-8')


# Verify Ansible version is 2.8 or newer.
if version.parse(ansible.__version__) < version.parse("2.8"):
    print('Your Ansible version is lower than 2.8. Upgrade it.')
    exit(1)

# Read Ansible requirements file.
with open(path.join(SCRIPT_DIR, 'requirements.yml'), 'r') as f:
    requirements = yaml.load(f, Loader=yaml.FullLoader)

# Check if each Ansible role is installed and has correct version.
errors = 0
for req in requirements:
    role = Role(req['name'], req.get('version'))

    if not role.exists():
        print('%25s - MISSING!' % role.name)
        errors += 1
        continue

    # For now we allow not specifying versions for everyhing.
    if role.version is None:
        print('%25s - No version!' % role.name)
        continue

    local_version = role.local_version()
    if role.version != local_version:
        print('%25s - MISMATCH: %s != %s' %
              (role.name, role.version[:8], local_version[:8]))
        errors += 1
        continue

    print('%25s - VALID' % role.name)

# Any issue with any role should cause failure.
if errors > 0:
    exit(1)
