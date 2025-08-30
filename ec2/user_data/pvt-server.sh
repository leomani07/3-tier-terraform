#!/bin/bash
sudo apt-get update -y
sudo apt-get install -y mysql-client
echo "MySQL client installed. Use: mysql -h <RDS-ENDPOINT> -u admin -p"

