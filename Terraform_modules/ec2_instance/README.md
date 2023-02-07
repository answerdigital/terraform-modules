# Terraform EC2 instance Module

This Terraform module will produce an EC2 instance which can be accessed via ssh or session manager via the aws management console. It also allows the possibility
of an elastic ip being associated with the EC2 instance.

<!-- BEGIN_TF_DOCS -->

<!-- END_TF_DOCS -->

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
