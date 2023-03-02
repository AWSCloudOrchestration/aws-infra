variable "s3_iam_policy_name" {
  type    = string
  default = "WebAppS3"
}

variable "iam_policy_version" {
  type    = string
  default = "2012-10-17"
}

variable "s3_iam_policy_actions" {
  type = list(string)
  default = [
    "s3:GetObject",
    "s3:PutObject",
    "s3:DeleteObject",
    "s3:ListMultipartUploadParts",
    "s3:AbortMultipartUpload"
  ]
}

variable "iam_role_name" {
  type    = string
  default = "ec2-iam-role"
}

variable "iam_environment" {
  type    = string
  default = null
}

variable "s3_bucket_name" {
  type    = string
  default = null
}
