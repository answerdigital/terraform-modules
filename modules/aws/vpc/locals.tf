locals {
  num_az_zones = length(var.azs) == 0 ? length(data.aws_availability_zones.available.names) : length(var.azs)

  az_zones = length(var.azs) == 0 ? data.aws_availability_zones.available.names : var.azs

  aws_region_short = replace(replace(replace(replace(replace(replace(replace(data.aws_region.current.name, "north", "n"), "south", "s"), "east", "e"), "west", "w"), "central", "c"), "gov", "g"), "-", "")

  public_subnet_cidrs = var.num_public_subnets == -1 ? [for i in range(1, local.num_az_zones + 1) : "10.0.${i}.0/24"] : [for i in range(1, var.num_public_subnets + 1) : "10.0.${i}.0/24"]

  private_subnet_cidrs = var.num_private_subnets == -1 ? [for i in range(1, local.num_az_zones + 1) : "10.0.10${i}.0/24"] : [for i in range(1, var.num_private_subnets + 1) : "10.0.10${i}.0/24"]
}
