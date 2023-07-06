locals {
  project_name = "name"
}


module "s3_state_manager" {
  source       = "../."
  project_name = local.project_name
  owner        = "Test"
}

output "state_bucket_name" {
  value       = module.s3_state_manager.state_bucket_name
  description = "The name of the bucket created to store the state against"
  sensitive   = false
}

output "state_bucket_dynamodb_table" {
  value       = module.s3_state_manager.state_bucket_dynamodb_table
  description = "The name of dyanamo-db table to store the terraform lock file in"
  sensitive   = false
}

output "state_bucket_filename" {
  value       = module.s3_state_manager.state_bucket_filename
  description = "The name of the filename to save the tfstate against"
  sensitive   = false
}