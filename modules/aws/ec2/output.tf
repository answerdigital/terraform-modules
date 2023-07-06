output "instance_public_ip_address" {
  value       = aws_eip.public_elastic_ip[0].public_ip
  description = "This outputs the public IP associated with the EC2 instance. Note that this output will be the same as the elastic IP if `needs_elastic_ip` is set to `true`. This output is of type `string`."
}

output "instance_id" {
  value       = aws_instance.ec2.id
  description = "This outputs the unique ID of the EC2 instance."
}

output "private_key" {
  value       = tls_private_key.private_key.private_key_pem
  description = "This outputs the private key."
  sensitive   = true
}
