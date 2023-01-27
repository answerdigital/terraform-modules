# Terraform RDS Serverless Module

This Terraform module will produce a 


# Inputs
## project_name (Manadatory)

## owner 

## database_name

## database_engine

## database_engine_version

## database_subnet_ids

## database_availability_zone


# Outputs

## rds_cluster_instance_port

## rds_cluster_instance_endpoint

## rds_cluster_master_username

## rds_cluster_master_password

## rds_cluster_instance_db_name


# Example Usage

Below is an example of how you would call the `rds_serverless_cluster` module in your terraform code. In this example we show two ways of calling the module; the first is calling it directly from this github repository, the second (which is commented out) is how you would call it if the terraform module file was copied to your local root file. Note that when calling it directly from the github repository you can specify a version by appending the below source reference with `?ref=v1.2.0` for version "1.2.0" (for further information please see https://developer.hashicorp.com/terraform/language/modules/sources#modules-in-package-sub-directories)

<pre><code>module "rds_cluster_setup" {
  source                     = "git::https://github.com/AnswerConsulting/AnswerKing-Infrastructure.git//Terraform_modules/rds_serverless_cluster"
  # source                     = "./Terraform_modules/rds_serverless_clusters"
  project_name               = var.project_name
  owner                      = var.owner
  database_availability_zone = module.vpc_subnet_setup.az_zones[0]
  database_engine            = var.database_engine
  database_engine_version    = var.database_engine_version
  database_name              = var.database_name
  database_subnet_ids        = module.vpc_subnet_setup.private_subnet_ids
  database_security_groups   = [aws_security_group.rds_cluster.id]
}
</code></pre>
