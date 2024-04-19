# Description

This role configures a Systemd timer which generates Nimbus ERA files weekly.

The purpose of those is to save space by sharing the same historical data between nodes.

Read more about ERA files [here](https://github.com/status-im/nimbus-eth2/blob/unstable/docs/e2store.md#era-files).

# Configuration

```yaml
nimbus_era_files_timer_name: 'nimbus-era-files'
nimbus_era_files_timer_update_name: '{{ nimbus_era_files_timer_name }}-update'
nimbus_era_files_timer_verify_name: '{{ nimbus_era_files_timer_name }}-verify'
nimbus_era_files_timer_path: '/data/era'
nimbus_era_files_nclidb_path: '/data/nimbus/repo/build/bin/ncli_db'
nimbus_era_files_db_path: '/data/nimbus/data/db'
#nimbus_era_files_network: 'holesky'
```

# Management

The timers runs weekly with 12h random delay by default, but you can start it manually:
```
 > systemctl -o cat status nimbus-era-files-update
● nimbus-era-files-update.service - Update Nimbus beacon node ERA files
     Loaded: loaded (/etc/systemd/system/nimbus-era-files-update.service; static; vendor preset: enabled)
     Active: inactive (dead) since Wed 2022-07-13 20:22:16 UTC; 2h 31min ago
TriggeredBy: ● nimbus-era-files-update.timer
       Docs: https://github.com/status-im/infra-role-systemd-timer
    Process: 153635 ExecStart=/data/beacon-node-mainnet-stable-01/repo/build/ncli_db exportEra --db=/data/beacon-node-mainnet-stable-01/data/shared_mainnet_0/db (code=exited, status=0/SUCCESS)
   Main PID: 153635 (code=exited, status=0/SUCCESS)

Written all complete eras
All time are ms
     Average,       StdDev,          Min,          Max,      Samples,         Test
     565.673,       41.529,      486.430,      635.203,           45, tState
    1107.374,      147.118,      685.914,     1293.401,           45, tBlocks
nimbus-era-files-update.service: Succeeded.
Finished Update Nimbus beacon node ERA files.
```
```
admin@linux-03.he-eu-hel1.nimbus.holesky:~ % systemctl -o cat status nimbus-era-files-verify
× nimbus-era-files-verify.service - Verify Nimbus beacon node ERA files
     Loaded: loaded (/etc/systemd/system/nimbus-era-files-verify.service; static)
     Active: failed (Result: exit-code) since Wed 2022-11-23 18:17:58 UTC; 39min ago
TriggeredBy: ● nimbus-era-files-verify.timer
       Docs: https://github.com/status-im/infra-role-systemd-timer
    Process: 444226 ExecStart=/usr/local/bin/nimbus-era-files-verify (code=exited, status=1/FAILURE)
   Main PID: 444226 (code=exited, status=1/FAILURE)
        CPU: 333ms

Starting Verify Nimbus beacon node ERA files...
Checking: /data/era/holesky-00000-043db0d9.era
895390e92edc03df7096e9f51e51896e8dbe6e7e838180dadbfd869fdd77a659
Checking: /data/era/holesky-00001-d530d14d.era
```
