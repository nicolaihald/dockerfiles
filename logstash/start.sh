#!/bin/bash

set -e

# Add logstash as command if needed
if [ "${1:0:1}" = '-' ]; then
  set -- logstash "$@"
fi

# Run as user "logstash" if the command is "logstash"
if [ "$1" = 'logstash' ]; then
  set -- gosu logstash "$@"
fi


LOGSTASH_CFG_FILE="/config/logstash.conf"
# Download the config file if given a URL
if [ ! -z ${LOGSTASH_CFG_URL} ]; then
  wget -O ${LOGSTASH_CFG_FILE} ${LOGSTASH_CFG_URL}
  if [ $? -ne 0 ]; then
    echo "[LOGSTASH] Unable to download file ${LOGSTASH_CFG_URL}."
    exit 1
  fi
fi

exec "$@"