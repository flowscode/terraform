terraform {
  cloud {
    organization = "flowscode"

    workspaces {
      name = "vpc-test"
    }
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  # profile = "default"
  region = var.AWS_REGION
}
