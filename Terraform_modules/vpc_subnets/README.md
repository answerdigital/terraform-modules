# Terraform VPC and Subnets Module

This Terraform module will produce a VPC and public and private subnets in each Availability Zone specified.
If the Availability Zones are not specified the region will be set to the region specified in the provider for
the Terraform project. A public and private subnet will be created in each Availability Zone of this region.
See image for an example structure when the region in the provider is set to `eu-west-2`.

![VPC Subnet Module Diagram](vpc_subnet_module_diagram.svg?raw=true "VPC Subnet Module Diagram")

<!-- BEGIN_TF_DOCS -->

<!-- END_TF_DOCS -->

# Example Usage

Below are examples of how you would call the `vpc_subnet` module in your terraform code.
In this example we show two ways the module can be used;
the first uses the module to create a public and private subnet on each Availability Zone in your defined region,
the second uses the module to create 1 public subnet in the AZ `eu-west-1` and 2 private subnets in `eu-west-1`
and `eu-west-3` respectively. Note that when calling the module directly from the github
repository you can specify a version by appending the below source reference with
`?ref=v1.2.0` for version "1.2.0" (for further information please see
[here](https://developer.hashicorp.com/terraform/language/modules/sources#modules-in-package-sub-directories))

```hcl
module "vpc_subnet" {
  source       = "git::https://github.com/AnswerConsulting/AnswerKing-Infrastructure.git//Terraform_modules/vpc_subnets?ref=v1.0.0"
  owner        = "joe_blogs"
  project_name = "example_project_name"
}

module "vpc_subnet" {
  source              = "git::https://github.com/AnswerConsulting/AnswerKing-Infrastructure.git//Terraform_modules/vpc_subnets?ref=v1.0.0"
  owner               = "joe_blogs"
  project_name        = "example_project_name"
  azs                 = ["eu-west-1", "eu-west-3"]
  num_public_subnets  = 1
  num_private_subnets = 2
}
```
