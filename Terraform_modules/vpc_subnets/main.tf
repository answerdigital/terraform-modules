terraform {
  required_version = "~> 1.3"
}

resource "aws_vpc" "vpc" {
  cidr_block            = var.vpc_cidr
  enable_dns_support    = var.enable_dns_support
  enable_dns_hostnames  = var.enable_dns_hostnames

  tags = {
    Name = "${var.project_name}-vpc"
  }
}

resource "aws_subnet" "public_subnets" {
  count = local.num_az_zones
  vpc_id = aws_vpc.vpc.id
  cidr_block = element(local.public_subnet_cidrs, count.index)
  availability_zone = element(local.az_zones, count.index)

  tags = {
    Name = "Public-subnet-${count.index +1}"
    Zone = "Public"
  }
}

resource "aws_subnet" "private_subnets" {
  count = local.num_az_zones
  vpc_id = aws_vpc.vpc.id
  cidr_block = element(local.private_subnet_cidrs, count.index)
  availability_zone = element(local.az_zones, count.index)

  tags = {
    Name = "Private-subnet-${count.index +1}"
    Zone = "Private"
  }
}

