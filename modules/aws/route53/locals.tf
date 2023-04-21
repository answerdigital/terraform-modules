locals {
  security_contact = var.security_contact != null ? var.security_contact : format("security@%s", var.domain)

  alias_records_list = flatten([
    for zone, records in var.alias_records : [
      for key, record in records : {
        zone    = zone
        key     = key
        name    = record.name != null ? record.name : zone
        ttl     = record.ttl != null ? record.ttl : var.default_ttl
        type    = record.type
        records = record.records
      }
    ]
  ])
}
