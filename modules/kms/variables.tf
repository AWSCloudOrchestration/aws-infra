variable "kms_description" {
  type    = string
  default = "KMS Key"
}

variable "kms_deletion_window_in_days" {
  type    = number
  default = 7
}

variable "kms_key_usage" {
  type    = string
  default = "ENCRYPT_DECRYPT"
}

variable "kms_enable_key_rotation" {
  type    = bool
  default = false
}

variable "kms_is_enabled" {
  type    = bool
  default = true
}

variable "kms_multi_region" {
  type    = bool
  default = true
}

variable "kms_policy" {
  type = object({
    Version = string
    Statement = list(object({
      Sid       = optional(string)
      Effect    = string
       Principal = object({
        AWS = string
      })
      Action    = list(string)
      Resource  = any
    }))
  })
  default = null
}
