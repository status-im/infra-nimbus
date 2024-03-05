#!/usr/bin/env bash
set -of pipefail

GRN='\033[0;32m'
BLD='\033[1m'
RST='\033[0m'

DOMAIN='statusim.net'

function fleets() {
    grep -oP '^\[\K[^]]+' ansible/inventory/test
}

function hosts() {
    awk "
/^\[${1}\]$/{
    while (\$0 != \"\") {
        getline
        print(\$1)
        continue
    }
}
" ansible/inventory/test
}

function ssh_command() {
    echo -e "${GRN}${BLD}${1}${RST}"
    ssh -o StrictHostKeyChecking=accept-new "${1}.${DOMAIN}" "${2}"
}

function usage() {
    echo "
Usage: $0 [FLEET] <COMMAND>

Examples:

$0 nimbus.sepolia 'systemctl start build-beacon-node-sepolia-stable'

echo linux-01.ih-eu-mda1.nimbus.sepolia | $0 'systemctl start build-beacon-node-sepolia-stable'
"
}

if [[ "${#}" -eq 0 ]]; then
    usage
    echo -e "Available fleets:\n"
    fleets
    exit
elif [[ "${#}" -eq 1 ]]; then
    # Get hostnames from stdin.
    while IFS=$'\n' read -r FLEET_HOST; do
        ssh_command "${FLEET_HOST}" "${1}"
    done
else
    # Get hostnames using fleet name.
    for FLEET_HOST in $(hosts "${1}"); do
        ssh_command "${FLEET_HOST}" "${2}"
    done
fi
