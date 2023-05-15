variable "application_port" {
  default = "The port of the application to forward traffic to"
}

variable "application_http_protocol" {
  default = "The protocol over which to forward traffic. Used for the health check and the and the load balancer itself "
}

variable "vpc_id" {
  description = "The id of the VPC to create the ELB In this is provided by the VPC Module"
}

variable "internal" {
  description = "If the ELB is internally facing or externally facing"
}

variable "lb_name" {
  description = "The name of the load balancer"
}

variable "security_group_id" {
  default = "The security group of which this LB will belong to"
}

variable "subnet_ids" {
  default = "The Subnets in which this LB will operate"
}