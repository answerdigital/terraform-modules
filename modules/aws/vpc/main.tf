terraform {
  required_version = "~> 1.3"

  required_providers {
    random = {
      source  = "hashicorp/random"
      version = ">= 3.4.3"
    }
  }
}

resource "aws_flow_log" "flow_log" {
  iam_role_arn    = aws_iam_role.iam_role[0].arn
  log_destination = aws_cloudwatch_log_group.log_group[0].arn
  traffic_type    = var.vpc_flow_logs_traffic_type
  vpc_id          = aws_vpc.vpc.id
  count           = var.enable_vpc_flow_logs ? 1 : 0
}

resource "random_uuid" "log_group_guid_identifier" {
}

resource "aws_cloudwatch_log_group" "log_group" {
  name  = "${var.project_name}-vpc-flow-logs-${random_uuid.log_group_guid_identifier.result}"
  count = var.enable_vpc_flow_logs ? 1 : 0
}

resource "aws_iam_role" "iam_role" {
  name  = "${var.project_name}-vpc-logs-iam"
  count = var.enable_vpc_flow_logs ? 1 : 0

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "vpc-flow-logs.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "iam_role_policy" {
  name  = "${var.project_name}-vpc-iam-logs-policy"
  role  = aws_iam_role.iam_role[0].id
  count = var.enable_vpc_flow_logs ? 1 : 0

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:CreateLogStream",
        "logs:PutLogEvents",
        "logs:DescribeLogGroups",
        "logs:DescribeLogStreams"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}


resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = var.enable_dns_support
  enable_dns_hostnames = var.enable_dns_hostnames

  tags = {
    Name  = "${var.project_name}-vpc"
    Owner = var.owner
  }
}

resource "aws_subnet" "public_subnets" {
  count             = length(local.public_subnet_cidrs)
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = element(local.public_subnet_cidrs, count.index)
  availability_zone = element(local.az_zones, count.index)

  tags = {
    Name  = "${var.project_name}-public-subnet-${count.index + 1}"
    Zone  = "Public"
    Owner = var.owner
  }
}

resource "aws_subnet" "private_subnets" {
  count             = length(local.private_subnet_cidrs)
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = element(local.private_subnet_cidrs, count.index)
  availability_zone = element(local.az_zones, count.index)

  tags = {
    Name  = "${var.project_name}-private-subnet-${count.index + 1}"
    Zone  = "Private"
    Owner = var.owner
  }
}

resource "aws_internet_gateway" "ig" {
  count  = length(local.public_subnet_cidrs) > 0 ? 1 : 0
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name  = "${var.project_name}-vpc-ig"
    Owner = var.owner
  }
}

resource "aws_route_table" "route_table" {
  count  = length(local.public_subnet_cidrs) > 0 ? 1 : 0
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
    Name  = "${var.project_name}-public-route-table"
    Owner = var.owner
  }
}

resource "aws_route_table_association" "public_subnet_rt_asso" {
  count          = length(local.public_subnet_cidrs)
  subnet_id      = element(aws_subnet.public_subnets[*].id, count.index)
  route_table_id = aws_route_table.route_table[0].id
}