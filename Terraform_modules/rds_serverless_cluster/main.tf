terraform {
  required_version = "~> 1.3"

  required_providers {
    random = {
      source  = "hashicorp/random"
      version = ">= 3.4.3"
    }
  }
}

resource "aws_kms_key" "secrets" {
  enable_key_rotation = true
  count               = var.kms_customer_managed_key == true ? 1 : 0
}

resource "aws_secretsmanager_secret" "aurora_db_secret" {
  name       = "${var.project_name}-aurora-db-secret-${random_id.secrets_id.hex}"
  kms_key_id = var.kms_customer_managed_key == true ? aws_kms_key[0].secrets.arn : "aws/secretsmanager"
}

resource "aws_secretsmanager_secret_version" "aurora_db_secret_version" {
  secret_id     = aws_secretsmanager_secret.aurora_db_secret.id
  secret_string = <<-EOF
  {
    "username": "admin",
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

  cluster_identifier     = "${var.project_name}-cluster"
  engine                 = var.database_engine
  engine_mode            = "provisioned"
  engine_version         = var.database_engine_version
  database_name          = var.database_name
  master_username        = jsondecode(aws_secretsmanager_secret_version.aurora_db_secret_version.secret_string)["username"]
  master_password        = jsondecode(aws_secretsmanager_secret_version.aurora_db_secret_version.secret_string)["password"]
  skip_final_snapshot    = true
  storage_encrypted      = false
  deletion_protection    = false
  vpc_security_group_ids = var.database_security_groups
  db_subnet_group_name   = aws_db_subnet_group.private_db_subnet_group.name

  serverlessv2_scaling_configuration {
    max_capacity = var.database_serverlessv2_scaling_max_capacity
    min_capacity = var.database_serverlessv2_scaling_min_capacity
  }

  tags = {
    Name  = "${var.project_name}-rds-cluster"
    Owner = var.owner
  }
}

resource "aws_rds_cluster_instance" "rds_cluster_instance" {
  cluster_identifier   = aws_rds_cluster.rds_cluster.id
  instance_class       = "db.serverless"
  engine               = aws_rds_cluster.rds_cluster.engine
  engine_version       = aws_rds_cluster.rds_cluster.engine_version
  db_subnet_group_name = aws_db_subnet_group.private_db_subnet_group.name

  auto_minor_version_upgrade = var.database_auto_minor_version_upgrade
  availability_zone          = var.database_availability_zone

  tags = {
    Name  = "${var.project_name}-rds-cluster-instance"
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
