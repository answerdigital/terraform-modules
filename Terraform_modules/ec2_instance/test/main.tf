module "ec2_instance_setup" {
  source                 = "../../ec2_instance"
  project_name           = "SingleWord"
  owner                  = "Test Owner"
  ami_id                 = 1
  availability_zone      = "eu-west-2"
  subnet_id              = 1
  vpc_security_group_ids = []
  needs_elastic_ip       = true
}
