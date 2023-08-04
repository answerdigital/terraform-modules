# Terraform Acme certificate Module

This Terraform module will register a SSL certificate and return the certificate and key from the providers issuer. Generally [Lets Encrypt](https://letsencrypt.org/).

A alias will also be added to the certificate as a wildcard for the subdomains of the domain submitted.

<!-- BEGIN_TF_DOCS -->
<!-- END_TF_DOCS -->

# Example Usage

Below is an example of how you would call the `acme_certificate` module in your terraform code.

It requires access to Route53 to create the records to allow for DNS Challenge.

The example uses LetsEncrypt as the certificate register.

(Note: It is recommended to use the staging server while testing creation of certificates using LetsEncrypt due to a hard limit of 5 regenerations of a certificate on the production LetsEncrypt server)


```hcl
provider "acme" {
  server_url = "https://acme-v02.api.letsencrypt.org/directory" #"https://acme-staging-v02.api.letsencrypt.org/directory"
}

locals {
  base_domain_name  = "test-project.test.com"
  dns_email_address = "dns@test.com"
  dns_access_key    = "<AWS Access Key>
  dns_secret_key    = "<AWS Secret Key>
  dns_region        = "eu-west-2"
}

data "aws_route53_zone" "test_com" {
  name         = "test.com"
  private_zone = false
}

module "test_project_test_com" {
  source             = "github.com/answerdigital/terraform-modules//modules/aws/acme_certificate?ref=v2"
  email_address      = local.dns_email_address
  aws_hosted_zone_id = data.aws_route53_zone.test_com.zone_id
  base_domain_name   = local.base_domain_name

  aws_access_key = local.dns_access_key
  aws_secret_key = local.dns_secret_key
  aws_region     = local.dns_region
}
```
