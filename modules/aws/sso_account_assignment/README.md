# Terraform SSO Account Assignment Module

This Terraform module creates permission sets and account assignments. This is
to be used with AWS IAM Identity Center.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.3 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 4.0 |

## Resources

| Name | Type |
|------|------|
| [aws_identitystore_group.internal](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/identitystore_group) | resource |
| [aws_ssoadmin_account_assignment.to_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssoadmin_account_assignment) | resource |
| [aws_ssoadmin_managed_policy_attachment.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssoadmin_managed_policy_attachment) | resource |
| [aws_ssoadmin_permission_set.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssoadmin_permission_set) | resource |
| [aws_identitystore_group.by_display_name](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/identitystore_group) | data source |
| [aws_ssoadmin_instances.identity_center](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ssoadmin_instances) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_assignments"></a> [assignments](#input\_assignments) | List of assignments between group, account and permission set. The key of each object is the group<br>    name that will be assigned the permissions. Ideally the organisation will use an external identity<br>    provider and this group should be created via SCIM. To also create the groups, enable `create_groups`.<br><br>    • `account_ids`     - (Required) The AWS account IDs to apply the assignment.<br>    • `permission_sets` - (Required) The Permission Sets to be assigned to the group. These should<br>                                     be a subset of the Permission Sets created above. | <pre>map(list(object({<br>    account_ids     = list(string)<br>    permission_sets = list(string)<br>  })))</pre> | n/a | yes |
| <a name="input_create_groups"></a> [create\_groups](#input\_create\_groups) | Whether the module should also create the groups. | `bool` | `false` | no |
| <a name="input_permission_sets"></a> [permission\_sets](#input\_permission\_sets) | List of permission sets for the organization.<br><br>    • `name`             - (Optional) The name of the Permission Set. The key will be used by default.<br>    • `description`      - (Optional) The description of the Permission Set.<br>    • `managed_policies` - (Required) A list of managed policy names. The prefix `arn:aws:iam::aws:policy/`<br>                                      will be prepended to create the full ARN. | <pre>map(object({<br>    name             = optional(string)<br>    description      = optional(string)<br>    managed_policies = list(string)<br>  }))</pre> | n/a | yes |
<!-- END_TF_DOCS -->

# Example Usage

The following example creates a permission set "AdministratorAccess" which attaches
the AWS managed policy also named AdministratorAccess. This permission set is then
applied to the "SystemAdministrator" group across all accounts in the organisation.

```hcl
resource "aws_organizations_organization" "example" {
}

module "iam_example" {
  source = "github.com/answerdigital/terraform-modules//modules/aws/sso_account_assignment?ref=v4"

  permission_sets = {
    AdministratorAccess = {
      managed_policies = ["AdministratorAccess"]
    }
  }

  assignments = {
    "SystemAdministrator" = [{
      account_ids = aws_organizations_organization.example.accounts.*.id

      permission_sets = [
        "AdministratorAccess"
      ]
    }]
  }
}
```
