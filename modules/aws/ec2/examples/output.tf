output "ip" {
  value = module.ec2_instance_setup.instance_public_ip_address
}

output "generated_private_key" {
  value     = module.ec2_instance_setup.private_key
  sensitive = true
}
