# Notes for this project

This project consists of:

- 1 ec2 instance
- 1 vpc, with one subnet (taking up the whole CIDR)
- 1 security group associated with the vpc

At the end, the ec2 is then associated with the security group and subnet. The sg determines the rules of ingress and egress of traffic whereas the subnet assigns the private IP address of the ec2 instance within the vpc.

# For following project

- the current ec2 instance has code which returns a hello world .html file but at the moment, I cant access this file via the public address ip address of the ec2 instance even though the sg, vpc and subnet appears to be configured and accounted for properly 🤷‍♂️
