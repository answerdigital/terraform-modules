resource "tls_private_key" "this" {
  algorithm = "RSA"
}

resource "acme_registration" "this" {
  account_key_pem = tls_private_key.this.private_key_pem
  email_address   = var.email_address
}

resource "acme_certificate" "this" {
  account_key_pem           = acme_registration.this.account_key_pem
  common_name               = var.base_domain_name
  subject_alternative_names = ["*.${var.base_domain_name}"]

  dns_challenge {
    provider = "route53"

    config = {
      AWS_HOSTED_ZONE_ID    = var.aws_hosted_zone_id
      AWS_ACCESS_KEY_ID     = var.aws_access_key
      AWS_SECRET_ACCESS_KEY = var.aws_secret_key
      AWS_DEFAULT_REGION    = var.aws_region
      AWS_SESSION_TOKEN     = ""
    }
  }

  depends_on = [acme_registration.this]
}
