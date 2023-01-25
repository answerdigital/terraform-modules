terraform {
  required_version = "~> 1.3"
}

resource "aws_vpc" "vpc" {
  cidr_block            = var.vpc_cidr
  enable_dns_support    = var.enable_dns_support
  enable_dns_hostnames  = var.enable_dns_hostnames

  tags = {
    Name = "${var.project_name}-vpc"
    Owner = var.owner
  }
}

resource "aws_subnet" "public_subnets" {
  count = length(local.public_subnet_cidrs)
  vpc_id = aws_vpc.vpc.id
  cidr_block = element(local.public_subnet_cidrs, count.index)
  availability_zone = element(local.az_zones, count.index)

  tags = {
    Name = "${var.project_name}-public-subnet-${count.index +1}"
    Zone = "Public"
    Owner = var.owner
  }
}

resource "aws_subnet" "private_subnets" {
  count = length(local.private_subnet_cidrs)
  vpc_id = aws_vpc.vpc.id
  cidr_block = element(local.private_subnet_cidrs, count.index)
  availability_zone = element(local.az_zones, count.index)

  tags = {
    Name = "${var.project_name}-private-subnet-${count.index +1}"
    Zone = "Private"
    Owner = var.owner
  }
}

resource "aws_internet_gateway" "ig" {
  count = length(local.public_subnet_cidrs) > 0 ? 1 : 0
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${var.project_name}-vpc-ig"
    Owner = var.owner
  }
}

resource "aws_route_table" "route_table" {
  count = length(local.public_subnet_cidrs) > 0 ? 1 : 0
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = var.ig_cidr
    gateway_id = aws_internet_gateway.ig[0].id
  }

  route {
    ipv6_cidr_block = var.ig_ipv6_cidr
    gateway_id      = aws_internet_gateway.ig[0].id
  }

  tags = {
    Name = "${var.project_name}-public-route-table"
    Owner = var.owner
  }
}

resource "aws_route_table_association" "public_subnet_rt_asso" {
  count          = length(local.public_subnet_cidrs)
  subnet_id      = element(aws_subnet.public_subnets[*].id, count.index)
  route_table_id = aws_route_table.route_table[0].id
}
