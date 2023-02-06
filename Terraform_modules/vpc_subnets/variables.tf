variable "project_name" {
  type = string
}

variable "owner" {
  type = string
}

# VPC variables
variable "vpc_cidr" {
  type        = string
  description = "The CIDR block given to the vpc."
  default     = "10.0.0.0/16"
}

variable "enable_dns_support" {
  type    = bool
  default = true
}

variable "enable_dns_hostnames" {
  type    = bool
  default = true
}

# Availability Zone variables
variable "azs" {
  type        = list(string)
  description = "A list of Availability Zones."
  default     = []
}

# Subnet variables
variable "num_public_subnets" {
  type        = number
  description = "Number indicating how many public subnets you want"
  default     = -1
}

variable "num_private_subnets" {
  type        = number
  description = "Number indicating how many public subnets you want"
  default     = -1
}

variable "ig_cidr" {
  type    = string
  default = "0.0.0.0/0"
}

variable "ig_ipv6_cidr" {
  type    = string
  default = "::/0"
}
