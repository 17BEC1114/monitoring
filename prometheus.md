# Metrics collector

- **Node exporter** only exposes current metrics and does not store the old data/metrics.
- Now, once the metrics are exposed on a particular port or path, you need a software/application which will collect these metrics from the exposed port or path and store it.
- Once the metrics are stored, you can use this older data/metrics to track server usage, peak hours etc.
- These metrics need to be stored with **timestamps**.
- We need a **time-series database** which can store these metrics over a period of time.

---

## **Prometheus**

- It is a **time-series database**.
- Prometheus collects and stores its metrics as time series data, i.e. metrics information is stored with the **timestamp** at which it was recorded, alongside optional key-value pairs called **labels**.
- Prometheus is a **monitoring platform** that collects metrics from monitored targets by scraping metrics HTTP endpoints on targets.
- These **HTTP endpoints** are the ports/paths where node exporter is exporting the metrics.
- The **targets** are the nodes/instances from which Prometheus will collect the metrics.

---

### When user downloads Prometheus tar file, you get below files and directories:

| File/Directory      | Description |
|---------------------|-------------|
| **Prometheus**      | This is the main Prometheus server binary. Run this binary to start Prometheus.<br>- Scraping metrics from targets <br>- Evaluating rules <br>- Storing time-series data <br>- Serving the web UI and HTTP API |
| **Promtool**        | This is the command-line utility for Prometheus. It helps with:<br><br> - Validating configuration files (`prometheus.yml`) <br> - Checking rule files <br> - Debugging expressions <br> - Running unit tests on rules |
| **Console_libraries** | A directory containing shared helper libraries (written in Go templates) used by the Prometheus web UI's consoles. They include utility functions for formatting and templating metric data. |
| **Consoles**        | Contains pre-built example dashboards or "consoles" that demonstrate how to display Prometheus data using templates and the libraries in console_libraries. These are rendered in the Prometheus web interface under `/consoles`. |
| **Prometheus.yml**  | The main configuration file for Prometheus. You customize this file to fit your infrastructure. It defines:<br><br> - Scrape targets (what metrics to collect and from where) <br> - Alerting rules <br> - External labels <br> - Remote write/read targets <br> - Rule evaluation intervals |

---

## **Prometheus as a Service**

Prometheus runs as a binary/command. We need to create a **service** so that Prometheus binary/command can run as a background service.

### **Creating a `prometheus.service` file:**

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
