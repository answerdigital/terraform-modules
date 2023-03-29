variable "default_ttl" {
  description = "Default TTL for DNS records."
  type        = number
  default     = 86400
}

variable "domain" {
  description = "The top-level domain name to hold the records."
  type        = string
}

variable "comment" {
  description = "A comment for the hosted zone. Defaults to 'Managed by Terraform'."
  type        = string
  default     = null
}

variable "tags" {
  description = "Tags for the hosted zone."
  type        = map(any)
  default     = {}
}

variable "records" {
  description = <<EOT
    List of DNS records for the domain.

    • `name`    - (Optional) The name of the record. Defaults to the domain (i.e. an apex record).
    • `ttl`     - (Optional) The TTL of the record. Defaults to `default_ttl`.
    • `type`    - (Required) The record type.
    • `records` - (Required) A string list of records.
  EOT
  type = map(object({
    name    = optional(string)
    ttl     = optional(string)
    type    = string
    records = list(string)
  }))
}

variable "apex_txt" {
  description = "List of TXT records to be added at the apex."
  type        = list(string)
  default     = []
}

variable "security_contact" {
  description = "Security contact for the domain. Defaults to 'security@DOMAIN', where `DOMAIN` is the top-level domain name."
  type        = string
  default     = null
}

variable "spf" {
  description = "List of SPF directives for the domain."
  type        = list(string)
  default     = []
}

variable "caa_issuers" {
  description = "List of CAs that can issue certificates."
  type        = list(string)
  default = [
    "amazontrust.com",
    "awstrust.com",
    "amazonaws.com",
    "amazon.com",
  ]
}
