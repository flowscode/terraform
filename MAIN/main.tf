terraform {
  required_providers{
    aws = {
      source = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = "us-west-1"
  access_key = "aws_ak"
  secret_key = "aws_sk"
}
