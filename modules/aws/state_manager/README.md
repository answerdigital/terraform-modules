## Terraform State Management Bucket

This Terraform module will produce a State Management bucket that will allow you to store and manage the Terraform state for a specific project on a remote environment instead of locally.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.3 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 5.0 |

## Resources

| Name | Type |
|------|------|
| [aws_dynamodb_table.project_tf_locks](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/dynamodb_table) | resource |
| [aws_s3_bucket.project_terraform_state](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket.project_terraform_state_log_bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_logging.project_terraform_state_logging](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_logging) | resource |
| [aws_s3_bucket_public_access_block.project_s3_public_access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_public_access_block) | resource |
| [aws_s3_bucket_server_side_encryption_configuration.project_s3_encryption](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_server_side_encryption_configuration) | resource |
| [aws_s3_bucket_versioning.project_versioning](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_versioning) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_create_logging_bucket"></a> [create\_logging\_bucket](#input\_create\_logging\_bucket) | Provide this if you want an access log for the Terraform State Bucket | `bool` | `true` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | This is used to label the components of the session storage with the AWS environment the bucket is hosted on | `string` | `"dev"` | no |
| <a name="input_owner"></a> [owner](#input\_owner) | This is used to specify the owner of the resources in this module. | `string` | n/a | yes |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | This is used to label the components of the session storage | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_state_bucket_dynamodb_table"></a> [state\_bucket\_dynamodb\_table](#output\_state\_bucket\_dynamodb\_table) | The name of dyanamo-db table to store the terraform lock file in |
| <a name="output_state_bucket_filename"></a> [state\_bucket\_filename](#output\_state\_bucket\_filename) | The name of the filename to save the tfstate against |
| <a name="output_state_bucket_name"></a> [state\_bucket\_name](#output\_state\_bucket\_name) | The name of the bucket created to store the state against |
<!-- END_TF_DOCS -->