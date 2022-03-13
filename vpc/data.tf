data "aws_vpc" "main" {
  id = aws_vpc.flow_vpc.id
}

data "aws_security_group" "default" {
  name   = "default"
  vpc_id = data.aws_vpc.main.id
}

data "external" "myipaddr" {
  program = ["bash", "-c", "curl -s 'https://ipinfo.io/json'"]
}
