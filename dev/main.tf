// Get availibilty zones
data "aws_availability_zones" "available" {
  state = "available"
}

module "network" {
  source = "../modules/network"

  region               = var.region
  environment          = var.environment
  vpc_cidr             = var.vpc_cidr
  public_subnets_cidr  = var.public_subnets_cidr
  private_subnets_cidr = var.private_subnets_cidr
  availability_zones   = length(var.preferred_availability_zones) > 0 ? var.preferred_availability_zones : data.aws_availability_zones.available.names

}

module "instance" {
  source = "../modules/instance"
  depends_on = [
    module.network,
    module.database
  ]
  ec2_source_ami       = var.ec2_source_ami
  ec2_instance_type    = var.ec2_instance_type
  ec2_target_subnet_id = module.network.public_subnet_ids[0].id
  ebs_size             = var.ebs_size
  ebs_type             = var.ebs_type
  application_sg_name  = var.application_sg_name
  ec2_sg_target_vpc_id = module.network.vpc_id
  instance_environment = var.environment
}

module "database" {
  source = "../modules/database"
  depends_on = [
    module.network
  ]
  db_private_subnet_ids    = [module.network.private_subnet_ids[0].id, module.network.private_subnet_ids[1].id]
  db_allocated_storage     = var.db_allocated_storage
  db_max_allocated_storage = var.db_max_allocated_storage
  db_name                  = var.db_name
  db_engine                = var.db_engine
  db_engine_version        = var.db_engine_version
  db_instance_class        = var.db_instance_class
  db_username              = var.db_username
  db_password              = var.db_password
  db_skip_final_snapshot   = var.db_skip_final_snapshot
  db_publicly_accessible   = var.db_publicly_accessible
}
