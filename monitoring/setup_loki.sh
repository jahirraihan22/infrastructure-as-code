#! /bin/bash


sudo cp "/vagrant/loki-linux-amd64" /usr/local/bin

sudo useradd --no-create-home --shell /bin/false loki
# make loki as sudoer
echo "loki  ALL=(ALL) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/loki
sudo mkdir -p /etc/loki

sudo chown loki:loki /usr/local/bin/loki-linux-amd64

sudo chown -R loki:loki /etc/loki/
sudo cp /vagrant/promtail-local-config.yaml /etc/loki/

sudo chown loki:loki /etc/loki/promtail-local-config.yaml
sudo touch /etc/systemd/system/loki.service
sudo cat <<EOF >"/etc/systemd/system/loki.service"
[Unit]
Description=Loki
Wants=network-online.target
After=network-online.target
[Service]
User=loki
Group=loki
Type=simple
ExecStart=sudo /usr/local/bin/loki-linux-amd64 -config.file=/etc/loki/loki-local-config.yaml
[Install]
WantedBy=multi-user.target
EOF
sudo chown loki:loki /etc/systemd/system/loki.service

sudo systemctl daemon-reload

sudo systemctl start loki

sudo systemctl enable loki

sudo systemctl status loki