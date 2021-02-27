#!/usr/bin/env bash

# ElasticSearch access
ES_HOST="{{ logclean_es_host | mandatory }}"
ES_PORT="{{ logclean_es_port | mandatory }}"

# Keep only this number of newest indices
INDICES_KEEP="{{ logclean_keep_indices | mandatory }}"
ES_REGEX="{{ logclean_index_regex }}"

ES_URL="http://${ES_HOST}:${ES_PORT}"

echo "Checking ElasticSearch for indices to clean...."

# Get list of indices
INDICES=$(curl -s "${ES_URL}/_cat/indices/${ES_REGEX}?pretty&h=index&s=index")
INDICES_NUM=$(echo "${INDICES}" | wc -l)

# If there are less indices than days stop
if [[ ${INDICES_NUM} -le ${INDICES_KEEP} ]]; then
    echo "Nothing to remove. (${INDICES_NUM}/${INDICES_KEEP} indices)"
    exit 0
fi

# Subtract how many to keep from number of existing indices
INDICES_TO_DELETE=$(echo "${INDICES}" | head -n$((INDICES_NUM-INDICES_KEEP)) )

echo "${INDICES_TO_DELETE}"

while IFS= read -r INDEX; do
    echo "Deleting: ${INDEX}"
    curl -s -XDELETE "${ES_URL}/${INDEX}"
done <<< "${INDICES_TO_DELETE}"
