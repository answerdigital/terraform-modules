data "aws_ssoadmin_instances" "identity_center" {}

# look up by DisplayName when using pre-existing groups
data "aws_identitystore_group" "by_display_name" {
  for_each = toset(var.create_groups ? [] : local.groups)

  identity_store_id = local.instance_identity_store_id

  alternate_identifier {
    unique_attribute {
      attribute_path  = "DisplayName"
      attribute_value = each.value
    }
  }
}
