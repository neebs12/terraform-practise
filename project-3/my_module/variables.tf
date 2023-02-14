#   - subnet
#   - sg
#   - port

variable "port_num" {
  type = number
  description = "port number for compute application"
}

variable "sg_id" {
  type = string
  description = "security group id for compute"
}

variable "subnet_id" {
  type = string
  description = "subnet id for compute"
}
