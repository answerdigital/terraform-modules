/*
  MANDATORY VARIABLES
*/
variable "project_name" {
  type        = string
  description = "This is used to label the resources of the module."
}

variable "owner" {
  type        = string
  description = "This is used to specify the owner of the resources in this module."
}

variable "database_name" {
  type        = string
  description = "The name assigned to the database."
}

variable "database_engine" {
  type        = string
  description = "This specifies the engine the database will use. This value has to be one of two options: aurora-mysql, aurora-postgresql"

  validation {
    condition     = can(regex("^aurora-postgresql$|^aurora-mysql$", var.database_engine))
    error_message = "[ERROR] The database engine is not valid or allowed."
  }
}

variable "database_engine_version" {
  type        = string
  description = "This is the version of the engine you would like."
}

variable "database_subnet_ids" {
  type        = list(string)
  description = "This is a list of subnet ids that the database cluster will be created across. The minimum number of subnets that can be supplied is 2."
}

variable "database_availability_zone" {
  type        = string
  description = "This is the availability zone that the database instance will be created on."
}

/*
  OPTIONAL VARIABLES
*/

variable "kms_customer_managed_key" {
  type    = bool
  default = false
  description = "This allows the usage of a KMS Key managed by you, by default this is managed by Amazon, enable this to control if you wish to use your own Cryptographic key"
}

variable "database_serverlessv2_scaling_max_capacity" {
  type        = number
  default     = 1.0
  description = "This sets the maximum scaling capacity of the severless database in Aurora capacity units (ACU)."
}

variable "database_serverlessv2_scaling_min_capacity" {
  type        = number
  default     = 0.5
  description = "This sets the minimum scaling capacity of the severless database in Auroracapacity units (ACU)."
}

variable "database_security_groups" {
  type        = list(string)
  default     = []
  description = "This is a list of VPC security group ids to associate with the database cluster."
}

variable "database_auto_minor_version_upgrade" {
  type        = bool
  default     = false
  description = "This is a boolean value determining if minor version upgrades for your database_engine_version should be applied automatically to your server."
}