# Description

This role configures a Systemd timer that periodically purges the Nimbus node database to test the sync process. Optionally it can use the [trusted node sync](https://nimbus.guide/trusted-node-sync.html) functionality.

# Configuration

In order to purge database of `beacon-node-mainnet-stable` weekly and sync it from trusted node:
```yaml
nimbus_db_purge_node_service_name: 'beacon-node-mainnet-stable'
nimbus_db_purge_node_service_path: '/data/{{ nimbus_db_purge_node_service_name }}'
nimbus_db_purge_node_network_name: 'mainnet'
nimbus_db_purge_timer_frequency: 'weekly'
nimbus_db_purge_truster_node_api_url: 'http://localhost:9300'
nimbus_db_purge_trusted_node_sync_enabled: true
```

# Management

The Systemd timer can be managed with `systemctl`:
```
 > sudo systemctl -o cat status purge-beacon-node-mainnet-stable
● purge-beacon-node-mainnet-stable.service - Purge beacon-node-mainnet-stable DB
     Loaded: loaded (/etc/systemd/system/purge-beacon-node-mainnet-stable.service; enabled; vendor preset: enabled)
     Active: inactive (dead) since Mon 2022-02-28 16:26:19 UTC; 4min 35s ago
TriggeredBy: ● purge-beacon-node-mainnet-stable.timer
       Docs: https://github.com/status-im/infra-role-systemd-timer
    Process: 1496098 ExecStart=/data/beacon-node-mainnet-stable/purge.sh (code=exited, status=0/SUCCESS)
   Main PID: 1496098 (code=exited, status=0/SUCCESS)

NOT 2022-02-28 16:26:19.669+00:00 Database initialized, historical blocks will be backfilled when starting the node missingSlots=3270047
NOT 2022-02-28 16:26:19.669+00:00 Done, your beacon node is ready to serve you! Don't forget to check that you're on the canoncial chain by comparing the checkpoint root with other online sources. See https://nim>
 >>> Starting node: beacon-node-mainnet-stable
  nimbus : TTY=unknown ; PWD=/data/beacon-node-mainnet-stable ; USER=root ; COMMAND=/usr/bin/systemctl start beacon-node-mainnet-stable
pam_unix(sudo:session): session opened for user root by (uid=0)
pam_unix(sudo:session): session closed for user root
purge-beacon-node-mainnet-stable.service: Succeeded.
Finished Purge beacon-node-mainnet-stable DB.
```
