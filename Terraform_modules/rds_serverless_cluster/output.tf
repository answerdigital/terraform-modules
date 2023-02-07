output "rds_cluster_instance_port" {
  value       = aws_rds_cluster_instance.rds_cluster_instance.port
  description = "This is the port via which the database communicates on. This value should be used when referencing the `DATABASE_PORT` in your configuration. This output is of type `string`."
}

output "rds_cluster_instance_endpoint" {
  value       = aws_rds_cluster_instance.rds_cluster_instance.endpoint
  description = "This is the endpoint where the database instance is hosted. This value should be used when referencing the `DATABASE_HOST` in your configuration. This output is of type `string`."
}

output "rds_cluster_master_username" {
  value       = aws_rds_cluster.rds_cluster.master_username
  sensitive   = true
  description = "This is the username of the default account the database is set up with. This username can be accessed in the AWS Secrets Manager under `<project_name>-aurora-db-secret-<random-hex-string>`. This output is of type `string` and `sensitivity` is set to `true`."
}

output "rds_cluster_master_password" {
  value       = aws_rds_cluster.rds_cluster.master_password
  sensitive   = true
  description = "This is the password of the default account the database is set up with. This password can be accessed in the AWS Secrets Manager under `<project_name>-aurora-db-secret-<random-hex-string>`. The password itself is a randomly generated password of length 16. This output is of type `string` and `sensitivity` is set to `true`."
}

output "rds_cluster_instance_db_name" {
  value       = aws_rds_cluster.rds_cluster.database_name
  description = "This is the name of the database created. This value should be used when referencing the `DATABASE_NAME` in your configuration. This output is of type `string`."
}