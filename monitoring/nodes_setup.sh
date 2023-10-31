#! /bin/bash
echo -e "Setting up Promtail\n===================================\n"
sudo ./promtail_setup.sh
echo -e "\n===================================\n"
sleep 2

echo -e "Setting up Node Exporter\n===================================\n"
sudo ./node_exporter_setup.sh
echo -e "\n===================================\n"
sleep 2
