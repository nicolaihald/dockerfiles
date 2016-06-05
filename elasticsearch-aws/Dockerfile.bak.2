FROM java:8-jre

# credits goes to Geoff Bourne. 
# Checkout his original repo: https://hub.docker.com/r/itzg/elasticsearch/
MAINTAINER nicolaihald

# Setup environment
ENV ES_VERSION 2.3.2 
ENV ES_HOME /opt/elasticsearch 
ENV ES_VOL /var/lib/elasticsearch 
ENV ES_USER elasticsearch 
ENV ES_GROUP elasticsearch

#ENV ES_PLUGIN_AWS_VERSION 2.7.1
#ENV ES_PLUGIN_BIGDESK_VERSION 2.5.0

# Install requirements and Elasticsearch
#RUN apt-get update && apt-get install -y \
#RUN apt-get update
RUN apt-get install -y \
      curl \
      bash && \
    mkdir -p \
      ${ES_VOL}/data \
      ${ES_VOL}/logs \
      ${ES_VOL}/plugins \
      ${ES_VOL}/work \
      ${ES_VOL}/config \
      /opt &&\
    curl -sSL https://download.elasticsearch.org/elasticsearch/elasticsearch/elasticsearch-${ES_VERSION}.tar.gz | tar zxf - -C /opt &&\
    ln -s /opt/elasticsearch-${ES_VERSION} ${ES_HOME} 
    #  <-- make a symbolic link ("/opt/elasticsearch") to "/opt/elasticsearch-2.3.2" 

RUN useradd -d $ES_HOME -M -r elasticsearch && \
  chown -R elasticsearch: $ES_HOME

RUN ${ES_HOME}/bin/plugin install cloud-aws --timeout 2m &&\
    ${ES_HOME}/bin/plugin install royrusso/elasticsearch-HQ --timeout 2m
    #${ES_HOME}/bin/plugin install royrusso/elasticsearch-HQ --silent --timeout 2m

# Configure environment
COPY src/ /

# Expose volumes
VOLUME ["${ES_VOL}"]

# Define working directory.dps
WORKDIR ${ES_VOL}

# Listen for 9200/tcp (HTTP) and 9300/tcp (cluster)
EXPOSE 9200 9300

###############################################################################
#                                    START
###############################################################################

# Allow us to customize the entrypoint of the image.
COPY docker-entrypoint.sh /

# Start container
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["elasticsearch"]


