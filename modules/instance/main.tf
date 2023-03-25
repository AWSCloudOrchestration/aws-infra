#############################################
## INSTANCE MODULE
#############################################

## Source AMI
data "aws_ami" "custom_ami" {
  most_recent = true

  filter {
    name   = "name"
    values = ["webapp-ami-*"]
  }
}

## Random id 8 bit suffix
resource "random_id" "suffix_id" {
  byte_length = 8
}

## EC2 instance from custom AMI
resource "aws_instance" "webapp-ec2" {
  ami                     = var.ec2_source_ami == null ? data.aws_ami.custom_ami.id : var.ec2_source_ami
  instance_type           = var.ec2_instance_type
  subnet_id               = var.ec2_target_subnet_id
  disable_api_termination = var.ec2_disable_api_termination
  vpc_security_group_ids  = var.ec2_vpc_security_group_ids
  iam_instance_profile    = var.s3_iam_instance_profile
  # User data
  user_data = templatefile("${path.module}/../../scripts/setup-creds.sh", {
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
  })

  root_block_device {
    volume_size           = var.ebs_size
    volume_type           = var.ebs_type
    delete_on_termination = var.ebs_delete_on_termination
  }

  tags = {
    Name        = "instance-${var.instance_environment}-${random_id.suffix_id.hex}"
    Environment = "${var.instance_environment}"
  }
}
