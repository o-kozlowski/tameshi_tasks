# Tasks

# Task 1 - Cloud Formation IaC
1. Create VPC.
2. Create 2 Public Subnets and an Internet Gateway that contains Public Subnets route 0.0.0.0/0 to Internet Gateway.
3. Create one NAT Gateway.
4. Create 2 Private Subnets that contains route from 0.0.0.0/0 to NAT Gateway.
5. Create 2 Database Subnets where database subnet contains NO route 0.0.0.0/0.
6. Create bastion host to which you will be able to connect using SSH, remember to deploy it in public subnet.

# Task 2 - Creating a wordpress site using Cloud Formation
1. Create a PHP web page using WordPress on Amazon Linux
2. The AWS stack will contain:
    - EC2 instances created by an ASG
    - RDS
    - EFS
    - ELB
    - Contain UserData that will install Wordpress and configure it with RDS & EFS

# Task 4 - Terraform (Unfinished)
1. Complete tasks 1 & 2 using terraform
