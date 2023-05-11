
locals {
  state_management_key = "global/${var.environment}/s3/terraform.tfstate"
}

resource "aws_s3_bucket" "project_terraform_state" {
  bucket = "${var.project_name}-var.environment-state-management-bucket"
  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_s3_bucket_versioning" "project_versioning" {
  bucket = aws_s3_bucket.project_terraform_state.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "project_s3_encryption" {
  bucket = aws_s3_bucket.project_terraform_state.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "project_s3_public_access" {
  bucket                  = aws_s3_bucket.project_terraform_state.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_dynamodb_table" "project_tf_locks" {
  name         = "${var.project_name}-tf-locks-${var.environment}"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}