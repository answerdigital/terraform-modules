module "vpc_subnet_basic" {
  source               = "./.."
  owner                = "joe_blogs"
  project_name         = "example_vpc_with_logs"
  enable_vpc_flow_logs = true
}

module "vpc_subnet_no_vpc_logs" {
  source               = "./.."
  owner                = "joe_blogs"
  project_name         = "example_vpc_no_logs"
  enable_vpc_flow_logs = false
}