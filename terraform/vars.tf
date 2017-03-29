#######################################################
#
#	Vars configuration
#
#		by J.CUADRADO 15/02/2017
#
#######################################################
# v1    - Création
# v1.1  - Ajout key_pairs
# v2    - Modifications majeurs - trie des variables et amélioration commentaires
#######################################################


#######################################################
#### OS - key_pairs ####
variable "openstack_centos7_image_id" {
    description = "CentOS 7 x86_64"
    default = "92e32e14-5cd6-4b49-80d2-a74825bf7164"
}

variable "image-flavor" {
  default = "m1.small"
}

variable "openstack_keypair" {
    description = "The keypair to be used."
    default  = "demo_key"
}

#######################################################
#### Reverse ELK nodes ####
variable "rp-node-count" {
  default ="3"
}


#######################################################
#### Networking stuff ####
variable "openstack_tenant_network" {
    description = "The network to be used."
    default  = "b8a28df2-7f9d-4b2a-8f34-0e1d63c8a78b"
}

#### ID of Floating-IPs declaration ####
variable "external_gateway" {
    default = "45306006-f2c9-48bc-a029-028cc3b0a86c"
}

#### Pool of floating IPs ####
variable "pool" {
  default = "internet_floating_net"
}




