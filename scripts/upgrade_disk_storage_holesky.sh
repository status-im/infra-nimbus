#!/usr/bin/env bash

# The purpose of this script is to give you and overview what needs to be done when
# upgrading the storage on holesky nodes. In this example we were upgrading the EL node
# storage which is mounted(usually) at /docker and /dev/sdc. The storage drive is HBA.
# Depending on the type of EL node: Erigon, Geth or Nethermind, the setup differs in what folders
# need to be backed up before the disk upgrade:
# Geth: only node/data/geth/chaindata needs to be backed up
# Erigon: both node/data/chaindata and node/data/snapshots need to be backed up
# Nethermind: only node/data/nethermind_db needs to be backed up

# You should understand this script before running it and adapt it for your use case.

set -e  # Exit immediately if a command exits with a non-zero status.
set -u  # Treat unset variables as an error.

# Constants
DOCKER_DIR="/docker"
CONFIG_BACKUP_DIR="/data/el_nodes_bak"
CHAINDATA_BACKUP_DIR="/data/el_nodes_chaindata"
SNAPSHOTS_BACKUP_DIR="/data/el_nodes_snapshots"

stop_containers_and_services() {
    local el_node_type=$1
    echo "Stopping and cleaning up $el_node_type containers, BN's and other services..."
    sudo systemctl stop beacon-node-holesky-libp2p
    sudo systemctl stop beacon-node-holesky-stable
    sudo systemctl stop beacon-node-holesky-unstable
    sudo systemctl stop beacon-node-holesky-testing
    sudo systemctl stop rsyslog
    sudo systemctl stop wazuh-agent

    for i in {1..4}; do
        if [[ "$el_node_type" == "geth" ]]; then
            COMPOSE_FILE_NODE="${DOCKER_DIR}/${el_node_type}-holesky-0${i}/docker-compose.yml"
            COMPOSE_FILE_EXPORTER="${DOCKER_DIR}/${el_node_type}-holesky-0${i}/docker-compose.exporter.yml"
            if [[ -f "$COMPOSE_FILE_NODE" && -f "$COMPOSE_FILE_EXPORTER" ]]; then
                echo "Stopping containers for $COMPOSE_FILE_NODE and $COMPOSE_FILE_EXPORTER..."
                docker compose -f "$COMPOSE_FILE_NODE" -f "$COMPOSE_FILE_EXPORTER" down || echo "Failed to stop containers for $COMPOSE_FILE_NODE and $COMPOSE_FILE_EXPORTER"
            else
                echo "Compose file not found for $COMPOSE_FILE_NODE or $COMPOSE_FILE_EXPORTER"
            fi
        else
            COMPOSE_FILE="${DOCKER_DIR}/${el_node_type}-holesky-0${i}/docker-compose.yml"
            if [[ -f "$COMPOSE_FILE" ]]; then
                echo "Stopping containers for $COMPOSE_FILE..."
                docker compose -f "$COMPOSE_FILE" down || echo "Failed to stop containers for $COMPOSE_FILE"
            else
                echo "Compose file not found for $COMPOSE_FILE"
            fi
        fi
    done
}

backup_docker_data() {
    local el_node_type=$1
    echo "Creating backup directory: $CONFIG_BACKUP_DIR"
    mkdir -p "$CONFIG_BACKUP_DIR"

    if [[ "$el_node_type" == "erigon" ]]; then
        rsync -av --info=progress2 \
        --exclude "${DOCKER_DIR}/${el_node_type}-holesky-01/data" \
        --exclude "${DOCKER_DIR}/${el_node_type}-holesky-02/data" \
        --exclude "${DOCKER_DIR}/${el_node_type}-holesky-03/data" \
        --exclude "${DOCKER_DIR}/${el_node_type}-holesky-04/data" \
        "$DOCKER_DIR/" "$CONFIG_BACKUP_DIR/"
    else
        rsync -av --info=progress2 \
        --exclude "${DOCKER_DIR}/${el_node_type}-holesky-01/node/data" \
        --exclude "${DOCKER_DIR}/${el_node_type}-holesky-02/node/data" \
        --exclude "${DOCKER_DIR}/${el_node_type}-holesky-03/node/data" \
        --exclude "${DOCKER_DIR}/${el_node_type}-holesky-04/node/data" \
        "$DOCKER_DIR/" "$CONFIG_BACKUP_DIR/"
    fi
    echo "Synced config data to backup directory"

    if [[ "$el_node_type" == "erigon" ]]; then
        echo "Creating backup directory for chaindata: $CHAINDATA_BACKUP_DIR"
        mkdir -p "$CHAINDATA_BACKUP_DIR"

        echo "Creating backup directory for snapshots: $SNAPSHOTS_BACKUP_DIR"
        mkdir -p "$SNAPSHOTS_BACKUP_DIR"

        rsync -av --info=progress2 \
        "$DOCKER_DIR/${el_node_type}-holesky-01/node/data/chaindata" "$CHAINDATA_BACKUP_DIR/"

        rsync -av --info=progress2 \
        "$DOCKER_DIR/${el_node_type}-holesky-01/node/data/snapshots" "$SNAPSHOTS_BACKUP_DIR/"
    elif [[ "$el_node_type" == "geth" ]]; then
        echo "Creating backup directory for chaindata: $CHAINDATA_BACKUP_DIR"
        mkdir -p "$CHAINDATA_BACKUP_DIR"

        rsync -av --info=progress2 \
        "$DOCKER_DIR/${el_node_type}-holesky-01/node/data/geth/chaindata" "$CHAINDATA_BACKUP_DIR/"
    elif [[ "$el_node_type" == "nethermind" ]]; then
        echo "Creating backup directory for chaindata: $CHAINDATA_BACKUP_DIR"
        mkdir -p "$CHAINDATA_BACKUP_DIR"
        rsync -av --info=progress2 \
        "$DOCKER_DIR/${el_node_type}-holesky-01/node/data/nethermind_db" "$CHAINDATA_BACKUP_DIR/"
    fi
    echo "Synced chain data to backup directory"
}

setup_raid_and_mount() {
    # Unmount the devices
    echo "Unmounting devices..."
    sudo umount /docker
    sudo umount /mnt/sdc

    # Wipe the devices
    echo "Wiping devices..."
    sudo wipefs -a /dev/sdc
    sudo wipefs -a /dev/sdd

    # Create the RAID0
    echo "Creating RAID0..."
    sudo mdadm --create /dev/md0 --level=0 --raid-devices=2 /dev/sdc /dev/sdd

    # Format and label the RAID device
    echo "Formatting the RAID0 device..."
    sudo mkfs.ext4 /dev/md0
    sudo e2label /dev/md0 docker_data

    # Create the /docker directory and mount the RAID
    echo "Mounting the RAID to /docker..."
    sudo mkdir -p /docker
    sudo mount /dev/md0 /docker

    # Make mount persistent in /etc/fstab
    echo "Making mount persistent in /etc/fstab..."
    echo "UUID=$(blkid -s UUID -o value /dev/md0) /docker ext4 defaults 0 0" | sudo tee -a /etc/fstab

    # Ensure mount is persistent
    echo "Checking if mount is persistent..."
    sudo umount /docker
    sudo mount -a
    df -h /docker
}

restore_data() {
    local el_node_type=$1
    echo "Restoring config back to /docker from backup..."
    sudo rsync -av --info=progress2 "$CONFIG_BACKUP_DIR" /docker/

    echo "Restoring data back for each EL from backup..."
    if [[ "$el_node_type" == "erigon" ]]; then
        for i in {1..4}; do
            sudo mkdir -p "$DOCKER_DIR/${el_node_type}-holesky-0${i}/node/data/chaindata"
            chown dockremap:dockremap "$DOCKER_DIR/${el_node_type}-holesky-0${i}/node/data/chaindata"

            sudo mkdir -p "$DOCKER_DIR/${el_node_type}-holesky-0${i}/node/data/snapshots"
            chown dockremap:dockremap "$DOCKER_DIR/${el_node_type}-holesky-0${i}/node/data/snapshots"

            sudo rsync -av --info=progress2 \
            "$CHAINDATA_BACKUP_DIR/" "$DOCKER_DIR/${el_node_type}-holesky-0${i}/node/data/chaindata"

            sudo rsync -av --info=progress2 \
            "$SNAPSHOTS_BACKUP_DIR/" "$DOCKER_DIR/${el_node_type}-holesky-0${i}/node/data/snapshots"

            COMPOSE_FILE_NODE="${DOCKER_DIR}/${el_node_type}-holesky-0${i}/docker-compose.yml"
            docker compose -f "$COMPOSE_FILE_NODE" up -d
        done
    elif [[ "$el_node_type" == "geth" ]]; then
        for i in {1..4}; do
            sudo mkdir -p "$DOCKER_DIR/${el_node_type}-holesky-0${i}/node/data/geth/chaindata"
            chown dockremap:dockremap "$DOCKER_DIR/${el_node_type}-holesky-0${i}/node/data/geth/chaindata"

            sudo rsync -av --info=progress2 \
            "$CHAINDATA_BACKUP_DIR/" "$DOCKER_DIR/${el_node_type}-holesky-0${i}/node/data/geth/chaindata"
            
            COMPOSE_FILE_NODE="${DOCKER_DIR}/${el_node_type}-holesky-0${i}/docker-compose.yml"
            COMPOSE_FILE_EXPORTER="${DOCKER_DIR}/${el_node_type}-holesky-0${i}/docker-compose.exporter.yml"
            docker compose -f "$COMPOSE_FILE_NODE" -f "$COMPOSE_FILE_EXPORTER" up -d
        done
    elif [[ "$el_node_type" == "nethermind" ]]; then
        for i in {1..4}; do
            sudo mkdir -p "$DOCKER_DIR/${el_node_type}-holesky-0${i}/node/data/nethermind_db"
            chown dockremap:dockremap "$DOCKER_DIR/${el_node_type}-holesky-0${i}/node/data/nethermind_db"

            sudo rsync -av --info=progress2 \
            "$CHAINDATA_BACKUP_DIR/" "$DOCKER_DIR/${el_node_type}-holesky-0${i}/node/data/nethermind_db"

            COMPOSE_FILE_NODE="${DOCKER_DIR}/${el_node_type}-holesky-0${i}/docker-compose.yml"
            docker compose -f "$COMPOSE_FILE_NODE" up -d
        done
    fi
    echo "Restored chain data."
}

start_services() {
    echo "Starting remaining services..."
    sudo systemctl start beacon-node-holesky-libp2p
    sudo systemctl start beacon-node-holesky-stable
    sudo systemctl start beacon-node-holesky-unstable
    sudo systemctl start beacon-node-holesky-testing
    sudo systemctl start rsyslog
    sudo systemctl start wazuh-agent
}

usage() {
    echo "Usage: $0 <el_node_type>"
    echo "el_node_type can be: geth, nethermind, or erigon"
    exit 1
}

main() {
    if [ "$#" -ne 1 ]; then
        echo "Error: Missing argument for el_node_type."
        usage
    fi

    el_node_type=$1

    if [[ "$el_node_type" != "geth" && "$el_node_type" != "nethermind" && "$el_node_type" != "erigon" ]]; then
        echo "Error: Invalid el_node_type '$el_node_type'."
        usage
    fi

    # Step 1: Stop containers and services
    stop_containers_and_services "$el_node_type"

    # Step 2: Backup Docker data
    backup_docker_data "$el_node_type"

    # Step 3: RAID setup and mounting
    setup_raid_and_mount

    # Step 4: Restore data back to /docker and start containers
    restore_data "$el_node_type"

    # Step 5: Start BN's and remaining services
    start_services
}

# Run the script
main
