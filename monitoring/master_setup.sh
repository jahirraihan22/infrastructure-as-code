#! /bin/bash
echo -e "Setting up Grafana\n===================================\n"
sudo ./grafana_setup.sh
echo -e "\n===================================\n"
sleep 2

echo -e "Setting up Loki\n===================================\n"
sudo ./loki_setup.sh
echo -e "\n===================================\n"
sleep 2

echo -e "Setting up Prometheus\n===================================\n"
sudo ./prometheus_setup.sh
echo -e "\n===================================\n"
sleep 2