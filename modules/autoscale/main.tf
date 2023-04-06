#############################################
## AUTOSCALE MODULE
#############################################

## Source AMI
data "aws_ami" "custom_ami" {
  most_recent = true

  filter {
    name   = "name"
    values = ["webapp-ami-*"]
  }
}

## Launch configuration
resource "aws_launch_template" "launch_template" {
  name                                 = var.launch_config_name
  image_id                             = var.ec2_source_ami == null ? data.aws_ami.custom_ami.id : var.ec2_source_ami
  instance_type                        = var.ec2_instance_type
  key_name                             = var.instance_key_name
  vpc_security_group_ids               = var.ec2_vpc_security_group_ids
  disable_api_termination              = var.ec2_disable_api_termination
  instance_initiated_shutdown_behavior = "terminate"

  user_data = base64encode(templatefile("${path.module}/../../scripts/setup-creds.sh", {
    rds_address             = var.rds_address
    rds_username            = var.rds_username
    rds_password            = var.rds_password
    rds_db_name             = var.rds_db_name
    s3_instance_bucket_name = var.s3_instance_bucket_name
    s3_aws_region           = var.s3_aws_region
    webapp_env              = var.webapp_env
    webapp_port             = var.webapp_port
    sql_max_pool_conn       = var.sql_max_pool_conn
    sql_max_retries         = var.sql_max_retries
    statsd_host             = var.statsd_host
    statsd_port             = var.statsd_port
    statsd_prefix           = var.statsd_prefix
    statsd_cache_dns        = var.statsd_cache_dns
    app_logs_dirname        = var.app_logs_dirname
    app_error_logs_dirname  = var.app_error_logs_dirname
    cw_config_path          = var.cw_config_path
  }))

#   network_interfaces {
#     associate_public_ip_address = true
#     delete_on_termination       = true
#   }

  iam_instance_profile {
    arn = var.s3_iam_instance_profile
  }

  block_device_mappings {
    device_name = "/dev/xvda"
    ebs {
      volume_size           = var.ebs_size
      volume_type           = var.ebs_type
      delete_on_termination = var.ebs_delete_on_termination
    }
  }

  lifecycle {
    create_before_destroy = true
  }
}

## Autoscaling group
resource "aws_autoscaling_group" "asg" {
  depends_on = [
    aws_launch_template.launch_template
  ]
  name                  = var.asg_name
  min_size              = var.asg_min_size
  max_size              = var.asg_max_size
  default_cooldown      = var.asg_default_cooldown
  desired_capacity      = var.asg_desired_capacity
  desired_capacity_type = var.asg_desired_capacity_type
  vpc_zone_identifier   = [var.ec2_target_subnet_id]
  target_group_arns     = var.alb_target_group_arns

  launch_template {
    id      = aws_launch_template.launch_template.id
    version = "$Latest"
  }

  lifecycle {
    create_before_destroy = true
  }

  tag {
    key                 = "Application"
    value               = "WebApp"
    propagate_at_launch = true
  }
}

## Autoscale up policy
resource "aws_autoscaling_policy" "autoscale_up_policy" {
  name                     = var.asp_up_name
  autoscaling_group_name   = aws_autoscaling_group.asg.name
  adjustment_type          = "ChangeInCapacity"
  scaling_adjustment       = 1 // Number of instances by which to scale
  enabled                  = true
#   min_adjustment_magnitude = 5 // PercentChangeInCapacity
  cooldown                 = 30
}

resource "aws_cloudwatch_metric_alarm" "scale_up" {
  alarm_description   = "Monitors CPU utilization for Webapp ASG"
  alarm_actions       = [aws_autoscaling_policy.autoscale_up_policy.arn]
  alarm_name          = "webapp_scale_up"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  namespace           = "AWS/EC2"
  metric_name         = "CPUUtilization"
  threshold           = 2
  evaluation_periods  = 1
  period              = 10
  statistic           = "Average"

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.asg.name
  }
}

resource "aws_cloudwatch_metric_alarm" "scale_down" {
  alarm_description   = "Monitors CPU utilization for Webapp ASG"
  alarm_actions       = [aws_autoscaling_policy.autoscale_down_policy.arn]
  alarm_name          = "webapp_scale_down"
  comparison_operator = "LessThanOrEqualToThreshold"
  namespace           = "AWS/EC2"
  metric_name         = "CPUUtilization"
  threshold           = 3
  evaluation_periods  = 1
  period              = 10
  statistic           = "Average"

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.asg.name
  }
}

# Autoscale down policy
resource "aws_autoscaling_policy" "autoscale_down_policy" {
  name                     = var.asp_down_name
  autoscaling_group_name   = aws_autoscaling_group.asg.name
  adjustment_type          = "ChangeInCapacity"
  scaling_adjustment       = -1 // Number of instances by which to scale
  enabled                  = true
#   min_adjustment_magnitude = 3 // PercentChangeInCapacity
  cooldown                 = 30
}




