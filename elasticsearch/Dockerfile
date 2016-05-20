FROM java:8-jre

# All credits goes to Geoff Bourne. 
# Checkout his original repo: https://hub.docker.com/r/itzg/elasticsearch/
MAINTAINER nicolaihald

ENV ES_VERSION 2.3.2

RUN wget -qO /tmp/es.tgz https://download.elasticsearch.org/elasticsearch/release/org/elasticsearch/distribution/tar/elasticsearch/$ES_VERSION/elasticsearch-$ES_VERSION.tar.gz && \
  cd /usr/share && \
  tar xf /tmp/es.tgz && \
  rm /tmp/es.tgz

ENV ES_HOME /usr/share/elasticsearch-$ES_VERSION
RUN useradd -d $ES_HOME -M -r elasticsearch && \
  chown -R elasticsearch: $ES_HOME

RUN mkdir /es /es/data /es/config && touch /es/data/.CREATED /es/config/.CREATED && chown -R elasticsearch: /es/data /es/config
#VOLUME ["/data","/conf"]
VOLUME ["/es/data", "/es/config"]

ADD start.sh /start.sh

WORKDIR $ES_HOME
USER elasticsearch

EXPOSE 9200 9300

# set ES_HEAP_SIZE to 50% of mem_limit, but no more than 31g
ENV CLUSTER_NAME=Elastic \
	ES_HEAP_SIZE=1g \
	ES_NODE_MASTER=true \
	ES_NODE_DATA=true \
	ES_NETWORK_HOST=_eth0:ipv4_ \
	ES_NETWORK_BIND_HOST=0.0.0.0 \
	ES_DISOVERY_ZEN_PING_MULTICAST_ENABLED=true \
	ES_DISOVERY_ZEN_PING_UNICAST_HOSTS=

#ENV OPTS=-Dnetwork.host=_non_loopback_

# default plugin
#ENV PLUGINS royrusso/elasticsearch-HQ
RUN bin/plugin install royrusso/elasticsearch-HQ

CMD ["/bin/bash", "/start.sh"]