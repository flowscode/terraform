variable "instance_type" {
  type = string
}

variable "web_servers" {
  type = list(string)
}

variable "region" {
  type = string
}

variable "ubuntu_ami" {
  type = string
}

variable "key_name" {
  type = string
}

variable "public_key" {
  type = string
}
