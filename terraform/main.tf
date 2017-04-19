#######################################################
#
#	Main configuration
#
#		by J.CUADRADO 31/03/2017
#
########################################################
# v1  - Création

resource "openstack_compute_keypair_v2" "terraform" {
  name       = "terraform_jcu"
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
    from_port   = 873
    to_port     = 873
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
    from_port   = 443
    to_port     = 443
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

resource "openstack_compute_floatingip_v2" "bastion_ip" {
  pool       = "${var.pool}"
  depends_on = ["openstack_networking_router_interface_v2.terraform"]
}

resource "openstack_compute_floatingip_v2" "webserv_ip" {
  pool       = "${var.pool}"
  depends_on = ["openstack_networking_router_interface_v2.terraform"]
}

resource "openstack_compute_instance_v2" "terraform" {
  name            = "bastion"
  image_name      = "${var.image}"
  flavor_name     = "${var.flavor}"
  key_pair        = "${openstack_compute_keypair_v2.terraform.name}"
  security_groups = ["${openstack_compute_secgroup_v2.terraform.name}"]
  floating_ip     = "${openstack_compute_floatingip_v2.bastion_ip.address}"
  network {
    uuid = "${openstack_networking_network_v2.terraform.id}"
    fixed_ip_v4 = "192.168.199.5"
  }
  user_data     = "user_data.sh"

  provisioner "file" {
    connection {
      user     = "${var.ssh_user_name}"
      private_key = "${file(var.ssh_key_file)}"
    }
    source      = "bootstrapbastion-${var.os_name}.sh"
    destination = "~/bootstrapbastion.sh"
  }
    
  provisioner "file" {
    connection {
      user     = "${var.ssh_user_name}"
      private_key = "${file(var.ssh_key_file)}"
    }
    source      = "~/.ssh/id_rsa"
    destination = "~/.ssh/id_rsa"
  }
  
  provisioner "remote-exec" {
    connection {
      user     = "${var.ssh_user_name}"
      private_key = "${file(var.ssh_key_file)}"
    }
    inline = [
      "sudo echo 'Port 873' >> /etc/ssh/sshd_config",
      "chmod 755 ~/bootstrapbastion.sh",
      "~/bootstrapbastion.sh",
    ]
  }
  
   provisioner "file" {
    connection {
      user     = "${var.ssh_user_name}"
      private_key = "${file(var.ssh_key_file)}"
    }
    source      = "trainees/no-ip2.conf"
    destination = "/tmp/no-ip2.conf"
  }  
  
  provisioner "file" {
    connection {
      user     = "${var.ssh_user_name}"
      private_key = "${file(var.ssh_key_file)}"
    }
    source      = "trainees/noip2"
    destination = "/tmp/noip2"
  }

  provisioner "remote-exec" {
    connection {
      user     = "${var.ssh_user_name}"
      private_key = "${file(var.ssh_key_file)}"
    }
    inline = [
      "sudo echo 'Port 873' >> /etc/ssh/sshd_config",
      "sudo cp /tmp/noip2 /usr/local/bin/noip2",
      "sudo cp /tmp/no-ip2.conf /usr/local/etc/no-ip2.conf",
      "sudo chmod 755 /usr/local/bin/noip2",
      "sudo /usr/local/bin/noip2",
      "for i in $(echo 'bastion webserver node-0 node-1 node-2');do ssh-keyscan $i;done",
    ]
  }
}

######## WebServer  ########
resource "openstack_compute_instance_v2" "webserver" {
  name            = "webserver"
  image_name      = "${var.image}"
  flavor_name     = "${var.flavor}"
  key_pair        = "${openstack_compute_keypair_v2.terraform.name}"
  security_groups = ["${openstack_compute_secgroup_v2.terraform.name}"]
  floating_ip     = "${openstack_compute_floatingip_v2.webserv_ip.address}"
  network {
    uuid = "${openstack_networking_network_v2.terraform.id}"
    fixed_ip_v4 = "192.168.199.10"
  }
  user_data     = "user_data.sh"
  
  provisioner "file" {
    connection {
      user     = "${var.ssh_user_name}"
      private_key = "${file(var.ssh_key_file)}"
    }
    source      = "~/.ssh/id_rsa"
    destination = "~/.ssh/id_rsa"
  }
  
   provisioner "file" {
    connection {
      user     = "${var.ssh_user_name}"
      private_key = "${file(var.ssh_key_file)}"
    }
    source      = "mydashboard/no-ip2.conf"
    destination = "/tmp/no-ip2.conf"
  }  
  
  provisioner "file" {
    connection {
      user     = "${var.ssh_user_name}"
      private_key = "${file(var.ssh_key_file)}"
    }
    source      = "mydashboard/noip2"
    destination = "/tmp/noip2"
  }

  provisioner "remote-exec" {
    connection {
      user     = "${var.ssh_user_name}"
      private_key = "${file(var.ssh_key_file)}"
    }
    inline = [
      "sudo cp /tmp/noip2 /usr/local/bin/noip2",
      "sudo cp /tmp/no-ip2.conf /usr/local/etc/no-ip2.conf",
      "sudo chmod 755 /usr/local/bin/noip2",
      "sudo /usr/local/bin/noip2",
      "for i in $(echo 'bastion webserver node-0 node-1 node-2');do ssh-keyscan $i;done",
    ]
  }
    
}

######## ELASTIC SERVERS ########
resource "openstack_compute_instance_v2" "node" {
  count = "${var.elastic}"
  name            = "node-${count.index}"
  image_name      = "${var.image}"
  flavor_name     = "${var.flavor}"
  key_pair        = "${openstack_compute_keypair_v2.terraform.name}"
  security_groups = ["${openstack_compute_secgroup_v2.terraform.name}"]
  network {
    uuid = "${openstack_networking_network_v2.terraform.id}"
    fixed_ip_v4 = "192.168.199.2${count.index}"
  }
}