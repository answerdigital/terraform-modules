terraform {
  required_version = "~> 1.3"

  required_providers {
    tls = {
      source  = "hashicorp/tls"
      version = ">= 4.0.4"
    }
  }
}

resource "aws_iam_instance_profile" "instance_profile" {
  name = "${var.project_name}-ec2-monitoring-and-setup"
  role = aws_iam_role.instance_role.name
}

resource "aws_iam_role" "instance_role" {
  name               = "${var.project_name}-ec2-monitoring-and-setup"
  assume_role_policy = <<-EOF
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Action": ["sts:AssumeRole"],
        "Effect": "Allow",
        "Principal": {
          "Service": ["ec2.amazonaws.com"]
        }
      }
    ]
  }
  EOF
}

resource "aws_iam_role_policy_attachment" "instance_role" {
  for_each = toset([
    "arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforSSM",
    "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
  ])
  role = aws_iam_role.instance_role.name
  policy_arn = each.value
}

resource "tls_private_key" "private_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "key_pair" {
  key_name   = "${var.project_name}-key-pair"
  public_key = tls_private_key.private_key.public_key_openssh
}

resource "aws_instance" "ec2" {
  instance_type = var.ec2_instance_type
  key_name      = aws_key_pair.key_pair.key_name
  ami           = var.ami_id

  availability_zone           = var.availability_zone
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = var.vpc_security_group_ids
  associate_public_ip_address = var.associate_public_ip_address

  iam_instance_profile = aws_iam_instance_profile.instance_profile.name

  user_data = var.user_data

  tags = {
    Name  = "${var.project_name}-ec2"
    Owner = var.owner
  }
}

resource "aws_eip" "public_elastic_ip" {
  count = var.needs_elastic_ip == true ? 1 : 0

  instance = aws_instance.ec2.id
  vpc      = true

  tags = {
    Name  = "${var.project_name}-public-elastic-ip"
    Owner = var.owner
  }
}