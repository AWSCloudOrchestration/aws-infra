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

variable "application_sg_id" {
  type    = string
  default = null
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
  type = list(string)
  default = null
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
    self        = true
    cidr_blocks = null
  }]
}

variable "ingress_security_groups" {
  type    = list(string)
  default = []
}

variable "egress_security_groups" {
  type = list(string)
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
    self        = true
    cidr_blocks = null
  }]
}
