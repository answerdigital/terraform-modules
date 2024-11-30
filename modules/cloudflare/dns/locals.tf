locals {
  zone_id = var.create_zone ? cloudflare_zone.dns_zone[0].id : data.cloudflare_zones.dns_zone_lookup[0].id

  security_contact = var.security_contact != null ? var.security_contact : format("security@%s", var.domain)
}
