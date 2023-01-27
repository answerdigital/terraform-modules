# Terraform RDS Serverless Module

This Terraform module will produce a 


# Inputs
**project_name (Manadatory)**

This is used to label the resources of the module.

**owner (Mandatory)**

This is used to specify the owner of the resources in this module.

**database_name (Mandatory)**

The name assigned to the database.

**database_engine (Mandatory)**

This specifies the engine the database will use. This value has to be one of two options:

  Options:
  
    - "aurora-mysql"
    
    - "aurora-postgresql"

**database_engine_version (Mandatory)**

This is the version of the engine you would like.
  - For a list of possible Postgresql versions please see [here](https://docs.aws.amazon.com/AmazonRDS/latest/AuroraUserGuide/AuroraPostgreSQL.Updates.Versions.html)
  - For a list of possible MySQL versions please see [here](https://docs.aws.amazon.com/AmazonRDS/latest/AuroraUserGuide/AuroraMySQL.Updates.Versions.html)

**database_subnet_ids (Mandatory)**
This is a list of subnet ids that the database cluster will be created across. The minimum number of subnets that can be supplied is 2.

**database_availability_zone (Mandatory)**

This is the availability zone that the dtatbase instance will be created on.

**database_serverlessv2_scaling_min_capacity (Optional)**

This sets the minimum scaling capacity of the severless database in Aurora capacity units (ACU). "Aurora Serverless capacity is measured in Aurora capacity units (ACUs). Each ACU is a combination of approximately 2 gibibytes (GiB) of memory, corresponding CPU, and networking." The minimum value that can be specified is 0.5 ACU (ref: [Aurora capacity units](https://aws.amazon.com/blogs/aws/amazon-aurora-serverless-v2-is-generally-available-instant-scaling-for-demanding-workloads/#:~:text=Aurora%20Serverless%20capacity%20is%20measured,capacity%20supported%20is%20128%20ACU.)). The default value is set to 0.5 ACU.

**database_serverlessv2_scaling_max_capacity (Optional)**

This sets the minimum scaling capacity of the severless database in Auroracapacity units (ACU). "Aurora Serverless capacity is measured in Aurora capacity units (ACUs). Each ACU is a combination of approximately 2 gibibytes (GiB) of memory, corresponding CPU, and networking." The maximum value that can be specified is 128 ACU (ref: [Aurora capacity units](https://aws.amazon.com/blogs/aws/amazon-aurora-serverless-v2-is-generally-available-instant-scaling-for-demanding-workloads/#:~:text=Aurora%20Serverless%20capacity%20is%20measured,capacity%20supported%20is%20128%20ACU.)). The default value is set to 1.0 ACU.

**database_security_groups (Optional)**

This is a list of VPC security group ids to associate with the database cluster. This defaults to an empty list.

**database_auto_minor_version_upgrade**

This is a boolean value determining if minor version upgrades for your `database_engine_version` should be applied automatically to your server. The default value is set to `false`.

# Outputs

**rds_cluster_instance_port**

This is the port via which the database communicates on. This value should be used when referencing the `DATABASE_PORT` in your configuration.

**rds_cluster_instance_endpoint**

This is the endpoint where the database instance is hosted. This value should be used when referecing the `DATABASE_HOST` in your configuration.

**rds_cluster_master_username**

This is the username of the default account the database is set up with. This username can be accessed in the AWS Secrets Manager under "<project_name>-aurora-db-secret-<random-hex-string>.

**rds_cluster_master_password**

This is the password of the default account the database is set up with. This password can be accessed in the AWS Secrets Manager under "<project_name>-aurora-db-secret-<random-hex-string>. The password itself is a randomly generated pasword of length 16.

**rds_cluster_instance_db_name**

This is the name of the database created. This value should be used when referecing the `DATABASE_NAME` in your configuration.


# Example Usage

Below is an example of how you would call the `rds_serverless_cluster` module in your terraform code. In this example we show two ways of calling the module; the first is calling it directly from this github repository, the second (which is commented out) is how you would call it if the terraform module file was copied to your local root file. Note that when calling it directly from the github repository you can specify a version by appending the below source reference with `?ref=v1.2.0` for version "1.2.0" (for further information please see [here](https://developer.hashicorp.com/terraform/language/modules/sources#modules-in-package-sub-directories))

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
