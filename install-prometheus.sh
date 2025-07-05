# Creating a user for node-exporter
sudo useradd --no-create-home prometheus
echo "Created prometheus user"

# Getting the architecture of machine 
Architecture=$(uname -m)

if [[ "$Architecture" == "x86_64" ]]; then
    echo "Architecture: AMD64 (x86_64)"
# Downloading the node-exporter tar file for AMD machine 
    sudo curl -LO https://github.com/prometheus/prometheus/releases/download/v2.53.5/prometheus-2.53.5.linux-amd64.tar.gz

# Untarring the downloaded file
    sudo tar -xvf prometheus-2.53.5.linux-amd64.tar.gz

# Copying executables to /usr/local/bin    
    sudo cp prometheus-2.53.5.linux-amd64/prometheus /usr/local/bin/prometheus
    sudo cp prometheus-2.53.5.linux-amd64/promtool /usr/local/bin/promtool
    echo "Copied prometheus and promtool to /usr/local/bin"

# Creating Prometheus configuration directories and files.
    sudo mkdir /etc/prometheus
    sudo cp prometheus-2.53.5.linux-amd64/prometheus.yml /etc/prometheus
    sudo touch /etc/prometheus/rules.yml
    sudo touch /etc/prometheus/web.yml

# Setting up files and directories permissions  
    sudo chmod 0750 /etc/prometheus
    sudo chmod 0600 /etc/prometheus/prometheus.yml
    sudo chmod 0600 /etc/prometheus/rules.yml
    sudo chmod 0600 /etc/prometheus/web.yml
    sudo chown -R prometheus:prometheus /etc/prometheus

# Configuring Prometheus storage directories and files    
    sudo mkdir /var/lib/prometheus
    sudo mkdir /var/lib/prometheus/tsdb
    
# Copying consoles and consoles libraries    
    sudo mv prometheus-2.53.5.linux-amd64/console_libraries /var/lib/prometheus
    sudo mv prometheus-2.53.5.linux-amd64/consoles /var/lib/prometheus

# Setting up permissions for prometheus storage
    sudo chmod 0750 /var/lib/prometheus
    sudo chown -R prometheus:prometheus /var/lib/prometheus

elif [[ "$Architecture" == "aarch64" ]]; then
    echo "Architecture: ARM64 (aarch64)"
# Downloading the node-exporter tar file for ARM machine 
    sudo curl -LO https://github.com/prometheus/prometheus/releases/download/v2.53.5/prometheus-2.53.5.linux-arm64.tar.gz
# Untarring the downloaded file
    sudo tar -xvf prometheus-2.53.5.linux-arm64.tar.gz

# Copying executables to /usr/local/bin    
    sudo cp prometheus-2.53.5.linux-arm64/prometheus /usr/local/bin/prometheus
    sudo cp prometheus-2.53.5.linux-arm64/promtool /usr/local/bin/promtool
    echo "Copied prometheus and promtool to /usr/local/bin"

# Creating Prometheus configuration directories and files.
    sudo mkdir /etc/prometheus
    sudo cp prometheus-2.53.5.linux-arm64/prometheus.yml /etc/prometheus
    sudo touch /etc/prometheus/rules.yml
    sudo touch /etc/prometheus/web.yml

# Setting up files and directories permissions  
    sudo chmod 0750 /etc/prometheus
    sudo chmod 0600 /etc/prometheus/prometheus.yml
    sudo chmod 0600 /etc/prometheus/rules.yml
    sudo chmod 0600 /etc/prometheus/web.yml
    sudo chown -R prometheus:prometheus /etc/prometheus

# Configuring Prometheus storage directories and files    
    sudo mkdir /var/lib/prometheus
    sudo mkdir /var/lib/prometheus/tsdb
    
# Copying consoles and consoles libraries    
    sudo mv prometheus-2.53.5.linux-arm64/console_libraries /var/lib/prometheus
    sudo mv prometheus-2.53.5.linux-arm64/consoles /var/lib/prometheus

# Setting up permissions for prometheus storage
    sudo chmod 0750 /var/lib/prometheus
    sudo chown -R prometheus:prometheus /var/lib/prometheus

else
    echo "Unknown architecture: $ARCHITECTURE"
    exit 1
fi

# Removing the downloaded file and extracted file
    sudo rm -rf prometheus-2.53.5.linux-arm64.tar.gz prometheus-2.53.5.linux-arm64


# Creating a prometheus.service file to run prometheus as a service
sudo touch /etc/systemd/system//prometheus.service
sudo chmod 0640 /etc/systemd/system//prometheus.service

sudo tee /etc/systemd/system//prometheus.service <<'EOF'
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
EOF

# Starting prometheus service
sudo systemctl enable prometheus
sudo systemctl start prometheus
sudo systemctl status prometheus