# VPC Subnet module

module "vpc_subnet" {
  source = "../Terraform_modules/vpc_subnets"

  project_name = var.project_name
  owner = var.owner
  public_subnets = true
  private_subnets = false
}

# Security Group: Defines network traffic rules

resource "aws_security_group" "ec2_sg" {
  name        = "${var.project_name}-ec2_sg"
  description = "Security group for ec2_sg"
  vpc_id       = module.vpc_subnet.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol   = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name  = "${var.project_name}-ec2-sg"
    Owner = var.owner
  }
}

# IAM: Define roles that the EC2 instance needs

resource "aws_iam_role" "ec2_role" {
  name = "${var.project_name}-ec2_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF

  tags = {
    Name  = "${var.project_name}-ec2-role"
    Owner = var.owner
  }
}

resource "aws_iam_instance_profile" "ec2_profile" {
  name = "ec2_profile"
  role = aws_iam_role.ec2_role.name

  tags = {
    Name = "${var.project_name}-ec2-profile"
    Owner = var.owner
  }
}

resource "aws_iam_role_policy" "ec2_policy" {
  name = "ec2_policy"
  role = aws_iam_role.ec2_role.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "ec2:RunInstances",
        "ec2:AssociateIamInstanceProfile",
        "ec2:ReplaceIamInstanceProfileAssociation",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}

# Elastic IP: Public address persists when an instance is restarted

resource "aws_eip" "eip" {
  instance = aws_instance.api.id
  vpc      = true

  tags = {
    Name = "${var.project_name}-eip"
  }
}

resource "aws_eip_association" "eip_assoc" {
  instance_id   = aws_instance.api.id
  allocation_id = aws_eip.eip.id
}

# AMI: Provides image info for Amazon Linux 2

data "aws_ami" "amazon_linux_2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-ebs"]
  }
}

# EC2 Instance:
# Executes user_data.sh to pull and run the C# API Docker image

data "template_file" "user_data" {
  template = file("${path.module}/scripts/user_data.sh")
  vars = {
    image_url = var.image_url
  }
}

resource "aws_instance" "api" {
  ami           = data.aws_ami.amazon_linux_2.id
  instance_type = "t2.micro"

  root_block_device {
    volume_size = 8
  }

  user_data                   = data.template_file.user_data.rendered
  user_data_replace_on_change = true

  subnet_id                   = module.vpc_subnet.public_subnet_ids[0]
  vpc_security_group_ids      = [aws_security_group.ec2_sg.id]
  associate_public_ip_address = true
  
  iam_instance_profile = aws_iam_instance_profile.ec2_profile.name

  tags = {
    Name    = "${var.project_name}-ec2"
    Owner   = var.owner
  }

  monitoring              = true
  disable_api_termination = false
}