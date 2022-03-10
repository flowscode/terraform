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

provider "aws" {
  profile = "default"
  region = "eu-west-2"
  alias = "london"
}

provider "aws" {
  profile = "default"
  region = "eu-west-1"
  alias = "ireland"
}

provider "aws" {
  profile = "default"
  region = "us-east-2"
  alias = "ohio"
}

data "aws_ami" "example-ohio" {
  most_recent      = true
  owners           = ["amazon"]
  provider = aws.ohio
  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }
}


resource "aws_instance" "my_server_ohio" {
  provider = aws.ohio
  ami           = data.aws_ami.example-ohio.id
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

data "aws_ami" "example-london" {
  most_recent      = true
  owners           = ["amazon"]
  provider = aws.london
  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }
}

resource "aws_instance" "my_server_london" {
  provider = aws.london
  ami           = data.aws_ami.example-london.id
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

output "public_ips_ohio" {
  value = values(aws_instance.my_server_ohio)[*].public_ip
}
output "public_ips_london" {
  value = values(aws_instance.my_server_london)[*].public_ip
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
