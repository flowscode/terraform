resource "aws_vpc" "flow_vpc" { // create's VPC resource
    cidr_block = "10.0.0.0/16" // sets the CIDR block
    enable_dns_support = true //give me internal domain name
    enable_dns_hostnames = true // internal host name
    enable_classiclink = false // this would allow me to connect classic EC2 to vpc (not needed right now)
    instance_tenancy = "default" // this would be able to make sure only instance in an AWS physical hardware (expensive so no thanks lol)
    tags = {
        Name = "flow_vpc"  //  Name tag
    }
}

resource "aws_subnet" "flow-vpc-public" { // creates subnet resource
  count = length(local.public_cidrs) // this should create however many cidr ranges i have put in the list based on the length of the list
  vpc_id = "${aws_vpc.flow_vpc.id}" // attaches the subnet to the specified VPC
  cidr_block = local.public_cidrs[count.index] // will set each created subnet's CIDR based on what is in the list using the count to iterate throught the list
  map_public_ip_on_launch = true //it makes this a public subnet
  availability_zone = "eu-west-2a" // sets the az
  tags = {
      Name = "flow-vpc-public-${count.index + 1}" //Subnet name tag  -- count specific, + 1 just  to be cheeky ;)
  }
}

resource "aws_subnet" "flow-vpc-private" { // creates subnet resource
  count = length(local.private_cidrs) // this should create however many cidr ranges i have put in the list based on the length of the list
  vpc_id = "${aws_vpc.flow_vpc.id}" // attaches the subnet to the specified VPC
  cidr_block = local.private_cidrs[count.index] // will set each created subnet's CIDR based on what is in the list using the count to iterate throught the list
  map_public_ip_on_launch = false //it makes this a public subnet
  availability_zone = "eu-west-2a" // sets the az
  tags = {
      Name = "flow-vpc-public-${count.index + 1}" //Subnet name tag  -- count specific, + 1 just  to be cheeky ;)
  }
}

resource "aws_instance" "public_server" {
    depends_on = [aws_subnet.flow-vpc-public]
    count = 2
    ami = "ami-0e1d30f2c40c4c701"
    instance_type = "t2.micro"
    # vpc_security_group_ids = [module.vpc.default_security_group_id]
    # subnet_id = module.vpc.public_subnets[count.index]
    tags = {
      Name = "public_server_${count.index + 1}"
    }
}

resource "aws_instance" "private_server" {
    depends_on = [aws_subnet.flow-vpc-private]
    count = 2
    ami = "ami-0e1d30f2c40c4c701"
    instance_type = "t2.micro"
    # vpc_security_group_ids = [module.vpc.default_security_group_id]
    # subnet_id = module.vpc.private_subnets[count.index]
    tags = {
      Name = "private_server_${count.index + 1}"
    }
}

output "public_ips"{
  value = [
    "${aws_instance.public_server[*].tags["Name"]}","${aws_instance.public_server[*].public_ip}",
    "${aws_instance.private_server[*].tags["Name"]}","${aws_instance.private_server[*].public_ip}"]
}
