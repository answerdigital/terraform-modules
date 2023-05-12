locals {
  state_management_key = "global/${var.environment}/s3/terraform.tfstate"
  environment = var.environment ? var.environment : "test"
}