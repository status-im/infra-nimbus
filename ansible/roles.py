#!/usr/bin/env python3
import yaml
import logging
import ansible
import argparse
import subprocess
import functools
from enum import Enum
from os import path, getenv, symlink, readlink
from packaging.version import parse as version_parse
from concurrent import futures

HELP_DESCRIPTION='''
This tool managed Ansible roles as Git repositories.
It is both faster and simpler than Ansible Galaxy.

By default ~/.ansible/roles is symlinked to ~/work.
Override it using --roles-symlink or ROLES_SYMLINK.

Installation behavior:
- If no version is specified newest is pulled.
- If version is matching nothing is done.
- If repo is dirty or detached nothing is done.
- If version is newer user is notified.
'''
HELP_EXAMPLE='''Examples:
./roles.py --install
./roles.py --check
./roles.py --update
'''

SCRIPT_DIR = path.dirname(path.realpath(__file__))
# Where Ansible looks for installed roles.
ROLES_PATH = path.join(path.expanduser('~'), '.ansible/roles')
ROLES_SYMLINK = path.join(path.expanduser('~'), 'work')
ROLES_WORKERS = 20
REQUIREMENTS_PATH = path.join(SCRIPT_DIR, 'requirements.yml')

# Setup logging.
log_format = '[%(levelname)s] %(message)s'
logging.basicConfig(level=logging.INFO, format=log_format)
LOG = logging.getLogger(__name__)

# Colors
RST = '\033[0m'
NORMAL = lambda x: f'\033[00m{x}{RST}'
PURPLE = lambda x: f'\033[35m{x}{RST}'
YELLOW = lambda x: f'\033[33m{x}{RST}'
BLUE   = lambda x: f'\033[34m{x}{RST}'
GREY   = lambda x: f'\033[90m{x}{RST}'
RED    = lambda x: f'\033[31m{x}{RST}'
ORANGE = lambda x: f'\033[91m{x}{RST}'
GREEN  = lambda x: f'\033[32m{x}{RST}'
CYAN   = lambda x: f'\033[36m{x}{RST}'
BOLD   = lambda x: f'\033[1m{x}{RST}{RST}'

class State(Enum):
    # Order is priority. Higher status trumps lower.
    UNKNOWN       = 0
    EXISTS        = 1
    WRONG_VERSION = 2
    NEWER_VERSION = 3
    DIRTY         = 4
    DETACHED      = 5
    NO_VERSION    = 6
    CLONE_FAILURE = 7
    MISSING       = 8
    CLONED        = 9
    UPDATED       = 10
    VALID         = 11
    SKIPPED       = 12

    def __str__(self):
        match self:
            case State.NEWER_VERSION: color = BOLD
            case State.WRONG_VERSION: color = RED
            case State.DIRTY:         color = YELLOW
            case State.DETACHED:      color = YELLOW
            case State.NO_VERSION:    color = PURPLE
            case State.CLONE_FAILURE: color = RED
            case State.MISSING:       color = RED
            case State.CLONED:        color = GREEN
            case State.UPDATED:       color = GREEN
            case State.VALID:         color = GREEN
            case State.SKIPPED:       color = GREY
            case _:                   color = NORMAL
        return color(self.name.replace('_', ' '))

    # Allow calling max() to compare with previous state.
    def __gt__(self, other):
        if other is None:
            return True
        if self.__class__ is other.__class__:
            return self.value > other.value
        return NotImplemented

    # Decorator to manage Role state based on function return value.
    def update(success=None, failure=None):
        def decorator(func):
            @functools.wraps(func)
            def wrapper_decorator(self, *args, **kwargs):
                # Set state to failure one on exception.
                try:
                    rval = func(self, *args, **kwargs)
                except:
                    self.state = max(failure, self.state)
                    raise
                # Set state based on truthiness of result, higher one wins.
                if rval:
                    self.state = max(success, self.state)
                else:
                    self.state = max(failure, self.state)
                LOG.debug('[%-27s]: %s%s: state = %s',
                          self.name, func.__name__, args, self.state)
                return rval
            return wrapper_decorator
        return decorator

class Role:

    def __init__(self, name, src, required):
        self.state = State.UNKNOWN
        self.name = name
        self.src = src
        self.required = required

    @classmethod
    def from_requirement(cls, obj):
        return cls(obj['name'], obj.get('src'), obj.get('version'))

    def __repr__(self):
        return 'Role(name=%s, src=%s, required=%s, state=%s)' % (
            self.name, self.src, self.required, self.state,
        )

    def to_dict(self):
        obj = {
            'name': self.name,
            'src':  self.src,
        }
        if self.required:
            obj['version'] = self.required
        return obj

    def _git(self, *args, cwd=None):
        cmd = ['git'] + list(args)
        LOG.debug('[%-27s]: COMMAND: %s', self.name, ' '.join(cmd))
        rval = subprocess.run(
            cmd,
            capture_output=True,
            cwd=cwd or self.path
        )
        LOG.debug('[%-27s]: RETURN: %d', self.name, rval.returncode)
        if rval.stdout:
            LOG.debug('[%-27s]: STDOUT: %s', self.name, rval.stdout.decode().strip())
        if rval.stderr:
            LOG.debug('[%-27s]: STDERR: %s', self.name, rval.stderr.decode().strip())
        rval.check_returncode()
        return str(rval.stdout.strip(), 'utf-8')

    def _git_fail_is_false(self, *args, cwd=None):
        try:
            self._git(*args, cwd=cwd)
        except:
            return True
        else:
            return False

    @property
    def repo_parent_dir(self):
        return self.path.removesuffix(self.name)

    @property
    def branch(self):
        return self._git('rev-parse', '--abbrev-ref', 'HEAD')

    @property
    def current_commit(self):
        if not self.exists():
            return '........'
        return self._git('rev-parse', 'HEAD')

    @State.update(success=State.DIRTY)
    def is_dirty(self):
        return self._git_fail_is_false('diff-files', '--quiet')

    @State.update(success=State.DETACHED)
    def is_detached(self):
        return self._git_fail_is_false('symbolic-ref', 'HEAD')

    @State.update(success=State.NEWER_VERSION)
    def is_ancestor(self):
        if self.required is None or self.required == self.current_commit:
            return False
        return not self._git_fail_is_false(
            'merge-base', self.required, '--is-ancestor', self.current_commit
        )

    @property
    @State.update(failure=State.NO_VERSION)
    def version(self):
        return self.required

    @version.setter
    @State.update(success=State.UPDATED, failure=State.SKIPPED)
    def version(self, version):
        if self.required is not None:
            self.required = version
        return self.required

    @State.update(success=State.VALID, failure=State.WRONG_VERSION)
    def valid_version(self):
        return self.required == self.current_commit

    @State.update(success=State.VALID, failure=State.WRONG_VERSION)
    def pull(self):
        self._git('remote', 'update')
        status = self._git('status', '--untracked-files=no')

        if 'branch is up to date' in status:
            return True
        elif 'branch is behind' not in status:
            return None

        rval = self._git('pull')
        return self.valid_version()

    @State.update(success=State.CLONED, failure=State.CLONE_FAILURE)
    def clone(self):
        LOG.debug('Clogning: %s', self.src)
        try:
            self._git(
                'clone',
                self.src, self.name,
                cwd=self.repo_parent_dir
            )
        except Exception as ex:
            LOG.error('Clone failed: %s', ex.stderr.decode())
            return False
        return True

    @property
    def path(self):
        return path.join(ROLES_PATH, self.name)

    @State.update(success=State.EXISTS, failure=State.MISSING)
    def exists(self):
        return path.isdir(self.path)


def handle_role(role, check=False, update=False, install=False):
    LOG.debug('[%-27s]: Processing role...', role.name)
    if not role.exists():
        if not check and not update:
            role.clone()
        return role

    # Check if current version is newer.
    if not update and role.is_ancestor():
            return role

    # Check if current version matches required.
    if role.valid_version():
        return role

    # Verify if git repo is not dirty or has detached head.
    if not update and (role.is_dirty() or role.is_detached()):
        return role

    # No need to fail if no version is set.
    if check and not role.version:
        return role

    # Update config version or pull new changes.
    if update:
        role.version = role.current_commit
    elif install:
        # If version is not specified we just want the newest.
        role.pull()
    return role


# Special function to preserve order and separating newlines.
def roles_to_yaml(old_reqs, processed_roles):
    # Get processed role when available, use original one when not.
    return '\n'.join([
        yaml.dump([processed_roles.get(role.name, role).to_dict()])
        for role in old_reqs
    ])

def commit_or_any(commit):
    return '*' if commit is None else commit[:8]

# Symlink only if folder or link doesn't exist.
def symlink_roles_dir(roles_symlink):
    if path.islink(ROLES_PATH):
        dest = readlink(ROLES_PATH)
        if dest != roles_symlink:
            LOG.error('Roles path is already a link to: %s', dest)
            exit(1)
        else:
            return
    elif path.isdir(ROLES_PATH):
        LOG.error('Roles path is a directory, cannot symlink!')
        exit(1)

    symlink(roles_symlink, ROLES_PATH)

def parse_args():
    parser = argparse.ArgumentParser(
        epilog=HELP_EXAMPLE,
        description=HELP_DESCRIPTION,
        formatter_class=argparse.RawTextHelpFormatter,
    )

    parser.add_argument('-f', '--filter', default='',
                        help='Filter role repo names.')
    parser.add_argument('-w', '--workers', default=getenv('ROLES_WORKERS', ROLES_WORKERS), type=int,
                        help='Max workers to run in parallel.')
    parser.add_argument('-r', '--requirements', default=getenv('REQUIREMENTS_PATH', REQUIREMENTS_PATH),
                        help='Location of requirements.yml file.')
    parser.add_argument('-s', '--roles-symlink', default=getenv('ROLES_SYMLINK', ROLES_SYMLINK),
                        help='Actual location of installed roles.')
    parser.add_argument('-l', '--log-level', default='INFO',
                        help='Logging level.')
    parser.add_argument('-d', '--fail-dirty', action='store_true',
                       help='Fail if repo is dirty.')
    parser.add_argument('-a', '--fail-detached', action='store_true',
                       help='Fail if repo has detached head.')

    group = parser.add_mutually_exclusive_group()
    group.add_argument('-i', '--install', action='store_true',
                       help='Clone and update required roles.')
    group.add_argument('-c', '--check', action='store_true',
                       help='Only check roles, no installing.')
    group.add_argument('-u', '--update', action='store_true',
                       help='Update requirements with current commits.')

    args = parser.parse_args()

    assert args.install or args.check or args.update, \
        parser.error('Pick one: --install, --check, --update')

    return args


def main():
    args = parse_args()

    LOG.setLevel(args.log_level.upper())

    # Verify Ansible version is 2.8 or newer.
    if version_parse(ansible.__version__) < version_parse("2.8"):
        LOG.error('Your Ansible version is lower than 2.8. Upgrade it.')
        exit(1)

    # Symlink ansible roles directory to work directory.
    symlink_roles_dir(args.roles_symlink)

    # Read Ansible requirements file.
    with open(args.requirements, 'r') as f:
        requirements = yaml.load(f, Loader=yaml.FullLoader)

    requirements = [
        Role.from_requirement(req) for req in requirements
    ]

    # Check if each Ansible role is installed and has correct version.
    with futures.ProcessPoolExecutor(max_workers=args.workers) as executor:
        these_futures = [
            executor.submit(handle_role, role, args.check, args.update, args.install)
            for role in requirements
            if args.filter in role.name
        ]
        # Wait for all the workers to finishe and return their role.
        processed_roles = {
            r.name: r for r in
            [r.result() for r in futures.as_completed(these_futures)]
        }

    # Use the same order as requirements.yml file.
    for req in requirements:
        if args.filter not in req.name:
            continue
        role = processed_roles[req.name]
        print('%s%-44s --- %22s (Git: %s | Req: %s)' %
              (RST, BOLD(role.name), role.state,
               CYAN(role.current_commit[:8]),
               commit_or_any(role.required)))

    if args.update:
        with open(args.requirements, 'w') as f:
            f.write(roles_to_yaml(requirements, processed_roles))

    fail_states = set([State.MISSING, State.WRONG_VERSION])
    if args.fail_dirty:
        fail_states.append(State.DIRTY)
    if args.fail_detached:
        fail_states.append(State.DETACHED)
    if fail_states.intersection([r.state for r in processed_roles.values()]):
        exit(1)

if __name__ == "__main__":
    main()
