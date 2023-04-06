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
  enable_cross_zone_load_balancing = true
  enable_deletion_protection       = false
  enable_http2                     = true
  ip_address_type                  = "ipv4"
  preserve_host_header             = true
  tags = {
    Name        = "application-lb"
    Environment = var.lb_environment
    Application = "WebApp"
  }
}

## Instance Target Group
resource "aws_lb_target_group" "alb_tg" {
  name        = var.alb_tg_name
  port        = var.alb_target_port
  protocol    = var.alb_tg_protocol
  target_type = "instance"
  vpc_id      = var.alb_tg_vpc_id
  health_check {
    path = "/healthz"
  }
}

# resource "aws_lb_target_group_attachment" "lb_target_group_attachment" {
#   target_group_arn = aws_lb_target_group.alb_tg.arn
#   target_id        = var.autoscaling_group_id
#   port             = var.alb_target_port
# }

resource "aws_lb_listener" "alb_listener" {
  depends_on = [
    aws_lb_target_group.alb_tg
  ]
  load_balancer_arn = aws_lb.application_lb.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    target_group_arn = aws_lb_target_group.alb_tg.arn
    type             = "forward"
  }
}
