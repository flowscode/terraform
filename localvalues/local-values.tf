// SET THE VERSIONS OF THE PROVIDERS
terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

// ADD AUTH KEYS FOR PROVIDER
provider "aws" {
  region = "us-west-2"
  access_key = var.aws_ak
  secret_key = var.aws_sk
}

resource "aws_instance" "app-dev" {
  ami = "ami-0b9f27b05e1de14e9"
  instance_type = "t2.micro"
  tags = local.common_tags
}

resource "aws_instance" "db-dev" {
  ami = "ami-0b9f27b05e1de14e9"
  instance_type = "t2.small"
  tags = local.common_tags
}

resource "aws_ebs_volume" "db-ebs" {
  availability_zone = "us-west-2a"
  size              = 8
  tags = local.common_tags
}
