output "rds_cluster_instance_port" {
  value = module.rds_cluster_setup.rds_cluster_instance_port
}
output "rds_cluster_instance_endpoint" {
  value = module.rds_cluster_setup.rds_cluster_instance_endpoint
}
output "rds_cluster_master_password" {
  value     = module.rds_cluster_setup.rds_cluster_master_password
  sensitive = true
}
output "rds_cluster_master_username" {
  value     = module.rds_cluster_setup.rds_cluster_master_username
  sensitive = true
}
output "rds_cluster_instance_db_name" {
  value = module.rds_cluster_setup.rds_cluster_instance_db_name
}

output "rds_cluster_replica_instance_endpoints" {
  value = module.rds_cluster_setup.rds_cluster_replica_instance_endpoints
}
output "rds_cluster_replica_instance_ports" {
  value = module.rds_cluster_setup.rds_cluster_replica_instance_ports
}