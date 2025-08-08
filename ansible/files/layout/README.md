# Description

This folder contains generated TSV files with mapping of hosts, nodes, and their validators.

# Usage

To update the TSV files run the `gen_tsv.sh` script for given fleet:
```sh
ansible/files/gen_tsv.sh nimbus.sepolia
```

# Anti-Slashing Verification

This file is a good way to identify duplicate key locations with a simple command:
```bash
cut -f3 ansible/files/layout/nimbus.hoodi.tsv | sort | uniq -d
```
If it lists anything you're in danger of a slashing.
