variable "permission_sets" {
  description = <<EOT
    List of permission sets for the organization.

    • `name`              - (Optional) The name of the Permission Set. The key will be used by default.
    • `description`       - (Optional) The description of the Permission Set.
    • `managed_policies`  - (Required) A list of AWS-managed policy names. The prefix `arn:aws:iam::aws:policy/`
                                       will be prepended to create the full ARN.
    • `inline_policy`     - (Optional) An IAM inline policy to attach to the Permission Set.
  EOT
  type = map(object({
    name             = optional(string)
    description      = optional(string)
    managed_policies = list(string)
    inline_policy    = optional(string, "")
  }))
}

variable "assignments" {
  description = <<EOT
    List of assignments between group, account and permission set. The key of each object is the group
    name that will be assigned the permissions. Ideally the organisation will use an external identity
    provider and this group should be created via SCIM. To also create the groups, enable `create_groups`.

    • `account_ids`     - (Required) The AWS account IDs to apply the assignment.
    • `permission_sets` - (Required) The Permission Sets to be assigned to the group. These should
                                     be a subset of the Permission Sets created above.
  EOT
  type = map(list(object({
    account_ids     = list(string)
    permission_sets = list(string)
  })))
}

variable "create_groups" {
  description = "Whether the module should also create the groups."
  type        = bool
  default     = false
}
