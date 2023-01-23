output "instance_public_ip_address" {
  value = aws_instance.ec2.public_ip
}
