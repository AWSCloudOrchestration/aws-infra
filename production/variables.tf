variable "region" {
  description = "AWS Deployment region"
  default     = "us-east-2"
}

variable "preferred_availability_zones" {
  description = "AWS availability zones"
  default     = null
}

variable "profile" {
  description = "AWS cli profile"
  default     = "production"
}

variable "environment" {
  description = "The Deployment environment"
  default     = "production"
}

variable "vpc_cidr" {
  description = "VPC CIDR"
}

variable "public_subnets_cidr" {
  type        = list(any)
  description = "CIDR block for public subnets"
}

variable "private_subnets_cidr" {
  type        = list(any)
  description = "CIDR block for private subnets"
}

variable "public_route_destination_cidr_block" {
  description = "The destination cidr for public route"
  default     = "0.0.0.0/0"
}
