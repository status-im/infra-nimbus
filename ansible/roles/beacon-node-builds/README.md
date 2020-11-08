# Description

This role configures a set of Systemd timers that build configured branches of [nimbus-eth2]() and push the built docker images.

# Configuration

The minimal configuration would look something like:
```yaml
# Branch to build and frequency
beacon_node_builds_branches:
  - name: 'xyz'
    branch: 'feature/xyz'
    frequency: '*-*-* 02:00:00'

# Required to push Docker images
beacon_node_builds_docker_hub_user: 'docker-hub-user'
beacon_node_builds_docker_hub_token: 'super-secret-password'
```

# Management

You can check the status of the timers using:
```
 > sudo systemctl list-timers 'beacon-node-build-*'
NEXT                        LEFT          LAST                        PASSED       UNIT                           ACTIVATES                       
Mon 2020-11-09 02:00:00 UTC 4h 12min left Sun 2020-11-08 02:00:01 UTC 19h ago      beacon-node-build-master.timer beacon-node-build-master.service
Mon 2020-11-09 10:00:00 UTC 12h left      Sun 2020-11-08 10:00:03 UTC 11h ago      beacon-node-build-devel.timer  beacon-node-build-devel.service 
Mon 2020-11-09 18:00:00 UTC 20h left      Sun 2020-11-08 18:00:04 UTC 3h 47min ago beacon-node-build-libp2p.timer beacon-node-build-libp2p.service

3 timers listed.
```
