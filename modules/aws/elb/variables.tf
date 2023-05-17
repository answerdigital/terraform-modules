variable "application_port" {
  description = "The port of the application to forward traffic to"
}

variable "application_http_protocol" {
  description = "The protocol over which to forward traffic. Used for the health check and the and the load balancer itself "
}

variable "vpc_id" {
  description = "The id of the VPC to create the load balancer in this is provided by the VPC module"
}

variable "internal" {
  description = "If the load balancer is internally facing or externally facing"
}

variable "lb_name" {
  description = "The name of the load balancer"
}

variable "subnet_ids" {
  description = "The Subnets in which this load balancer will operate"
}

variable "healthcheck_endpoint" {
  description = "The api endpoint the load balancer will use as a health-check"
}

variable "sticky_session" {
  description = "Makes the LB Sticky, if requests come from the same client then sessions are persisted"
  default     = false
}

variable "vpc_security_group_ids" {
  type        = list(string)
  description = "This is a list of ids that specifies the security groups you want your EC2 to be in. If you do not wish to specify a security group for your module then please set this value to an empty list"
}
