# Create 3 tier architecture

This creates a 3 tier architecture on AWS using Terraform.

![image](https://user-images.githubusercontent.com/35563797/201526460-ceaf1b55-63bc-4d57-b9b6-a19a774b39c5.png)

Features:

1)  Use of s3 remote backend to store state file.
2)  A VPC with 9 subnets (3 public and 6 private) all within 3 availability zones.
3)  Automatically assigns ipv4 and ipv6 (for public subnets) CIDR blocks to subnets from the specified VPC CIDR block.
3)  NAT gateways on each public subnet (in each avalilability zone used) for HA.
4)  Creates and attaches IAM roles to the EC2 instances to ensure the database can be accessed.
5)  Creation of autoscaling group for each tier to automatically scale when an instance (server) becomes unhealthy.
6)  Automatic setup of servers when provisioned with the use of user data shell scripts.
7)  Provisions an RDS database accross all used availability zones.
8)  Application load balancers in front of the 1st and 2nd tier of the infrastructure to evenly distribute traffic.
9)  Security groups to restrict traffic from each tier to only the resource ahead of it (ie app load balancer -> app servers -> middleware load balancer -> middleware servers -> database).
10) Generation of random password to be used by database instance.
11) Stores generated password in aws secret manager

Troubleshooting: The number of subnets in each tier should not be greater than the number of public subnets. 

Note: NAT gateways might be expensive to light users (billed per hour and by GB of data). An ec2 instance can be provisioned and configured as a NAT server (if you know how to).


