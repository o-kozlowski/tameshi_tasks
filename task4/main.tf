terraform {
  backend "s3" {
    bucket = "cf-templates-tybz6uevylk9-eu-west-1"
    key    = "task4/.terraform/terraform.tfstate"
    region = "eu-west-1"
  }
}
module "aws_vpc" {
  source = "terraform-aws-modules/vpc/aws"
  name   = "vpc"
  cidr   = "10.0.0.0/16"
  azs    = ["eu-west-1a", "eu-west-1b"]
  database_subnets = ["10.0.20.0/24", "10.0.21.0/24"]
  private_subnets  = ["10.0.10.0/24", "10.0.11.0/24"]
  public_subnets   = ["10.0.1.0/24", "10.0.2.0/24"]

  enable_nat_gateway  = true
  single_nat_gateway  = true

  enable_dns_hostnames = true
  enable_dns_support   = true

}

module "aws_ec2_instance" {
    source = "terraform-aws-modules/ec2-instance/aws"

    name = "bastion-instance"

    ami = var.BASTION_HOST_AMI
    instance_type = var.BASTION_HOST_INSTANCE_TYPE
    subnet_id = "${element(module.aws_vpc.public_subnets, 0)}"
    vpc_security_group_ids = [module.aws_sg.security_group_id]
    iam_instance_profile = aws_iam_instance_profile.ssm_instance_profile.id
}

module "aws_sg" {
    source = "terraform-aws-modules/security-group/aws"
    description = "SSH & SSM access from the internet"
    name = "bastion-sg"
    vpc_id = module.aws_vpc.vpc_id

    ingress_with_cidr_blocks = [
        {
            protocol = "tcp"
            from_port = 22
            to_port = 22
            cidr_blocks = "${var.BASTION_HOST_CIDR}"
        },
        {
            protocol = "tcp"
            from_port = 80
            to_port = 80
            cidr_blocks = "0.0.0.0/0"
        },
    ]
}

resource "aws_iam_role" "ssm_role" {
    name = "ssm_role"
    path = "/"

    assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
    managed_policy_arns = ["arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforSSM"]
}


resource "aws_iam_instance_profile" "ssm_instance_profile" {
    name = "ssm_instance_profile"
    role = aws_iam_role.ssm_role.name
}

