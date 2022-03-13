locals {
  public_cidrs  = [var.public_cidr_1, var.public_cidr_2]
  private_cidrs = [var.private_cidr_1, var.private_cidr_2]
  azs           = ["us-east-2a", "us-east-2b", "us-east-2c"]
  ingress = [{
    port        = 80
    description = "port 80"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    },
    {
      port        = 443
      description = "port 443"
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      port        = -1
      description = "port -1"
      protocol    = "icmp"
      cidr_blocks = ["0.0.0.0/0"]
  }]
}
