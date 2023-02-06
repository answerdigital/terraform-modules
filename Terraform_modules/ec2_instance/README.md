# Terraform EC2 instance Module

This Terraform module will produce an EC2 instance which can be accessed via ssh or session manager via the aws management console. It also allows the possibility
 of an elastic ip being associated with the EC2 instance.

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.3 |
| <a name="requirement_tls"></a> [tls](#requirement\_tls) | >= 4.0.4 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |
| <a name="provider_tls"></a> [tls](#provider\_tls) | >= 4.0.4 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_eip.public_elastic_ip](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip) | resource |
| [aws_iam_instance_profile.instance_profile](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_instance_profile) | resource |
| [aws_iam_role.instance_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.instance_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_instance.ec2](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance) | resource |
| [aws_key_pair.key_pair](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/key_pair) | resource |
| [tls_private_key.private_key](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/resources/private_key) | resource |

## Inputs

| Name | Description                                                                                                                                                                                   | Type | Default | Required |
|------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|------|---------|:--------:|
| <a name="input_ami_id"></a> [ami\_id](#input\_ami\_id) | This is the id of the ami image used for the ec2 instance.                                                                                                                                    | `string` | n/a | yes |
| <a name="input_associate_public_ip_address"></a> [associate\_public\_ip\_address](#input\_associate\_public\_ip\_address) | This is a boolean value indicating if a public IP address should be associated with the EC2 instance.                                                                                         | `bool` | `true` | no |
| <a name="input_availability_zone"></a> [availability\_zone](#input\_availability\_zone) | This is the availability zone you want the ec2 instance to be created in.                                                                                                                     | `string` | n/a | yes |
| <a name="input_ec2_instance_type"></a> [ec2\_instance\_type](#input\_ec2\_instance\_type) | This is the type of EC2 instance you want.                                                                                                                                                    | `string` | `"t2.micro"` | no |
| <a name="input_needs_elastic_ip"></a> [needs\_elastic\_ip](#input\_needs\_elastic\_ip) | This is a boolean value inidcating whether an elastic IP should be generated and associated with the EC2 instance.                                                                            | `bool` | `false` | no |
| <a name="input_owner"></a> [owner](#input\_owner) | This is used to specify the owner of the resources in this module.                                                                                                                            | `string` | n/a | yes |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | This is used to label the resources of the module.                                                                                                                                            | `string` | n/a | yes |
| <a name="input_subnet_id"></a> [subnet\_id](#input\_subnet\_id) | This is the id of the subnet you want the ec2 instance to be created in.                                                                                                                      | `string` | n/a | yes |
| <a name="input_user_data"></a> [user\_data](#input\_user\_data) | This allows bash scripts and command line commands to be specified and run in the EC2 instance when launched. Do not pass gzip-compressed data via this argument.                             | `string` | `""` | no |
| <a name="input_user_data_replace_on_change"></a> [user\_data\_replace\_on\_change](#input\_user\_data\_replace\_on\_change) | This value indicates whether changes to the `user_data` value triggers a rebuild of the EC2 instance.                                                                                         | `bool` | `true` | no |
| <a name="input_vpc_security_group_ids"></a> [vpc\_security\_group\_ids](#input\_vpc\_security\_group\_ids) | This is a list of ids that specify the security groups you want your EC2 to be in. If you do not wish to specify a security group for your module then please set this value to an empty list | `list(string)` | n/a | yes |

## Outputs

| Name | Description | type |
|------|-------------|------|
| <a name="output_instance_public_ip_address"></a> [instance\_public\_ip\_address](#output\_instance\_public\_ip\_address) | This outputs the public IP associated with the EC2 instance. Note that this ouput will be the same as the elastic IP if `needs_elastic_ip` is set to `true`. | string |



# Example Usage

Below is an example of how you would call the `ec2_instance` module in your terraform code. Note that when calling it directly from the github repository you can specify a version by appending the below source reference with `?ref=v1.2.0` for version "1.2.0" 
(for further information please see [here](https://developer.hashicorp.com/terraform/language/modules/sources#modules-in-package-sub-directories)). Here we also give an example of a bash script used to install docker on `Amazon linux`, then create a 
.env file on the instance and finally run a chosen docker image with the .env file. 

<pre><code>module "ec2_instance_setup" {
  source                 = "git::https://github.com/AnswerConsulting/AnswerKing-Infrastructure.git//Terraform_modules/ec2_instance?ref=v1.0.0"
  project_name           = var.project_name
  owner                  = var.owner
  ami_id                 = var.ami_id
  availability_zone      = var.az_zones[0]
  subnet_id              = module.vpc_subnet_setup.public_subnet_ids[0]
  vpc_security_group_ids = [aws_security_group.ec2_security_group.id]
  needs_elastic_ip       = true
  
  user_data              = <<-EOF
  #!/bin/bash -xe
  #logs all user_data commands into a user-data.log file
  exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1

  sudo yum update -y
  sudo yum upgrade -y
  sudo yum install docker -y
  sudo systemctl enable docker.service
  sudo systemctl start docker.service

  sudo cat << EOL > /usr/.env
  DATABASE_NAME=${var.database_name}
  DATABASE_HOST=${module.rds_cluster_setup.rds_serverless_endpoint}
  DATABASE_PORT=${module.rds_cluster_setup.rds_serverless_port}
  DATABASE_USER=${module.rds_cluster_setup.rds_serverless_master_username}
  DATABASE_PASS=${module.rds_cluster_setup.rds_serverless_master_password}
  DATABASE_ENGINE=django.db.backends.mysql
  EOL

  sudo docker run -p 80:8000 --env-file /usr/.env ${var.docker_image_ref}

 EOF
}
</code></pre>
