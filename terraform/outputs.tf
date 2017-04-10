output "address of Bastion" {
  value = "${openstack_compute_floatingip_v2.bastion_ip.address}"
}

output "address of Webserver" {
  value = "${openstack_compute_floatingip_v2.webserv_ip.address}"
}

output "address of nodes" {
  value = "${join(",", openstack_compute_instance_v2.*.ip)}"
}
