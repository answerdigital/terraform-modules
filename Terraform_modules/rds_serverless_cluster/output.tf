output "rds_cluster_instance_port" {
  value = aws_rds_cluster_instance.rds_cluster_instance.port
}

output "rds_cluster_instance_endpoint" {
  value = aws_rds_cluster_instance.rds_cluster_instance.endpoint
}

output "rds_cluster_master_username" {
  value = aws_rds_cluster.rds_cluster.master_username
  sensitive = true
}

output "rds_cluster_master_password" {
  value = aws_rds_cluster.rds_cluster.master_password
  sensitive = true
}

output "rds_cluster_instance_db_name" {
  value = aws_rds_cluster.rds_cluster.database_name
}