/*
  MANDATORY VARIABLES
*/
variable "project_name" {
  type = string
}

variable "owner" {
  type = string
}

variable "database_name" {
  type = string
}

variable "database_engine" {
  type = string

  validation {
    condition = can(regex("^aurora-postgresql$|^aurora-mysql$", var.database_engine))
    error_message = "[ERROR] The database engine is not valid or allowed."
  }
}

variable "database_engine_version" {
  type = string
}

variable "database_subnet_ids" {
  type = list(string)
}

variable "database_availability_zone" {
  type = string
}

/*
  OPTIONAL VARIABLES
*/
variable "database_serverlessv2_scaling_max_capacity" {
  type = number
  default = 1.0
}

variable "database_serverlessv2_scaling_min_capacity" {
  type = number
  default = 0.5
}

variable "database_security_groups" {
  type = list(string)
  default = []
}

variable "database_auto_minor_version_upgrade" {
  type = bool
  default = false
}