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
        type    = "A"
        records = ["8.7.6.5"]
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