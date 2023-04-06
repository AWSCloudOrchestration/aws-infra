variable "alb_name" {
  type    = string
  default = "webapp-lb"
}

variable "lb_environment" {
  type    = string
  default = null
}

variable "alb_security_groups" {
  type    = list(any)
  default = null
}

variable "alb_subnets" {
  type    = list(any)
  default = null
}

variable "alb_tg_name" {
  type    = string
  default = "application-lb-tg"
}

variable "alb_tg_vpc_id" {
  type    = string
  default = null
}

variable "alb_tg_protocol" {
  type    = string
  default = "HTTP"
}

variable "alb_target_port" {
  type    = number
  default = 3001
}

variable "autoscaling_group_id" {
  type    = string
  default = null
}
