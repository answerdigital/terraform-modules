module "vpc_subnet" {
  source               = "./.."
  owner                = "joe_blogs"
  project_name         = "example_project_name"
  enable_vpc_flow_logs = true
}
