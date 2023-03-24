variable "ec2_source_ami" {
  type    = string
  default = null
}

variable "ec2_target_subnet_id" {
  type    = string
  default = null
}

variable "ec2_instance_type" {
  type    = string
  default = "t2.micro"
}

variable "ebs_size" {
  type    = number
  default = 8
}

variable "ebs_type" {
  type    = string
  default = "gp2"
}

variable "application_sg_name" {
  type    = string
  default = "application"
}

variable "ec2_sg_target_vpc_id" {
  type = string
}

variable "instance_environment" {
  type    = string
  default = "dev"
}

variable "ebs_delete_on_termination" {
  type    = bool
  default = true
}

variable "rds_address" {
  type    = string
  default = null
}

variable "rds_username" {
  type    = string
  default = null
}

variable "rds_password" {
  type    = string
  default = null
}

variable "rds_db_name" {
  type    = string
  default = null
}

variable "ec2_vpc_security_group_ids" {
  type = list(string)
}

variable "s3_iam_instance_profile" {
  type    = string
  default = null
}

variable "s3_instance_bucket_name" {
  type    = string
  default = null
}

variable "s3_aws_region" {
  type    = string
  default = null
}

variable "ec2_disable_api_termination" {
  type    = bool
  default = false
}

variable "webapp_env" {
  type    = string
  default = null
}

variable "webapp_port" {
  type    = number
  default = 3001
}

variable "sql_max_pool_conn" {
  type    = number
  default = 10
}

variable "sql_max_retries" {
  type    = number
  default = 3
}

variable "statsd_host" {
  type    = string
  default = "localhost"
}

variable "statsd_port" {
  type    = number
  default = 8125
}

variable "statsd_prefix" {
  type    = string
  default = "webapp"
}

variable "statsd_cache_dns" {
  type    = bool
  default = true
}

variable "app_logs_dirname" {
  type    = string
  default = "/var/log/webapp"
}

variable "app_error_logs_dirname" {
  type    = string
  default = "/var/log/webapp"
}

variable "cw_config_path" {
  type    = string
  default = "/opt/cloudwatch-config.json"
}
