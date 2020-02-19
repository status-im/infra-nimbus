# Description

This role defined a simple service which lists the current state of the nodes in the fleet. It does it by collecting most recent messages from the logs stored in ElasticSearch cluster and saves them in a JSON file which is then hosted publicly via Nginx.

# Configuration

The only setting that should be usually changed is the domain:
```yaml
nimbus_stats_domain: my-amazing-domain.example.org
# To query for ElasticSearch Load Blancer to query
consul_service_name: elasticsearch-lb
consul_service_tag: my-logs-cluster-name
```

# Script

The [`collect.py`](./files/collect.py`) script queries ElasticSearch for the logs we want to publish.

This script is by default put under `/usr/local/bin/collect_nimbus_stats.py` and is used by the `/usr/local/bin/save_nimbus_stats.py` in a `cron` job.
```
Usage: collect.py [options]

This script collects latest log entries for provided messages from all nodes
in a Nimbus fleet

Options:
  -h, --help            show this help message and exit
  -i ES_INDEX, --index=ES_INDEX
                        Patter for matching indices. (logstash-2019.04.18)
  -m MESSAGES, --messages=MESSAGES
                        Messages to query for. (['Fork chosen', 'Attestation
                        received', 'Slot start'])
  -H ES_HOST, --host=ES_HOST
                        ElasticSearch host. (localhost)
  -P ES_PORT, --port=ES_PORT
                        ElasticSearch port. (9200)
  -p PROGRAM, --program=PROGRAM
                        Program to query for. (*beacon-node-*)
  -s SINCE, --since=SINCE
                        Period for which to query logs. (now-15m)
  -S PAGE_SIZE, --page-size=PAGE_SIZE
                        Size of results page. (10000)
  -f FLEET, --fleet=FLEET
                        Fleet to query for. (nimbus.test)
  -t TIMEOUT, --timeout=TIMEOUT
                        Connection timeout in seconds. (120)
  -l LOG_LEVEL, --log-level=LOG_LEVEL
                        Logging level. (INFO)
  -o OUTPUT_FILE, --output-file=OUTPUT_FILE
                        File to which write the resulting JSON.

Example: collect -i logstash-2019.03.01 output.json
```

# Timer

The script runs on a [systemd timer](https://github.com/status-im/infra-role-systemd-timer) which can be checked with:
```
 $ sudo systemctl list-timers -a nimbus-stats.timer
NEXT                         LEFT     LAST                         PASSED       UNIT               ACTIVATES
Wed 2020-02-19 10:50:00 UTC  37s left Wed 2020-02-19 10:45:00 UTC  4min 21s ago nimbus-stats.timer nimbus-stats.service
```
Which triggers the `nimbus-stats` service:
```
 $ sudo systemctl status nimbus-stats.service    
● nimbus-stats.service - Generates stats for Nimbus cluster.
   Loaded: loaded (/lib/systemd/system/nimbus-stats.service; static; vendor preset: enabled)
   Active: inactive (dead) since Wed 2020-02-19 10:47:24 UTC; 2min 33s ago
     Docs: https://github.com/status-im/infra-role-systemd-timer
  Process: 24950 ExecStart=/usr/local/bin/nimbus-stats (code=exited, status=0/SUCCESS)
 Main PID: 24950 (code=exited, status=0/SUCCESS)

Feb 19 10:47:21 master-01.aws-eu-central-1a.nimbus.test systemd[1]: Starting Generates stats for Nimbus cluster....
Feb 19 10:47:22 master-01.aws-eu-central-1a.nimbus.test nimbus-stats[24950]: [INFO]: Querying fleet: nimbus.test
Feb 19 10:47:24 master-01.aws-eu-central-1a.nimbus.test nimbus-stats[24950]: [INFO]: Found matching logs: 10000
Feb 19 10:47:24 master-01.aws-eu-central-1a.nimbus.test nimbus-stats[24950]: [INFO]: Saving to file: /var/www/nimbus/nimbus_stats.json
Feb 19 10:47:24 master-01.aws-eu-central-1a.nimbus.test systemd[1]: Started Generates stats for Nimbus cluster..
```

# Context

For more details see: https://github.com/status-im/infra-nimbus/issues/1
