output "instance_public_ip_address" {
  value       = aws_instance.ec2.public_ip
  description = "This outputs the public IP associated with the EC2 instance. Note that this ouput will be the same as the elastic IP if `needs_elastic_ip` is set to `true`. This output is of type `string`."
}
