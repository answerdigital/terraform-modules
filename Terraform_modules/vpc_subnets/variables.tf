variable "project_name" {
  type = string
  default = "eu-west-2"
}

variable "vpc_cidr" {
  type        = string
  description = "The CIDR block given to the vpc."
  default     = "10.0.0.0/16"
}

variable "azs" {
  type        = list(string)
  description = "A list of Availability Zones."
  default     = ["eu-west-2a", "eu-west-2b", "eu-west-2c"]
}

variable "public_subnet_cidrs" {
  type        = list(string)
  description = "A list of public Subnet CIDR values."
  default     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

variable "private_subnet_cidrs" {
  type        = list(string)
  description = "A list of private Subnet CIDR values."
  default     = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
}
