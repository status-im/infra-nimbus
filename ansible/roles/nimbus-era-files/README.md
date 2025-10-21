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
nimbus_era_files_nclidb_path: '/data/nimbus/bin/ncli_db'
nimbus_era_files_db_path: '/data/nimbus/data/db'
#nimbus_era_files_network: 'hoodi'
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
admin@geth-01.ih-eu-mda1.nimbus.hoodi:~ % systemctl -o cat status nimbus-era-files-verify

○ nimbus-era-files-verify.service - Verify Nimbus beacon node ERA files
     Loaded: loaded (/etc/systemd/system/nimbus-era-files-verify.service; static)
     Active: inactive (dead) since Mon 2025-10-20 03:22:44 UTC; 1 day 5h ago
TriggeredBy: ● nimbus-era-files-verify.timer
       Docs: https://github.com/status-im/infra-role-systemd-timer
    Process: 107272 ExecStart=/usr/local/bin/nimbus-era-files-verify (code=exited, status=0/SUCCES>
   Main PID: 107272 (code=exited, status=0/SUCCESS)
        CPU: 1h 2min 49.108s

ce5df969f3fbd24d8aad1f3820ca4b13198d8aaa51a5894c1acb8826a9dcab9e
Checking: /docker/era/hoodi-00182-6ccc699c.era
b7fe0e099bba33f719e0ea48e8cd1242fe91faa648aca44d4773c037285507d3
Checking: /docker/era/hoodi-00183-ec9725ed.era
ae3f7e136c1df31dc800a83f05aee5304aae7767c9b033a7926dd41427259285
Checking: /docker/era/hoodi-00184-90a79536.era
3268c4555e0a1a1c9d1c47bb7b4f61acf195a85ca23ae326cc8baabaf09bc2e6
```
