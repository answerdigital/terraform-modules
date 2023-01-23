resource "aws_iam_policy_document" "read_react_app_bucket" {
  statement {
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.react.arn}/*"]

    principals {
      type        = "AWS"
      identifiers = [aws_cloudfront_origin_access_identity.react.iam_arn]
    }
  }

  statement {
    actions   = ["s3:ListBucket"]
    resources = [aws_s3_bucket.react.arn]

    principals {
      type        = "AWS"
      identifiers = [aws_cloudfront_origin_access_identity.react.iam_arn]
    }
  }
}

resource "aws_s3_bucket" "react" {
  bucket = var.bucket_name
  acl    = "private"

  website {
    index_document = "index.html"
  }
}

resource "aws_s3_bucket_policy" "read_react_app" {
  bucket = aws_s3_bucket.react.id
  policy = data.aws_iam_policy_document.read_react_app_bucket.json
}

resource "aws_s3_bucket_public_access_block" "react" {
  bucket = aws_s3_bucket.react.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
