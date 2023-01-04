output "vpc_id" {
  value = aws_vpc.module_vpc.id
}

output "public_subnet_ids" {
    value =  aws_subnet.public_subnets[*].id
}

output "private_subnet_ids" {
    value =  aws_subnet.private_subnets[*].id
}

output "az_zones" {
    value = var.azs
}