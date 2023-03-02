variable "s3_versioning_configuration" {
  description = "Versioning enabled"
  type        = string
  default     = "Disabled"
}

variable "s3_bucket_acl" {
  type    = string
  default = "private"
}

variable "transition_to_IA_days" {
  description = "Transition from STANDARD to STANDARD-IA days"
  type        = number
  default     = 30
}

variable "s3_environment" {
  description = "S3 environment"
  type        = string
  default     = null
}

variable "s3_block_public_acls" {
  type    = bool
  default = true
}

variable "s3_block_public_policy" {
  type    = bool
  default = true
}

variable "s3_ignore_public_acls" {
  type    = bool
  default = true
}

variable "s3_restrict_public_buckets" {
  type    = bool
  default = true
}

variable "s3_sse_algorithm" {
  type    = string
  default = "AES256"
}

variable "s3_force_destroy" {
  type    = bool
  default = true
}
