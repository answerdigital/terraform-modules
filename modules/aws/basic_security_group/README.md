This provided a basic security group that allows SSH Access as-well as HTTP and HTTPS access

For Client based project where more fine-grained security is required it is _HIGHLY_ recommended to create this yourself
It is recommended to use this as reference.
<!-- BEGIN_TF_DOCS -->


## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_security_group.aws_sg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | The name of the project | `any` | n/a | yes |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | The VPC Id in which this security group will belong | `any` | n/a | yes |
<!-- END_TF_DOCS -->