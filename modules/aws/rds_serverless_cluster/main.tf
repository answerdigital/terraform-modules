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

resource "aws_secretsmanager_secret" "aurora_db_secret" {
  name = "${var.project_name}-aurora-db-secret-${random_id.secrets_id.hex}"
}

resource "aws_secretsmanager_secret_version" "aurora_db_secret_version" {
  secret_id     = aws_secretsmanager_secret.aurora_db_secret.id
  secret_string = <<-EOF
  {
    "username": "projectadmin",
    "password": "${random_password.password.result}"
  }
  EOF
}

resource "aws_db_subnet_group" "private_db_subnet_group" {
  name       = "${var.project_name}-db-private-subnet-group"
  subnet_ids = var.database_subnet_ids

  tags = {
    Name  = "${var.project_name}-db-private-subnet-group"
    Owner = var.owner
  }
}

resource "aws_rds_cluster" "rds_cluster" {
  depends_on = [aws_secretsmanager_secret.aurora_db_secret]

  cluster_identifier      = "${var.project_name}-cluster"
  engine                  = var.database_engine
  engine_mode             = "provisioned"
  engine_version          = var.database_engine_version
  database_name           = var.database_name
  master_username         = jsondecode(aws_secretsmanager_secret_version.aurora_db_secret_version.secret_string)["username"]
  master_password         = jsondecode(aws_secretsmanager_secret_version.aurora_db_secret_version.secret_string)["password"]
  skip_final_snapshot     = true
  storage_encrypted       = var.enable_encrypted_storage
  backup_retention_period = var.backup_retention_period
  deletion_protection     = var.prevent_deletion
  vpc_security_group_ids  = var.database_security_groups
  db_subnet_group_name    = aws_db_subnet_group.private_db_subnet_group.name

  preferred_backup_window      = "07:00-09:00"
  preferred_maintenance_window = "sun:04:00-sun:05:00"

  serverlessv2_scaling_configuration {
    max_capacity = var.database_serverlessv2_scaling_max_capacity
    min_capacity = var.database_serverlessv2_scaling_min_capacity
  }

  tags = {
    Name  = "${var.project_name}-rds-cluster"
    Owner = var.owner
  }
}

resource "aws_rds_cluster_instance" "primary_rds_cluster_instance" {
  cluster_identifier   = aws_rds_cluster.rds_cluster.id
  instance_class       = "db.serverless"
  engine               = aws_rds_cluster.rds_cluster.engine
  engine_version       = aws_rds_cluster.rds_cluster.engine_version
  db_subnet_group_name = aws_db_subnet_group.private_db_subnet_group.name

  performance_insights_enabled = var.database_performance_insights_enabled
  auto_minor_version_upgrade   = var.database_auto_minor_version_upgrade
  availability_zone            = var.database_availability_zone

  tags = {
    Name  = "${var.project_name}-rds-primary-cluster-instance"
    Owner = var.owner
  }
}

resource "aws_rds_cluster_instance" "replicated_rds_cluster_instances" {
  depends_on           = [aws_rds_cluster_instance.primary_rds_cluster_instance]
  for_each             = toset(var.replicate_on_availability_zones)
  availability_zone    = each.value
  cluster_identifier   = aws_rds_cluster.rds_cluster.id
  instance_class       = "db.serverless"
  engine               = aws_rds_cluster.rds_cluster.engine
  engine_version       = aws_rds_cluster.rds_cluster.engine_version
  db_subnet_group_name = aws_db_subnet_group.private_db_subnet_group.name

  auto_minor_version_upgrade = var.database_auto_minor_version_upgrade

  tags = {
    Name  = "${var.project_name}-rds-replicated-cluster-instance-${each.value}"
    Owner = var.owner
  }
}

// Utilities
resource "random_password" "password" {
  length  = 16
  special = false
}

resource "random_id" "secrets_id" {
  byte_length = 8
}
