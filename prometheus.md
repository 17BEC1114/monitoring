# Metrics collector

- **Node exporter** only exposes current metrics and does not store the old data/metrics.
- Now, once the metrics are exposed on a particular port or path, you need a software/application which will collect these metrics from the exposed port or path and store it.
- Once the metrics are stored, you can use this older data/metrics to track server usage, peak hours etc.
- These metrics need to be stored with **timestamps**.
- We need a **time-series database** which can store these metrics over a period of time.

  
  

## **Prometheus**

- It is a **time-series database**.
- Prometheus collects and stores its metrics as time series data, i.e. metrics information is stored with the **timestamp** at which it was recorded, alongside optional key-value pairs called **labels**.
- Prometheus is a **monitoring platform** that collects metrics from monitored targets by scraping metrics HTTP endpoints on targets.
- These **HTTP endpoints** are the ports/paths where node exporter is exporting the metrics.
- The **targets** are the nodes/instances from which Prometheus will collect the metrics.

  
  

### When user downloads Prometheus tar file, you get below files and directories:

| File/Directory      | Description |
|---------------------|-------------|
| **Prometheus**      | This is the main Prometheus server binary. Run this binary to start Prometheus.<br>- Scraping metrics from targets <br>- Evaluating rules <br>- Storing time-series data <br>- Serving the web UI and HTTP API |
| **Promtool**        | This is the command-line utility for Prometheus. It helps with:<br>- Validating configuration files (`prometheus.yml`) <br>- Checking rule files <br>- Debugging expressions <br>- Running unit tests on rules |
| **Console_libraries** | A directory containing shared helper libraries (written in Go templates) used by the Prometheus web UI's consoles. They include utility functions for formatting and templating metric data. |
| **Consoles**        | Contains pre-built example dashboards or "consoles" that demonstrate how to display Prometheus data using templates and the libraries in console_libraries. These are rendered in the Prometheus web interface under `/consoles`. |
| **Prometheus.yml**  | The main configuration file for Prometheus. You customize this file to fit your infrastructure. It defines:<br>- Scrape targets (what metrics to collect and from where) <br>- Alerting rules <br>- External labels <br>- Remote write/read targets <br>- Rule evaluation intervals |
  


## **Prometheus as a Service**

Prometheus runs as a binary/command. We need to create a **service** so that Prometheus binary/command can run as a background service.

### **Creating a `prometheus.service` file:**

The above used flags in the prometheus.service file are to mention required configurations.  
You can see a list of these by running ./prometheus --help command in the directory where Prometheus binary is present.

```ini
[Unit]
Description=Prometheus
Documentation=https://prometheus.io/docs/introduction/overview/
Wants=network-online.target
After=network-online.target

[Service]
User=prometheus
Group=prometheus
Type=simple
ExecStart=/usr/local/bin/prometheus \
  --config.file /etc/prometheus/prometheus.yml \
  --web.config.file /etc/prometheus/web.yml \
  --storage.tsdb.retention.time 2d \
  --web.enable-remote-write-receiver \
  --web.listen-address :9090 \
  --storage.tsdb.path /var/lib/prometheus/tsdb \
  --web.console.templates=/var/lib/prometheus/consoles \
  --web.console.libraries=/var/lib/prometheus/console_libraries

[Install]
WantedBy=multi-user.target
```

## Configuring Prometheus
  - We can configure Prometheus using the prometheus.yml file.  
  - The Prometheus download comes with a sample configuration in a file called prometheus.yml  
  - Prometheus is configured via command-line flags and a configuration file.  
  - The command-line flags configure immutable system parameters (such as storage locations, amount of data to keep on disk and in memory, etc.)  
  - The configuration file defines everything related to scraping jobs and their instances, as well as which rule files to load.  
  - There are three blocks of configuration in the example configuration file:  
    - global
    - rule_files
    - scrape_configs

**global**
  - The global block controls the Prometheus server's global configuration.  
  - The scrape_interval controls how often Prometheus will scrape targets.  
  - The evaluation_interval option controls how often Prometheus will evaluate rules.  

**rule_files**
  - The rule_files block specifies the location of any rules we want the Prometheus server to load.

**scrape_configs**
  - This controls what resources Prometheus monitors.  
  - Since Prometheus also exposes data about itself as an HTTP endpoint, it can scrape and monitor its own health.  
  - In the default configuration, there is a single job, called prometheus, which scrapes the time series data exposed by the Prometheus server.  
  - The job contains a single, statically configured, target — localhost on port 9090.  
  - Prometheus expects metrics to be available on targets on a path of /metrics.  
    

### Reference
https://prometheus.io/docs/introduction/first_steps/#configuring-prometheus  
https://prometheus.io/docs/prometheus/latest/configuration/configuration/  
https://bindplane.com/docs/going-to-production/bindplane/architecture/prometheus/install-manual
