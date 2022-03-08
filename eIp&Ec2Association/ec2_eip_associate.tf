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

// CREATE A RESOURCE {EC2 INSTANCE}
resource "aws_instance" "myfirstec2" {
    ami = "ami-0b9f27b05e1de14e9"
    instance_type = var.typeslist[count.index]
    count = 3

}

// CREATE A RESOURCE {ELASTIC IP}
resource "aws_eip" "lb" {
  vpc = true
  count = 3
}

// OUTPUT THE VALUE OF A SPECIFIC ATTRIBUTE FOR A RESOURCE {ELASTIC_IP ADDRESS}
output "eip_ip0" {
  value = aws_eip.lb[0].public_ip
}
output "eip_ip1" {
  value = aws_eip.lb[1].public_ip
}
output "eip_ip2" {
  value = aws_eip.lb[2].public_ip
}


// EIP ASSOCIATION RESOURCE, ATTACHING THE ELASTIC IP WITH THE SPECIFIED EC2 INSTANCE
resource "aws_eip_association" "eip_assoc0" {
  instance_id   = aws_instance.myfirstec2[0].id
  allocation_id = aws_eip.lb[0].id
}
resource "aws_eip_association" "eip_assoc1" {
  instance_id   = aws_instance.myfirstec2[1].id
  allocation_id = aws_eip.lb[1].id
}
resource "aws_eip_association" "eip_assoc2" {
  instance_id   = aws_instance.myfirstec2[2].id
  allocation_id = aws_eip.lb[2].id
}


// CREATE A SECURITY GROUP
resource "aws_security_group" "terra_sg" {
  name = "terra_sg"

  ingress {
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["${aws_instance.myfirstec2[0].public_ip}/32"]
  }
  ingress {
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["${aws_instance.myfirstec2[1].public_ip}/32"]
  }
  ingress {
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["${aws_instance.myfirstec2[2].public_ip}/32"]
  }

}

// OUTPUT THE DETAILS FOR THE INSTANCE
output "myec2_new_details" {
  value = aws_instance.myfirstec2
}
