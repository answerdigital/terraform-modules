# Terraform VPC and Subnets Module

This Terraform module will produce a VPC and public and private subnets in each Availability Zone specified.
If the Availability Zones are not specified the region will be set to the region specified in the provider for
the Terraform project. A public and private subnet will be created in each Availability Zone of this region.
See image for an example structure when the region in the provider is set to `eu-west-2`.

![VPC Subnet Module Diagram](vpc_subnet_module_diagram.svg?raw=true "VPC Subnet Module Diagram")

The option `enable_vpc_flow_logs` must be selected to decide whether you want to include Cloudwatch logging of your VPC
traffic, this is good from an auditing perspective, however you will be charged for the required Cloudwatch storage.


<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.3 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | >= 3.4.3 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 4.0 |
| <a name="provider_random"></a> [random](#provider\_random) | >= 3.4.3 |

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_log_group.log_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_flow_log.flow_log](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/flow_log) | resource |
| [aws_iam_role.iam_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.iam_role_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_internet_gateway.ig](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/internet_gateway) | resource |
| [aws_route_table.route_table](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table_association.public_subnet_rt_asso](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_subnet.private_subnets](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_subnet.public_subnets](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_vpc.vpc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc) | resource |
| [random_uuid.log_group_guid_identifier](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/uuid) | resource |
| [aws_availability_zones.available](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/availability_zones) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_azs"></a> [azs](#input\_azs) | This is a list that specifies all the Availability Zones that will have public and private subnets in it. Defaulting this value to an empty list selects of all the Availability Zones in the region you specify when defining the provider in your terraform project. | `list(string)` | `[]` | no |
| <a name="input_enable_dns_hostnames"></a> [enable\_dns\_hostnames](#input\_enable\_dns\_hostnames) | This allows AWS DNS hostname support to be switched on or off. | `bool` | `true` | no |
| <a name="input_enable_dns_support"></a> [enable\_dns\_support](#input\_enable\_dns\_support) | This allows AWS DNS support to be switched on or off. | `bool` | `true` | no |
| <a name="input_enable_vpc_flow_logs"></a> [enable\_vpc\_flow\_logs](#input\_enable\_vpc\_flow\_logs) | Whether to enable VPC Flow Logs for this VPC, this has cost but is considered a security risk without | `bool` | n/a | yes |
| <a name="input_ig_cidr"></a> [ig\_cidr](#input\_ig\_cidr) | This specifies the CIDR block for the internet gateway. | `string` | `"0.0.0.0/0"` | no |
| <a name="input_ig_ipv6_cidr"></a> [ig\_ipv6\_cidr](#input\_ig\_ipv6\_cidr) | This specifies the IPV6 CIDR block for the internet gateway. | `string` | `"::/0"` | no |
| <a name="input_num_private_subnets"></a> [num\_private\_subnets](#input\_num\_private\_subnets) | This is a number specifying how many private subnets you want. Setting this to its default value of `-1` will result in `x` private subnets where `x` is the number of Availability Zones. If the number of private subnets is greater than the number of Availability Zones the private subnets will be spread out evenly over the available AZs. The CIDR values used are of the form `10.0.{i}.0/24` where `i` starts at 101 and increases by 1 for each private subnet. | `number` | `-1` | no |
| <a name="input_num_public_subnets"></a> [num\_public\_subnets](#input\_num\_public\_subnets) | This is a number specifying how many public subnets you want. Setting this to its default value of `-1` will result in `x` public subnets where `x` is the number of Availability Zones. If the number of public subnets is greater than the number of Availability Zones the public subnets will be spread out evenly over the available AZs. The CIDR values used are of the form `10.0.{i}.0/24` where `i` starts at 1 and increases by 1 for each public subnet. | `number` | `-1` | no |
| <a name="input_owner"></a> [owner](#input\_owner) | This is used to identify AWS resources through its tags. | `string` | n/a | yes |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | This is used to label the VPC as "`project_name`-vpc". | `string` | n/a | yes |
| <a name="input_vpc_cidr"></a> [vpc\_cidr](#input\_vpc\_cidr) | This specifies the CIDR block for the VPC. | `string` | `"10.0.0.0/16"` | no |
| <a name="input_vpc_flow_logs_traffic_type"></a> [vpc\_flow\_logs\_traffic\_type](#input\_vpc\_flow\_logs\_traffic\_type) | The Type of traffic to log, Requires vpc\_flow\_logs to be true | `string` | `"ALL"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_az_zones"></a> [az\_zones](#output\_az\_zones) | A list of the Availability Zones that have been used. This output is of type `string`. |
| <a name="output_private_subnet_ids"></a> [private\_subnet\_ids](#output\_private\_subnet\_ids) | A list of the private subnet IDs that have been created. This output is of type `list(string)`. |
| <a name="output_public_subnet_ids"></a> [public\_subnet\_ids](#output\_public\_subnet\_ids) | A list of the public subnet IDs that have been created. This output is of type `list(string)`. |
| <a name="output_vpc_id"></a> [vpc\_id](#output\_vpc\_id) | The ID of the VPC that has been created. This output is of type `list(string)`. |
<!-- END_TF_DOCS -->

# Example Usage

Below are examples of how you would call the `vpc` module in your terraform code.

In this example we show two ways the module can be used;
the first uses the module to create a public and private subnet on each Availability Zone in your defined region,
the second uses the module to create 1 public subnet in the AZ `eu-west-1` and 2 private subnets in `eu-west-1`
and `eu-west-3` respectively.

```hcl
module "vpc_subnet" {
  source               = "github.com/answerdigital/terraform-modules//modules/aws/vpc?ref=v4"
  owner                = "joe_blogs"
  project_name         = "example_project_name"
  enable_vpc_flow_logs = true
}

module "vpc_subnet" {
  source                     = "github.com/answerdigital/terraform-modules//modules/aws/vpc?ref=v4"
  owner                      = "joe_blogs"
  project_name               = "example_project_name"
  azs                        = ["eu-west-1", "eu-west-3"]
  num_public_subnets         = 1
  num_private_subnets        = 2
  enable_vpc_flow_logs       = true
  vpc_flow_logs_traffic_type = "ALL"
  enable_dns_support         = true
  enable_dns_hostnames       = true
}
```
