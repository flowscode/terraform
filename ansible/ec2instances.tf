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
  count = length(var.web_servers)
  ami                    = "ami-0e1d30f2c40c4c701"
  instance_type          = var.instance_type
  tags = {
    Name = element(var.web_servers, count.index)
  }
  }
