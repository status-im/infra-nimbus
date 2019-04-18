# Description

This role defined a simple service which lists the current state of the nodes in the fleet. It does it by collecting most recent messages from the logs stored in ElasticSearch cluster and saves them in a JSON file which is then hosted publicly via Nginx.

# Configuration

The only setting that should be usually changed is the domain:
```yaml
nimbus_stats_domain: my-amazing-domain.example.org
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
                        Period for which to query logs. (now-30m)
  -S PAGE_SIZE, --page-size=PAGE_SIZE
                        Size of results page. (10000)
  -f FLEET, --fleet=FLEET
                        Fleet to query for. (nimbus.test)
  -l LOG_LEVEL, --log-level=LOG_LEVEL
                        Logging level. (INFO)
  -o OUTPUT_FILE, --output-file=OUTPUT_FILE
                        File to which write the resulting JSON.

Example: collect -i logstash-2019.03.01 output.json
```

# Context

For more details see: https://github.com/status-im/infra-nimbus/issues/1

