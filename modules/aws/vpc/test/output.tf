output "vpc_id" {
  value       = module.vpc_subnet_basic.vpc_id
}

output "public_subnet_ids" {
  value       = module.vpc_subnet_basic.public_subnet_ids
  description = "A list of the public subnet IDs that have been created. This output is of type `list(string)`."
}

output "private_subnet_ids" {
  value       = module.vpc_subnet_basic.private_subnet_ids
  description = "A list of the private subnet IDs that have been created. This output is of type `list(string)`."
}

output "az_zones" {
  value       = module.vpc_subnet_basic.az_zones
  description = "A list of the Availability Zones that have been used. This output is of type `string`."
}

