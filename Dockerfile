#
# Aerospike Server Dockerfile
#
# http://github.com/aerospike/aerospike-server.docker
#

FROM centos6-base

ENV AEROSPIKE_VERSION 3.8.3

COPY aerospike-server-community-$AEROSPIKE_VERSION-el6.tgz /tmp/aerospike-server.tgz

# Install Aerospike
RUN \
  yum install -y logrotate ca-certificates tar \
  && mkdir aerospike \
  && tar xzf /tmp/aerospike-server.tgz --strip-components=1 -C aerospike \
  && rpm -ivh aerospike/aerospike-server-*.rpm \
  && mkdir -p /var/log/aerospike/ \
  && mkdir -p /var/run/aerospike/ \
  && rm -rf aerospike-server.tgz aerospike /var/lib/apt/lists/*
 

# Add the Aerospike configuration specific to this dockerfile
COPY aerospike.conf /etc/aerospike/aerospike.conf
COPY entrypoint.sh /entrypoint.sh
# Mount the Aerospike data directory
VOLUME ["/opt/aerospike/data"]
# VOLUME ["/etc/aerospike/"]


# Expose Aerospike ports
#
#   3000 – service port, for client connections
#   3001 – fabric port, for cluster communication
#   3002 – mesh port, for cluster heartbeat
#   3003 – info port
#
EXPOSE 3000 3001 3002 3003

# Execute the run script in foreground mode
ENTRYPOINT ["/entrypoint.sh"]
CMD ["asd"]
