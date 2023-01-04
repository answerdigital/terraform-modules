# Terraform VPC and Subnets Module

This Terraform module will produce a VPC in the region `eu-west-2`. Six 
subnets will be created within this VPC, three being Public Subnets and three
being Private subnets. The Public and Private Subnets will be paired up and 
placed in the three Availability Zones of `eu-west-2`.

Note that no route tables are defined (so the subnets are not technically public or private)
and this will need to be done outside of this Terraform module.

# Outputs

## vpc_id
This output references the ID of the VPC.

## az_zones
This output lists the Availability Zones set up in the vpc. 

## public_subnet_ids
This output lists the IDs of the public subnets in an array and are in the order of the Availability Zone array
(e.g. the first element of `public_subnet_ids` will be located in the region given by the first element of `az_zones`).

## private_subnet_ids
This output lists the IDs of the private subnets in an array and are in the order of the Availability Zone array 
(e.g. the first element of `public_subnet_ids` will be located in the region given by the first element of `az_zones`).
