// Network module variables
variable "region" {
  type        = string
  description = "AWS Deployment region"
  default     = "us-east-1"
}

variable "preferred_availability_zones" {
  type        = list(string)
  description = "AWS availability zones"
  default     = []
}

variable "profile" {
  type        = string
  description = "AWS cli profile"
  default     = "dev"
}

variable "environment" {
  type        = string
  description = "The Deployment environment"
}

variable "vpc_cidr" {
  type        = string
  description = "VPC CIDR"
}

variable "public_subnets_cidr" {
  type        = list(string)
  description = "CIDR block for public subnets"
}

variable "private_subnets_cidr" {
  type        = list(string)
  description = "CIDR block for private subnets"
}

variable "public_route_destination_cidr_block" {
  type        = string
  description = "The destination cidr for public route"
  default     = "0.0.0.0/0"
}

// Module instance variables
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

variable "application_sg_description" {
  type    = string
  default = "Application security group"
}

variable "instance_environment" {
  type    = string
  default = "dev"
}

variable "ec2_vpc_security_group_ids" {
  type    = list(string)
  default = null
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

variable "webapp_env" {
  type    = string
  default = "development"
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

// RDS variables

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

variable "rds_sg_name" {
  type    = string
  default = "database"
}

variable "rds_sg_description" {
  type    = string
  default = "RDS security group"
}

variable "db_vpc_security_group_ids" {
  type    = list(string)
  default = null
}

variable "db_port" {
  type    = number
  default = 3306
}

// Application SG rules

variable "application_sg_ingress_rules" {
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
  default = [
    {
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      from_port   = 3001
      to_port     = 3001
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]
}

variable "application_sg_egress_rules" {
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
  default = [{
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }]
}

variable "ingress_security_groups" {
  type    = list(string)
  default = []
}

variable "egress_security_groups" {
  type    = list(string)
  default = []
}

// RDS SG Rules
variable "rds_sg_ingress_rules" {
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
  default = [{
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = null
  }]
}

variable "rds_sg_egress_rules" {
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
  default = [{
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }]
}

variable "db_environment" {
  type    = string
  default = null
}

// S3 bucket variables
variable "s3_versioning_configuration" {
  type    = string
  default = "Disabled"
}

variable "s3_bucket_name" {
  type    = string
  default = null
}

variable "s3_bucket_acl" {
  type    = string
  default = "private"
}

variable "transition_to_IA_days" {
  type    = number
  default = 30
}

variable "s3_environment" {
  type    = string
  default = null
}

// IAM variables
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
  default = "EC2-CSYE6225"
}

variable "iam_environment" {
  type    = string
  default = null
}

## Route 53 variables
variable "route53_zone_name" {
  type    = string
  default = null
}

variable "route53_dns_records" {
  type = list(object({
    name = string
    type = string
    ttl  = number
  }))
  default = null
}

variable "route53_records_value" {
  type    = list(string)
  default = null
}

variable "route53_alias_name" {
  type    = string
  default = null
}

variable "route53_alias_type" {
  type    = string
  default = "A"
}

