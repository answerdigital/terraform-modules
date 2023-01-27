# Terraform EC2 instance Module

This Terraform module will produce an EC2 instance which can be accessed via ssh or session manager via the aws management console. It also allows the posibility
 of an elastic ip being associated with the EC2 instance.

# Inputs

**project_name (Manadatory)**

This is used to label the resources of the module.

**owner (Mandatory)**

This is used to specify the owner of the resources in this module.

**ami_id (Mandatory)**

This is the id of the ami image used for the ec2 instance.

**availability_zone (Mandatory)**

This is the avaliability zone you want the ec2 instance to be created in.

**subnet_id (Mandatory)**

This is the subnet id you want the ec2 instance to be created in.

**vpc_security_group_ids (Mandatory)**

This is a list of ids that specifies the security groups you want your EC2 to be in. If you do not wish to specify a security group for your module then please set 
this value to an empty list.

**ec2_instance_type (Optional)**

This is the type of EC2 instane you want (e.g. "t2.micro", "m5.large" etc.). The default value for this is "t2.micro" as this is the free tier instance.

**associate_public_ip_address (Optional)**

This is a boolean value indicating if a public IP address should be associated with the EC2 instance. The default value is `true`.

**user_data (Optional)**

This allows bash scripts and command line commands to be specified and run in the EC2 instance when launched. Do not pass gzip-compressed data via this argument.

**needs_elastic_ip (Optional)**

This is a boolean value inidcating whether an elastic IP should be generated and associated with the EC2 instance. The default value is `false`.

**user_data_replace_on_change (Optional)**

This vaule indicates whether changes to the `user_data` value triggers a rebuild of the EC2 instance. The default value is `true`.


# Outputs

**instance_public_ip_address**

This outputs the public IP associated with the EC2 instance. Note that this ouput will be the same as the elastic IP if `needs_elastic_ip` is set to `true`.

# Example Usage

Below is an example of how you would call the `ec2_instance` module in your terraform code. In this example we show two ways of calling the module; the first is calling 
it directly from this github repository, the second (which is commented out) is how you would call it if the terraform module file was copied to your local root file. 
Note that when calling it directly from the github repository you can specify a version by appending the below source reference with `?ref=v1.2.0` for version "1.2.0" 
(for further information please see [here](https://developer.hashicorp.com/terraform/language/modules/sources#modules-in-package-sub-directories))

<pre><code>module "ec2_instance_setup" {
  source                 = "git::https://github.com/AnswerConsulting/AnswerKing-Infrastructure.git//Terraform_modules/ec2_instance"
  # source               = "./Terraform_modules/ec2_instance"
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
