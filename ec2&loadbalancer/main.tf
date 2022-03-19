terraform {

  backend "local" {
    path = "./terraform.tfstate"

  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  access_key = var.access_key
  secret_key = var.secret_key
  region = var.region
}


############ Creating Security Group for EC2 & ELB ############
resource "aws_security_group" "web-server" {
  name        = "web-server"
  description = "Allow http inbound traffic"

  ingress {
    description      = "TLS from VPC"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

}

 ################## Creating 2 EC2 Instances ##################
resource "aws_instance" "web-server" {
  count = 2
  ami           = "ami-01cc34ab2709337aa"
  instance_type = "t2.micro"
  key_name        = "whizlabs-key"
  security_groups = [aws_security_group.web-server.name]

  user_data = <<-EOF
       #!/bin/bash
       sudo su
        yum update -y
        yum install httpd -y
        systemctl start httpd
        systemctl enable httpd
        echo "<html><h1> Welcome. greeting from $(hostname -f)...</p> </h1></html>" >> /var/www/html/index.html
        EOF
  tags = {
    Name = "web-server-${count.index}"
  }
}

###################### Default VPC ######################
data "aws_vpc" "default" {
    default = true
}

# data "aws_subnets" "subnet" {
#     vpc = data.aws_vpc.default.id
# }

data "aws_subnets" "subnet" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

#################### Creating Target Group ####################
resource "aws_lb_target_group" "target-group" {
    health_check {
        interval            = 10
        path                = "/"
        protocol            = "HTTP"
        timeout             = 5
        healthy_threshold   = 5
        unhealthy_threshold = 2
    }
    name          = "my-tg"
    port          = 80
    protocol      = "HTTP"
    target_type   = "instance"
    vpc_id = data.aws_vpc.default.id
}

############# Creating Application Load Balancer #############
resource "aws_lb" "application-lb" {
    name            = "josh-alb"
    internal        = false
    ip_address_type     = "ipv4"
    load_balancer_type = "application"
    security_groups = [aws_security_group.web-server.id]
    subnets = data.aws_subnets.subnet.ids
    tags = {
        Name = "whiz-alb"
    }
}
######################## Creating Listener ######################
resource "aws_lb_listener" "alb-listener" {
    load_balancer_arn          = aws_lb.application-lb.arn
    port                       = 80
    protocol                   = "HTTP"
    default_action {
        target_group_arn         = aws_lb_target_group.target-group.arn
        type                     = "forward"
    }
}

################ Attaching Target group to ALB ################
resource "aws_lb_target_group_attachment" "ec2_attach" {
    count = length(aws_instance.web-server)
    target_group_arn = aws_lb_target_group.target-group.arn
    target_id        = aws_instance.web-server[count.index].id
}
