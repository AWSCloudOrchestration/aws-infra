variable "region" {
  description = "AWS Deployment region"
  default     = "us-east-1"
}

variable "profile" {
  description = "AWS cli profile"
  default     = "dev"
}

variable "environment" {
  description = "The Deployment environment"
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
