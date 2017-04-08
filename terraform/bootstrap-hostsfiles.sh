#!/bin/bash

cat > ~/hosts <<EOL
127.0.0.1 localhost
192.168.199.5   bastion
192.168.199.10  webserver
192.168.199.20  node-0
192.168.199.21  node-1
192.168.199.22  node-2
EOL
sudo cp ~/hosts /etc/hosts