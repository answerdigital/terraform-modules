provider "aws" {
  region                      = var.aws_region
  skip_credentials_validation = true
}

#provider "docker" { }

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

    /*
    docker = {
      source = "kreuzwerker/docker"
      version = "~> 2.13.0"
    }
    */
  }
}
