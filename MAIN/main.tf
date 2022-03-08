terraform {
  required_providers{
    aws = {
      source = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  profile = "default"
  # region = "us-east-1"
  # access_key = "aws_ak"
  # secret_key = "aws_sk"
}

resource "aws_instance" "my_server" {
    ami = "ami-0c293f3f676ec4f90"
    instance_type = "t2.micro"
    count = 3

    tags = {
      Name = "MyServer"
    }
}
