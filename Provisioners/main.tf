terraform {
  cloud {
    organization = "flowscode"

    workspaces {
      name = "provisioners"
    }
  }
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_key_pair" "deployer" {
  key_name   = "deployer-key"
  public_key = var.ssh_key
}

resource "aws_instance" "my_server" {
    ami = "ami-0e1d30f2c40c4c701"
    instance_type = "t2.micro"
    key_name = "${aws_key_pair.deployer.key_name}"
    tags = {
      Name = "MyServer"
    }
}

output "my_server-public_ip"{
  value = "aws_instance.my_server.public_ip"
}
