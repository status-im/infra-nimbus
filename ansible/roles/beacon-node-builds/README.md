# Description

This role configures a set of Systemd timers that build configured branches of [nimbus-eth2]() and push the built docker images.

# Configuration

The minimal configuration would look something like:
```yaml
# Branch to build and frequency
beacon_node_builds_branches:
  - name: 'xyz'
    version: 'feature/xyz'
    targets: ['nimbus_beacon_node', 'nimbus_signing_process']
    frequency: '*-*-* 02:00:00'

# Required to push Docker images
beacon_node_builds_docker_hub_user: 'docker-hub-user'
beacon_node_builds_docker_hub_token: 'super-secret-password'
```

# Management

You can check the status of the timers using:
```
 > sudo systemctl list-timers 'beacon-node-build-*'
NEXT                        LEFT         LAST                        PASSED       UNIT                           ACTIVATES                       
Tue 2020-11-10 18:00:00 UTC 2h 3min left Mon 2020-11-09 18:00:03 UTC 21h ago      beacon-node-build-libp2p.timer beacon-node-build-libp2p.service
Wed 2020-11-11 10:00:00 UTC 18h left     Tue 2020-11-10 10:00:03 UTC 5h 56min ago beacon-node-build-unstable.timer  beacon-node-build-unstable.service 
Wed 2020-11-11 10:00:00 UTC 18h left     Tue 2020-11-10 10:00:03 UTC 5h 56min ago beacon-node-build-testing.timer  beacon-node-build-testing.service 
Wed 2020-11-11 02:00:00 UTC 10h left     Tue 2020-11-10 02:00:03 UTC 13h ago      beacon-node-build-stable.timer beacon-node-build-stable.service

4 timers listed.
```
You can start a job without having to wait for it with:
```
sudo systemctl --no-block start beacon-node-build-stable
```
