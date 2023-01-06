# Terraform VPC and Subnets Module

This Terraform module will produce a VPC and public and private subnets in each Availability Zone specified.
if the Availability Zones are not specified the region will be set to the region specified in the provider for 
the Terraform project. A public and private subnet will be created in each Availability Zone of this region.

Note that no route tables are defined (so the subnets are not technically public or private)
and this will need to be done outside of this Terraform module.

# Inputs

**project_name**

This is used to label the VPC as "`project_name`-vpc"

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

**public_subnets (Optional)**

This is a boolean to indicate if you want public subnets. The default value is true.

**private_subnets (Optional)**

This is a boolean to indicate if you want private subnets. The default value is true.

**public_subnet_cidrs (Optional)**

This is a list that specifies the CIDR values for the public subnets. The order follows the list of Availability 
Zones specified by azs such that the first CIDR block value will be allocated to the public subnet located in the 
Availability Zone given by az[0].Note that if `public_subnet_cidrs` is specified its length has to be equal to that
of `azs`.The default values are a list of `10.0.{i}.0/24` where `i` starts at 1 and increases by 1 for each 
Availability Zone.

**private_subnet_cidrs (Optional)**

This is a list that specifies the CIDR values for the private subnets. The order follows the list of Availability 
Zones specified by azssuch that the first CIDR block value will be allocated to the private subnet located in the 
Availability Zone given by az[0].Note that if `private_subnet_cidrs` is specified its length has to be equal to 
that of `azs`.The default values are a list of `10.0.10{i}.0/24` where `i` starts at 1 and increases by 1 for each
Availability Zone.

**ig_cidr (Optional)**

This specifies the CIDR block for the internet gateway. The default value is `0.0.0.0/0` which allows all traffic 
through the gateway.


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
