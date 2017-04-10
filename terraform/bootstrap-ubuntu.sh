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
#ansible-playbook -i 'localhost,' -c local playbooks/install-noip2.yml --tags trainees
#ansible-playbook -i 'localhost,' -c local playbooks/install-noip2.yml --tags mydashboard