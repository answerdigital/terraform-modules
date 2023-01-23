data "aws_route53_zone" "route53_zone" {
  name         = "www.answerking.co.uk"
  private_zone = false
}

resource "aws_route53_record" "cf_dns" {
  zone_id = data.aws_route53_zone.route53_zone.zone_id
  name    = "www.answerking.co.uk"
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.website_cdn.domain_name
    zone_id                = aws_cloudfront_distribution.website_cdn.hosted_zone_id
    evaluate_target_health = false
  }
}
