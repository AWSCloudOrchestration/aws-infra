variable "region" {
  type        = string
  description = "AWS Deployment region"
  default     = "us-east-2"
}

variable "preferred_availability_zones" {
  type        = list(string)
  description = "AWS availability zones"
  default     = []
}

variable "profile" {
  type        = string
  description = "AWS cli profile"
  default     = "production"
}

variable "environment" {
  type        = string
  description = "The Deployment environment"
  default     = "production"
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

