This Docker image provides an easily configurable Elasticsearch node. Via
port mappings, it is easy to create an arbitrarily sized cluster of
nodes. As long as the versions match, you can mix-and-match "real"
Elasticsearch nodes with container-ized ones.


### All credits goes to itzg
Check-out **Geoff's** original [repo](https://hub.docker.com/r/itzg/elasticsearch/). 


# Basic Usage
To start an Elasticsearch data node that listens on the standard ports on
your host's network interface:

    docker run -d -p 9200:9200 -p 9300:9300 nicolaihald/elasticsearch

You'll then be able to connect to the Elasticsearch HTTP interface to confirm
it's alive:

http://DOCKERHOST:9200/

    {
      "status" : 200,
      "name" : "Charon",
      "version" : {
        "number" : "1.3.5",
        "build_hash" : "4a50e7df768fddd572f48830ae9c35e4ded86ac1",
        "build_timestamp" : "2014-11-05T15:21:28Z",
        "build_snapshot" : false,
        "lucene_version" : "4.9"
      },
      "tagline" : "You Know, for Search"
    }

Where `DOCKERHOST` would be the actual hostname of your host running
Docker.

# Simple, multi-node cluster

To run a multi-node cluster (3-node in this example) on a single Docker machine use:

    docker run -d --name es0 -p 9200:9200                    es
    docker run -d --name es1 --link es0 -e UNICAST_HOSTS=es0 es
    docker run -d --name es2 --link es0 -e UNICAST_HOSTS=es0 es


and then check the cluster health, such as http://192.168.99.100:9200/_cluster/health?pretty

    {
      "cluster_name" : "elasticsearch",
      "status" : "green",
      "timed_out" : false,
      "number_of_nodes" : 3,
      "number_of_data_nodes" : 3,
      "active_primary_shards" : 0,
      "active_shards" : 0,
      "relocating_shards" : 0,
      "initializing_shards" : 0,
      "unassigned_shards" : 0
    }

# Configuration

The following configuration options are specified using `docker run`
environment variables (`-e`) like

    docker run ... -e NAME=VALUE ... nicolaihald/elasticsearch

Since Docker's `-e` settings are baked into the container definition, this image provides an
extra feature to change any of the settings below for an existing container. Either
create/edit the file `env` in the `/conf` volume mapping or edit within the running container's
context using:

    docker exec -it CONTAINER_ID vi /conf/env

replacing `CONTAINER_ID` with the container's ID or name.

The contents of the `/conf/env` file are standard shell

    NAME=VALUE

entries where `NAME` is one of the variables described below.

Configuration options not explicitly supported below can be specified via the `OPTS` environment variable. For
example, by default `OPTS` is set with

    OPTS=-Dnetwork.bind_host=_non_loopback_

_NOTE: That option is a default since `bind_host` defaults to `localhost` as of 2.0, which isn't helpful for
port mapping out from the container_.

## Cluster Name

If joining a pre-existing cluster, then you may need to specify a cluster name
different than the default "elasticsearch":

    -e CLUSTER=dockers

## Zen Unicast Hosts

When joining a multi-physical-host cluster, multicast may not be supported
on the physical network. In that case, your node can reference specific one or more hosts in
the cluster via the
[Zen Unicast Hosts](http://www.elasticsearch.org/guide/en/elasticsearch/reference/current/modules-discovery-zen.html#unicast) capability as a comma-separated list of `HOST:PORT` pairs:

    -e UNICAST_HOSTS=HOST:PORT[,HOST:PORT]

such as

    -e UNICAST_HOSTS=192.168.0.100:9300

## Plugins

You can install one or more plugins before startup by passing a comma-separated
list of plugins.

    -e PLUGINS=ID[,ID]

In this example, it will install the Marvel plugin

    -e PLUGINS=elasticsearch/marvel/latest
    -e PLUGINS=royrusso/elasticsearch-HQ
   
	
_Example_:
```
docker run -d -p 9200:9200 -p 9300:9300 -e PLUGINS=royrusso/elasticsearch-HQ nicolaihald/elasticsearch
```

Many more plugins [are available here](http://www.elasticsearch.org/guide/en/elasticsearch/reference/current/modules-plugins.html#known-plugins).

## Publish As

Since the container gives the Elasticsearch software an isolated perspective
of its networking, it will most likely advertise its published address with
a container-internal IP address. This can be overridden with a physical networking
name and port using:

    -e PUBLISH_AS=DOCKERHOST:9301

_Author Note: I have yet to hit a case where this was actually necessary. Other
than the cosmetic weirdness in the logs, Elasticsearch seems to be quite tolerant._

## Node Name

Rather than use the randomly assigned node name, you can indicate a specific
one using:

    -e NODE_NAME=Docker