resource "aws_s3_bucket" "redirect" {
  for_each = toset(concat(var.aliases, [for a in var.aliases : "www.${a}"]))
  bucket   = each.key
}

resource "aws_s3_bucket_acl" "redirect" {
  for_each = toset(concat(var.aliases, [for a in var.aliases : "www.${a}"]))
  bucket   = aws_s3_bucket.redirect[each.key].bucket
  acl      = "private"
}

resource "aws_s3_bucket_website_configuration" "redirect" {
  for_each = toset(concat(var.aliases, [for a in var.aliases : "www.${a}"]))
  bucket   = aws_s3_bucket.redirect[each.key].bucket

  redirect_all_requests_to {
    host_name = var.domain
    protocol  = var.alias_redirect_protocol
  }
}

resource "aws_route53_zone" "redirect_zone" {
  for_each = toset(var.aliases)
  name     = each.key
  tags     = var.tags
}

resource "aws_route53_record" "redirect_record_apex" {
  for_each = toset(var.aliases)

  zone_id         = aws_route53_zone.redirect_zone[each.key].zone_id
  name            = each.key
  type            = "A"
  allow_overwrite = true

  alias {
    zone_id                = aws_s3_bucket.redirect[each.key].hosted_zone_id
    name                   = aws_s3_bucket_website_configuration.redirect[each.key].website_domain
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "redirect_record_www" {
  for_each = toset(var.aliases)

  zone_id         = aws_route53_zone.redirect_zone[each.key].zone_id
  name            = "www"
  type            = "A"
  allow_overwrite = true

  alias {
    zone_id                = aws_s3_bucket.redirect["www.${each.key}"].hosted_zone_id
    name                   = aws_s3_bucket_website_configuration.redirect["www.${each.key}"].website_domain
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "redirect_record_mx" {
  for_each = toset(var.alias_mx)

  zone_id         = aws_route53_zone.redirect_zone[each.key].zone_id
  allow_overwrite = true
  name            = each.key
  type            = "MX"
  ttl             = aws_route53_record.dns_record[var.canonical_mx_record].ttl
  records         = aws_route53_record.dns_record[var.canonical_mx_record].records
}

resource "aws_route53_record" "redirect_record_extra" {
  for_each = { for r in local.alias_records_list : "${r.zone}_${r.key}" => r }

  zone_id         = aws_route53_zone.redirect_zone[each.value.zone].zone_id
  allow_overwrite = true
  name            = each.value.name
  type            = each.value.type
  ttl             = each.value.ttl
  records         = each.value.records
}
