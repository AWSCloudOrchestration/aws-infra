variable "ec2_source_ami" {
  type    = string
  default = null
}

variable "ec2_target_subnet_id" {
  type    = list(any)
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
  default = "webapp_"
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

variable "instance_key_name" {
  type    = string
  default = "WebAppInstanceKey"
}

variable "launch_config_name" {
  type    = string
  default = "WebAppLaunchConfig"
}

variable "asg_name" {
  type    = string
  default = "WebAppASG"
}

variable "asg_min_size" {
  type    = number
  default = 1
}

variable "asg_max_size" {
  type    = number
  default = 3
}

variable "asg_default_cooldown" {
  description = "Amount of time, in seconds, after a scaling activity completes before another scaling activity can start."
  type        = number
  default     = 30
}

variable "asg_desired_capacity" {
  description = "Number of Amazon EC2 instances that should be running in the group."
  type        = number
  default     = 1
}

variable "asg_desired_capacity_type" {
  description = "Valid values: 'units', 'vcpu', 'memory-mib'"
  type        = string
  default     = "units"
}

variable "asp_up_name" {
  type    = string
  default = "webapp-asp-up"
}

variable "asp_down_name" {
  type    = string
  default = "webapp-asp-down"
}

variable "alb_target_group_arns" {
  type    = list(string)
  default = null
}

variable "block_device_name" {
  type    = string
  default = "/dev/xvda"
}

variable "asg_health_check_grace_period" {
  type    = number
  default = 100
}

variable "asg_health_check_type" {
  type    = string
  default = "EC2"
}

variable "launch_template_version" {
  type    = string
  default = "$Latest"
}

variable "asp_up_cooldown" {
  type    = number
  default = 60
}

variable "asp_up_scaling_adjustment" {
  description = "Number of instances by which to scale"
  type        = number
  default     = 1
}

variable "asp_down_scaling_adjustment" {
  description = "Number of instances by which to scale"
  type        = number
  default     = -1
}

variable "asp_down_cooldown" {
  type    = number
  default = 60
}

variable "asp_up_enabled" {
  type    = bool
  default = true
}

variable "asp_down_enabled" {
  type    = bool
  default = true
}

variable "asp_up_adjustment_type" {
  type    = string
  default = "ChangeInCapacity"
}

variable "asp_down_adjustment_type" {
  type    = string
  default = "ChangeInCapacity"
}

variable "asg_termination_policies" {
  type    = list(string)
  default = ["OldestInstance"]
}

variable "cma_up_threshold" {
  type    = number
  default = 10
}

variable "cma_up_evaluation_periods" {
  type    = number
  default = 2
}

variable "cma_up_period" {
  type    = number
  default = 60
}

variable "cma_up_statistic" {
  type    = string
  default = "Average"
}

variable "cma_up_actions_enabled" {
  type    = bool
  default = true
}

variable "cma_up_alarm_name" {
  type    = string
  default = "webapp_scale_up"
}

variable "cma_up_comparison_operator" {
  type    = string
  default = "GreaterThanOrEqualToThreshold"
}

variable "cma_up_namespace" {
  type    = string
  default = "AWS/EC2"
}

variable "cma_up_metric_name" {
  type    = string
  default = "CPUUtilization"
}

variable "cma_down_actions_enabled" {
  type    = bool
  default = true
}

variable "cma_down_alarm_name" {
  type    = string
  default = "webapp_scale_down"
}

variable "cma_down_comparison_operator" {
  type    = string
  default = "LessThanOrEqualToThreshold"
}

variable "cma_down_namespace" {
  type    = string
  default = "AWS/EC2"
}

variable "cma_down_metric_name" {
  type    = string
  default = "CPUUtilization"
}

variable "cma_down_threshold" {
  type    = number
  default = 5
}

variable "cma_down_evaluation_periods" {
  type    = number
  default = 2
}

variable "cma_down_period" {
  type    = number
  default = 60
}

variable "cma_down_statistic" {
  type    = string
  default = "Average"
}

variable "instance_associate_public_ip_address" {
  type    = bool
  default = true
}

variable "instance_delete_on_termination" {
  type    = bool
  default = true
}

variable "ebs_kms_key_id" {
  type    = string
  default = null
}

variable "kms_description" {
  type    = string
  default = "KMS Key"
}

variable "kms_deletion_window_in_days" {
  type    = number
  default = 7
}
