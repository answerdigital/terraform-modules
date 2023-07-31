<!-- BEGIN_TF_DOCS -->


## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_rds_cluster_setup"></a> [rds\_cluster\_setup](#module\_rds\_cluster\_setup) | ../. | n/a |
| <a name="module_vpc_subnet"></a> [vpc\_subnet](#module\_vpc\_subnet) | ../../vpc | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_security_group.aws_sg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_rds_engine_version.test](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/rds_engine_version) | data source |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_rds_cluster_instance_db_name"></a> [rds\_cluster\_instance\_db\_name](#output\_rds\_cluster\_instance\_db\_name) | n/a |
| <a name="output_rds_cluster_instance_endpoint"></a> [rds\_cluster\_instance\_endpoint](#output\_rds\_cluster\_instance\_endpoint) | n/a |
| <a name="output_rds_cluster_instance_port"></a> [rds\_cluster\_instance\_port](#output\_rds\_cluster\_instance\_port) | n/a |
| <a name="output_rds_cluster_master_password"></a> [rds\_cluster\_master\_password](#output\_rds\_cluster\_master\_password) | n/a |
| <a name="output_rds_cluster_master_username"></a> [rds\_cluster\_master\_username](#output\_rds\_cluster\_master\_username) | n/a |
| <a name="output_rds_cluster_replica_instance_endpoints"></a> [rds\_cluster\_replica\_instance\_endpoints](#output\_rds\_cluster\_replica\_instance\_endpoints) | n/a |
| <a name="output_rds_cluster_replica_instance_ports"></a> [rds\_cluster\_replica\_instance\_ports](#output\_rds\_cluster\_replica\_instance\_ports) | n/a |
<!-- END_TF_DOCS -->