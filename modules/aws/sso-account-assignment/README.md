# Terraform SSO Account Assignment Module

This Terraform module creates permission sets and account assignments. This is
to be used with AWS IAM Identity Center.

<!-- BEGIN_TF_DOCS -->
<!-- END_TF_DOCS -->

# Example Usage

The following example creates a permission set "AdministratorAccess" which attaches
the AWS managed policy also named AdministratorAccess. This permission set is then
applied to the "SystemAdministrator" group across all accounts in the organisation.

```hcl
resource "aws_organizations_organization" "example" {
}

module "iam_example" {
  source = "github.com/answerdigital/terraform-modules//modules/aws/sso-account-assignment?ref=v2"

  permission_sets = {
    AdministratorAccess = {
      managed_policies = ["AdministratorAccess"]
    }
  }

  assignments = {
    "SystemAdministrator" = {
      account_ids = [
        for account in aws_organizations_organization.example.accounts : account.id
      ]

      permission_sets = [
        "AdministratorAccess"
      ]
    }
  }
}
```
