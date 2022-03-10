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
  region = "us-east-1"
}

resource "aws_instance" "my_server" {
  ami           = "ami-0c293f3f676ec4f90"
  instance_type = var.instance_type
  count         = 2

  tags = {
    # Name = "MyServer-(${var.test_dev[count.index]})"
    Name = "MyServer-${local.environments[count.index]}"
  }
}


resource "aws_s3_bucket" "bucket" {
  bucket = "7368368463dependson"
  depends_on = [aws_instance.my_server]
}

output "public_ip_0" {
  value = aws_instance.my_server[0].public_ip
}
output "public_ip_1" {
  value = aws_instance.my_server[1].public_ip
}
