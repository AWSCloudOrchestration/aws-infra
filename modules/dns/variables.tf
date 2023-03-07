variable "route53_zone_name" {
  type    = string
  default = null
}

variable "route53_dns_records" {
  type = list(object({
    name    = string
    type    = string
    ttl     = number
  }))
  default = null
}

variable "route53_allow_record_overwrite" {
  type    = bool
  default = true
}

variable "route53_records_value" {
  type    = list(string)
  default = null
}

variable "route53_alias_name" {
  type = string
  default = null
}

variable "route53_alias_type" {
  type = string
  default = "A"
}
