variable "project_name" {
  type        = string
  description = "The projects's name - can only contain alphanumeric/underscore chatracters."

  validation {
    condition     = can(regex("^[0-9A-Za-z_]+$", var.project_name))
    error_message = "For the project_name value, only a-z, A-Z, 0-9 and _ are allowed."
  }
}

variable "environment" {
  type        = string
  description = "The environment being deployed to - can only contain lower case letters."

  validation {
    condition     = can(regex("^[a-z]+$", var.environment))
    error_message = "For the environment value, only a-z are allowed."
  }
}

variable "owner" {
  type        = string
  description = "The email address of the owner."

  validation {
    condition     = can(match("^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$", var.owner))
    error_message = "Invalid email address format. Please provide a valid email address."
  }
}

# VPC variables
variable "vpc_cidr" {
  type        = string
  description = "This specifies the CIDR block for the VPC."
  default     = "10.0.0.0/16"

  validation {
    condition     = can(cidrhost(var.vpc_cidr, 0))
    error_message = "Must be valid IPv4 CIDR."
  }
}

variable "enable_vpc_flow_logs" {
  type        = bool
  description = "Whether to enable VPC Flow Logs for this VPC, this has cost but is considered a security risk without"
}

variable "vpc_flow_logs_traffic_type" {
  type        = string
  description = "The Type of traffic to log, Requires vpc_flow_logs to be true"
  default     = "ALL"

  validation {
    condition     = contains(["ALL", "ACCEPT", "REJECT"], var.vpc_flow_logs_traffic_type)
    error_message = "Valid values for traffic_type: ALL, ACCEPT, REJECT."
  }
}

# DNS Support
variable "enable_dns_support" {
  type        = bool
  description = "This allows AWS DNS support to be switched on or off."
  default     = true
}

variable "enable_dns_hostnames" {
  type        = bool
  description = "This allows AWS DNS hostname support to be switched on or off."
  default     = true
}

# Availability Zone variables
variable "azs" {
  type        = list(string)
  description = "This is a list that specifies all the Availability Zones that will have public and private subnets in it. Defaulting this value to an empty list selects of all the Availability Zones in the region you specify when defining the provider in your terraform project."
  default     = []
}

# Subnet variables
variable "num_public_subnets" {
  type        = number
  description = "This is a number specifying how many public subnets you want. Setting this to its default value of `-1` will result in `x` public subnets where `x` is the number of Availability Zones. If the number of public subnets is greater than the number of Availability Zones the public subnets will be spread out evenly over the available AZs. The CIDR values used are of the form `10.0.{i}.0/24` where `i` starts at 1 and increases by 1 for each public subnet."
  default     = -1
}

variable "num_private_subnets" {
  type        = number
  description = "This is a number specifying how many private subnets you want. Setting this to its default value of `-1` will result in `x` private subnets where `x` is the number of Availability Zones. If the number of private subnets is greater than the number of Availability Zones the private subnets will be spread out evenly over the available AZs. The CIDR values used are of the form `10.0.{i}.0/24` where `i` starts at 101 and increases by 1 for each private subnet."
  default     = -1
}

# CIDR Defintions
variable "ig_cidr" {
  type        = string
  description = "This specifies the CIDR block for the internet gateway."
  default     = "0.0.0.0/0"

  validation {
    condition     = can(cidrhost(var.ig_cidr, 0))
    error_message = "Must be valid IPv4 CIDR."
  }
}

variable "ig_ipv6_cidr" {
  type        = string
  description = "This specifies the IPV6 CIDR block for the internet gateway."
  default     = "::/0"

  validation {
    condition     = can(cidrhost(var.ig_ipv6_cidr, 0))
    error_message = "Must be valid IPv6 CIDR."
  }
}
