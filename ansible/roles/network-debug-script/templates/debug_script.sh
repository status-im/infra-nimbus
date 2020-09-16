#!/usr/bin/env bash

function get_network_state() {
    set -x
    ip route
    ip --brief address show
    docker network list
}

MAX_KEPT={{ net_debug_keep_logs }}
LOG_DIR="{{ net_debug_logs_dir }}"
TSTAMP=$(date -u +%Y%m%d%H%M%S)

# Save network state
get_network_state > "${LOG_DIR}/${TSTAMP}.log" 2>&1

# Clean old states
OLD_LOGS=$(ls -Art ${LOG_DIR} | head -n -${MAX_KEPT})
rm -vf ${OLD_LOGS}
