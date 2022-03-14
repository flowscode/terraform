resource "aws_db_subnet_group" "rds_subnet_group" {
  name       = "rds_subnet_group"
  subnet_ids = [aws_subnet.flow-sub-private[1].id]

  tags = {
    Name = "My DB subnet group"
  }
}


resource "aws_db_instance" "mysql_db" {
  allocated_storage      = 10
  engine                 = "mysql"
  engine_version         = "5.7"
  instance_class         = "db.t3.micro"
  db_name                   = "mydb"
  username               = "root"
  password               = "password"
  port                   = 3306
  skip_final_snapshot    = true
  db_subnet_group_name   = aws_db_subnet_group.rds_subnet_group.name
  vpc_security_group_ids = [aws_security_group.db_sg.id]
}
