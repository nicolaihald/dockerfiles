#!/bin/sh

if [ -f /es/config/env ]; then
  . /es/config/env
fi

if [ ! -e /es/config/elasticsearch.* ]; then
  cp $ES_HOME/config/elasticsearch.yml /es/config
fi

if [ ! -e /es/config/logging.* ]; then
  cp $ES_HOME/config/logging.yml /es/config
fi

OPTS="$OPTS -Des.path.conf=/es/config \
  -Des.path.data=/es/data \
  -Des.path.logs=/es/data/ \
  -Des.transport.tcp.port=9300 \
  -Des.http.port=9200"

if [ -n "$CLUSTER" ]; then
  OPTS="$OPTS -Des.cluster.name=$CLUSTER"
  if [ -n "$CLUSTER_FROM" ]; then
    if [ -d /es/data/$CLUSTER_FROM -a ! -d /es/data/$CLUSTER ]; then
      echo "Performing cluster data migration from $CLUSTER_FROM to $CLUSTER"
      mv /es/data/$CLUSTER_FROM /es/data/$CLUSTER
    fi
  fi
fi

if [ -n "$NODE_NAME" ]; then
  OPTS="$OPTS -Des.node.name=$NODE_NAME"
fi

if [ -n "$NETWORK" ]; then
  OPTS="$OPTS -Des.node.name=$NODE_NAME"
fi

if [ -n "$MULTICAST" ]; then
  OPTS="$OPTS -Des.discovery.zen.ping.multicast.enabled=$MULTICAST"
fi

if [ -n "$UNICAST_HOSTS" ]; then
  OPTS="$OPTS -Des.discovery.zen.ping.unicast.hosts=$UNICAST_HOSTS"
fi

if [ -n "$PUBLISH_AS" ]; then
  OPTS="$OPTS -Des.transport.publish_host=$(echo $PUBLISH_AS | awk -F: '{print $1}')"
  OPTS="$OPTS -Des.transport.publish_port=$(echo $PUBLISH_AS | awk -F: '{if ($2) print $2; else print 9300}')"
fi

if [ -n "$PLUGINS" ]; then
  for p in $(echo $PLUGINS | awk -v RS=, '{print}')
  do
    echo "Installing the plugin $p"
    $ES_HOME/bin/plugin install $p
  done
fi

echo "Starting Elasticsearch with the options $OPTS"
$ES_HOME/bin/elasticsearch $OPTS