FROM java:8-jre

MAINTAINER nicolaihald

ENV ES_VERSION 2.3.2
ENV ES_HOME /usr/share/elasticsearch-$ES_VERSION

WORKDIR $ES_HOME

RUN wget -qO /tmp/es.tgz https://download.elasticsearch.org/elasticsearch/release/org/elasticsearch/distribution/tar/elasticsearch/$ES_VERSION/elasticsearch-$ES_VERSION.tar.gz && \
  cd /usr/share && \
  tar xf /tmp/es.tgz && \
  rm /tmp/es.tgz

RUN useradd -d $ES_HOME -M -r elasticsearch && \
  chown -R elasticsearch: $ES_HOME

RUN mkdir /es /es/data /es/config && touch /es/data/.CREATED /es/config/.CREATED && chown -R elasticsearch: /es/data /es/config

# Add mounting points
VOLUME ["/es/data", "/es/config"]
COPY config/ /es/config

ADD start.sh /start.sh
USER elasticsearch

EXPOSE 9200 9300

# DEFAULT SETTINGS:
# Set ES_HEAP_SIZE to 50% of mem_limit:
ENV CLUSTER_NAME=Elastic \
	#ES_HEAP_SIZE=1g \
	# AWS: 	
	DISOVERY_EC2_GROUPS= \
	DISOVERY_EC2_TAG_ES_CLUSTER=

# Pre-install default plugin
RUN bin/plugin install royrusso/elasticsearch-HQ
RUN bin/plugin install cloud-aws

CMD ["/bin/bash", "/start.sh"]