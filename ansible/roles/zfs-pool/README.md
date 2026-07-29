# Description

Builds one RAIDZ1 pool over the host's data disks, with a dataset per storage
class.

```
ethdata                       raidz1, ashift=12
├── ethdata/data     /data    recordsize=16K
├── ethdata/docker   /docker  recordsize=64K
├── ethdata/era      /era     recordsize=1M
└── ethdata/era1     /era1    recordsize=1M
```

Free space stays fungible across all four, since no dataset carries a quota or
a reservation. The pool survives one disk failure.

# Behaviour

Idempotent and non-destructive by default, so it is safe in a converge playbook:

* The pool is created only when it does not already exist.
* `zpool create` runs without `-f`, so it refuses to build over a disk that
  still carries a filesystem. Set `zfs_pool_create_force` only when the disks
  were deliberately wiped first.
* Datasets, the ARC cap and the scrub timer are applied on every run, so a host
  whose pool was built by hand converges onto the same settings.

# Requirements

`zfsutils-linux` with OpenZFS 2.1 or newer, for `zfs-scrub-monthly@.timer`.
Ubuntu 22.04 ships 2.1.5. The role installs the package itself.

# Configuration

See [`defaults/main.yml`](defaults/main.yml).

* `zfs_pool_name`, default `ethdata`.
* `zfs_pool_type`, default `raidz1`.
* `zfs_pool_disk_count`, default `3`. Must match the number of equal-sized
  non-boot disks found, or the run aborts.
* `zfs_pool_datasets`, the layout above. Name, mountpoint and recordsize per
  dataset.
* `zfs_pool_scrub_schedule`, default `monthly`. Also accepts `weekly`.
* `zfs_pool_create_force`, pass `-f` to `zpool create`. Destroys data.
* `zfs_pool_rebuild`, destroy and recreate an existing pool. Destroys data.
