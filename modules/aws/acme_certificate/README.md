# Terraform Acme certificate Module

This Terraform module will register a SSL certificate and return the certificate and key from the providers issuer. Generally [Lets Encrypt](https://letsencrypt.org/).

A alias will also be added to the certificate as a wildcard for the subdomains of the domain submitted.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.2 |
| <a name="requirement_acme"></a> [acme](#requirement\_acme) | ~> 2.0 |
| <a name="requirement_tls"></a> [tls](#requirement\_tls) | ~> 4 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_acme"></a> [acme](#provider\_acme) | ~> 2.0 |
| <a name="provider_tls"></a> [tls](#provider\_tls) | ~> 4 |

## Resources

| Name | Type |
|------|------|
| [acme_certificate.this](https://registry.terraform.io/providers/vancluever/acme/latest/docs/resources/certificate) | resource |
| [acme_registration.this](https://registry.terraform.io/providers/vancluever/acme/latest/docs/resources/registration) | resource |
| [tls_private_key.this](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/resources/private_key) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_access_key"></a> [aws\_access\_key](#input\_aws\_access\_key) | AWS access key for the AWS account Route53 is on | `string` | n/a | yes |
| <a name="input_aws_hosted_zone_id"></a> [aws\_hosted\_zone\_id](#input\_aws\_hosted\_zone\_id) | Hosted zone Id of the domain | `string` | n/a | yes |
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | Region for the networking resources. (Defaults to eu-west-2) | `string` | `"eu-west-2"` | no |
| <a name="input_aws_secret_key"></a> [aws\_secret\_key](#input\_aws\_secret\_key) | AWS secret key for the AWS account Route53 is on | `string` | n/a | yes |
| <a name="input_base_domain_name"></a> [base\_domain\_name](#input\_base\_domain\_name) | Common name to create certificate for. Example: test.test.com | `string` | n/a | yes |
| <a name="input_email_address"></a> [email\_address](#input\_email\_address) | Email address to register the Certificate | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_certificate_pem"></a> [certificate\_pem](#output\_certificate\_pem) | The generated public certificate in pem format |
| <a name="output_issuer_pem"></a> [issuer\_pem](#output\_issuer\_pem) | Issuer certificate in pem format |
| <a name="output_private_key_pem"></a> [private\_key\_pem](#output\_private\_key\_pem) | The generated private key in pem format |
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
  dns_access_key    = "<AWS Access Key>"
  dns_secret_key    = "<AWS Secret Key>"
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
