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
    module.network
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
