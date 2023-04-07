#############################################
## LOAD BALANCER MODULE
#############################################

## Application Load Balancer
resource "aws_lb" "application_lb" {
  name                             = var.alb_name
  internal                         = false
  load_balancer_type               = "application"
  security_groups                  = var.alb_security_groups
  subnets                          = var.alb_subnets
  enable_cross_zone_load_balancing = var.alb_enable_cross_zone
  enable_deletion_protection       = var.alb_enable_deletion_protection
  enable_http2                     = var.alb_enable_http2
  ip_address_type                  = var.alb_ip_address_type
  preserve_host_header             = var.alb_preserve_host_header
  tags = {
    Name        = "application-lb"
    Environment = var.lb_environment
    Application = "WebApp"
  }
}

## Instance Target Group
resource "aws_lb_target_group" "alb_tg" {
  name                          = var.alb_tg_name
  port                          = var.alb_target_port
  protocol                      = var.alb_tg_protocol
  load_balancing_algorithm_type = var.alb_algorithm_type
  target_type                   = var.alb_target_type
  vpc_id                        = var.alb_tg_vpc_id
  
  health_check {
    path = var.lb_health_path
  }
}

## Load balancer listener
resource "aws_lb_listener" "alb_listener" {
  depends_on = [
    aws_lb_target_group.alb_tg
  ]
  load_balancer_arn = aws_lb.application_lb.arn
  port              = var.alb_listener_port
  protocol          = var.alb_listener_protocol
  default_action {
    target_group_arn = aws_lb_target_group.alb_tg.arn
    type             = var.alb_listener_default_action_type
  }
}
