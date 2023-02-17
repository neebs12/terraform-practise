# from input variables
variable "vpc_name" {
  type = string
  description = "vpc name"
}

variable "ec2_name" {
  type = string
  description = "ec2 name"
}

# from .tfvars in env
variable "ec2_ami" {
  type = string
  description = "ec2 image"
}

variable "ec2_instance_type" {
  type = string
  description = "ec2 instance type (ie: specs)"
}