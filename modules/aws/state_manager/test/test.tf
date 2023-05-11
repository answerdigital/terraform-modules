locals {
  environment  = "test"
  project_name = "p_name"
}


module "s3_state_manager" {
  source       = "../."
  project_name = local.project_name
  environment  = local.environment
}

terraform {
  backend "s3" {
    bucket         = module.s3_state_manager.state_bucket_name
    key            = module.s3_state_manager.state_bucket_filename
    region         = "eu-west-2"
    dynamodb_table = module.s3_state_manager.state_bucket_dynamodb_table
    encrypt        = true
  }
}