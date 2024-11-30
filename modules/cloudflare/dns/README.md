# Cloudflare DNS Module

This Terraform module manages a zone and multiple records in Cloudflare.
The module also simplifies a few boilerplate records at the apex for security purposes.

<!-- BEGIN_TF_DOCS -->
<!-- END_TF_DOCS -->

# Example Usage

Below is a simple example for an example.com zone with a single subdomain record.

```terraform
module "example_com" {
  source = "github.com/answerdigital/terraform-modules//modules/cloudflare/dns?ref=v4"

  domain = "example.com"
  records = {
    www = {
      name    = "www"
      type    = "A"
      value   = "1.2.3.4"
    }
  }
  spf = [
    "include:_spf.google.com"
  ]
}
```

By default, the module will create the zone as well as the records. If the zone
was created elsewhere, set the `create_zone` flag to `false`.
