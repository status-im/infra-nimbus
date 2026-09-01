# Description

This role configures Linux systemd timer-backed services for Nimbus ERE file generation and verification using `nimbus_history_exporter`.

- **generate** — exports `.ere` files from a Nimbus execution client data directory.
- **verify** — verifies all `.ere` files in a directory.

The exporter requires the Nimbus EL database to have been imported with body and receipt storage enabled (`--debug-store-bodies` and `--debug-store-receipts`).

# Configuration

```yaml
nimbus_ere_files_timer_enabled: true
nimbus_ere_files_dir:           '/docker/ere'
nimbus_ere_files_era_dir:       '/docker/era'
nimbus_ere_files_nec_data_dir:  '/docker/nimbus-eth1-mainnet-master/data' # mandatory
nimbus_ere_files_exporter_path: '{{ nimbus_eth1_service_path }}/repo/build/nimbus_history_exporter' # mandatory
```

# Management

```sh
systemctl status nimbus-ere-files-generate.service
systemctl status nimbus-ere-files-verify.service
systemctl start nimbus-ere-files-generate.service
systemctl start nimbus-ere-files-verify.service
```
