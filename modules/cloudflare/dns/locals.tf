locals {
  zone_id = var.create_zone ? cloudflare_zone.dns[0].id : data.cloudflare_zones.lookup[0].id

  security_contact = var.security_contact != null ? var.security_contact : format("security@%s", var.domain)
}
