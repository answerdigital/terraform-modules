module "example_com" {
  source = "../."

  domain  = "example.com"
  aliases = [
    "example.org"
  ]
  alias_records = {
    "example.org" = {
      foo = {
        name    = "foo"
        type    = "CNAME"
        records = ["www.example.com"]
      }
      something_interesting = {
        name    = "example_service"
        type    = "TXT"
        records = ["I can provide text or something, to some service somewhere!"]
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