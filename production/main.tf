## Get availibilty zones
data "aws_availability_zones" "available" {
  state = "available"
}

## Network
module "network" {
  source = "../modules/network"

  region               = var.region
  environment          = var.environment
  vpc_cidr             = var.vpc_cidr
  public_subnets_cidr  = var.public_subnets_cidr
  private_subnets_cidr = var.private_subnets_cidr
  availability_zones   = length(var.preferred_availability_zones) > 0 ? var.preferred_availability_zones : data.aws_availability_zones.available.names

}

## Application security group
module "application_sg" {
  source = "../modules/security"
  depends_on = [
    module.network
  ]
  sg_name                 = var.application_sg_name
  sg_description          = var.application_sg_description
  sg_target_vpc_id        = module.network.vpc_id
  sg_environment          = var.environment
  sg_ingress_rules        = var.application_sg_ingress_rules
  sg_egress_rules         = var.application_sg_egress_rules
  ingress_security_groups = [module.lb_sg.security_group_id]
}

## RDS security group
module "rds_sg" {
  source = "../modules/security"
  depends_on = [
    module.application_sg
  ]
  sg_name                 = var.rds_sg_name
  sg_description          = var.rds_sg_description
  sg_target_vpc_id        = module.network.vpc_id
  sg_environment          = var.environment
  sg_ingress_rules        = var.rds_sg_ingress_rules
  sg_egress_rules         = var.rds_sg_egress_rules
  ingress_security_groups = [module.application_sg.security_group_id]
}

## LB security group
module "lb_sg" {
  source = "../modules/security"
  depends_on = [
    module.network
  ]
  sg_name          = var.lb_sg_name
  sg_description   = var.lb_sg_description
  sg_target_vpc_id = module.network.vpc_id
  sg_environment   = var.environment
  sg_ingress_rules = var.lb_sg_ingress_rules
  sg_egress_rules  = var.lb_sg_egress_rules
}


## Database
module "database" {
  source = "../modules/database"
  depends_on = [
    module.rds_sg
  ]
  db_private_subnet_ids     = [module.network.private_subnet_ids[0].id, module.network.private_subnet_ids[1].id]
  db_allocated_storage      = var.db_allocated_storage
  db_max_allocated_storage  = var.db_max_allocated_storage
  db_name                   = var.db_name
  db_engine                 = var.db_engine
  db_engine_version         = var.db_engine_version
  db_instance_class         = var.db_instance_class
  db_port                   = var.db_port
  db_username               = var.db_username
  db_password               = var.db_password
  db_skip_final_snapshot    = var.db_skip_final_snapshot
  db_publicly_accessible    = var.db_publicly_accessible
  db_multi_az               = var.db_multi_az
  db_sg_target_vpc_id       = module.network.vpc_id
  db_vpc_security_group_ids = [module.rds_sg.security_group_id]
  db_environment            = var.environment
}

## Application Load Balancer
module "webapp_alb" {
  source = "../modules/lb"

  lb_environment       = var.environment
  alb_security_groups  = [module.lb_sg.security_group_id]
  alb_subnets          = [module.network.public_subnet_ids[0].id, module.network.public_subnet_ids[1].id, module.network.public_subnet_ids[2].id]
  alb_tg_vpc_id        = module.network.vpc_id
  autoscaling_group_id = module.instance.autoscaling_group_id
}

## Autoscalable Instance
module "instance" {
  source = "../modules/autoscale"
  depends_on = [
    module.database,
    module.s3_iam,
    module.s3_bucket
  ]
  ec2_source_ami             = var.ec2_source_ami
  ec2_instance_type          = var.ec2_instance_type
  ec2_target_subnet_id       = [module.network.public_subnet_ids[0].id, module.network.public_subnet_ids[1].id, module.network.public_subnet_ids[2].id]
  ebs_size                   = var.ebs_size
  ebs_type                   = var.ebs_type
  application_sg_name        = var.application_sg_name
  ec2_sg_target_vpc_id       = module.network.vpc_id
  instance_environment       = var.environment
  rds_address                = module.database.db_instance_address
  rds_username               = var.db_username
  rds_password               = var.db_password
  rds_db_name                = var.db_name
  ec2_vpc_security_group_ids = [module.application_sg.security_group_id]
  s3_iam_instance_profile    = module.s3_iam.s3_iam_instance_profile_arn
  s3_instance_bucket_name    = module.s3_bucket.s3_bucket_name
  s3_aws_region              = module.s3_bucket.s3_aws_region
  webapp_env                 = var.webapp_env
  webapp_port                = var.webapp_port
  sql_max_pool_conn          = var.sql_max_pool_conn
  sql_max_retries            = var.sql_max_retries
  statsd_host                = var.statsd_host
  statsd_port                = var.statsd_port
  statsd_prefix              = var.statsd_prefix
  statsd_cache_dns           = var.statsd_cache_dns
  app_logs_dirname           = var.app_logs_dirname
  app_error_logs_dirname     = var.app_error_logs_dirname
  cw_config_path             = var.cw_config_path
  alb_target_group_arns      = module.webapp_alb.alb_target_group_arns
}

## S3 Bucket
module "s3_bucket" {
  source = "../modules/bucket"

  s3_versioning_configuration = var.s3_versioning_configuration
  s3_bucket_acl               = var.s3_bucket_acl
  transition_to_IA_days       = var.transition_to_IA_days
  s3_environment              = var.environment
}

## IAM
module "s3_iam" {
  source = "../modules/iam"

  s3_iam_policy_name    = var.s3_iam_policy_name
  iam_policy_version    = var.iam_policy_version
  s3_iam_policy_actions = var.s3_iam_policy_actions
  iam_role_name         = var.iam_role_name
  iam_environment       = var.environment
  s3_bucket_name        = module.s3_bucket.s3_bucket_name

}

## Route 53
module "route_53" {
  source = "../modules/dns"

  route53_zone_name   = var.route53_zone_name
  route53_dns_records = var.route53_dns_records
  route53_alias_name = var.route53_alias_name
  route53_alias_type = var.route53_alias_type
  alb_dns_name       = module.webapp_alb.alb_dns_name
  alb_zone_id        = module.webapp_alb.alb_zone_id

}
