# create a vpc
# create ec2
# create a subnet
# create a route table
# create a igw
# create a sg

#  create vpc
resource "aws_vpc" "my_vpc" {
  cidr_block = "172.31.0.0/16"

  tags = {
    "Name" = var.vpc_name
  }
}

#  create ec2
resource "aws_instance" "my_ec2" {
  instance_type = var.ec2_instance_type
  ami = var.ec2_ami
  
  # subnet
  subnet_id = aws_subnet.my_sn.id
  # sg
  # security_groups only work with classic EC2 and default VPC only T_T
  # security_groups = [ aws_security_group.my_sg.id ]
  # you have to be fucking shitting me. this works but the other doesnt? WHY?
  vpc_security_group_ids = [ aws_security_group.my_sg.id ]

  # user_data
  user_data = <<-EOF
              #!/bin/bash
              echo "<h1>Hello, World<h1>" > index.html
              python3 -m http.server 80 &
              EOF

  tags = {
    "Name" = var.ec2_name
  }
}

# create subnet
resource "aws_subnet" "my_sn" {
  vpc_id = aws_vpc.my_vpc.id
  cidr_block = "172.31.1.0/24"

  # since is public, we wnat to set auto public ipv4 addresses instances within the subnet
  map_public_ip_on_launch = true

  tags = {
    "Name" = "sb_ext_trf_1"
  }
}

# create a route table
resource "aws_route_table" "my_rt" {
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    "Name" = "rt_ext_trf_1"
  }
}

# route table rules, local is defaulted to VPC CIDR, no need
# route table route rules, internet access only
resource "aws_route" "internet_access" {
  route_table_id = aws_route_table.my_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.my_igw.id
}

# subnet association - hangs the deployment :/
resource "aws_route_table_association" "route_subnet_assc" {
  # omg bro, this is supposed to be assc w the TABLE, not the fcking route rule
  route_table_id = aws_route_table.my_rt.id
  subnet_id = aws_subnet.my_sn.id

  depends_on = [
    aws_route_table.my_rt,
    aws_subnet.my_sn
  ]
}

# internet gateway
resource "aws_internet_gateway" "my_igw" {
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    "Name" = "igw_ext_trf_1"
  }
}

# sg
resource "aws_security_group" "my_sg" {
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    "Name" = "sg_ext_trf_1"
  }
}

# sg, assc. ingress rule, allow all
resource "aws_security_group_rule" "any_ingress" {
  type = "ingress"
  from_port = 0
  to_port = 0
  protocol = "-1"
  cidr_blocks = [ "0.0.0.0/0" ]
  security_group_id = aws_security_group.my_sg.id
}

# sg, assc. egress rule, allow all (as this is the "external")
resource "aws_security_group_rule" "any_egress" {
  type = "egress"
  from_port = 0
  to_port = 0
  protocol = "-1"
  cidr_blocks = [ "0.0.0.0/0" ]
  security_group_id = aws_security_group.my_sg.id
}

