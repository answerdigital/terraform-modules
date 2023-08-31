output "vpc_id" {
  value       = aws_vpc.this.id
  description = "The ID of the VPC that has been created. This output is of type `string`."
}

output "public_subnet_ids" {
  value       = aws_subnet.public[*].id
  description = "A list of the public subnet IDs that have been created. This output is of type `list(string)`."
}

output "private_subnet_ids" {
  value       = aws_subnet.private[*].id
  description = "A list of the private subnet IDs that have been created. This output is of type `list(string)`."
}

output "az_zones" {
  value       = local.az_zones
  description = "A list of the Availability Zones that have been used. This output is of type `list(string)`."
}
