output "certificate_pem" {
  value       = lookup(acme_certificate.this, "certificate_pem")
  description = "The generated public certificate in pem format"
  sensitive   = false
}

output "issuer_pem" {
  value       = lookup(acme_certificate.this, "issuer_pem")
  description = "Issuer certificate in pem format"
  sensitive   = false
}

output "private_key_pem" {
  value       = lookup(acme_certificate.this, "private_key_pem")
  description = "The generated private key in pem format"
  sensitive   = true
}
