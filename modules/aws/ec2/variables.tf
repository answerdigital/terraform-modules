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

variable "ami_id" {
  type        = string
  description = "This is the id of the ami image used for the ec2 instance."
}

variable "availability_zone" {
  type        = string
  description = "This is the availability zone you want the ec2 instance to be created in."
}

variable "subnet_id" {
  type        = string
  description = "This is the id of the subnet you want the ec2 instance to be created in."
}

variable "vpc_security_group_ids" {
  type        = list(string)
  description = "This is a list of ids that specifies the security groups you want your EC2 to be in."
}

/*
  OPTIONAL VARIABLES
*/
variable "ec2_instance_type" {
  type        = string
  default     = "t2.micro"
  description = "This is the type of EC2 instance you want."
}

variable "associate_public_ip_address" {
  type        = bool
  default     = true
  description = "This is a boolean value indicating if a public IP address should be associated with the EC2 instance."
}

variable "user_data" {
  type        = string
  default     = ""
  description = "This allows bash scripts and command line commands to be specified and run in the EC2 instance when launched. Do not pass gzip-compressed data via this argument."
}

variable "needs_elastic_ip" {
  type        = bool
  default     = false
  description = "This is a boolean value indicating whether an elastic IP should be generated and associated with the EC2 instance."
}

variable "user_data_replace_on_change" {
  type        = bool
  default     = true
  description = "This value indicates whether changes to the `user_data` value triggers a rebuild of the EC2 instance."
}

variable "custom_key_name" {
  type        = string
  description = "Provide the name of an EC2 key pair to use your own key. By default the SSH key will be managed by this module."
  default     = ""
}
