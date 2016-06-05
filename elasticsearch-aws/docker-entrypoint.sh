#!/usr/bin/env bash
#!/bin/bash

# Exit the script as soon as something fails.
set -e


# ###############################################################################
# 					 	 Set environment
# ################################################################################
ES_CLUSTER_NAME=${ES_CLUSTER_NAME:-"elastico"}
ES_CFG_FILE="/usr/share/elasticsearch/config/elasticsearch.yml"
# Download the config file if given a URL
if [ ! -z ${ES_CFG_URL} ]; then
  curl -sSL --output ${ES_CFG_FILE} ${ES_CFG_URL}
  if [ $? -ne 0 ]; then
    echo "[ES] Unable to download file ${ES_CFG_URL}."
    exit 1
  fi
fi

# Reset/set to value to avoid errors in env processing
ES_CFG_URL=${ES_CFG_FILE}

# Process environment variables
for VAR in `env`; do
  if [[ "$VAR" =~ ^ES_ && ! "$VAR" =~ ^ES_CFG_ && ! "$VAR" =~ ^ES_PLUGIN_ && ! "$VAR" =~ ^ES_HOME && ! "$VAR" =~ ^ES_VERSION && ! "$VAR" =~ ^ES_VOL && ! "$VAR" =~ ^ES_USER && ! "$VAR" =~ ^ES_GROUP ]]; then
    ES_CONFIG_VAR=$(echo "$VAR" | sed -r "s/ES_(.*)=.*/\1/g" | tr '[:upper:]' '[:lower:]' | tr _ . | sed  -r "s/\.\./_/g")
    ES_ENV_VAR=$(echo "$VAR" | sed -r "s/(.*)=.*/\1/g")

    if egrep -q "(^|^#)$ES_CONFIG_VAR" $ES_CFG_FILE; then
      # No config values may contain an '@' char. Below is due to bug otherwise seen.
      sed -r -i "s@(^|^#)($ES_CONFIG_VAR): (.*)@\2: ${!ES_ENV_VAR}@g" $ES_CFG_FILE
    else
      echo "$ES_CONFIG_VAR: ${!ES_ENV_VAR}" >> $ES_CFG_FILE
    fi
  fi
done
# #################################################################################

# #################################################################################
# 	Add elasticsearch as command if needed
# #################################################################################
if [ "${1:0:1}" = '-' ]; then
	set -- elasticsearch "$@"
fi

# Drop root privileges if we are running elasticsearch
# allow the container to be started with `--user`
if [ "$1" = 'elasticsearch' -a "$(id -u)" = '0' ]; then
	# Change the ownership of /usr/share/elasticsearch/data to elasticsearch
	chown -R elasticsearch:elasticsearch /usr/share/elasticsearch/data
	
	set -- gosu elasticsearch "$@"
	#exec gosu elasticsearch "$BASH_SOURCE" "$@"
fi

# #################################################################################
# ECS will report the docker interface without help, so we override that with host's private ip
# #################################################################################
AWS_PRIVATE_IP=`curl http://169.254.169.254/latest/meta-data/local-ipv4`
set -- "$@" --network.publish_host=$AWS_PRIVATE_IP

# As argument is not related to elasticsearch,
# then assume that user wants to run his own process,
# for example a `bash` shell to explore this image
exec "$@"