# Notes for this project

This project consists of:

- 1 vpc
- 4 subnets (2 public, 2 private)
- 1 nat gateway
- 1 internet gateway
- 2 routing tables (1 for the public subnets, 1 for the private subnets)
- 1 eip (I had to because you couldnt assign an automatic public ip address to the nat-gw)
- 1 security group
  - no need to do one for public and private.
- 2 ec2 instances
  - 1 ec2 public (so assigned in a public subnet)
  - 1 ec2 private (so assigned in a private subnet)

## Description of project
