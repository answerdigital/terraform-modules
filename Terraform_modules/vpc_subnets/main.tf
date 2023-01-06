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
  count = var.public_subnets == true ? local.num_az_zones : 0
  vpc_id = aws_vpc.vpc.id
  cidr_block = element(local.public_subnet_cidrs, count.index)
  availability_zone = element(local.az_zones, count.index)

  tags = {
    Name = "${var.project_name}-public-subnet-${count.index +1}"
    Zone = "Public"
  }
}

resource "aws_subnet" "private_subnets" {
  count = var.private_subnets == true ? local.num_az_zones : 0
  vpc_id = aws_vpc.vpc.id
  cidr_block = element(local.private_subnet_cidrs, count.index)
  availability_zone = element(local.az_zones, count.index)

  tags = {
    Name = "${var.project_name}-private-subnet-${count.index +1}"
    Zone = "Private"
  }
}

resource "aws_internet_gateway" "ig" {
  count = var.public_subnets == true ? 1 : 0
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${var.project_name}-vpc-ig"
  }
}

resource "aws_route_table" "route_table" {
  count = var.public_subnets == true ? 1: 0
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = var.ig_cidr
    gateway_id = aws_internet_gateway.ig[0].id
  }

  tags = {
    Name = "${var.project_name}-public-route-table"
  }
}

resource "aws_route_table_association" "public_subnet_rt_asso" {
  count          = var.public_subnets == true ? local.num_az_zones : 0
  subnet_id      = element(aws_subnet.public_subnets[*].id, count.index)
  route_table_id = aws_route_table.route_table[0].id
}
