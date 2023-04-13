variable "db_private_subnet_ids" {
  type = list(string)
}

variable "db_parameter_group_name" {
  type    = string
  default = "rds-mysql8"
}

variable "db_parameter_group_family" {
  type    = string
  default = "mysql8.0"
}

variable "db_name" {
  type    = string
  default = "csye6225"
}

variable "db_engine" {
  type    = string
  default = "mysql"
}

variable "db_engine_version" {
  type    = string
  default = "8.0"
}

variable "db_instance_class" {
  type    = string
  default = "db.t3.micro"
}

variable "db_username" {
  type    = string
  default = "csye6225"
}

variable "db_password" {
  type    = string
  default = "csye6225secret"
}

variable "db_skip_final_snapshot" {
  type    = bool
  default = true
}

variable "db_publicly_accessible" {
  type    = bool
  default = false
}

variable "db_allocated_storage" {
  type    = number
  default = 8
}

variable "db_max_allocated_storage" {
  type    = number
  default = 10
}

variable "db_multi_az" {
  type    = bool
  default = false
}

variable "db_sg_name" {
  type    = string
  default = "database"
}

variable "db_sg_target_vpc_id" {
  type = string
}

variable "db_vpc_security_group_ids" {
  type    = list(string)
  default = null
}

variable "db_environment" {
  type    = string
  default = null
}

variable "db_port" {
  type = number
  default = 3306
}

variable "db_storage_encrypted" {
  type = bool
  default = true
}

variable "kms_description" {
  type    = string
  default = "KMS Key"
}

variable "rds_kms_deletion_window_in_days" {
  type    = number
  default = 7
}

variable "rds_kms_key_usage" {
  type    = string
  default = "ENCRYPT_DECRYPT"
}

variable "rds_kms_enable_key_rotation" {
  type    = bool
  default = false
}

variable "rds_kms_is_enabled" {
  type    = bool
  default = true
}

variable "rds_kms_multi_region" {
  type    = bool
  default = true
}
