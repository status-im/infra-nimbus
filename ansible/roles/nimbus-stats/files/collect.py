#!/usr/bin/env python3
import os
import sys
import json
import socket
import logging
import requests
from datetime import datetime
from optparse import OptionParser
from elasticsearch import Elasticsearch

HELP_DESCRIPTION='This script collects latest log entries for provided messages from all nodes in a Nimbus fleet'
HELP_EXAMPLE='Example: collect -i logstash-2019.03.01 output.json'
DEFAULT_MESSAGES = [
    'Fork chosen',
    'Attestation received',
    'Slot start',
]

ENV = os.environ
LOG = logging.getLogger('root')
handler = logging.StreamHandler(sys.stderr)
formatter = logging.Formatter('[%(levelname)s]: %(message)s')
handler.setFormatter(formatter)
LOG.addHandler(handler)

class ES:
    def __init__(self, host, port, page_size, timeout):
        self.page_size = page_size
        self.es = Elasticsearch([host], port=port, timeout=timeout)

    def make_query(self, fleet, program, messages, after):
        return {
            'query': { 'bool': {
                'must': [
                    { 'match': { 'fleet': fleet } },
                    { 'match': { 'program': program } },
                    { 'range': { '@timestamp': { 'gt': after } } },
                ],
                'should': [
                    { 'match_phrase': { 'message': msg } } for msg in messages
                ],
                'minimum_should_match': 1,
            }, },
            'sort': [
                { '@timestamp': { 'order': 'desc' } },
            ],
        }

    def _index(self):
       return

    def get_logs(self, query):
        return self.es.search(
            index=self._index(),
            body=query,
            size=self.page_size
        )

def get_first_for_node(logs):
    data = {}
    for log_obj in logs:
        log = log_obj['_source']
        host_obj = data.setdefault(log['logsource'], {})
        # remove "docker/" prefix from program name
        program = log['program'].replace('docker/', '')
        prog_obj = host_obj.setdefault(program, {})
        prog_obj[log['message']] = json.loads(log['raw'])
    return data

def save_stats(data, output_file):
    # add metadata for easier debugging
    output = {
        'meta': {
            'hostname': socket.gethostname(),
            'timestamp': datetime.utcnow().isoformat(),
        },
        'data': data,
    }

    if output_file:
        LOG.info('Saving to file: %s', output_file)
        with open(output_file, 'w') as f:
            json.dump(data, f, indent=4)
    else:
        LOG.info('Printing results to STDOUT')
        print(json.dumps(data, indent=4))

def parse_opts():
    parser = OptionParser(description=HELP_DESCRIPTION, epilog=HELP_EXAMPLE)
    parser.add_option('-i', '--index', dest='es_index',
                      default='logstash-'+datetime.today().strftime('%Y.%m.%d'),
                      help='Patter for matching indices. (%default)')
    parser.add_option('-m', '--messages', action="append", default=DEFAULT_MESSAGES,
                      help='Messages to query for. (%default)')
    parser.add_option('-H', '--host', dest='es_host', default='localhost',
                      help='ElasticSearch host. (%default)')
    parser.add_option('-P', '--port', dest='es_port', default=9200,
                      help='ElasticSearch port. (%default)')
    parser.add_option('-p', '--program', default='*beacon-node-*',
                      help='Program to query for. (%default)')
    parser.add_option('-s', '--since', default='now-15m',
                      help='Period for which to query logs. (%default)')
    parser.add_option('-S', '--page-size', default=10000,
                      help='Size of results page. (%default)')
    parser.add_option('-f', '--fleet', default='nimbus.test',
                      help='Fleet to query for. (%default)')
    parser.add_option('-t', '--timeout', default=120,
                      help='Connection timeout in seconds. (%default)')
    parser.add_option('-l', '--log-level', default='INFO',
                      help='Logging level. (%default)')
    parser.add_option('-o', '--output-file',
                      help='File to which write the resulting JSON.')

    return parser.parse_args()

def debug_options(opts):
    LOG.debug('Settings:')
    for key, val in opts.__dict__.items():
       LOG.debug('%s=%s', key, val)

def main():
    (opts, args) = parse_opts()
    LOG.setLevel(opts.log_level)

    debug_options(opts)

    es = ES(opts.es_host, opts.es_port, opts.page_size, opts.timeout)

    LOG.info('Querying fleet: %s', opts.fleet)
    query = es.make_query(opts.fleet, opts.program, opts.messages, opts.since)
    rval = es.get_logs(query)

    LOG.info('Found matching logs: %d', rval['hits']['total']['value'])
    logs = rval['hits']['hits']

    data = get_first_for_node(logs)

    save_stats(data, opts.output_file)

if __name__ == '__main__':
    main()
