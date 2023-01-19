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
  type = bool
  default = true
}

variable "enable_dns_hostnames" {
  type = bool
  default = true
}

# Availability Zone variables
variable "azs" {
  type        = list(string)
  description = "A list of Availability Zones."
  default     = []
}

# Subnet variables
variable "public_subnets" {
  type = bool
  description = "Boolean indicating if you want public subnets"
  default = true
}

variable "private_subnets" {
  type = bool
  description = "Boolean indicating if you want private subnets"
  default = true
}

variable "public_subnet_cidrs" {
  type        = list(string)
  description = "A list of public Subnet CIDR values."
  default     = []
}

variable "private_subnet_cidrs" {
  type        = list(string)
  description = "A list of private Subnet CIDR values."
  default     = []
}

variable "ig_cidr" {
  type = string
  default = "0.0.0.0/0"
}

variable "ig_ipv6_cidr" {
  type = string
  default = "::/0"
}
