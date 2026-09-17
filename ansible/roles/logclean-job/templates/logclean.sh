#!/usr/bin/env bash

# ElasticSearch access
ES_HOST="{{ logclean_es_host | mandatory }}"
ES_PORT="{{ logclean_es_port | mandatory }}"
ES_USERNAME="{{ logclean_es_username | default('', true) }}"
ES_PASSWORD="{{ logclean_es_password | default('', true) }}"

# Keep only this number of newest indices
INDICES_KEEP="{{ logclean_keep_indices | mandatory }}"
ES_REGEX="{{ logclean_index_regex }}"

ES_URL="http://${ES_HOST}:${ES_PORT}"
CURL_ARGS=(-s)
if [[ -n "${ES_USERNAME}" ]]; then
    CURL_ARGS+=(-u "${ES_USERNAME}:${ES_PASSWORD}")
fi

echo "Checking ElasticSearch for indices to clean...."

# Get list of indices
if ! INDICES=$(curl -f "${CURL_ARGS[@]}" "${ES_URL}/_cat/indices/${ES_REGEX}?pretty&h=index&s=index"); then
    echo "Failed to list indices from ${ES_URL}!" >&2
    exit 1
fi
INDICES_NUM=$(echo "${INDICES}" | wc -l)

# If there are less indices than days stop
if [[ ${INDICES_NUM} -le ${INDICES_KEEP} ]]; then
    echo "Nothing to remove. (${INDICES_NUM}/${INDICES_KEEP} indices)"
    exit 0
fi

# Subtract how many to keep from number of existing indices
INDICES_TO_DELETE=$(echo "${INDICES}" | head -n$((INDICES_NUM-INDICES_KEEP)) )

echo "${INDICES_TO_DELETE}"

RC=0
while IFS= read -r INDEX; do
    echo "Deleting: ${INDEX}"
    # Every cluster node runs this job, so the index might be already gone.
    HTTP_CODE=$(curl "${CURL_ARGS[@]}" -o /dev/null -w '%{http_code}' -XDELETE "${ES_URL}/${INDEX}")
    if [[ "${HTTP_CODE}" != "200" && "${HTTP_CODE}" != "404" ]]; then
        echo "Failed to delete ${INDEX}: HTTP ${HTTP_CODE}" >&2
        RC=1
    fi
done <<< "${INDICES_TO_DELETE}"

exit ${RC}
