<!-- BEGIN_TF_DOCS -->


## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_lb.aws_lb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb) | resource |
| [aws_lb_listener.mdm_lb_listener](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener) | resource |
| [aws_lb_target_group.mdm_target_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_application_http_protocol"></a> [application\_http\_protocol](#input\_application\_http\_protocol) | The protocol over which to forward traffic. Used for the health check and the and the load balancer itself | `any` | n/a | yes |
| <a name="input_application_port"></a> [application\_port](#input\_application\_port) | The port of the application to forward traffic to | `any` | n/a | yes |
| <a name="input_healthcheck_endpoint"></a> [healthcheck\_endpoint](#input\_healthcheck\_endpoint) | The api endpoint the load balancer will use as a healtcheck | `any` | n/a | yes |
| <a name="input_internal"></a> [internal](#input\_internal) | If the load balancer is internally facing or externally facing | `any` | n/a | yes |
| <a name="input_lb_name"></a> [lb\_name](#input\_lb\_name) | The name of the load balancer | `any` | n/a | yes |
| <a name="input_security_group_id"></a> [security\_group\_id](#input\_security\_group\_id) | The security group of which this LB will belong to | `any` | n/a | yes |
| <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids) | The Subnets in which this load balancer will operate | `any` | n/a | yes |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | The id of the VPC to create the load balancer in this is provided by the VPC module | `any` | n/a | yes |
<!-- END_TF_DOCS -->