# Terraform Route53 Module

This Terraform module manages a zone and multiple records in Route53.
The module also simplifies a few boilerplate records at the apex for security purposes.

<!-- BEGIN_TF_DOCS -->
<!-- END_TF_DOCS -->

# Example Usage

Below is a simple example for an example.com zone with a single subdomain record.

```terraform
module "example_com" {
  source = "github.com/answerdigital/terraform-modules//modules/aws/route53?ref=v2.0.0"

  domain = "example.com"
  records = {
    www = {
      name    = "www"
      type    = "A"
      records = ["1.2.3.4"]
    }
  }
  spf = [
    "include:_spf.google.com"
  ]
}
```
