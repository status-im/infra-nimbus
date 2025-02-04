#!/usr/bin/env bash
GATEWAY='2a0a:d580:40:60::1'
ADDR_PREFIX='2a0a:d580:40:60:'
COUNTER=256

function update_yaml() {
    [[ "${FILE}" == "update.sh" ]] && return
    ADDR="${ADDR_PREFIX}:$(printf '%x\n' "${COUNTER}")"
    grep "${ADDR}" "${1}" > /dev/null && { COUNTER=$((COUNTER+1)); return; }
    sed -i "s/addresses: \[ \([0-9./]\+\) \]$/addresses:\n        - \1/" "${1}"
    sed -i "/gateway4:/i \        - ${ADDR}/64" "${1}"
    sed -i "/gateway4:/a \      gateway6: ${GATEWAY}" "${1}"
    COUNTER=$((COUNTER+1))
}

for FILE in erigon-*.holesky.yml; do update_yaml "${FILE}"; done
for FILE in geth-*.holesky.yml;   do update_yaml "${FILE}"; done
for FILE in nec-*.holesky.yml;    do update_yaml "${FILE}"; done
for FILE in neth-*.holesky.yml;   do update_yaml "${FILE}"; done
for FILE in erigon-*.mainnet.yml; do update_yaml "${FILE}"; done
for FILE in geth-*.mainnet.yml;   do update_yaml "${FILE}"; done
for FILE in nec-*.mainnet.yml;    do update_yaml "${FILE}"; done
for FILE in linux-*.sepolia.yml;  do update_yaml "${FILE}"; done
