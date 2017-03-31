#variable "image" {
#  default = "Ubuntu 14.04"
#}

variable "image" {
  default = "ubuntu-16.04-x64"
}

variable "flavor" {
  default = "Small"
}

variable "ssh_key_file" {
  default = "~/.ssh/id_rsa"
}

variable "ssh_user_name" {
  default = "ubuntu"
}

variable "external_gateway" {}

variable "pool" {
  default = "internet_floating_net"
}