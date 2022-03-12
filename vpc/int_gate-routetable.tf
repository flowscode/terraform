resource "aws_internet_gateway" "gw" {
  vpc_id = data.aws_vpc.main.id

  tags = {
    Name = "main_ig"
  }
}

resource "aws_eip" "elastic_ip" {
  count = 2
  vpc   = true
}


resource "aws_nat_gateway" "ngw" {
  count             = length(aws_subnet.flow-sub-private)
  connectivity_type = "public"
  allocation_id     = aws_eip.elastic_ip[count.index].id
  subnet_id         = aws_subnet.flow-sub-private[count.index].id
}

resource "aws_route_table" "public_subnet_route" {
  vpc_id = data.aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
  route {
    cidr_block     = aws_subnet.flow-sub-private[0].cidr_block
    nat_gateway_id = aws_nat_gateway.ngw[0].id
  }
  route {
    cidr_block     = aws_subnet.flow-sub-private[1].cidr_block
    nat_gateway_id = aws_nat_gateway.ngw[1].id
  }
  tags = {
    Name = "public_route"
  }
}

# resource "aws_route_table" "private_route" {
#   vpc_id = data.aws_vpc.main.id
#   route {
#     cidr_block = aws_subnet.flow-sub-private.cidr_block
#   }
#   tags = {
#     Name = "public_route"
#   }
# }

resource "aws_route_table_association" "public-subnet-route-assc" {
  count          = length(aws_subnet.flow-sub-public)
  subnet_id      = aws_subnet.flow-sub-public[count.index].id
  route_table_id = aws_route_table.public_subnet_route.id
}
