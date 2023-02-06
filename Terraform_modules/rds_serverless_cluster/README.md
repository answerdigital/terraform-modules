# Terraform RDS Serverless Module

This Terraform module will produce an Aurora serverless database inside a database
cluster. The serverless database can be of two types `aurora-mysql` or `aurora-postgresql`.
AWS Secrets manager is used to store the default username and password given to the
serverless database where the password is a randomly generated sequence of 16 characters.
These secrets can be viewed in the Secrets Manager section of the aws management console.
These secrets are also set as outputs of the module and can be referenced throughout your terraform code.

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.3 |
| <a name="requirement_random"></a> [random](#requirement\_random) | >= 3.4.3 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |
| <a name="provider_random"></a> [random](#provider\_random) | >= 3.4.3 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_database_auto_minor_version_upgrade"></a> [database\_auto\_minor\_version\_upgrade](#input\_database\_auto\_minor\_version\_upgrade) | This is a boolean value determining if minor version upgrades for your database\_engine\_version should be applied automatically to your server. | `bool` | `false` | no |
| <a name="input_database_availability_zone"></a> [database\_availability\_zone](#input\_database\_availability\_zone) | This is the availability zone that the database instance will be created on. | `string` | n/a | yes |
| <a name="input_database_engine"></a> [database\_engine](#input\_database\_engine) | This specifies the engine the database will use. This value has to be one of two options: aurora-mysql, aurora-postgresql | `string` | n/a | yes |
| <a name="input_database_engine_version"></a> [database\_engine\_version](#input\_database\_engine\_version) | This is the version of the engine you would like. | `string` | n/a | yes |
| <a name="input_database_name"></a> [database\_name](#input\_database\_name) | The name assigned to the database. | `string` | n/a | yes |
| <a name="input_database_security_groups"></a> [database\_security\_groups](#input\_database\_security\_groups) | This is a list of VPC security group ids to associate with the database cluster. | `list(string)` | `[]` | no |
| <a name="input_database_serverlessv2_scaling_max_capacity"></a> [database\_serverlessv2\_scaling\_max\_capacity](#input\_database\_serverlessv2\_scaling\_max\_capacity) | This sets the maximum scaling capacity of the severless database in Aurora capacity units (ACU). | `number` | `1` | no |
| <a name="input_database_serverlessv2_scaling_min_capacity"></a> [database\_serverlessv2\_scaling\_min\_capacity](#input\_database\_serverlessv2\_scaling\_min\_capacity) | This sets the minimum scaling capacity of the severless database in Auroracapacity units (ACU). | `number` | `0.5` | no |
| <a name="input_database_subnet_ids"></a> [database\_subnet\_ids](#input\_database\_subnet\_ids) | This is a list of subnet ids that the database cluster will be created across. The minimum number of subnets that can be supplied is 2. | `list(string)` | n/a | yes |
| <a name="input_owner"></a> [owner](#input\_owner) | This is used to specify the owner of the resources in this module. | `string` | n/a | yes |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | This is used to label the resources of the module. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_rds_cluster_instance_db_name"></a> [rds\_cluster\_instance\_db\_name](#output\_rds\_cluster\_instance\_db\_name) | This is the name of the database created. This value should be used when referencing the `DATABASE_NAME` in your configuration. |
| <a name="output_rds_cluster_instance_endpoint"></a> [rds\_cluster\_instance\_endpoint](#output\_rds\_cluster\_instance\_endpoint) | This is the endpoint where the database instance is hosted. This value should be used when referencing the `DATABASE_HOST` in your configuration. |
| <a name="output_rds_cluster_instance_port"></a> [rds\_cluster\_instance\_port](#output\_rds\_cluster\_instance\_port) | This is the port via which the database communicates on. This value should be used when referencing the `DATABASE_PORT` in your configuration. |
| <a name="output_rds_cluster_master_password"></a> [rds\_cluster\_master\_password](#output\_rds\_cluster\_master\_password) | This is the password of the default account the database is set up with. This password can be accessed in the AWS Secrets Manager under `<project_name>-aurora-db-secret-<random-hex-string>`. The password itself is a randomly generated password of length 16. |
| <a name="output_rds_cluster_master_username"></a> [rds\_cluster\_master\_username](#output\_rds\_cluster\_master\_username) | This is the username of the default account the database is set up with. This username can be accessed in the AWS Secrets Manager under `<project_name>-aurora-db-secret-<random-hex-string>`. |

# Example Usage

Below is an example of how you would call the `rds_serverless_cluster` module in your
terraform code. Note that when calling it directly from the github repository you can specify a
version by appending the below source reference with `?ref=v1.2.0` for version "1.2.0"
(for further information please see
[here](https://developer.hashicorp.com/terraform/language/modules/sources#modules-in-package-sub-directories)).

<pre><code>module "rds_cluster_setup" {
source                     = "git::https://github.com/AnswerConsulting/AnswerKing-Infrastructure.git//Terraform_modules/rds_serverless_cluster?ref=v1.0.0"
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
