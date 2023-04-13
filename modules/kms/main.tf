#############################################
##  AWS KEY MANAGEMENT SERVICE MODULE
#############################################


resource "aws_kms_key" "kms_key" {
  description             = var.kms_description
  deletion_window_in_days = var.kms_deletion_window_in_days
  key_usage               = var.kms_key_usage
  enable_key_rotation     = var.kms_enable_key_rotation
  is_enabled              = var.kms_is_enabled
  multi_region            = var.kms_multi_region
  policy                  = jsonencode(var.kms_policy)
}
