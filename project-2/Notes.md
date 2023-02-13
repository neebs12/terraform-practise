# Notes for this project

This project consists of:

- 1 vpc
- 4 subnets (2 public, 2 private)
- 1 nat gateway
- 1 internet gateway
- 2 routing tables (1 for the public subnets, 1 for the private subnets)
- 1 eip (I had to because you couldnt assign an automatic public ip address to the nat-gw)

## Description of project

- public routing table has the following routing rules
  - default local (I didnt have to specify),
    - I think the range here is CIDR of the VPC ??? (yes)
  - `0.0.0.0/0` targetting igw
- private routing table
  - default local
  - `0.0.0.0/0` targetting natgw
