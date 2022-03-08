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
  # region = "us-east-1"
  # access_key = var.aws_ak
  # secret_key = var.aws_sk
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

output "instance_0_public_ip" {
  value = aws_instance.my_server[0].public_ip
}
output "instance_1_public_ip" {
  value = aws_instance.my_server[1].public_ip
}
