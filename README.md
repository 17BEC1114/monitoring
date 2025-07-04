# Node Exporter Setup for Prometheus Monitoring

## Metrics 
There are two types of metrics:-

**System Metrics**: Collected from the host machine or environment (Server/Infrastructure)
- Examples: CPU usage, Memory, disk, network I/O, Load average, Filesystem usage , Host uptime 

**Application Metrics**: Collected from your application - things it knows about itself.
- Examples: Number of requests served, Response times, Error rates, Queue lengths, Custom business metrics (e.g., number of signups) 

  
These metrics are used to monitor the performance of a machine/instance/server or an application whether its working fine or not. 

**In case of application**, it collects its own metrics from the application and exposes it on a particular port or path.  
Example: application.com/metrics, application.com:7586

**In case of server**, these metrics are not exposed by default on a port or path. The metrics just sits there with OS. An agent needs to collect these metrics from the OS/Environment.  
Example of such agent is node-exporter. 


## Node Exporter 
- The Prometheus Node Exporter exposes a wide variety of hardware- and kernel-related metrics. 
- The Prometheus Node Exporter is a single static binary which outputs multiple system metrics when this binary is ran. 
- Node Exporter will collect metrics and expose it on a port. 
- Default port is 9100.
- This binary/command needs to be run as a service so that it always keeps running in the background. 
- To do that, admin should create a node-exporter.service file.
- Use install-node-exporter.sh file to install node exporter. 

## Reference
https://prometheus.io/docs/guides/node-exporter/#installing-and-running-the-node-exporter  
https://developer.couchbase.com/tutorial-node-exporter-setup/
