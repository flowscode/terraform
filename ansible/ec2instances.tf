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
  region  = var.region
}

resource "aws_key_pair" "key1" {
  key_name   = var.key_name
  public_key = var.public_key
}

resource "aws_instance" "ansible-control-servers" {
  ami           = var.ubuntu_ami
  instance_type = var.instance_type
  tags = {
    Name = "ansible-control"
  }
  key_name = var.key_name
}

resource "aws_instance" "ansible-web-servers" {
  count         = length(var.web_servers)
  ami           = var.ubuntu_ami
  instance_type = var.instance_type
  tags = {
    Name = element(var.web_servers, count.index)
  }
  key_name = var.key_name
}
