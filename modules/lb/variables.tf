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

variable "alb_enable_cross_zone" {
  type    = bool
  default = true
}

variable "alb_enable_deletion_protection" {
  type    = bool
  default = false
}

variable "alb_enable_http2" {
  type    = bool
  default = true
}

variable "alb_ip_address_type" {
  type    = string
  default = "ipv4"
}

variable "alb_preserve_host_header" {
  type    = bool
  default = true
}

variable "lb_health_path" {
  type    = string
  default = "/healthz"
}

variable "alb_listener_port" {
  type    = number
  default = 443
}

variable "alb_listener_protocol" {
  type    = string
  default = "HTTPS"
}

variable "alb_listener_default_action_type" {
  type    = string
  default = "forward"
}

variable "alb_target_type" {
  type    = string
  default = "instance"
}

variable "alb_algorithm_type" {
  type    = string
  default = "round_robin"
}

variable "alb_certificate_arn" {
  type    = string
  default = null
}

variable "alb_ssl_policy" {
  type    = string
  default = "ELBSecurityPolicy-TLS13-1-2-2021-06"
}

variable "acm_domain_name" {
  type    = string
  default = null
}

variable "acm_statuses" {
  type    = list(string)
  default = ["ISSUED"]
}
