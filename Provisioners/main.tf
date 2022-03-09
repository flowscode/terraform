terraform {
  # cloud {
  #   organization = "flowscode"
  #
  #   workspaces {
  #     name = "provisioners"
  #   }
  # }
  backend "local" {
    path = "./terraform.tfstate.d/provisioners/terraform.tfstate"
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
  region = "us-east-1"
}

data "aws_vpc" "main" {
  id = "vpc-e2fb4598"
}

resource "aws_security_group" "sg_my_server" {
  name        = "sg_my_server"
  description = "MyServer Security Group"
  vpc_id      = data.aws_vpc.main.id

  ingress {
    description      = "HTTP from VPC"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = []
  }

  ingress {
    description      = "SSH from VPC"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["149.22.65.211/32"]
    ipv6_cidr_blocks = []
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_tls"
  }
}

resource "aws_key_pair" "deployer" {
  key_name   = "deployer-key"
  public_key = var.ssh_key
}

# data "template_file" "user_data" {
#   template = file("./userdata.yaml")
# }


resource "aws_instance" "my_server" {
  count                  = 3
  ami                    = "ami-0e1d30f2c40c4c701"
  instance_type          = "t2.micro"
  key_name               = aws_key_pair.deployer.key_name
  vpc_security_group_ids = [aws_security_group.sg_my_server.id]
  user_data              = templatefile("./userdata.yaml", {})

  provisioner "remote-exec" {
    inline = ["echo ${self.private_ip} >> /home/ec2-user/private_ips.txt"]

    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = templatefile(var.ssh_path, {})
      host        = self.public_ip
    }

  }

  tags = {
    Name = "MyServer_${count.index}"
  }

}

output "my_server-public_ip_0" {
  value = aws_instance.my_server[0].public_ip
}
output "my_server-public_ip_1" {
  value = aws_instance.my_server[1].public_ip
}
output "my_server-public_ip_2" {
  value = aws_instance.my_server[2].public_ip
}
