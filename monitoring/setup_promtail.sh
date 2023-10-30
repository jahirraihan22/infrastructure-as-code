#! /bin/bash


sudo cp "/vagrant/promtail-linux-amd64" /usr/local/bin

sudo useradd --no-create-home --shell /bin/false promtail
# make promtail as sudoer
echo "promtail  ALL=(ALL) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/promtail

sudo mkdir -p /etc/promtail

sudo chown promtail:promtail /usr/local/bin/promtail-linux-amd64

sudo chown -R promtail:promtail /etc/promtail/
sudo cp /vagrant/promtail-local-config.yaml /etc/promtail/

sudo chown promtail:promtail /etc/promtail/promtail-local-config.yaml
sudo touch /etc/systemd/system/promtail.service
sudo cat <<EOF > "/etc/systemd/system/promtail.service"
[Unit]
Description=promtail
Wants=network-online.target
After=network-online.target
[Service]
User=promtail
Group=promtail
Type=simple
ExecStart=sudo /usr/local/bin/promtail-linux-amd64 -config.file=/etc/promtail/promtail-local-config.yaml
[Install]
WantedBy=multi-user.target
EOF
sudo chown promtail:promtail /etc/systemd/system/promtail.service

sudo systemctl daemon-reload

sudo systemctl start promtail

sudo systemctl enable promtail

sudo systemctl status promtail