FROM java:8-jre

MAINTAINER nicolaihald

ENV LOGSTASH_VERSION 1.5.0-1

# install plugin dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
		libzmq3 \
	&& apt-get install logrotate -y --no-install-recommends \
	&& rm -rf /var/lib/apt/lists/*

RUN wget -qO /tmp/logstash.deb http://download.elastic.co/logstash/logstash/packages/debian/logstash_${LOGSTASH_VERSION}_all.deb
RUN dpkg -i /tmp/logstash.deb && rm /tmp/logstash.deb

ENV PATH /opt/logstash/bin:$PATH

WORKDIR /opt/logstash

# For collectd reception
EXPOSE 25826

# /conf is the default directory where our logstash will read pipeline config files
# /logs is an optional attach point to reference something like /var/log on the host
VOLUME ["/config","/logs"]

ENV PLUGIN_UPDATES 2016-05-16

RUN bin/plugin install logstash-input-heartbeat
RUN bin/plugin install logstash-output-elasticsearch_groom

CMD ["bin/logstash","agent","-f","/config"]