locals {
  instance_arn               = tolist(data.aws_ssoadmin_instances.identity_center.arns)[0]
  instance_identity_store_id = tolist(data.aws_ssoadmin_instances.identity_center.identity_store_ids)[0]

  managed_policies = flatten([
    for permission_set, options in var.permission_sets : [
      for policy in options.managed_policies : {
        permission_set = permission_set
        policy_name    = policy
        policy_arn     = "arn:aws:iam::aws:policy/${policy}"
      }
    ]
  ])

  inline_policies = [
    for permission_set, options in var.permission_sets : {
      permission_set = permission_set
      inline_policy  = options.inline_policy
    } if options.inline_policy != ""
  ]

  account_assignments = flatten(flatten(flatten([
    for group, assignments in var.assignments : [
      for assignment in assignments : [
        for permission_set in assignment.permission_sets : [
          for account_id in assignment.account_ids : {
            group          = group
            account_id     = account_id
            permission_set = permission_set
          }
        ]
      ]
    ]
  ])))

  groups = keys(var.assignments)
}
