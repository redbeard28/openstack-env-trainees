variable "image" {
#  default = "CentOS-7-x86_64-1702"
  default = "ubuntu-16.04-x64"
}

variable "flavor" {
  default = "Large"
}

variable "ssh_key_file" {
  default = "~/.ssh/id_rsa"
}

variable "ssh_user_name" {
#  default = "centos"
  default = "ubuntu"
}

variable "external_gateway" {
  default = "45306006-f2c9-48bc-a029-028cc3b0a86c"
}

variable "pool" {
  default = "internet_floating_net"
}

variable "elastic" {
  default ="3"
}

variable "os_name" {}