# Description

Migrates a Nimbus host from `ext4` + `mdadm` to a single ZFS RAIDZ1 pool, in place.
See [infra-nimbus#287](https://github.com/status-im/infra-nimbus/issues/287).

**This destroys all data on the host's data disks.**

Before:

```
/data    ext4 on a bare disk        1.5 T   34-85% full, filling up
/docker  ext4 on md0 (raid0)        2.9 T   11-20% full, mostly idle
```

After, the host runs the [`zfs-pool`](../zfs-pool) layout, the same one a new
host gets. Total usable capacity drops from 4.36 TiB to ~2.82 TiB.

This role only handles the conversion. It drains the host, tears down `mdadm`
and the old `fstab` entries, then calls `zfs-pool` to build the pool. A host
built from scratch skips all of that and uses `zfs-pool` directly.

# Usage

```sh
# Migrate.
ansible-playbook ansible/zfs-migrate.yml \
  --limit neth-01.ih-eu-mda1.nimbus.hoodi \
  -e zfs_migration_confirm=neth-01.ih-eu-mda1.nimbus.hoodi

# Then redeploy.
ansible-playbook ansible/bootstrap.yml --limit neth-01.ih-eu-mda1.nimbus.hoodi
ansible-playbook ansible/hoodi.yml     --limit neth-01.ih-eu-mda1.nimbus.hoodi
```

# What is checked

Three things abort the run.

* **`zfs_migration_confirm` must equal the target hostname.** Without it,
  `--limit 'nimbus-hoodi-*'` wipes 15 hosts.
* **`bootstrap__extra_volume_enabled` must be false.** The bootstrap role
  `mkfs.ext4`s any partitionless disk it finds, which is exactly what these disks
  look like between the wipe and the pool creation.
* **The controller must report HBA mode.** Anything else means the host needs a
  reinstall rather than this playbook.

Preflight runs `zfs-pool`'s disk discovery rather than its own, so the disks it
lists as about to be wiped are the ones the pool gets built over. See that role
for how they are chosen.

Already-migrated hosts skip the destructive phases. `zfs-pool` still runs, so
the layout, ARC cap and scrub schedule converge either way.

# Configuration

See [`defaults/main.yml`](defaults/main.yml), and
[`zfs-pool`](../zfs-pool) for anything about the pool itself.

* `zfs_migration_confirm`, mandatory, must equal the target hostname.
* `zfs_migration_force`, migrate a host that already has the pool. Destroys data.
