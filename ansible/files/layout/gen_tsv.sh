#!/usr/bin/env bash

GIT_ROOT=$(cd "${BASH_SOURCE%/*}" && git rev-parse --show-toplevel)

FLEET="${1}"
[[ -z "${FLEET}" ]] && { echo "No fleet name given!" >&1; exit 1; }
LAYOUT_FILE="${GIT_ROOT}/ansible/files/layout/${FLEET}.tsv"

# Add headers for nice display on GitHub.
echo -e 'Hostname\tNode Name\tValidator ID' > "${LAYOUT_FILE}"

# Find validator files and convert into a TSV.
ansible "${FLEET},!nimbus-holesky-windows,!nimbus-hoodi-macm2" --become \
    -a 'find /data/*/data/secrets -type f -printf "$(hostname)%p\n"' \
    | awk -F'/' '!/CHANGED/&&!/^$/{printf "%s\t%s\t%s\n", $1, $3, $6}' \
    | sort >> "${LAYOUT_FILE}"
