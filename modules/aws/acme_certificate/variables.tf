variable "email_address" {
  description = "Email address to register the Certificate"
  type        = string
}

variable "aws_hosted_zone_id" {
  description = "Hosted zone Id of the domain"
  type        = string
}

variable "base_domain_name" {
  description = "Domain without www. or https to create a certificate for"
  type        = string
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
}
