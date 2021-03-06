# Aerospike 

Aerospike is an open source distributed database. Aerospike is built on a 
"shared nothing" architecture designed to reliably stores terabytes of data 
with automatic fail-over, replication and cross data-center synchronization.

Documentation for Aerospike is available at [http://aerospike.com/docs](http://aerospike.com/docs).

# Using this Image

The following will run `asd` with all the exposed ports forward to the host machine.

	docker run -tid --name aerospike -p 3000:3000 -p 3001:3001 -p 3002:3002 -p 3003:3003 aerospike/aerospike-server
	
**NOTE** Although this is the simplest method to getting Aerospike up and running, but it is not the preferred method. To properly run the container, please specify an **custom configuration** with the **access-address** defined.



# Advanced Usage 

## Custom Configuration

By default, `asd` will use the configuration file in `/etc/aerospike/aerospike.conf`, which is added to the directory by the Dockerfile. To provide a custom configuration, you should first mount a directory containing the file using the `-v` option for `docker`:

	-v <DIRECTORY>:/opt/aerospike/etc

Where `<DIRECTORY>` is the path to a directory containing your custom configuration file. Next, you will want to tell `asd` to use a configuration file from `/opt/aerospike/etc`, by using the `--config-file` option for `aerospike/aerospike-server`:
 
	--config-file /opt/aerospike/etc/aerospike.conf

This will use tell `asd` to use the file in `/opt/aerospike/etc/aerospike.conf`, which is mapped to `<DIRECTORY>/aerospike.conf`.

A full example:

	docker run -tid -v <DIRECTORY>:/opt/aerospike/etc --name aerospike -p 3000:3000 -p 3001:3001 -p 3002:3002 -p 3003:3003 aerospike/aerospike-server /usr/bin/asd --foreground --config-file /opt/aerospike/etc/aerospike.conf

## access-address Configuration

In order for Aerospike to properly broadcast its address to the cluster or applications, the **access-address** needs to be set in the configuration file. If it is not set, then the IP address within the container will be used, which is not accessible to other nodes.

To specify **access-address** in aerospike.conf:

	network {
		service {
			address any                  # Listening IP Address
			port 3000                    # Listening Port
			access-address 192.168.1.100 # IP Address to be used by applications
																	 # and other nodes in the cluster.
		}
		...


## Persistent Data Directory

With Docker, the files within the container are not persisted. To persist the data, you will want to mount a directory from the host to the guest's `/opt/aerospike/data` using the `-v` option:

	-v <DIRECTORY>:/opt/aerospike/data

Where `<DIRECTORY>` is the path to a directory containing your data files.

A full example:

	docker run -tid -v <DIRECTORY>:/opt/aerospike/data --name aerospike -p 3000:3000 -p 3001:3001 -p 3002:3002 -p 3003:3003 aerospike/aerospike-server


## Clustering

Aerospike recommends using multicast clustering whenever possible, however, we are currently working to figure out how to best support multicast via Docker. For the time being, it will be best to setup Mesh Clustering. We are open to pull-requests with proposals on how to implement multicast for our Dockerfile.

### Mesh Clustering

Mesh networking requires setting up links between each node in the cluster. This can be achieved in two ways:

1. Define a configuration for each node in the cluster, as defined in [Network Heartbeat Configuration](http://www.aerospike.com/docs/operations/configure/network/heartbeat/#mesh-unicast-heartbeat).

2. Use `asinfo` to send the `tip` command, to make the node aware of another node, as defined in [tip command in asinfo](http://www.aerospike.com/docs/tools/asinfo/#tip).


# Sending Performance Data to Aerospike

Aerospike Telemetry is a feature that allows us to collect certain use data – not the database data – on your Aerospike Community Edition server use. 
We’d like to know when clusters are created and destroyed, cluster size, cluster workload, how often queries are run, whether instances are deployed purely in-memory or with Flash. 
Aerospike Telemetry collects information from running Community Edition server instances every 10 minutes. The data helps us to understand how the product is being used,
identify issues, and create a better experience for the end user. [More Info](http://www.aerospike.com/aerospike-telemetry/)



# Supported Docker versions

This image is officially supported on Docker version 1.4.1.

Support for older versions (down to 1.0) is provided on a best-effort basis.

# User Feedback

## Issues

If you have any problems with or questions about this image, please contact us on the [Aerospike Forums](discuss.aerospike.com) or through a [GitHub issue](https://github.com/aerospike/aerospike-server.docker/issues).


## Contributing

You are invited to contribute new features, fixes, or updates, large or small; we are always thrilled to receive pull requests, and do our best to process them as fast as we can.

Before you start to code, we recommend discussing your plans on the [Aerospike Forums](discuss.aerospike.com) or through a [GitHub issue](https://github.com/aerospike/aerospike-server.docker/issues), especially for more ambitious contributions. This gives other contributors a chance to point you in the right direction, give you feedback on your design, and help you find out if someone else is working on the same thing.

