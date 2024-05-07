# vpc
resource "aws_vpc" "vpc1" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "PrimaryVPC"
  }
}

resource "aws_vpc" "vpc2" {
  cidr_block           = "10.1.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "SecondaryVPC"
  }
}

# subnet
resource "aws_subnet" "subnet1" {
  vpc_id     = aws_vpc.vpc1.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "Subnet1"
  }
}

resource "aws_subnet" "subnet2" {
  vpc_id     = aws_vpc.vpc2.id
  cidr_block = "10.1.1.0/24"

  tags = {
    Name = "Subnet2"
  }
}

# route table
resource "aws_route_table" "rtb1" {
  vpc_id = aws_vpc.vpc1.id
}

resource "aws_route_table" "rtb2" {
  vpc_id = aws_vpc.vpc2.id
}

# route
resource "aws_route" "route1" {
  route_table_id            = aws_route_table.rtb1.id
  destination_cidr_block    = aws_vpc.vpc2.cidr_block 
  vpc_peering_connection_id = "pcx-578451154151544"
}

resource "aws_route" "route2" {
  route_table_id            = aws_route_table.rtb2.id
  destination_cidr_block    = aws_vpc.vpc1.cidr_block
  vpc_peering_connection_id = "pcx-578451154151544"
}

# route table association
resource "aws_route_table_association" "a1" {
  subnet_id      = aws_subnet.subnet1.id
  route_table_id = aws_route_table.rtb1.id
}

resource "aws_route_table_association" "a2" {
  subnet_id      = aws_subnet.subnet2.id
  route_table_id = aws_route_table.rtb2.id
}