locals {
  certificate_arn = var.ssl_certificate_arn
}

resource "aws_cloudfront_origin_access_identity" "react" {
  comment = "react"
}

resource "aws_cloudfront_distribution" "website_cdn" {
  enabled             = true
  default_root_object = "index.html"
  aliases             = ["www.answerking.co.uk", "answerking.co.uk"]

  logging_config {
    include_cookies = false
    bucket          = aws_s3_bucket.react.bucket
    prefix          = "react-log"
  }

  default_cache_behavior {
    allowed_methods        = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods         = ["GET", "HEAD"]
    target_origin_id       = aws_s3_bucket.react.bucket
    viewer_protocol_policy = "redirect-to-https"
    compress               = true

    min_ttl     = 0
    default_ttl = 5 * 60
    max_ttl     = 60 * 60

    forwarded_values {
      query_string = true

      cookies {
        forward = "none"
      }
    }
  }

  origin {
    domain_name = aws_s3_bucket.react.bucket_regional_domain_name
    origin_id   = aws_s3_bucket.react.bucket

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.react.cloudfront_access_identity_path
    }
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn      = local.certificate_arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2018"
  }
}


