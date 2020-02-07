# Description

This is a systemd timer that runs daily and removes from ElasticSearch logs older than `N` days.

This is done because Nimbus generates a metric shitton of `TRACE` logs.

# Configuration

The main configuration values are:
```yaml
logclean_es_host: '127.0.0.1'
logclean_es_port: 9200
logclean_index_regex: 'logstash-*'
logclean_keep_indices: 120
logclean_service_name: 'logclean-job'
logclean_service_timeout: 60
logclean_timer_frequency: 'daily'
```
For sake of security minimum for `logclean_keep_indices` is `60`.

# Usage

To check the timer status use:
```
 $ sudo systemctl list-timers logclean-job.timer
NEXT                         LEFT     LAST PASSED UNIT               ACTIVATES
Sat 2020-02-08 00:00:00 UTC  10h left n/a  n/a    logclean-job.timer logclean-job.service
```
You can check job logs using:
```
 $ sudo journalctl -o cat -a -u logclean-job.service
...
Starting "Job for cleaning ElasticSearch cluster periodically."...
Checking ElasticSearch for indices to clean....
Nothing to remove. (3/90 indices)
Started "Job for cleaning ElasticSearch cluster periodically.".
```
