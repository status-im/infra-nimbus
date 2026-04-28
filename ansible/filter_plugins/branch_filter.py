from jinja2.runtime import Undefined


def filter_by_branch(nodes, branch=None):
    """Filter list of node entries by branch name(s).

    Used to limit Ansible playbook runs to a single branch (or subset of branches)
    instead of looping through all entries in nodes_layout.

    Usage in playbook:
        with_items: "{{ nodes_layout[inventory_hostname] | filter_by_branch(branch_filter) }}"

    Usage on CLI:
        ansible-playbook ansible/hoodi.yml -l <host> -e branch_filter=libp2p
        ansible-playbook ansible/hoodi.yml -l <host> -e 'branch_filter=["libp2p","unstable"]'
        ansible-playbookansible/hoodi.yml -l <host> # no filter, loops through all branches

    Accepts a single branch as string, list of branches, or None/undefined
    (returns all nodes unchanged).
    """
    if branch is None or isinstance(branch, Undefined):
        return nodes
    if isinstance(branch, str):
        branch = [branch]
    return [n for n in nodes if n.get('branch') in branch]


class FilterModule(object):
    def filters(self):
        return {
            'filter_by_branch': filter_by_branch,
        }