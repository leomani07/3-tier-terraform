#!/bin/bash
sudo apt-get update -y
sudo apt-get install -y apache2
echo "<h1>Public Server is Running</h1>" | sudo tee /var/www/html/index.html
systemctl enable apache2
systemctl start apache2

