

resource "aws_security_group" "bastion_sg" {
  name        = "bastion_sg"
  description = "Allow all TLS inbound HTTP/HTTPS"
  vpc_id      = data.aws_vpc.main.id

  dynamic "ingress" {
    for_each = local.ingress
    content {
      description = ingress.value.description
      from_port   = ingress.value.port
      to_port     = ingress.value.port
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
    }
  }

  # ingress {
  #   description      = "HTTP from anywhere"
  #   from_port        = 80
  #   to_port          = 80
  #   protocol         = "tcp"
  #   cidr_blocks      = ["0.0.0.0/0"]
  #   ipv6_cidr_blocks = []
  # }
  # ingress {
  #   description      = "HTTPS from anywhere"
  #   from_port        = 443
  #   to_port          = 443
  #   protocol         = "tcp"
  #   cidr_blocks      = ["0.0.0.0/0"]
  #   ipv6_cidr_blocks = []
  # }
  # ingress {
  #   description      = "icmp from anywhere"
  #   from_port        = -1
  #   to_port          = -1
  #   protocol         = "icmp"
  #   cidr_blocks      = ["0.0.0.0/0"]
  #   ipv6_cidr_blocks = []
  # }
  ingress {
    description      = "SSH from me only"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["************/32"]
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

  dynamic "ingress" {
    for_each = local.ingress
    content {
      description = ingress.value.description
      from_port   = ingress.value.port
      to_port     = ingress.value.port
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
    }
  }
  # ingress {
  #   description      = "HTTP from anywhere"
  #   from_port        = 80
  #   to_port          = 80
  #   protocol         = "tcp"
  #   cidr_blocks      = ["0.0.0.0/0"]
  #   ipv6_cidr_blocks = []
  # }
  # ingress {
  #   description      = "HTTPS from anywhere"
  #   from_port        = 443
  #   to_port          = 443
  #   protocol         = "tcp"
  #   cidr_blocks      = ["0.0.0.0/0"]
  #   ipv6_cidr_blocks = []
  # }
  # ingress {
  #   description      = "icmp from anywhere"
  #   from_port        = -1
  #   to_port          = -1
  #   protocol         = "icmp"
  #   cidr_blocks      = ["0.0.0.0/0"]
  #   ipv6_cidr_blocks = []
  # }

  ingress {
    description = "bastion access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [data.aws_vpc.main.cidr_block]
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
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
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

resource "aws_security_group" "db_sg" {
  name        = "db_sg"
  description = "db flow"
  vpc_id      = data.aws_vpc.main.id

  ingress {
    description = "bastion access mysql from bastion subnet"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = [data.aws_vpc.main.cidr_block]
  }

  ingress {
    description = "bastion access ssh from bastion subnet"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
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
