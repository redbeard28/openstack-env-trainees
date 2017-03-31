variable "image" {
  default = "centos-7-x86_64"
}

variable "flavor" {
  default = "Large"
}

variable "ssh_key_file" {
  default = "~/.ssh/id_rsa"
}

variable "ssh_user_name" {
  default = "centos"
}

variable "external_gateway" {
  default = "45306006-f2c9-48bc-a029-028cc3b0a86c"
}

variable "pool" {
  default = "internet_floating_net"
}