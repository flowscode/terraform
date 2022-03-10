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
  # instance_type = var.instance_type
  # count = 2
  for_each      = {
    nano = "t2.nano"
    micro = "t2.micro"
    small = "t2.small"
  }
  instance_type = each.value
  tags = {
    # Name = "MyServer-(${var.test_dev[count.index]})"
    # Name = "MyServer-${local.environments[count.index]}"
    Name = "MyServer-${each.key}"
  }
}

output "public_ips" {
  value = values(aws_instance.my_server)[*].public_ip
}
# output "public_ip_nano" {
#   value = aws_instance.my_server["nano"].public_ip
# }
# output "public_ip_micro" {
#   value = aws_instance.my_server["micro"].public_ip
# }
# output "public_ip_small" {
#   value = aws_instance.my_server["small"].public_ip
# }
