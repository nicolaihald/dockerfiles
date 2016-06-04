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
ENV ES_CLUSTER_NAME=ElasticAWS \	
	#ES_HEAP_SIZE=1g \
	# AWS: 	
	ES_DISOVERY_TYPE=ec2 \
	ES_DISOVERY_EC2_GROUPS=sg-8c53fceb \
	ES_CLOUD_AWS_REGION=eu-west-1

# Pre-install default plugin
RUN bin/plugin install royrusso/elasticsearch-HQ
RUN bin/plugin install cloud-aws

CMD ["/bin/bash", "/start.sh"]