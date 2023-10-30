#!/bin/bash
source .env
echo -e "Installing dependency\n========================\n"
sudo apt install curl unzip -y
echo -e "\n========================\n"

sudo useradd --no-create-home --shell /bin/false prometheus
sudo mkdir /etc/prometheus
sudo mkdir /var/lib/prometheus
sudo chown prometheus:prometheus /etc/prometheus
sudo chown prometheus:prometheus /var/lib/prometheus/
sudo chown prometheus:prometheus /etc/prometheus/
curl -O -L "https://github.com/prometheus/prometheus/releases/download/v${PROMETHEUS_VERSION}/prometheus-${PROMETHEUS_VERSION}.linux-amd64.tar.gz"
tar xvf prometheus-${PROMETHEUS_VERSION}.linux-amd64.tar.gz

sudo cp prometheus-${PROMETHEUS_VERSION}.linux-amd64/prometheus /usr/local/bin/ 
sudo cp prometheus-${PROMETHEUS_VERSION}.linux-amd64/promtool /usr/local/bin/ 
sudo chown prometheus:prometheus /usr/local/bin/prometheus 
sudo chown prometheus:prometheus /usr/local/bin/promtool 
sudo cp -r prometheus-${PROMETHEUS_VERSION}.linux-amd64/consoles/ /etc/prometheus/
sudo cp -r prometheus-${PROMETHEUS_VERSION}.linux-amd64/console_libraries/ /etc/prometheus/
sudo chown  -R prometheus:prometheus /etc/prometheus/consoles/
sudo chown  -R prometheus:prometheus /etc/prometheus/console_libraries/
sudo cp prometheus-${PROMETHEUS_VERSION}.linux-amd64/prometheus.yml  /etc/prometheus/
sudo chown  prometheus:prometheus /etc/prometheus/prometheus.yml
sudo cat <<EOF > "/etc/systemd/system/prometheus.service"
[Unit]
Description=Prometheus
Wants=network-online.target
After=network-online.target
[Service]
User=prometheus
Group=prometheus
Type=simple
ExecStart=/usr/local/bin/prometheus \
    --config.file /etc/prometheus/prometheus.yml \
    --storage.tsdb.path /var/lib/prometheus/ \
    --web.console.templates=/etc/prometheus/consoles \
    --web.console.libraries=/etc/prometheus/console_libraries
[Install]
WantedBy=multi-user.target
EOF


sleep 2
sudo systemctl daemon-reload
sudo systemctl start prometheus
sudo systemctl enable prometheus
sudo systemctl status prometheus
