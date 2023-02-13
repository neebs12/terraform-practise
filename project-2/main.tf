terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

# create a VPC
resource "aws_vpc" "my_vpc" {
  # reserved IP addr range
  cidr_block = "10.0.0.0/16"

  tags = {
    "Name" = "vpc_trf"
  }
}

# create four SUBNETS, 2 private, 2 public
resource "aws_subnet" "subnet_pub_1" {
  vpc_id = aws_vpc.my_vpc.id
  cidr_block = "10.0.1.0/24"
  
  # set true for public
  map_public_ip_on_launch = true

  tags = {
    Name = "sb_public_trf_1"
  }
}

resource "aws_subnet" "subnet_pub_2" {
  vpc_id = aws_vpc.my_vpc.id
  cidr_block = "10.0.2.0/24"

  # set true for public
  map_public_ip_on_launch = true

  tags = {
    Name = "sb_public_trf_2"
  }
}

resource "aws_subnet" "subnet_prv_1" {
  vpc_id = aws_vpc.my_vpc.id
  cidr_block = "10.0.3.0/24"

  tags = {
    Name = "sb_private_trf_1"
  }
}

resource "aws_subnet" "subnet_prv_2" {
  vpc_id = aws_vpc.my_vpc.id
  cidr_block = "10.0.4.0/24"

  tags = {
    Name = "sb_private_trf_2"
  }
}

# create Internet Gateway
resource "aws_internet_gateway" "igw_1" {
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name = "igw_trf"
  }
}

# create a EIP (required for the NAT gateway)
resource "aws_eip" "eip_1" {
  vpc = true
  
}

# create a NAT gateway
resource "aws_nat_gateway" "nat_1" {
  # assign to a public subnet, (the first public one)
  subnet_id = aws_subnet.subnet_pub_1.id
  # eip required, otherwise will not work!!
  allocation_id = aws_eip.eip_1.id

  tags = {
    Name = "nat_trf"
  }

  # explicit dependency on the creation of the required eip
  depends_on = [
    aws_eip.eip_1
  ]
}

# create Route Table
resource "aws_route_table" "rt_1_public" {
  vpc_id = aws_vpc.my_vpc.id

  # local route is specified implicitly!
  # for specifying internet access
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw_1.id
  }
} 

resource "aws_route_table" "rt_2_private" {
  vpc_id = aws_vpc.my_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_1.id
  }
}

# associations, 2 public subnets <-> rt_1_public, 
resource "aws_route_table_association" "assc_pub_1" {
  subnet_id = aws_subnet.subnet_pub_1.id
  route_table_id = aws_route_table.rt_1_public.id
}

resource "aws_route_table_association" "assc_pub_2" {
  subnet_id = aws_subnet.subnet_pub_2.id
  route_table_id = aws_route_table.rt_1_public.id
}

# associations 2 private subnets <-> rt_2_private
resource "aws_route_table_association" "assc_prv_1" {
  subnet_id = aws_subnet.subnet_prv_1.id
  route_table_id = aws_route_table.rt_2_private.id
}

resource "aws_route_table_association" "assc_prv_2" {
  subnet_id = aws_subnet.subnet_prv_2.id
  route_table_id = aws_route_table.rt_2_private.id
}