output "state_bucket_name" {
  value       = aws_s3_bucket.project_terraform_state.bucket
  description = "The name of the bucket created to store the state against"
  sensitive   = false
}

output "state_bucket_dynamodb_table" {
  value       = aws_dynamodb_table.project_tf_locks.name
  description = "The name of dyanamo-db table to store the terraform lock file in"
  sensitive   = false
}

output "state_bucket_filename" {
  value       = local.state_management_key
  description = "The name of the filename to save the tfstate against"
  sensitive   = false
}