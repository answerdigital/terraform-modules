variable "email_address" {
  description = "Email address to register the Certificate"
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$", var.email_address))
    error_message = "Invalid email address format. Please provide a valid email address."
  }
}

variable "aws_hosted_zone_id" {
  description = "Hosted zone Id of the domain"
  type        = string
}

variable "base_domain_name" {
  description = "Common name to create certificate for. Example: test.test.com"
  type        = string

  validation {
    condition     = !can(regex("^https?://", var.base_domain_name))
    error_message = "Base domain name cannot start with http:// or https://."
  }
}

variable "aws_access_key" {
  description = "AWS access key for the AWS account Route53 is on"
  type        = string
  sensitive   = true
}

variable "aws_secret_key" {
  description = "AWS secret key for the AWS account Route53 is on"
  type        = string
  sensitive   = true
}

variable "aws_region" {
  description = "Region for the networking resources. (Defaults to eu-west-2)"
  type        = string
  default     = "eu-west-2"

  validation {
    condition     = can(regex("[a-z][a-z]-[a-z]+-[1-9]", var.aws_region))
    error_message = "Must be valid AWS Region names."
  }
}
