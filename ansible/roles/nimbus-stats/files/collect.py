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
formatter = logging.Formatter('%(asctime)s [%(levelname)s]: %(message)s')
handler.setFormatter(formatter)
LOG.addHandler(handler)

class ES:
    def __init__(self, host, port, page_size):
        self.page_size = page_size
        self.es = Elasticsearch([host], port=port, timeout=30)

    def make_query(self, fleet, program, message, after):
        return {
            'query': { 'bool': {
                'must': [
                    { 'match': { 'fleet': fleet } },
                    { 'match': { 'program': program } },
                    { 'match_phrase': { 'message': message } },
                    { 'range': { '@timestamp': { 'gt': after } } },
                ],
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
        prog_obj = host_obj.setdefault(log['program'], {})
        prog_obj[log['message']] = json.loads(log['raw'])
    return data

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
    parser.add_option('-s', '--since', default='now-30m',
                      help='Period for which to query logs. (%default)')
    parser.add_option('-S', '--page-size', default=10000,
                      help='Size of results page. (%default)')
    parser.add_option('-f', '--fleet', default='nimbus.test',
                      help='Fleet to query for. (%default)')
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

    es = ES(opts.es_host, opts.es_port, opts.page_size)
    
    logs = []

    LOG.info('Querying fleet: %s', opts.fleet)
    for msg in opts.messages:
        query = es.make_query(opts.fleet, opts.program, msg, opts.since)
        rval = es.get_logs(query)
        LOG.info('Message: "%s" Found: %d', msg, rval['hits']['total'])
        logs.extend(rval['hits']['hits'])
    
    data = get_first_for_node(logs)
    
    # add metadata for easier debugging
    output = {
        'meta': {
            'hostname': socket.gethostname(),
            'timestamp': datetime.utcnow().isoformat(),
        },
        'data': data,
    }
    
    if opts.output_file:
        with open(opts.output_file, 'w') as f:
            json.dump(data, f, indent=4)
    else:
        print(json.dumps(data, indent=4))

if __name__ == '__main__':
    main()
