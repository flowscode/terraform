terraform {
  backend "local" {
    path = "./terraform.tfstate"
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  profile = "default"
  region = "us-east-2"
}

data "aws_ami" "packer_image"{
  most_recent = true
  name_regex = "httpd"
  owners = ["self"]
}

resource "aws_instance" "my_server" {
  ami           = data.aws_ami.packer_image.id
  instance_type = "t2.micro"
  tags = {
    # Name = "MyServer-(${var.test_dev[count.index]})"
    Name = "MyServer-Apache-Packer"
  }
}
