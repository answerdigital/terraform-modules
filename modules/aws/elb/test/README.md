<!-- BEGIN_TF_DOCS -->


## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_ec2_instance_setup"></a> [ec2\_instance\_setup](#module\_ec2\_instance\_setup) | ../../ec2 | n/a |
| <a name="module_elb"></a> [elb](#module\_elb) | ../. | n/a |
| <a name="module_vpc_subnet"></a> [vpc\_subnet](#module\_vpc\_subnet) | ../../vpc | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_ami.ec2_ami](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami) | data source |
| [aws_availability_zones.available](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/availability_zones) | data source |
<!-- END_TF_DOCS -->