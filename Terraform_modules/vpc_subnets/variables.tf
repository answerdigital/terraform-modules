variable "project_name" {
  type        = string
  description = "This is used to label the VPC as \"`project_name`-vpc\"."
}

variable "owner" {
  type        = string
  description = "This is used to identify AWS resources through its tags."
}

# VPC variables
variable "vpc_cidr" {
  type        = string
  description = "This specifies the CIDR block for the VPC."
  default     = "10.0.0.0/16"
}

variable "enable_vpc_flow_logs" {
  type        = bool
  description = "Whether to enable VPC Flow Logs for this VPC, this has cost but is considered a security risk without"
}

variable "vpc_flow_logs_traffic_type" {
  type        = string
  description = "The Type of traffic to log, Either Accept, Reject or All. Requires vpc_flow_logs to be true"
}



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

variable "ig_cidr" {
  type        = string
  description = "This specifies the CIDR block for the internet gateway."
  default     = "0.0.0.0/0"
}

variable "ig_ipv6_cidr" {
  type        = string
  description = "This specifies the IPV6 CIDR block for the internet gateway."
  default     = "::/0"
}
