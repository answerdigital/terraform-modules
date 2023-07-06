<!-- BEGIN_TF_DOCS -->


## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_ec2_instance_setup"></a> [ec2\_instance\_setup](#module\_ec2\_instance\_setup) | ../. | n/a |
| <a name="module_vpc_subnet"></a> [vpc\_subnet](#module\_vpc\_subnet) | ../../vpc | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_security_group.aws_sg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_ami.ec2_ami](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami) | data source |
| [aws_availability_zones.available](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/availability_zones) | data source |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_generated_private_key"></a> [generated\_private\_key](#output\_generated\_private\_key) | n/a |
| <a name="output_ip"></a> [ip](#output\_ip) | n/a |
<!-- END_TF_DOCS -->