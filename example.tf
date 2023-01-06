provider "aws" {
  region                      = var.region
  skip_credentials_validation = true
}

terraform {
  required_version = "~> 1.3"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.48.0"
    }

    random = {
      source  = "hashicorp/random"
      version = ">= 3.4.3"
    }
  }
}

module "vpc_subnet_setup" {
  source = "./Terraform_modules/vpc_subnets"

  project_name = "example_project"
  public_subnets = true
  private_subnets = false

}

