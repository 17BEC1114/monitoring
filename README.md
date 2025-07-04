# Node Exporter Setup for Prometheus Monitoring

## Overview

**Metrics are essential for monitoring the health and performance of your servers and applications.**  
They fall into two broad categories:

### 🔧 System Metrics (Infrastructure Metrics)
Collected from the host machine or environment (e.g., servers, VMs, containers).

**Examples:**
- CPU usage
- Memory usage
- Disk and network I/O
- Load average
- Filesystem usage
- Host uptime

### 🧠 Application Metrics
Collected directly from your application — metrics that the app knows about itself.

**Examples:**
- Number of requests served
- Response times
- Error rates
- Queue lengths
- Custom business metrics (e.g., number of user signups)

---

## How Metrics Are Exposed

### 📡 Application
Applications often expose their metrics over HTTP endpoints.

**Example:**
