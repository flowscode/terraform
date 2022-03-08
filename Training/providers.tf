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
