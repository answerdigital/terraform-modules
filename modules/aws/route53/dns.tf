locals {
  security_contact = var.security_contact != null ? var.security_contact : format("security@%s", var.domain)
}

resource "aws_route53_zone" "dns_zone" {
  name    = var.domain
  comment = var.comment
  tags    = var.tags
}

resource "aws_route53_record" "name_servers" {
  zone_id         = aws_route53_zone.dns_zone.zone_id
  allow_overwrite = true
  name            = var.domain
  ttl             = var.default_ttl
  type            = "NS"
  records         = aws_route53_zone.dns_zone.name_servers
}

resource "aws_route53_record" "dns_record" {
  for_each = var.records

  zone_id         = aws_route53_zone.dns_zone.zone_id
  allow_overwrite = true
  name            = each.value.name != null ? each.value.name : var.domain
  ttl             = each.value.ttl != null ? each.value.ttl : var.default_ttl
  type            = each.value.type
  records = [
    for r in each.value.records : length(r) > 255 ? join("\"\"", [
      for c in chunklist(split("", r), 255) : join("", c)
    ]) : r
  ]
}

resource "aws_route53_record" "apex_txt" {
  zone_id = aws_route53_zone.dns_zone.zone_id
  name    = var.domain
  ttl     = var.default_ttl
  type    = "TXT"
  records = concat(var.apex_txt, [
    format("security_contact=mailto:%s", local.security_contact),
    replace("v=spf1 ${join(" ", var.spf)} -all", "  ", " ")
  ])
}

resource "aws_route53_record" "caa" {
  zone_id = aws_route53_zone.dns_zone.zone_id
  name    = var.domain
  ttl     = var.default_ttl
  type    = "CAA"
  records = flatten([
    [for issuer in var.caa_issuers : format("0 issue \"%s\"", issuer)],
    format("0 iodef \"mailto:%s\"", local.security_contact)
  ])
}
