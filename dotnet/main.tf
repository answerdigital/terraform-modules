module "vpc_subnet_setup" {
  source = "../Terraform_modules/vpc_subnets"

  project_name = "ak_api_dotnet"
  owner = "ak_dotnet_team"
  public_subnets = true
  private_subnets = false

}

data "aws_vpc" "default" {
  default = true
}

data "aws_subnet_ids" "all" {
  vpc_id = data.aws_vpc.default.id
}

#Security Group
resource "aws_security_group" "ec2_sg" {
  name        = "ec2_sg"
  description = "Security group for ec2_sg"
  vpc_id      = data.aws_vpc.default.id

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
    Name    = "ec2_sg_ak_api_dotnet"
    project = "ak_api_dotnet"
  }
}

#AMI: provides image info for the EC2 instance
data "aws_ami" "amazon_linux_2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-ebs"]
  }
}

#IAM(Identity & Access Management): creates roles that the EC2 instance needs
resource "aws_iam_role" "ec2_role_ak_api_dotnet" {
  name = "ec2_role_ak_api_dotnet"

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
    Name    = "ec2_role_ak_api_dotnet"
    project = "ak_api_dotnet"
  }
}

resource "aws_iam_instance_profile" "ec2_profile_ak_api_dotnet" {
  name = "ec2_profile_ak_api_dotnet"
  role = aws_iam_role.ec2_role_ak_api_dotnet.name

  tags = {
    Name = "ec2_profile_ak_api_dotnet"
  }
}

resource "aws_iam_role_policy" "ec2_policy" {
  name = "ec2_policy_ak_api_dotnet"
  role = aws_iam_role.ec2_role_ak_api_dotnet.id

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

data "template_file" "startup_script" {
  template = file("${path.module}/scripts/user_data.sh")
}

resource "aws_instance" "ak_api_dotnet" {
  ami           = data.aws_ami.amazon_linux_2.id
  instance_type = "t2.micro"

  root_block_device {
    volume_size = 8
  }

  user_data = data.template_file.startup_script.rendered
  
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]
  
  iam_instance_profile = aws_iam_instance_profile.ec2_profile_ak_api_dotnet.name

  tags = {
    Name    = "ak_api_dotnet"
    project = "ak_api_dotnet"
  }

  monitoring              = true
  disable_api_termination = false
}