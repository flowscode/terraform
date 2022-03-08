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
  region = "us-east-1"
  access_key = var.aws_ak
  secret_key = var.aws_sk
}


resource "aws_instance" "dev" {
  ami = "ami-0c293f3f676ec4f90"
  instance_type = "t2.micro"
  count = var.istest == true ? 1 : 0
}

resource "aws_instance" "prod" {
  ami = "ami-0c293f3f676ec4f90"
  instance_type = "t2.large"
  count = var.istest == false ? 1 : 0
}
