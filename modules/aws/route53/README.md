# Terraform Route53 Module

This Terraform module manages a zone and multiple records in Route53.
The module also simplifies a few boilerplate records at the apex for security purposes.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 4.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 4.0 |

## Resources

| Name | Type |
|------|------|
| [aws_route53_record.apex_txt](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_route53_record.caa](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_route53_record.dns_record](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_route53_record.name_servers](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_route53_zone.dns_zone](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_zone) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_apex_txt"></a> [apex\_txt](#input\_apex\_txt) | List of TXT records to be added at the apex. | `list(string)` | `[]` | no |
| <a name="input_caa_issuers"></a> [caa\_issuers](#input\_caa\_issuers) | List of CAs that can issue certificates. | `list(string)` | <pre>[<br>  "amazontrust.com",<br>  "awstrust.com",<br>  "amazonaws.com",<br>  "amazon.com"<br>]</pre> | no |
| <a name="input_comment"></a> [comment](#input\_comment) | A comment for the hosted zone. Defaults to 'Managed by Terraform'. | `string` | `null` | no |
| <a name="input_default_ttl"></a> [default\_ttl](#input\_default\_ttl) | Default TTL for DNS records. | `number` | `86400` | no |
| <a name="input_domain"></a> [domain](#input\_domain) | The top-level domain name to hold the records. | `string` | n/a | yes |
| <a name="input_records"></a> [records](#input\_records) | List of DNS records for the domain.<br><br>    • `name`    - (Optional) The name of the record. Defaults to the domain (i.e. an apex record).<br>    • `ttl`     - (Optional) The TTL of the record. Defaults to `default_ttl`.<br>    • `type`    - (Required) The record type.<br>    • `records` - (Required) A string list of records. | <pre>map(object({<br>    name    = optional(string)<br>    ttl     = optional(string)<br>    type    = string<br>    records = list(string)<br>  }))</pre> | n/a | yes |
| <a name="input_security_contact"></a> [security\_contact](#input\_security\_contact) | Security contact for the domain. Defaults to 'security@DOMAIN', where `DOMAIN` is the top-level domain name. | `string` | `null` | no |
| <a name="input_spf"></a> [spf](#input\_spf) | List of SPF directives for the domain. | `list(string)` | `[]` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags for the hosted zone. | `map(any)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_zone_arn"></a> [zone\_arn](#output\_zone\_arn) | The Amazon Resource Name (ARN) of the Hosted Zone. |
| <a name="output_zone_id"></a> [zone\_id](#output\_zone\_id) | The Hosted Zone ID. |
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
