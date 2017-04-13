#!/bin/bash

sed -i 's/Port\ 22/Port\ 873/g' /etc/ssh/sshd_config
sed -i 's/PermitRootLogin\ yes/PermitRootLogin\ no/g' /etc/ssh/sshd_config
service ssh restart