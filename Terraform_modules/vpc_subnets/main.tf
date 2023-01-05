terraform {
  required_version = "~> 1.3"
}

resource "aws_vpc" "vpc" {
  cidr_block            = var.vpc_cidr
  enable_dns_support    = true
  enable_dns_hostnames  = true

  tags = {
    Name = "${var.project_name}-vpc"
  }
}

resource "aws_subnet" "public_subnets" {
  count = length(var.public_subnet_cidrs)
  vpc_id = aws_vpc.vpc.id
  cidr_block = element(var.public_subnet_cidrs, count.index)
  availability_zone = element(var.azs, count.index)

  tags = {
    Name = "Public subnet ${count.index +1}"
    Zone = "Public"
  }
}

resource "aws_subnet" "private_subnets" {
  count = length(var.private_subnet_cidrs)
  vpc_id = aws_vpc.vpc.id
  cidr_block = element(var.private_subnet_cidrs, count.index)
  availability_zone = element(var.azs, count.index)

  tags = {
    Name = "Private subnet ${count.index +1}"
    Zone = "Private"
  }
}

