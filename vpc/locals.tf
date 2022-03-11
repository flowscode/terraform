locals {
  public_cidrs = [var.public_cidr_1, var.public_cidr_2]
  private_cidrs = [var.private_cidr_1, var.private_cidr_2]
}
