data "aws_rds_engine_version" "test" {
  engine = "aurora-postgresql"

  filter {
    name   = "engine-mode"
    values = ["provisioned"]
  }
}

locals {
  owner         = "Test Person"
  project_name  = "test-serverless-db"
  database_name = "testserverlessdb"
}

module "vpc_subnet" {
  source               = "../../vpc"
  owner                = local.owner
  project_name         = local.project_name
  enable_vpc_flow_logs = true
}

resource "aws_security_group" "aws_sg" {
  name        = "${local.project_name}-sg"
  description = "A Basic Security Group"
  vpc_id      = module.vpc_subnet.vpc_id

  ingress {
    from_port   = 5432
    to_port     = 5432
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
    Name = local.project_name
  }
}

module "rds_cluster_setup" {
  source                          = "../."
  project_name                    = local.project_name
  owner                           = local.owner
  database_availability_zone      = module.vpc_subnet.az_zones[0]
  database_engine                 = data.aws_rds_engine_version.test.engine
  database_engine_version         = data.aws_rds_engine_version.test.version
  database_name                   = local.database_name
  database_subnet_ids             = module.vpc_subnet.private_subnet_ids
  database_security_groups        = [aws_security_group.aws_sg.id]
  replicate_on_availability_zones = [module.vpc_subnet.az_zones[1]]
  prevent_deletion                = false
}