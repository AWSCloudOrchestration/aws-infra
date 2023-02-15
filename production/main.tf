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
  availability_zones   = data.aws_availability_zones.available.names
}
