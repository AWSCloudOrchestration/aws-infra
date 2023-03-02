variable "sg_ingress_rules" {
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
}

variable "sg_egress_rules" {
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
}

variable "sg_name" {
  type = string
}

variable "sg_description" {
  type = string
}

variable "sg_target_vpc_id" {
  type = string
}

variable "sg_environment" {
  type = string
}

variable "ingress_security_groups" {
  type    = list(string)
  default = []
}

variable "egress_security_groups" {
  type    = list(string)
  default = []
}
