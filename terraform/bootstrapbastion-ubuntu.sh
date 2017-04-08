#!/bin/bash
#######################terraf   
#
# Bootstrap script for Ubuntu
#
#######################

echo "#############################

Installation de GIT

#################################"

sudo apt-get install -y git
sudo apt-get install -y unzip gzip gcc g++ make

echo "
############################################

Installation de Terraform, Packer et ANSIBLE

############################################"

cat > ~/hosts <<EOL
127.0.0.1 localhost
192.168.199.5   bastion
192.168.199.10  webserver
192.168.199.20  node-0
192.168.199.21  node-1
192.168.199.22  node-2
EOL
sudo cp ~/hosts /etc/hosts

mkdir ~/scripts
cd ~/scripts
git clone https://github.com/redbeard28/install_terraform_packer.git
cd ~/scripts/install_terraform_packer
chmod 755 install_terraform_packer.sh
sudo ./install_terraform_packer.sh
mkdir ~/repo
git clone https://github.com/redbeard28/openstack-env-trainees.git ~/repo/ -b traineesv1
cd ~/repo/ansible
#ansible-playbook -i 'localhost,' -c local playbooks/install-openldap.yml
#ansible-playbook -i 'localhost,' -c local playbooks/install-gitlab.yml
#ansible-playbook -i 'localhost,' -c local playbooks/install-sensu.yml
#ansible-playbook -i 'localhost,' -c local playbooks/install-postfixV2.yml
ansible-playbook -i inventory/hosts playbooks/commons.yml
ansible-playbook -i 'localhost,' -c local playbooks/install-noip2.yml --tags trainees
ansible-playbook -i inventory/hosts playbooks/install-noip2.yml --tags mydashboard
ansible-playbook -i inventory/hosts playbooks/create-users.yml --tags users,users_files

