terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  profile = "default"
  region = var.region
}

resource "aws_instance" "ansible-control-servers" {
  ami                    = var.ubuntu_ami
  instance_type          = var.instance_type
  tags = {
    Name = "ansible-control"
  }
}

resource "aws_instance" "ansible-web-servers" {
  count = length(var.web_servers)
  ami                    = var.ubuntu_ami
  instance_type          = var.instance_type
  tags = {
    Name = element(var.web_servers, count.index)
  }
}
