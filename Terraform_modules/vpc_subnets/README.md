# Terraform VPC and Subnets Module

This Terraform module will produce a VPC and public and private subnets in each Availability Zone specified.
If the Availability Zones are not specified the region will be set to the region specified in the provider for 
the Terraform project. A public and private subnet will be created in each Availability Zone of this region.
See image for an example structure when the region in the provider is set to `eu-west-2`.

![Alt text](vpc_subnet_module_diagram.svg?raw=true "VPC Subnet Module Diagram")

# Inputs

**project_name (Compulsory)**

This is used to label the VPC as "`project_name`-vpc".

**owner (Compulsory)**

This is used to identify AWS resources through its tags.


**vpc_cidr (Optional)**

This specifies the CIDR block for the VPC. The default value is `10.0.0.0/16`

**enable_dns_support (Optional)**

This is a boolean and allows AWS DNS support to be switched on or off. This defaults to true and it 
is recommended to leave this as true.  

**enable_dns_hostnames (Optional)**

This is a boolean and allows AWS DNS hostname support to be switched on or off. This defaults to true.  

**azs (Optional)**

This is a list that specifies all the Availability Zones that will have a public and private subnet in it.
Note that if `azs` is specified its length has to be equal to that of `public_subnet_cidrs`and `private_subnet_cidrs`.
The default value is a list of all the Availability Zones in the region you specify when defining the provider 
in your terraform project. 

**num_public_subnets (Optional)**

This is a number specifying how many public subnets you want. Not specifying this will result in `x` public subnets 
where `x` is the number of az zones. If the number specified is greater than the number of Availability Zones (AZs) 
the public subnets will be spread out evenly over the available AZs. The CIDR values used are of the form 
`10.0.{i}.0/24` where `i` starts at 1 and increases by 1 for each public subnet.

**num_private_subnets (Optional)**

This is a number specifying how many public subnets you want. Not specifying this will result in `x` public subnets 
where `x` is the number of az zones. If the number specified is greater than the number of Availability Zones (AZs) 
the public subnets will be spread out evenly over the available AZs. The CIDR values used are of the form 
`10.0.10{i}.0/24` where `i` starts at 1 and increases by 1 for each public subnet.

**ig_cidr (Optional)**

This specifies the CIDR block for the internet gateway. The default value is `0.0.0.0/0` which allows all traffic 
through the gateway.


# Outputs

**vpc_id**

This output references the ID of the VPC.

**az_zones**

This output lists the Availability Zones set up in the vpc. 

**public_subnet_ids**

This output lists the IDs of the public subnets in an array and are in the order of the Availability Zone (AZ) array
(e.g. the first element of `public_subnet_ids` will be located in the region given by the first element of `az_zones`). 
If there are more public subnets than AZs they will be spread out so that the `i`th public subnet is located in the 
`i%j`th availability zone where `j` is the number of AZs and `%` is the modulo operator. 

**private_subnet_ids**

This output lists the IDs of the private subnets in an array and are in the order of the Availability Zone array 
(e.g. the first element of `public_subnet_ids` will be located in the region given by the first element of `az_zones`). 
If there are more private subnets than AZs they will be spread out so that the `i`th public subnet is located in the 
`i%j`th availability zone where `j` is the number of AZs and `%` is the modulo operator. 


# Example Usage

Below is an example of how you would call the `vpc_subnet` module in your terraform code. In this example we show two ways of calling the module; the first is calling it directly from this github repository, the second (which is commented out) is how you would call it if the terraform module file was copied to your local root file. Note that when calling it directly from the github repository you can specify a version by appending the below source reference with `?ref=v1.2.0` for version "1.2.0" (for further information please see https://developer.hashicorp.com/terraform/language/modules/sources#modules-in-package-sub-directories)

<pre><code>module "vpc_subnet_setup" {
  source = "git::https://github.com/AnswerConsulting/AnswerKing-Infrastructure.git//Terraform_modules/vpc_subnets"
  # source = "./Terraform_modules/vpc_subnets"

  project_name = "example_project"
  owner = "answerking-python-team"
  num_public_subnets = 1
  num_private_subnets = 2
}
</code></pre>
