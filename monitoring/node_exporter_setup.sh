#! /bin/bash
source .env
curl -O -L "https://github.com/prometheus/node_exporter/releases/download/v${NODE_EXPORT_VERSION}/node_exporter-${NODE_EXPORT_VERSION}.linux-amd64.tar.gz"
tar xvf node_exporter-${NODE_EXPORT_VERSION}.linux-amd64.tar.gz 
mv node_exporter-${NODE_EXPORT_VERSION}.linux-amd64/node_exporter /usr/local/bin/

sudo useradd --no-create-home --shell /bin/false node_exporter

sudo chown node_exporter:node_exporter /usr/local/bin/node_exporter

sudo cat <<EOF >"/etc/systemd/system/node_exporter.service"
[Unit]
Description=Node Exporter
Wants=network-online.target
After=network-online.target
[Service]
User=node_exporter
Group=node_exporter
Type=simple
ExecStart=/usr/local/bin/node_exporter
[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload
sudo systemctl start node_exporter
sudo systemctl enable node_exporter
sudo systemctl status node_exporter