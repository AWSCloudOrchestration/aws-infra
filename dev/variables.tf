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

variable "instance_environment" {
  type    = string
  default = "dev"
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

