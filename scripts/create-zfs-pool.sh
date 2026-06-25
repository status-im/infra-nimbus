#!/usr/bin/env bash
set -exuo pipefail

# Script for creating

if [[ $# -lt 1 ]]; then
  echo "Usage: $0 /dev/disk/by-id/disk1 /dev/disk/by-id/disk2" >&2
  exit 1
fi

ZPOOL_NAME="${ZPOOL:-ethdata}"
ZPOOL_TYPE='raidz1'
DEVICES=("$@")

read -r -p "DESTROY data on these disks? Type YES: " USER_INPUT
[[ "${USER_INPUT}" == "YES" ]] || exit 1

for DEV in "${DEVICES[@]}"; do
  [[ -b "${DEV}" ]]         || { echo "Not a block device: ${DEV}" >&2; exit 1; }
  [[ "${DEV}" == *-part* ]] || { echo "Partition found: ${DEV}" >&2;    exit 1; }
  sudo wipefs -n "$d"
done

sudo zpool create -f \
  -o ashift=12 \
  -o autotrim=on \
  -o autoexpand=on \
  -O compression=lz4 \
  -O atime=off \
  -O acltype=posixacl \
  -O xattr=sa \
  -O dnodesize=auto \
  -O normalization=formD \
  -O mountpoint=none \
  -O canmount=off \
  "${ZPOOL_NAME}" "${ZPOOL_TYPE}" "${DEVICES[@]}"

DATASETS=(
  "era     /era     1M"  # CL archive files
  "era1    /era1    1M"  # EL archive files
  "data    /data    16K" # Nimbus SQLite DB, page_size=4096
  "docker  /docker  64K" # Geth LevelDB + big ancient files
)

for entry in "${DATASETS[@]}"; do
  read -r name mountpoint recordsize <<< "$entry"

  zfs create \
    -o "mountpoint=$mountpoint" \
    -o "recordsize=$recordsize" \
    "ethdata/$name"
done
