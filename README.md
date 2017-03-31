# openstack-env-trainees

## Object
This repo is used by myself to deploy an integral env for my trainees.

## Servers
- 3 x servers Elastic + logstash

## Virtuals workstations
- 2 x centos 7 x86_64 for trainees

## Communication env
- 1 x bastion server (gitlab, OpenLDAP, SMTP Relay with GMAIL)

## The idea
The OpenStask server is maintained by a third party. So I don't have any admin priviledges.

We use terraform to deploy the trainees env and ansible to install elasticsearch and logstash.
