#!/bin/bash
#######################
#
# Bootstrap script for CentOS
#
#######################

sudo setenforce permissive
sudo sed -i 's/enforcing/permissive/g' /etc/sysconfig/selinux
sudo yum install -y epel-release
sudo yum -y update
sudo yum install -y ansible
sudo yum install -y git
mkdir ~/repo
git clone https://github.com/redbeard28/openstack-env-trainees.git ~/repo/ -b traineesv1
cd ~/repo/ansible
#ansible-playbook -i 'localhost,' -c local playbooks/install-openldap.yml
#ansible-playbook -i 'localhost,' -c local playbooks/install-gitlab.yml
ansible-playbook -i 'localhost,' -c local playbooks/install-postfixV2.yml
ansible-playbook -i 'localhost,' -c local playbooks/install-postfixV2.yml
