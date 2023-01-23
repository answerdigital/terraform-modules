locals {
  num_az_zones = "${length(var.azs) == 0 ?
                  length(data.aws_availability_zones.available.names) :
                  length(var.azs)
                  }"
  az_zones     = "${length(var.azs) == 0 ?
                  data.aws_availability_zones.available.names :
                  var.azs
                  }"
}

locals {
  public_subnet_cidrs = "${length(var.public_subnet_cidrs) == 0 ?
                         [for i in range(1,local.num_az_zones+1): "10.0.${i}.0/24"] :
                         var.public_subnet_cidrs
                         }"

  private_subnet_cidrs = "${length(var.private_subnet_cidrs) == 0 ?
                         [for i in range(1,local.num_az_zones+1): "10.0.10${i}.0/24"] :
                         var.private_subnet_cidrs
                         }"
}