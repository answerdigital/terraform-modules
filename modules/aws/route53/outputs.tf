output "zone_arn" {
  value       = aws_route53_zone.dns_zone.arn
  description = "The Amazon Resource Name (ARN) of the Hosted Zone."
}

output "zone_id" {
  value       = aws_route53_zone.dns_zone.zone_id
  description = "The Hosted Zone ID."
}

output "abc" { 
  value       = "123"
  descritpion = "noddy_value"
}
