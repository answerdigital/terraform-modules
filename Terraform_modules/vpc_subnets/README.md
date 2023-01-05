# Terraform VPC and Subnets Module

This Terraform module will produce a VPC in the region `eu-west-2`. Six 
subnets will be created within this VPC, three being Public Subnets and three
being Private subnets. The Public and Private Subnets will be paired up and 
placed in the three Availability Zones of `eu-west-2`.

Note that no route tables are defined (so the subnets are not technically public or private)
and this will need to be done outside of this Terraform module.

# Inputs

**project_name**

This is used to label the VPC as "`project_name`-vpc"

**vpc_cdr (Optional)**

This specifies the CIDR block for the VPC. The default value is `10.0.0.0/16`

**azs (Optional)**

This is a list that specifies all the Availability Zones that will have a public and private subnet in it.
The default value is `["eu-west-2a", "eu-west-2b", "eu-west-2c"]`. Note that the length of `azs` has to be equal to that of `public_subnet_cidrs`
and `private_subnet_cidrs`.

**public_subnet_cidrs (Optional)**

This is a list that specifies the CIDR values for the public subnets. The order follows the list of Availability Zones specified by azs
such that the first CIDR block value will be allocated to the public subnet located in the Availability Zone given by az[0].
The default value is `["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]`.

**private_subnet_cidrs (Optional)**

This is a list that specifies the CIDR values for the private subnets. The order follows the list of Availability Zones specified by azs
such that the first CIDR block value will be allocated to the private subnet located in the Availability Zone given by az[0].
The default value is `["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]`.

# Outputs

**vpc_id**

This output references the ID of the VPC.

**az_zones**

This output lists the Availability Zones set up in the vpc. 

**public_subnet_ids**

This output lists the IDs of the public subnets in an array and are in the order of the Availability Zone array
(e.g. the first element of `public_subnet_ids` will be located in the region given by the first element of `az_zones`).

**private_subnet_ids**

This output lists the IDs of the private subnets in an array and are in the order of the Availability Zone array 
(e.g. the first element of `public_subnet_ids` will be located in the region given by the first element of `az_zones`).
