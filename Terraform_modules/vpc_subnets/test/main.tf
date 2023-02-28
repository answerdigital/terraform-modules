provider "aws" {
  region = "eu-west-2"
}

terraform {
  required_version = "~> 1.3"
}

module "vpc_subnet" {
  source               = "./.."
  enable_vpc_flow_logs = true
  num_private_subnets  = 1
  num_public_subnets   = 1

  owner        = "Testing Library"
  project_name = "test_one_vpc"
}