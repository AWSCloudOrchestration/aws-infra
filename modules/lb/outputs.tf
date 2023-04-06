output "alb_zone_id" {
  value = aws_lb.application_lb.zone_id
}

output "alb_dns_name" {
    value = aws_lb.application_lb.dns_name
}

output "alb_target_group_arns" {
  value = [aws_lb_target_group.alb_tg.arn]
}