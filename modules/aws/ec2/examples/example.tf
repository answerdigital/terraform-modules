locals {
  project = "test_project"
  owner   = "answer_tester"
}

resource "aws_security_group" "aws_sg" {
  name        = "${local.project}-sg"
  description = "A Basic Security Group"
  vpc_id      = module.vpc_subnet.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = local.project
  }
}

module "vpc_subnet" {
  source               = "../../vpc"
  owner                = local.owner
  project_name         = local.project
  enable_vpc_flow_logs = true
}

data "aws_ami" "ec2_ami" {
  most_recent = true
  filter {
    name   = "name"
    values = ["amzn-ami-hvm-*-x86_64-ebs"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
  owners = ["amazon"]
}

data "aws_availability_zones" "available" {
  state = "available"
}



module "ec2_instance_setup" {
  source                 = "../."
  project_name           = local.project
  owner                  = local.owner
  ami_id                 = data.aws_ami.ec2_ami.id
  availability_zone      = data.aws_availability_zones.available.names[0]
  subnet_id              = module.vpc_subnet.public_subnet_ids[0]
  vpc_security_group_ids = [aws_security_group.aws_sg.id]
  needs_elastic_ip       = true
  user_data              = <<EOF
#!/bin/bash -xe
#logs all user_data commands into a user-data.log file
exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1

sudo yum update -y
sudo yum upgrade -y
sudo yum install docker -y
sudo systemctl enable docker.service
sudo systemctl start docker.service

sudo cat << EOL > /usr/.env
DATABASE_ENGINE=django.db.backends.mysql
EOL
  EOF
}
