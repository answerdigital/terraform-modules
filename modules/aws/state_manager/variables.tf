variable "project_name" {
  type        = string
  description = "This is used to label the components of the session storage"
}

# OPTIONAL VARIABLES

variable "environment" {
  type        = string
  description = "This is used to label the components of the session storage with the AWS environment the bucket is hosted on"
  default     = "test"
}
