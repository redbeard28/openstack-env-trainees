#######################################################
#
#	Deploy configuration
#
#		by J.CUADRADO 15/02/2017
#
########################################################
# v1  - Création
# v2  - ...
# v3  - Association floating-IP à l'instances
########################################################


resource "openstack_compute_keypair_v2" "ca_jcukey_pub" {
  name = "ca_jcukey_pub"
  public_key = "${file("public_keys/jcu")}"
}

resource "openstack_compute_keypair_v2" "jfo_key_pub" {
  name = "jfo_key_pub"
  public_key = "${file("public_keys/jfo")}"
}

### Création de la ressource réseau ###
resource "openstack_networking_network_v2" "terraform" {
  name           = "terraform"
  admin_state_up = "true"
}

resource "openstack_networking_subnet_v2" "terraform" {
  name            = "terraform"
  network_id      = "${openstack_networking_network_v2.terraform.id}"
  cidr            = "192.168.199.0/24"
  ip_version      = 4
  dns_nameservers = ["8.8.8.8", "8.8.4.4"]
}

resource "openstack_networking_router_v2" "terraform" {
  name             = "terraform"
  admin_state_up   = "true"
  external_gateway = "${var.external_gateway}"
}

resource "openstack_networking_router_interface_v2" "terraform" {
  router_id = "${openstack_networking_router_v2.terraform.id}"
  subnet_id = "${openstack_networking_subnet_v2.terraform.id}"
}

resource "openstack_compute_floatingip_v2" "terraform" {
  pool       = "${var.pool}"
  depends_on = ["openstack_networking_router_interface_v2.terraform"]
}


resource "openstack_compute_secgroup_v2" "terraform" {
  name        = "terraform"
  description = "Security group for the Terraform example instances"

  rule {
    from_port   = 22
    to_port     = 22
    ip_protocol = "tcp"
    cidr        = "0.0.0.0/0"
  }

  rule {
    from_port   = 80
    to_port     = 80
    ip_protocol = "tcp"
    cidr        = "0.0.0.0/0"
  }

  rule {
    from_port   = -1
    to_port     = -1
    ip_protocol = "icmp"
    cidr        = "0.0.0.0/0"
  }
}

resource "openstack_compute_instance_v2" "REDBEARD28" {
  name = "REDBEARD28"
  image_id = "${var.openstack_centos7_image_id}"
  availability_zone = "nova"
  flavor_id = "1"
  key_pair = "${openstack_compute_keypair_v2.ca_jcukey_pub.name}"
  security_groups = ["Groupe_Securite"]
  network {
    uuid = "${openstack_networking_network_v2.terraform.id}"
  }
  floating_ip = "${openstack_compute_floatingip_v2.terraform.address}"
}

resource "openstack_compute_instance_v2" "webserver" {
  count = "${var.rp-node-count}"
  name = "webserver-${count.index}"
  image_id = "${var.openstack_centos7_image_id}"
  availability_zone = "nova"
  flavor_id = "1"
  key_pair = "${openstack_compute_keypair_v2.ca_jcukey_pub.name}"
  security_groups = ["Groupe_Securite"]
  network {
    uuid = "${openstack_networking_network_v2.terraform.id}"
  }
}