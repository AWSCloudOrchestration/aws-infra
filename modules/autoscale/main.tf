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

module "globals" {
  source = "../globals"
}

## KMS Key Policy
resource "aws_kms_key_policy" "ebs_kms_policy" {
  key_id = module.ebs_kms.kms_key_id
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "Allow access for Key Administrators",
        "Effect" : "Allow",
        "Principal" : {
          "AWS" : "arn:aws:iam::${module.globals.caller_account_id}:user/awscli"
        },
        "Action" : [
          "kms:Create*",
          "kms:Describe*",
          "kms:Enable*",
          "kms:List*",
          "kms:Put*",
          "kms:Update*",
          "kms:Revoke*",
          "kms:Disable*",
          "kms:Get*",
          "kms:Delete*",
          "kms:TagResource",
          "kms:UntagResource",
          "kms:ScheduleKeyDeletion",
          "kms:CancelKeyDeletion"
        ],
        "Resource" : [module.ebs_kms.kms_key_id]
      },
      {
        "Sid" : "Allow service-linked role use of the customer managed key",
        "Effect" : "Allow",
        "Principal" : {
          "AWS" : [
            "arn:aws:iam::${module.globals.caller_account_id}:role/aws-service-role/autoscaling.amazonaws.com/AWSServiceRoleForAutoScaling"
          ]
        },
        "Action" : [
          "kms:Encrypt",
          "kms:Decrypt",
          "kms:ReEncrypt*",
          "kms:GenerateDataKey*",
          "kms:DescribeKey"
        ],
        "Resource" : [module.ebs_kms.kms_key_id]
      },
      {
        "Sid" : "Allow attachment of persistent resources",
        "Effect" : "Allow",
        "Principal" : {
          "AWS" : [
            "arn:aws:iam::${module.globals.caller_account_id}:role/aws-service-role/autoscaling.amazonaws.com/AWSServiceRoleForAutoScaling"
          ]
        },
        "Action" : [
          "kms:CreateGrant"
        ],
        "Resource" : [module.ebs_kms.kms_key_id],
        "Condition" : {
          "Bool" : {
            "kms:GrantIsForAWSResource" : true
          }
        }
      }
    ]
  })
}

## KMS Key
module "ebs_kms" {
  source = "../kms"

  kms_description             = "EBS KMS Key"
  kms_deletion_window_in_days = var.ebs_kms_deletion_window_in_days
  kms_key_usage               = var.ebs_kms_key_usage
  kms_enable_key_rotation     = var.ebs_kms_enable_key_rotation
  kms_is_enabled              = var.ebs_kms_is_enabled
  kms_multi_region            = var.ebs_kms_multi_region
}

## Launch configuration
resource "aws_launch_template" "launch_template" {
  name                                 = var.launch_config_name
  image_id                             = var.ec2_source_ami == null ? data.aws_ami.custom_ami.id : var.ec2_source_ami
  instance_type                        = var.ec2_instance_type
  key_name                             = var.instance_key_name
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

  network_interfaces {
    associate_public_ip_address = var.instance_associate_public_ip_address
    delete_on_termination       = var.instance_delete_on_termination
    security_groups             = var.ec2_vpc_security_group_ids
  }

  iam_instance_profile {
    arn = var.s3_iam_instance_profile
  }

  block_device_mappings {
    device_name = var.block_device_name
    ebs {
      volume_size           = var.ebs_size
      volume_type           = var.ebs_type
      encrypted             = true
      kms_key_id            = module.ebs_kms.kms_key_id
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
  name                      = var.asg_name
  min_size                  = var.asg_min_size
  max_size                  = var.asg_max_size
  desired_capacity          = var.asg_desired_capacity
  vpc_zone_identifier       = var.ec2_target_subnet_id
  target_group_arns         = var.alb_target_group_arns
  termination_policies      = var.asg_termination_policies
  health_check_grace_period = var.asg_health_check_grace_period
  health_check_type         = var.asg_health_check_type

  launch_template {
    id      = aws_launch_template.launch_template.id
    version = var.launch_template_version
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
  name                   = var.asp_up_name
  autoscaling_group_name = aws_autoscaling_group.asg.name
  adjustment_type        = var.asp_up_adjustment_type
  scaling_adjustment     = var.asp_up_scaling_adjustment
  enabled                = var.asp_up_enabled
  cooldown               = var.asp_up_cooldown
}

# Autoscale down policy
resource "aws_autoscaling_policy" "autoscale_down_policy" {
  name                   = var.asp_down_name
  autoscaling_group_name = aws_autoscaling_group.asg.name
  adjustment_type        = var.asp_down_adjustment_type
  scaling_adjustment     = var.asp_down_scaling_adjustment
  enabled                = var.asp_down_enabled
  cooldown               = var.asp_down_cooldown
}

## Cloudwatch alarm for scale up by CPU utilization
resource "aws_cloudwatch_metric_alarm" "scale_up" {
  alarm_description   = "Monitors CPU utilization for Webapp ASG"
  actions_enabled     = var.cma_up_actions_enabled
  alarm_actions       = [aws_autoscaling_policy.autoscale_up_policy.arn]
  alarm_name          = var.cma_up_alarm_name
  comparison_operator = var.cma_up_comparison_operator
  namespace           = var.cma_up_namespace
  metric_name         = var.cma_up_metric_name
  threshold           = var.cma_up_threshold
  evaluation_periods  = var.cma_up_evaluation_periods
  period              = var.cma_up_period
  statistic           = var.cma_up_statistic

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.asg.name
  }
}

## Cloudwatch alarm for scale down by CPU utilization
resource "aws_cloudwatch_metric_alarm" "scale_down" {
  alarm_description   = "Monitors CPU utilization for Webapp ASG"
  actions_enabled     = var.cma_down_actions_enabled
  alarm_actions       = [aws_autoscaling_policy.autoscale_down_policy.arn]
  alarm_name          = var.cma_down_alarm_name
  comparison_operator = var.cma_down_comparison_operator
  namespace           = var.cma_down_namespace
  metric_name         = var.cma_down_metric_name
  threshold           = var.cma_down_threshold
  evaluation_periods  = var.cma_down_evaluation_periods
  period              = var.cma_down_period
  statistic           = var.cma_down_statistic

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.asg.name
  }
}






