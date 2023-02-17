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

# set variables here!
variable "ec2_ami" {
  type = string
  description = "ec2 machine image"
}

variable "ec2_instance_type" {
  type = string
  description = "ec2 instance type"
}

# 
module "my_ext_mod" {
  source = "./external_module"

  vpc_name = "vpc_ext_trf_1"
  ec2_name = "ec2_ext_trf_1"
  ec2_ami = var.ec2_ami
  ec2_instance_type = var.ec2_instance_type
}

output "ec2_ext_public_ip" {
  value = module.my_ext_mod.ec2_ext_public_ip
} 