module "vpc1" {
  source               = "../../modules/vpc"
  name                 = var.vpc1_name
  delete_default_routes = true
  subnets              = var.vpc1_subnets
}

module "vpc2" {
  source               = "../../modules/vpc"
  name                 = var.vpc2_name
  delete_default_routes = true
  subnets              = var.vpc2_subnets
}

module "peering_vpc1_vpc2" {
  source              = "./modules/vpc-peering"
  local_vpc_name      = module.vpc1.network_name
  peer_vpc_name       = module.vpc2.network_name
  local_vpc_self_link = module.vpc1.network_self_link
  peer_vpc_self_link  = module.vpc2.network_self_link
}