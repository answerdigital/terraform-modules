# create the groups ourselves if requested
resource "aws_identitystore_group" "internal" {
  for_each = toset(var.create_groups ? local.groups : [])

  identity_store_id = local.instance_identity_store_id
  display_name      = each.value
}

resource "aws_ssoadmin_permission_set" "this" {
  for_each = var.permission_sets

  name         = each.value.name != null ? each.value.name : each.key
  description  = each.value.description
  instance_arn = local.instance_arn
}

resource "aws_ssoadmin_managed_policy_attachment" "this" {
  for_each = { for p in local.managed_policies : "${p.permission_set}_${p.policy_name}" => p }

  instance_arn       = local.instance_arn
  managed_policy_arn = each.value.policy_arn
  permission_set_arn = aws_ssoadmin_permission_set.this[each.value.permission_set].arn
}

resource "aws_ssoadmin_account_assignment" "to_group" {
  for_each = { for a in local.account_assignments : "${a.account_id}_${a.group}_${a.permission_set}" => a }

  instance_arn       = local.instance_arn
  permission_set_arn = aws_ssoadmin_permission_set.this[each.value.permission_set].arn

  principal_id   = (var.create_groups ? aws_identitystore_group.internal : data.aws_identitystore_group.by_display_name)[each.value.group].group_id
  principal_type = "GROUP"

  target_id   = each.value.account_id
  target_type = "AWS_ACCOUNT"
}
