provider "aws" {
  region                      = var.aws_region
  skip_credentials_validation = true
}

provider "acme" {
  server_url = "https://acme-staging-v02.api.letsencrypt.org/directory"
  #server_url = "https://acme-v02.api.letsencrypt.org/directory"
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

    acme = {
      source  = "vancluever/acme"
      version = "~> 2.5.3"
    }

    /*
    docker = {
      source = "kreuzwerker/docker"
      version = "~> 2.13.0"
    }
    */
  }
}
