output "ip" {
  value = module.ec2_instance_setup.instance_public_ip_address
}

output "private_key" {
  value     = module.ec2_instance_setup.private_key
  sensitive = true
}
