module "example_com" {
  source = "../."

  domain  = "example.com"
  aliases = [
    "example.org"
  ]
  google_site_verification = {
    name    = "google-site-verification"
    type    = "TXT"
    records = ["google-site-verification-key"]
  },
  alias_records = {
    "example.org" = {
      foo = {
        name    = "foo"
        type    = "CNAME"
        records = ["www.example.com"]
      }
    }
  }
  records = {
    www = {
      name    = "www"
      type    = "A"
      records = ["1.2.3.4"]
    }
  }

}