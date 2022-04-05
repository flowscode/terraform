variable "instance_type" {
  type = string
}

variable "web_servers" {
  type = list(string)
}

variable "region" {
  type = string
}

variable "ubunto_ami" {
  type = string
}
