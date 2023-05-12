#Read these from output OR Include in the same and infer usage.

terraform {
  backend "s3" {
    bucket         = "name-dev-state-management-bucket"
    key            = "global/dev/s3/terraform.tfstate"
    region         = "eu-west-2"
    dynamodb_table = "name-tf-locks-dev"
    encrypt        = true
  }
}

resource "aws_s3_bucket" "bucket" {
  bucket = "i-am-a-test-bucket-4567834"
}