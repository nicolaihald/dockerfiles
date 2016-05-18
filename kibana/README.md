Ready-to-run [Kibana](http://www.elasticsearch.org/overview/kibana/) server that can
easily hook into your [Elasticsearch containers](https://registry.hub.docker.com/u/nicolaihald/elasticsearch/).

## Usage (linked containers)
Run elasticsearch 

    docker run -d --name ES -p 9200:9200 nicolaihald/elasticsearch

Run Kibana 

    docker run -d -p 5601:5601 --link ES:elasticsearch nicolaihald/kibana

Kibana will then be accessible from http://dockermachine:5601  (fx. http://192.168.99.100:5601) \
Checkout the official [Kibana documentation](http://www.elasticsearch.org/guide/en/kibana/current/access.html)

## Usage with non-Docker elasticsearch

Start Kibana using

    docker run -d -p 5601:5601 -e ES_URL=http://YOUR_ES:9200 nicolaihald/kibana

Replacing `http://YOUR_ES:9200` with the appropriate URL for your system.