resource "aws_security_group" "bastion_sg" {
  name        = "bastion_sg"
  description = "Allow all TLS inbound HTTP/HTTPS"
  vpc_id      = data.aws_vpc.main.id


  ingress {
    description      = "HTTP from anywhere"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = []
  }
  ingress {
    description      = "HTTPS from anywhere"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = []
  }
  ingress {
    description      = "icmp from anywhere"
    from_port        = -1
    to_port          = -1
    protocol         = "icmp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = []
  }
  ingress {
    description      = "SSH from me only"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["149.22.65.211/32"]
    ipv6_cidr_blocks = []
  }
  egress {
    description      = "outgoing for everyone"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = []
  }
}

resource "aws_security_group" "public_sg" {
  name        = "allow_tls"
  description = "Allow all TLS inbound HTTP/HTTPS"
  vpc_id      = data.aws_vpc.main.id


  ingress {
    description      = "HTTP from anywhere"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = []
  }
  ingress {
    description      = "HTTPS from anywhere"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = []
  }
  ingress {
    description      = "icmp from anywhere"
    from_port        = -1
    to_port          = -1
    protocol         = "icmp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = []
  }
  ingress {
    description      = "SSH from me only"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["149.22.65.211/32"]
    ipv6_cidr_blocks = []
  }
  egress {
    description      = "outgoing for everyone"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = []
  }
}

resource "aws_security_group" "private_sg" {
  name        = "private_sg"
  description = "internal traffic"
  vpc_id      = data.aws_vpc.main.id

  ingress {
    description = "bastion access"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks = [data.aws_vpc.main.cidr_block]
  }

  ingress {
    description      = "icmp from inside vpc"
    from_port        = -1
    to_port          = -1
    protocol         = "icmp"
    cidr_blocks      = [data.aws_vpc.main.cidr_block]
    ipv6_cidr_blocks = []
  }

  egress {
    description      = "outgoing for everyone"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = []
  }
}