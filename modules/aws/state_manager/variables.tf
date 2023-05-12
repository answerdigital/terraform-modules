variable "project_name" {
  type        = string
  description = "This is used to label the components of the session storage"
}

# OPTIONAL VARIABLES

variable "environment" {
  type        = string
  description = "This is used to label the components of the session storage with the AWS environment the bucket is hosted on"
  default     = "dev"
}

variable "create_logging_bucket" {
  type        = bool
  description = "Provide this if you want an access log for the Terraform State Bucket"
  default     = true
}