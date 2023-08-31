module "vpc_subnet" {
  source               = "../."
  owner                = "joe.blogs@answerdigital.com"
  project_name         = "test_person_name"
  enable_vpc_flow_logs = true
}
