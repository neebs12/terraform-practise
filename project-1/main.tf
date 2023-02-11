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
  cidr_block = "10.0.0.0/16"

  tags = {
    "Name" = "vpc_trf"
  }
}

# create a subnet
resource "aws_subnet" "my_subnet" {
  # assign to vpc
  vpc_id = aws_vpc.my_vpc.id
  # make cidr of subnet same as vpc's available ips
  cidr_block = aws_vpc.my_vpc.cidr_block

  tags = {
    Name = "subnet_trf"
  }
}

# create a security group
resource "aws_security_group" "my_sg" {
  name = "sg_trf"
  description = "Allow incoming HTTP traffic, allow all outbound traffic"
  # assign sg to vpc
  vpc_id = aws_vpc.my_vpc.id

  # allow HTTP traffic
  ingress {
    from_port = 80
    to_port = 80
    description = "Allow incoming HTTP traffic"
    protocol = "tcp"
    cidr_blocks = [ "0.0.0.0/0" ]
  }

  # allow all traffic to egress
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = [ "0.0.0.0/0" ]
  }

  tags = {
    "Name" = "sg_trf"
  }
}

# create an EC2 instance
resource "aws_instance" "my_instance" {
  ami = "ami-0aa7d40eeae50c9a9"
  instance_type = "t2.micro"
  
  subnet_id = "${aws_subnet.my_subnet.id}"
  # vpc_security_groups works better when the security group is first being made!
  vpc_security_group_ids = [ "${aws_security_group.my_sg.id}" ]
  # makes ip address accessible?
  associate_public_ip_address = true

  user_data = <<-EOF
    #!bin/bash
    echo "Hello World!!" > index.html
    python3 -m http.server 80 &
    EOF

  tags = {
    Name = "foo_instance_trf"
  }
}

output "my_instance_public_ip" {
  value = aws_instance.my_instance.public_ip
}