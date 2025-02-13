# Cloudflare DNS Module

This Terraform module manages a zone and multiple records in Cloudflare.
The module also simplifies a few boilerplate records at the apex for security purposes.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.3 |
| <a name="requirement_cloudflare"></a> [cloudflare](#requirement\_cloudflare) | >= 5.1.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_cloudflare"></a> [cloudflare](#provider\_cloudflare) | >= 5.1.0 |

## Resources

| Name | Type |
|------|------|
| [cloudflare_dns_record.apex_txt](https://registry.terraform.io/providers/cloudflare/cloudflare/latest/docs/resources/dns_record) | resource |
| [cloudflare_dns_record.caa](https://registry.terraform.io/providers/cloudflare/cloudflare/latest/docs/resources/dns_record) | resource |
| [cloudflare_dns_record.dns](https://registry.terraform.io/providers/cloudflare/cloudflare/latest/docs/resources/dns_record) | resource |
| [cloudflare_zone.dns](https://registry.terraform.io/providers/cloudflare/cloudflare/latest/docs/resources/zone) | resource |
| [cloudflare_zones.lookup](https://registry.terraform.io/providers/cloudflare/cloudflare/latest/docs/data-sources/zones) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_account_id"></a> [account\_id](#input\_account\_id) | The ID of the Cloudflare account. | `string` | n/a | yes |
| <a name="input_apex_txt"></a> [apex\_txt](#input\_apex\_txt) | List of TXT records to be added at the apex. | `list(string)` | `[]` | no |
| <a name="input_caa_issuers"></a> [caa\_issuers](#input\_caa\_issuers) | List of CAs that can issue certificates. | `list(string)` | <pre>[<br/>  "letsencrypt.org"<br/>]</pre> | no |
| <a name="input_create_zone"></a> [create\_zone](#input\_create\_zone) | Whether to create the zone. Defaults to `true`. | `bool` | `true` | no |
| <a name="input_default_ttl"></a> [default\_ttl](#input\_default\_ttl) | Default TTL for DNS records. Defaults to 1, which means “automatic”. | `number` | `1` | no |
| <a name="input_domain"></a> [domain](#input\_domain) | The top-level domain name to hold the records. | `string` | n/a | yes |
| <a name="input_records"></a> [records](#input\_records) | List of DNS records for the domain.<br/><br/>    • `name`     - (Optional) The name of the record. Defaults to "@" (i.e. an apex record).<br/>    • `ttl`      - (Optional) The TTL of the record. Defaults to `default_ttl`.<br/>    • `type`     - (Required) The record type.<br/>    • `content`  - (Required) The content of the record.<br/>    • `priority` - (Optional) The priority of the record.<br/>    • `proxied`  - (Optional) Whether to use Cloudflare’s origin protection. Defaults to `false`. | <pre>map(object({<br/>    name     = optional(string, "@")<br/>    ttl      = optional(number)<br/>    type     = string<br/>    content  = string<br/>    priority = optional(number)<br/>    proxied  = optional(bool, false)<br/>  }))</pre> | n/a | yes |
| <a name="input_security_contact"></a> [security\_contact](#input\_security\_contact) | Security contact for the domain. Defaults to 'security@DOMAIN', where `DOMAIN` is the top-level domain name. | `string` | `null` | no |
| <a name="input_spf"></a> [spf](#input\_spf) | List of SPF directives for the domain. | `list(string)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_zone_id"></a> [zone\_id](#output\_zone\_id) | The Zone ID. |
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
