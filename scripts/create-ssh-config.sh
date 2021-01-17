#!/bin/usr/env bash

set -e
cd $(dirname "$0")

if [[ "${SSH_CONFIG_DIR}" == "" ]]; then
  echo Please specify the SSH_CONFIG_DIR environment variable
  exit 1
fi

if [[ "${SSH_CONFIG_FILE}" == "" ]]; then
  echo Please specify the SSH_CONFIG_FILE environment variable
  exit 1
fi

INFRA_NIMBUS_SSH_CONFIG="${SSH_CONFIG_DIR}/${SSH_CONFIG_FILE}"
: ${SSH_USERNAME:=$(whoami)}

mkdir -p "${SSH_CONFIG_DIR}" && chmod 700 "${SSH_CONFIG_DIR}"
rm -f "${INFRA_NIMBUS_SSH_CONFIG}"

for host in $(ansible all -i ../ansible/inventory/test --list-hosts | grep -v 'hosts')
do
	cat << EOF >> "${INFRA_NIMBUS_SSH_CONFIG}"
Host nimbus-$host
  Hostname $host.statusim.net
  User ${SSH_USERNAME}

EOF
done

echo "Successfully written '${INFRA_NIMBUS_SSH_CONFIG}'"
