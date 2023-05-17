locals {
  project = "test_project"
  owner   = "answer_tester"
}

module "elb" {
  source                    = "../."
  application_http_protocol = "HTTP"
  application_port          = "80"
  healthcheck_endpoint      = "/var/www/html/index.html"
  internal                  = false
  lb_name                   = "test-lb"
  subnet_ids                = module.vpc_subnet.public_subnet_ids
  vpc_id                    = ""
  vpc_security_group_ids    = []
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


module "vpc_subnet" {
  source               = "../../vpc"
  owner                = local.owner
  project_name         = local.project
  enable_vpc_flow_logs = true
}

module "ec2_instance_setup" {
  source                 = "../../ec2"
  project_name           = local.project
  owner                  = local.owner
  ami_id                 = data.aws_ami.ec2_ami.id
  availability_zone      = data.aws_availability_zones.available.names[0]
  subnet_id              = module.vpc_subnet.public_subnet_ids[0]
  vpc_security_group_ids = []
  needs_elastic_ip       = true
  user_data              = <<EOF
#!/bin/bash -xe
#logs all user_data commands into a user-data.log file
exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1
sudo apt update -y
sudo apt install apache2 -y
sudo systemctl start apache2
EOL
  EOF
}