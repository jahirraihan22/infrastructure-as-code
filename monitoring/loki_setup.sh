#! /bin/bash

source .env
echo -e "Installing dependency\n========================\n"
sudo apt install curl unzip -y
echo -e "\n========================\n"

echo -e "Creating User\n========================\n"
sudo useradd --no-create-home --shell /bin/false loki
# make loki as sudoer
echo "loki  ALL=(ALL) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/loki
echo -e "Downloading Loki executable\n========================\n"

curl -O -L "https://github.com/grafana/loki/releases/download/v${LOKI_VERSION}/loki-linux-amd64.zip"
unzip loki-linux-amd64.zip
sudo cp loki-linux-amd64 /usr/local/bin
sudo chown loki:loki /usr/local/bin/loki-linux-amd64

sudo mkdir -p /etc/loki
sudo chown -R loki:loki /etc/loki/

sudo cp ${LOKI_CONFIG_PATH} /etc/loki/
sudo chown loki:loki /etc/loki/*.yaml

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