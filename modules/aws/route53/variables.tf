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

variable "aliases" {
  description = "List of alias domains that should redirect to the canonical domain."
  type        = list(string)
  default     = []
}

variable "alias_mx" {
  description = "List of alias domains that should have the same MX records as the canonical domain."
  type        = list(string)
  default     = []
}

variable "canonical_mx_record" {
  description = "The name of the MX record on the canonical domain."
  type        = string
  default     = "apex_mx"
}

variable "alias_records" {
  description = <<EOT
    List of DNS records for alias domains. The top-level keys should match entries in the `aliases`
    list. The second-level map should match the same structure as `records`.
  EOT
  type = map(map(object({
    name    = optional(string)
    ttl     = optional(string)
    type    = string
    records = list(string)
  })))
  default = {}
}

variable "alias_redirect_protocol" {
  description = "Protocol to use when redirecting to the canonical domain. Valid values: `http`, `https`."
  type        = string
  default     = "https"

  validation {
    condition     = contains(["http", "https"], var.alias_redirect_protocol)
    error_message = "Valid values for alias_redirect_protocol: http, https."
  }
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
    "amazon.com",
  ]
}

locals {
  alias_records_list = flatten([
    for zone, records in var.alias_records : [
      for key, record in records : {
        zone    = zone
        key     = key
        name    = record.name != null ? record.name : zone
        ttl     = record.ttl != null ? record.ttl : var.default_ttl
        type    = record.type
        records = record.records
      }
    ]
  ])
}
