resource "aws_vpc" "flow_vpc" {        // create's VPC resource
  cidr_block           = "10.0.0.0/16" // sets the CIDR block
  enable_dns_support   = true          //give me internal domain name
  enable_dns_hostnames = true          // internal host name
  enable_classiclink   = false         // this would allow me to connect classic EC2 to vpc (not needed right now)
  instance_tenancy     = "default"     // this would be able to make sure only instance in an AWS physical hardware (expensive so no thanks lol)
  tags = {
    Name = "flow_vpc" //  Name tag
  }
}

resource "aws_subnet" "flow-sub-public" { // creates subnet resource
  # for_each = {
  #   public_cidr_1 = var.public_cidr_1, // this should create however many cidr ranges i have put in the list based on the length of the list
  #   public_cidr_2 = var.public_cidr_2
  # }
  count                   = length(local.public_cidrs)
  cidr_block              = local.public_cidrs[count.index] // will set each created subnet's CIDR based on what is in the list using the count to iterate throught the list
  vpc_id                  = aws_vpc.flow_vpc.id             // attaches the subnet to the specified VPC
  map_public_ip_on_launch = true                            // it makes this a public subnet
  availability_zone       = local.azs[count.index]          // sets the az
  tags = {
    Name = "flow-sub-public-${count.index}" //Subnet name tag  -- count specific, + 1 just  to be cheeky ;)
  }
  depends_on = [aws_vpc.flow_vpc] // will not be created unless the vpc is created
}

resource "aws_subnet" "flow-sub-private" {                   // creates subnet resource
  count                   = length(local.private_cidrs)      // this should create however many cidr ranges i have put in the list based on the length of the list
  vpc_id                  = aws_vpc.flow_vpc.id              // attaches the subnet to the specified VPC
  cidr_block              = local.private_cidrs[count.index] // will set each created subnet's CIDR based on what is in the list using the count to iterate throught the list
  map_public_ip_on_launch = false                            //it makes this a public subnet
  availability_zone       = local.azs[count.index]           // sets the az
  tags = {
    Name = "flow-sub-private-${count.index + 1}" //Subnet name tag  -- count specific, + 1 just  to be cheeky ;)
  }
  depends_on = [aws_vpc.flow_vpc] // will not be created unless the vpc is created
}
