resource "aws_key_pair" "deployer" {
  key_name   = "deployer-key"
  public_key = var.ssh_key
}

resource "aws_instance" "bastion_host" {
  depends_on                  = [aws_subnet.flow-sub-public]
  key_name                    = aws_key_pair.deployer.key_name
  ami                         = "ami-008e1e7f1fcbe9b80"
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.flow-sub-public[0].id
  vpc_security_group_ids      = [aws_security_group.bastion_sg.id]
  associate_public_ip_address = true
  tags = {
    Name = "bastion_host"
  }
}

resource "aws_instance" "public_server" {
  depends_on                  = [aws_subnet.flow-sub-public]
  key_name                    = aws_key_pair.deployer.key_name
  ami                         = "ami-008e1e7f1fcbe9b80"
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.flow-sub-public[1].id
  vpc_security_group_ids      = [aws_security_group.public_sg.id]
  user_data                   = templatefile("./userdata.yaml", {})
  associate_public_ip_address = true
  tags = {
    Name = "public_server"
  }
}

resource "aws_instance" "private_server" {
  depends_on    = [aws_subnet.flow-sub-private]
  key_name      = aws_key_pair.deployer.key_name
  ami           = "ami-008e1e7f1fcbe9b80"
  instance_type = "t2.micro"
  # vpc_security_group_ids = [module.vpc.default_security_group_id]
  subnet_id              = aws_subnet.flow-sub-private[0].id
  vpc_security_group_ids = [aws_security_group.private_sg.id]
  user_data              = templatefile("./userdata.yaml", {})
  tags = {
    Name = "private_server"
  }
}
