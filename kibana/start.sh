#!/bin/bash
set -e

# Add kibana as command if needed
if [[ "$1" == -* ]]; then
	set -- kibana "$@"
fi

# Run as user "kibana" if the command is "kibana"
if [ "$1" = 'kibana' ]; then
	if [ "$ELASTICSEARCH_URL" ]; then
		sed -ri "s!^(\#\s*)?(elasticsearch\.url:).*!\2 '$ELASTICSEARCH_URL'!" /opt/kibana/config/kibana.yml
	fi

	set -- gosu kibana tini -- "$@"
fi

## Wait for the Elasticsearch container to be ready before starting Kibana.
#echo "Stalling for Elasticsearch"
#while true; do
#    nc -q 1 elasticsearch 9200 2>/dev/null && break
#done
#
exec "$@"