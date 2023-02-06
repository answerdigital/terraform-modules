/*
  MANDATORY VARIABLES
*/
variable "project_name" {
  type = string
}

variable "owner" {
  type = string
}

variable "ami_id" {
  type = string
}

variable "availability_zone" {
  type = string
}

variable "subnet_id" {
  type = string
}

variable "vpc_security_group_ids" {
  type = list(string)
}

/*
  OPTIONAL VARIABLES
*/
variable "ec2_instance_type" {
  type    = string
  default = "t2.micro"
}

variable "associate_public_ip_address" {
  type    = bool
  default = true
}

variable "user_data" {
  type    = string
  default = ""
}

variable "needs_elastic_ip" {
  type    = bool
  default = false
}

variable "user_data_replace_on_change" {
  type    = bool
  default = true
}