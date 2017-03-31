#######################################################
#
#	Main configuration
#
#		by J.CUADRADO 31/03/2017
#
########################################################
# v1  - Création

resource "openstack_compute_keypair_v2" "terraform" {
  name       = "terraform"
  public_key = "${file("${var.ssh_key_file}.pub")}"
}

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

resource "openstack_compute_floatingip_v2" "terraform" {
  pool       = "${var.pool}"
  depends_on = ["openstack_networking_router_interface_v2.terraform"]
}

resource "openstack_compute_instance_v2" "terraform" {
  name            = "terraform"
  image_name      = "${var.image}"
  flavor_name     = "${var.flavor}"
  key_pair        = "${openstack_compute_keypair_v2.terraform.name}"
  security_groups = ["${openstack_compute_secgroup_v2.terraform.name}"]
  floating_ip     = "${openstack_compute_floatingip_v2.terraform.address}"

  network {
    uuid = "${openstack_networking_network_v2.terraform.id}"
  }

  provisioner "remote-exec" {
    connection {
      user     = "${var.ssh_user_name}"
      private_key = "${file(var.ssh_key_file)}"
    }

    inline = [
      "sudo setenforce permissive",
      "sudo sed -i 's/enforcing/permissive/g' /etc/sysconfig/selinux",
      "sudo yum -y update",
      "sudo yum install -y epel-release",
      "sudo yum install -y ansible",
      "sudo yum install -y git",
<<<<<<< HEAD
      " mkdir ~/repo",
      "git clone https://github.com/redbeard28/openstack-env-trainees.git ~/repo/ -b traineesv1",
      "cd ~/repo/openstack-env-trainees",
      "ansible-playbook -i 'localhost,' -c local install.yml"
=======

>>>>>>> b283473fcd25460d7812b76db8485f30f7a208c5
    ]
  }
}