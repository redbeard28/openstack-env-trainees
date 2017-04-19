[![English](http://upload.wikimedia.org/wikipedia/commons/e/e1/Union_Jack_22x16.png "English")](README.md)
<h1>
  <span>Création d'un environnement Openstack pour stagiaires</span>
  <a href='http://openstack-env-trainees.readthedocs.io/en/latest/?badge=latest'>
    <img src='https://readthedocs.org/projects/openstack-env-trainees/badge/?version=latest' alt='Documentation Status' />
  </a>
</h1>

## Object
J'utilise ce repo pour créer des environnements Openstack pour mes tests ou stagiaires.

## Serveurs
- 3 x servers Elastic + logstash

## Virtuals workstations
- 2 x centos 7 x86_64 for trainees

## Communication env
- 1 x bastion server (gitlab, OpenLDAP, SMTP Relay with GMAIL)

## The idea
The OpenStask server is maintained by a third party. So I don't have any admin priviledges.

We use terraform to deploy the trainees env and ansible to install elasticsearch and logstash.

## Url vers la documentation complète en anglais...
[Full documentation](http://openstack-env-trainees.readthedocs.io/en/latest/)