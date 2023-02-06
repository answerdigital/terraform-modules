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
  description = <<EOT
                This is a list that specifies all the Availability Zones that will
                have a public and private subnets in it. The default value
                is a list of all the Availability Zones in the region you specify when defining the provider
                in your terraform project.
                EOT
  default     = []
}

# Subnet variables
variable "num_public_subnets" {
  type        = number
  description = <<EOT
                This is a number specifying how many public subnets you want. Not specifying this will result
                in `x` public subnets where `x` is the number of az zones. If the number specified is greater than
                the number of Availability Zones (AZs) the public subnets will be spread out evenly over the
                available AZs. The CIDR values used are of the form `10.0.{i}.0/24` where `i` starts at 1 and
                increases by 1 for each public subnet.
                EOT
  default     = -1
}

variable "num_private_subnets" {
  type        = number
  description = <<EOT
                This is a number specifying how many private subnets you want. Not specifying this will result
                in `x` private subnets where `x` is the number of az zones. If the number specified is greater than
                the number of Availability Zones (AZs) the public subnets will be spread out evenly over the
                available AZs. The CIDR values used are of the form `10.0.{i}.0/24` where `i` starts at 1 and
                increases by 1 for each public subnet.
                EOT
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
