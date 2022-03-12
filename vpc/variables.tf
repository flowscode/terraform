variable "AWS_REGION" {
  type = string
}

variable "public_cidr_1" {
  type = string
}
variable "public_cidr_2" {
  type = string
}

variable "private_cidr_1" {
  type = string
}
variable "private_cidr_2" {
  type = string
}

variable "ssh_key" {
  type      = string
  sensitive = true
}

variable "ssh_path" {
  type = string
}
