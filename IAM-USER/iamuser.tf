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

// CREATE USER Resource
resource "aws_iam_user" "user1" {
    name = var.usernumber
    path = "/system/"
}

//CREATE ELASTIC LOAD BALANCER
resource "aws_elb" "bar" {
  name               = var.elb1name
  availability_zones = var.azs

  listener {
    instance_port     = 8000
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }


  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:8000/"
    interval            = 30
  }

  cross_zone_load_balancing   = true
  idle_timeout                = var.timeout
  connection_draining         = true
  connection_draining_timeout = var.timeout

  tags = {
    Name = "foobar-terraform-elb"
  }
}
