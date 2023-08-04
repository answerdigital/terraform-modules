terraform {
  required_version = "~> 1.3"

  required_providers {
    random = {
      source  = "hashicorp/random"
      version = ">= 3.4.3"
    }
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0"
    }
  }
}

resource "aws_flow_log" "this" {
  iam_role_arn    = aws_iam_role.this[0].arn
  log_destination = aws_cloudwatch_log_group.this[0].arn
  traffic_type    = var.vpc_flow_logs_traffic_type
  vpc_id          = aws_vpc.this.id
  count           = var.enable_vpc_flow_logs ? 1 : 0
}

resource "random_uuid" "log_group_guid_identifier" {
}

resource "aws_cloudwatch_log_group" "this" {
  name  = "${var.project_name}-vpc-flow-logs-${random_uuid.log_group_guid_identifier.result}"
  count = var.enable_vpc_flow_logs ? 1 : 0
}

resource "aws_iam_role" "this" {
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

resource "aws_iam_role_policy" "this" {
  name   = "${var.project_name}-vpc-iam-logs-policy"
  role   = aws_iam_role.this[0].id
  count  = var.enable_vpc_flow_logs ? 1 : 0
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


resource "aws_vpc" "this" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = var.enable_dns_support
  enable_dns_hostnames = var.enable_dns_hostnames

  tags = {
    Name  = "${var.project_name}-vpc"
    Owner = var.owner
  }
}

resource "aws_subnet" "public" {
  count             = length(local.public_subnet_cidrs)
  vpc_id            = aws_vpc.this.id
  cidr_block        = element(local.public_subnet_cidrs, count.index)
  availability_zone = element(local.az_zones, count.index)

  tags = {
    Name  = "${var.project_name}-public-subnet-${count.index + 1}"
    Zone  = "Public"
    Owner = var.owner
  }
}

resource "aws_subnet" "private" {
  count             = length(local.private_subnet_cidrs)
  vpc_id            = aws_vpc.this.id
  cidr_block        = element(local.private_subnet_cidrs, count.index)
  availability_zone = element(local.az_zones, count.index)

  tags = {
    Name  = "${var.project_name}-private-subnet-${count.index + 1}"
    Zone  = "Private"
    Owner = var.owner
  }
}

resource "aws_internet_gateway" "this" {
  count  = length(local.public_subnet_cidrs) > 0 ? 1 : 0
  vpc_id = aws_vpc.this.id

  tags = {
    Name  = "${var.project_name}-vpc-ig"
    Owner = var.owner
  }
}

resource "aws_route_table" "this" {
  count  = length(local.public_subnet_cidrs) > 0 ? 1 : 0
  vpc_id = aws_vpc.this.id

  route {
    cidr_block = var.ig_cidr
    gateway_id = aws_internet_gateway.this[0].id
  }

  route {
    ipv6_cidr_block = var.ig_ipv6_cidr
    gateway_id      = aws_internet_gateway.this[0].id
  }

  tags = {
    Name  = "${var.project_name}-public-route-table"
    Owner = var.owner
  }
}

resource "aws_route_table_association" "public" {
  count          = length(local.public_subnet_cidrs)
  subnet_id      = element(aws_subnet.public[*].id, count.index)
  route_table_id = aws_route_table.this[0].id
}
