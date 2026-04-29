from jinja2.runtime import Undefined
import json


def filter_by_branch(nodes, branch=None):
    """Filter list of node entries by branch name(s).

    Used to limit Ansible playbook runs to a single branch (or subset of branches)
    instead of looping through all entries in nodes_layout.

    Usage in playbook:
        with_items: "{{ nodes_layout[inventory_hostname] | filter_by_branch(branch_filter) }}"

    Usage on CLI:
        ansible-playbook ansible/hoodi.yml -l <host> -e branch_filter=libp2p
        ansible-playbook ansible/hoodi.yml -l <host> -e branch_filter=libp2p,unstable
        ansible-playbook ansible/hoodi.yml -l <host> -e 'branch_filter=["libp2p","unstable"]'
        ansible-playbook ansible/hoodi.yml -l <host> -e '{"branch_filter": ["libp2p","unstable"]}'
        ansible-playbook ansible/hoodi.yml -l <host>  # no filter, loops through all branches

    Accepts a single branch as string, comma-separated string, JSON list string,
    native list, or None/undefined (returns all nodes unchanged).
    All returned nodes include an _idx field with their original position in the list.
    """
    if branch is None or isinstance(branch, Undefined):
        return [dict(n, _idx=i) for i, n in enumerate(nodes)]

    if isinstance(branch, str):
        try:
            parsed = json.loads(branch)
            branch = parsed if isinstance(parsed, list) else [branch]
        except (json.JSONDecodeError, ValueError):
            branch = [b.strip() for b in branch.split(',')]

    return [dict(n, _idx=i) for i, n in enumerate(nodes) if n.get('branch') in branch]


class FilterModule(object):
    def filters(self):
        return {
            'filter_by_branch': filter_by_branch,
        }