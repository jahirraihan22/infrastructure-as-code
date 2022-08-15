#!/bin/bash

# Installing Dependencies
echo "##########################"
echo "Installing Dependencies."
echo "##########################"
sudo yum install wget unzip httpd -y > /dev/null

# Start & Enable Service
echo "##########################"
echo "Start & Enable HTTPD Service."
echo "##########################"
sudo systemctl start httpd 
sudo systemctl enable httpd 
echo 

#Creating Temporary Directory
echo "##########################"
echo "Starting Artifact Deployment."
echo "##########################"
mkdir -p /tmp/webfiles # Note: -p will overwrite if file exists
cd /tmp/webfiles
echo

wget https://www.tooplate.com/zip-templates/2129_crispy_kitchen.zip > /dev/null
unzip 2129_crispy_kitchen.zip > /dev/null
sudo cp -r 2129_crispy_kitchen/* /var/www/html/ > /dev/null
echo

#Bounce Service
echo "##########################"
echo "Restarting HTTPD Service"
echo "##########################"
systemctl restart httpd 
echo

#Clean Up
echo "##########################"
echo "Removing Temporary Files"
echo "##########################"
rm -rf /tmp/webfiles
echo

echo "================ Completed ================"

sudo systemctl status httpd
ls  /var/www/html/
