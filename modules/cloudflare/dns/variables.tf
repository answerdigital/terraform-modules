variable "domain" {
  description = "The top-level domain name to hold the records."
  type        = string
}

variable "account_id" {
  description = "The ID of the Cloudflare account."
  type        = string
}

variable "create_zone" {
  description = "Whether to create the zone. Defaults to `true`."
  type        = bool
  default     = true
}

variable "records" {
  description = <<EOT
    List of DNS records for the domain.

    • `name`     - (Optional) The name of the record. Defaults to "@" (i.e. an apex record).
    • `ttl`      - (Optional) The TTL of the record. Defaults to `default_ttl`.
    • `type`     - (Required) The record type.
    • `content`  - (Required) The content of the record.
    • `priority` - (Optional) The priority of the record.
    • `proxied`  - (Optional) Whether to use Cloudflare’s origin protection. Defaults to `false`.
  EOT
  type = map(object({
    name     = optional(string, "@")
    ttl      = optional(number)
    type     = string
    content  = string
    priority = optional(number)
    proxied  = optional(bool, false)
  }))
}

variable "default_ttl" {
  description = "Default TTL for DNS records. Defaults to 1, which means “automatic”."
  type        = number
  default     = 1
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
    "letsencrypt.org",
  ]
}
